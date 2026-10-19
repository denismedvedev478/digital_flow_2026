# =====================================================================
# floorplan_5.tcl - Lab 3, grade-5 task
# Start state: floorplan from the grade-4 task loaded (read_floorplan / File -> Load).
# Run: source floorplan_5.tcl
#
# The script wipes the grade-4 result (PG wires, blockages) and rebuilds the
# floorplan from calculated dimensions. Stylus syntax, NOT verified:
# compare places marked CHECK with commands printed by the GUI console.
# =====================================================================

# ---------- Parameters (FILL IN A_CELLS) ----------
set DESIGN   $::env(ENV_DESIGN)
set PWR      [lindex $::env(ENV_POWER_NETS)  0]
set GND      [lindex $::env(ENV_GROUND_NETS) 0]

set A_CELLS  10000.0      ;# TODO: cell area from the Lab 2 report_area, um^2
set UTIL     0.5
set MIN_DIE  200.0
set GAP_A    2.0          ;# gap: inner edge of VDD ring -> remaining rows

set SITE     CoreSite     ;# CHECK: get_db sites .name
set PIN_LAYER Metal3      ;# task requires layer 3. CHECK: layer direction
set CLK_RE   {^clk}
# Control inputs (Bottom side). Adjust to your block's port names:
set CTRL_RE  {^(rst|reset|en|enable|start|load|valid|sel|we)}
set MFG      0.005        ;# CHECK: manufacturing grid

# ---------- Helpers ----------
proc snap {v g}   { return [expr {round($v/$g)*$g}] }
proc die_bbox {}  { return [join [get_db current_design .bbox]] }       ;# CHECK
proc core_bbox {} { return [join [get_db current_design .core_bbox]] }  ;# CHECK

set rnames [get_db layers -if {.type == routing} .name]
set LA [lindex $rnames end-1]
set LB [lindex $rnames end]
if {[get_db [get_db layers $LA] .direction] eq "horizontal"} {
    set LH $LA; set LV $LB
} else {
    set LH $LB; set LV $LA
}
set LOW [lindex $rnames 0]
puts "INFO: ring uses horizontal layer $LH, vertical layer $LV"

# ---------- 1. Size calculation (section 4.3 / task 5.1) ----------
set A_CORE [expr {$A_CELLS / $UTIL}]
set WC     [expr {sqrt($A_CORE)}]
set D 15.0
for {set i 0} {$i < 3} {incr i} {          ;# D depends on the rings, rings depend on die size
    set WD [expr {max($WC + 2*$D, $MIN_DIE)}]
    set HD $WD
    set L  [expr {min($WD, $HD)}]
    set w  [snap [expr {min(0.02*$L, 20.0)}] $MFG]
    set s  [snap [expr {min(0.01*$L, 20.0)}] $MFG]
    set o  [snap [expr {min(0.02*$L, 20.0)}] $MFG]
    # D lies between the inner VDD edge and the row-cut boundary (so the cut hits existing rows)
    set D  [expr {$o + 2*$w + $s + $GAP_A/2.0}]
}
set T [expr {$o + 2*$w + $s + $GAP_A}]     ;# row-cut boundary, measured from die
puts "CALC: Acore=$A_CORE Wcore=$WC Wdie=$WD d=$D | w=$w s=$s o=$o t=$T"

# ---------- 2. Clean up the grade-4 result ----------
catch {delete_routes -net_type special}    ;# CHECK: deleting special wires
catch {delete_obj [get_db place_blockages]}
catch {delete_obj [get_db route_blockages]}

# ---------- 3. Floorplan from explicit dimensions ----------
create_floorplan -site $SITE -die_size [list $WD $HD $D $D $D $D]
lassign [die_bbox] x0 y0 x1 y1
set W [expr {$x1 - $x0}]
set H [expr {$y1 - $y0}]
set xc [expr {($x0 + $x1)/2.0}]

lassign [core_bbox] cx0 cy0 cx1 cy1
set U_fact [expr {100.0 * $A_CELLS / (($cx1-$cx0)*($cy1-$cy0))}]
puts "RESULT: die=${W}x${H}  core=[expr {$cx1-$cx0}]x[expr {$cy1-$cy0}]  Ucore=[format %.1f $U_fact]%"

# ---------- 4. Signal pins ----------
set clk_p {}; set ctrl_p {}; set data_p {}
foreach p [get_db [get_db ports -if {.direction == in}] .name] {
    set base [regsub {\[\d+\]$} $p {}]
    if       {[regexp -nocase $CLK_RE  $base]} {lappend clk_p  $p} \
    elseif   {[regexp -nocase $CTRL_RE $base]} {lappend ctrl_p $p} \
    else                                       {lappend data_p $p}
}
set out_p [get_db [get_db ports -if {.direction == out}] .name]
puts "PINS: clk=$clk_p"
puts "PINS: ctrl=$ctrl_p"
puts "PINS: data_in=$data_p"
puts "PINS: out=$out_p"

# Data inputs - left side, central 30% (35%..65% of the height)
if {[llength $data_p]} {
    edit_pin -pin $data_p -side Left -layer $PIN_LAYER -unit micron \
        -spread_type range \
        -start [list $x0 [expr {$y0 + 0.35*$H}]] \
        -end   [list $x0 [expr {$y0 + 0.65*$H}]] \
        -fix_overlap 1 -fixed_pin 1
}
# clk - center of the top side
if {[llength $clk_p]} {
    edit_pin -pin $clk_p -side Top -layer $PIN_LAYER -unit micron \
        -assign [list $xc $y1] -fix_overlap 1 -fixed_pin 1      ;# CHECK: -assign
}
# reset and other control inputs - bottom side (centered)
if {[llength $ctrl_p]} {
    edit_pin -pin $ctrl_p -side Bottom -layer $PIN_LAYER -unit micron \
        -spread_type center -spacing 2.0 -fix_overlap 1 -fixed_pin 1
}
# Outputs - right side, spread evenly over 10%..90% of the height
if {[llength $out_p]} {
    edit_pin -pin $out_p -side Right -layer $PIN_LAYER -unit micron \
        -spread_type range \
        -start [list $x1 [expr {$y0 + 0.10*$H}]] \
        -end   [list $x1 [expr {$y0 + 0.90*$H}]] \
        -fix_overlap 1 -fixed_pin 1
}

# ---------- 5. Rings: outer VSS, inner VDD ----------
# Offset from core to the inner edge of VDD = d - (o + 2w + s)  (= 0.5*GAP_A > 0)
set RING_OFFSET [expr {$D - ($o + 2*$w + $s)}]
add_rings -nets [list $GND $PWR] -type core_rings -follow core \
    -layer [list top $LH bottom $LH left $LV right $LV] \
    -width $w -spacing $s -offset $RING_OFFSET        ;# CHECK: -nets order and offset meaning

# ---------- 6. Central stripes: VDD on the left, VSS on the right ----------
# Layer = vertical ring layer; symmetric about x = xc.
set vdd_xl [expr {$xc - $s/2.0 - $w}];  set vdd_xr [expr {$xc - $s/2.0}]
set vss_xl [expr {$xc + $s/2.0}];       set vss_xr [expr {$xc + $s/2.0 + $w}]
# VDD: from the middle of the bottom VDD ring wire to the middle of the top one
set vdd_yb [expr {$y0 + $o + $w + $s + $w/2.0}]
set vdd_yt [expr {$y1 - $o - $w - $s - $w/2.0}]
# VSS: from the middle of the bottom VSS ring wire to the middle of the top one
# (it crosses the VDD ring wires, but on a different layer)
set vss_yb [expr {$y0 + $o + $w/2.0}]
set vss_yt [expr {$y1 - $o - $w/2.0}]
# CHECK: create_shape (equivalent of Wire Edit -> Special -> Stripe). Fallback: add_stripes
create_shape -shape stripe -layer $LV -net $PWR -status fixed \
    -rect [list $vdd_xl $vdd_yb $vdd_xr $vdd_yt]
create_shape -shape stripe -layer $LV -net $GND -status fixed \
    -rect [list $vss_xl $vss_yb $vss_xr $vss_yt]

# Vias between the central stripes and the rings (same-net crossings only)
update_power_vias -add_vias 1 -nets [list $PWR $GND] \
    -bottom_layer $LA -top_layer $LB                    ;# CHECK: Power -> Edit Power Via

# ---------- 7. Cut rows: boundary t from die, 2 um gap from the inner VDD edge ----------
# Rows are cut BEFORE SRoute so follow-pin rails are built on the remaining rows.
# CHECK: cut_row command (GUI: Floorplan -> Row -> Cut Core Row)
cut_row -area [list $x0 $y0 [expr {$x0+$T}] $y1]                                    ;# left
cut_row -area [list [expr {$x1-$T}] $y0 $x1 $y1]                                    ;# right
cut_row -area [list [expr {$x0+$T}] $y0 [expr {$x1-$T}] [expr {$y0+$T}]]           ;# bottom
cut_row -area [list [expr {$x0+$T}] [expr {$y1-$T}] [expr {$x1-$T}] $y1]           ;# top

# ---------- 8. Power rails along rows ----------
connect_global_net $PWR -type pg_pin -pin_base_name $PWR -all
connect_global_net $GND -type pg_pin -pin_base_name $GND -all
route_special -connect {core_pin} \
    -nets [list $PWR $GND] \
    -allow_layer_change 1 -allow_jogging 1 \
    -layer_change_range        [list $LOW $LB] \
    -crossover_via_layer_range [list $LOW $LB] \
    -target_via_layer_range    [list $LOW $LB] \
    -block_pin_target nearest_target \
    -core_pin_target first_after_row_end

# ---------- 9. Additional blockages ----------
set ax [snap [expr {$x0 + 0.20*$W}] $MFG];  set ay [snap [expr {$y0 + 0.57*$H}] $MFG]
set bx [snap [expr {$x0 + 0.36*$W}] $MFG];  set by [snap [expr {$y0 + 0.74*$H}] $MFG]
set ccx [snap [expr {$x0 + 0.65*$W}] $MFG]; set ccy [snap [expr {$y0 + 0.27*$H}] $MFG]
set dx [snap [expr {$x0 + 0.81*$W}] $MFG];  set dy [snap [expr {$y0 + 0.44*$H}] $MFG]

create_place_blockage -type hard -rects [list $ax $ay $bx $by]
# One layer for the routing blockage - state it in the report
create_route_blockage -layers [list $LH] -rects [list $ccx $ccy $dx $dy]   ;# CHECK: options

puts "BLK: place A=($ax,$ay) B=($bx,$by)  route C=($ccx,$ccy) D=($dx,$dy) layer=$LH"

# ---------- 10. Checks and save ----------
catch {check_connectivity -type special}
puts "INFO: check rows (gap >= 2 um to the ring), blockages inside rows,"
puts "      no overlap with the ring and the central stripes"
write_floorplan ${DESIGN}_floorplan_5.fp   ;# CHECK: same as in floorplan_4.tcl
puts "DONE: floorplan_5"
