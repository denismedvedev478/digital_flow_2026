# =====================================================================
# floorplan_4.tcl - Lab 3, grade-4 task
# Start state: project after import (init_design already done).
# Run: source floorplan_4.tcl
#
# Stylus syntax, NOT verified on your Innovus version.
# Places marked CHECK should be compared with the commands the GUI prints
# to the console (lab manual, section 6.2): do the operation via the GUI,
# copy the printed command, and replace my line with it.
# =====================================================================

# ---------- Parameters ----------
set DESIGN   $::env(ENV_DESIGN)
set PWR      [lindex $::env(ENV_POWER_NETS)  0]
set GND      [lindex $::env(ENV_GROUND_NETS) 0]

set SITE     CoreSite     ;# CHECK: get_db sites .name
set PIN_LAYER Metal3      ;# CHECK: pin layer (grade-5 task requires layer 3)
set UTIL     0.5          ;# CHECK: the tool may expect 50 instead of 0.5
set MARGIN   20.0         ;# core-to-die margin
set MIN_DIE  200.0

set W_RING   4.0          ;# ring wire width
set S_RING   2.0          ;# VDD-VSS spacing
set O_RING   4.0          ;# die edge to outer edge of the ring
set B_W      [expr {$O_RING + 2*$W_RING + $S_RING}]   ;# 14 um

# ---------- Helpers ----------
proc die_bbox {}  { return [join [get_db current_design .bbox]] }       ;# CHECK
proc core_bbox {} { return [join [get_db current_design .core_bbox]] }  ;# CHECK

# Two topmost routing layers and their preferred directions
set rnames [get_db layers -if {.type == routing} .name]
set LA [lindex $rnames end-1]
set LB [lindex $rnames end]
if {[get_db [get_db layers $LA] .direction] eq "horizontal"} {
    set LH $LA; set LV $LB
} else {
    set LH $LB; set LV $LA
}
puts "INFO: ring uses horizontal layer $LH, vertical layer $LV"
set LOW [lindex $rnames 0]   ;# lowest layer for SRoute

# ---------- 1. Floorplan: util 50%, aspect 1:1, margins 20 ----------
create_floorplan -site $SITE \
    -core_density_size 1.0 $UTIL $MARGIN $MARGIN $MARGIN $MARGIN

lassign [die_bbox] x0 y0 x1 y1
if {($x1-$x0) < $MIN_DIE || ($y1-$y0) < $MIN_DIE} {
    puts "INFO: die is smaller than $MIN_DIE um, setting $MIN_DIE x $MIN_DIE with the same margins"
    create_floorplan -site $SITE \
        -die_size [list $MIN_DIE $MIN_DIE $MARGIN $MARGIN $MARGIN $MARGIN]
    lassign [die_bbox] x0 y0 x1 y1
}
puts "INFO: die  = [die_bbox]"
puts "INFO: core = [core_bbox]"

# ---------- 2. Signal pins (Pin Editor) ----------
# Inputs on the left, outputs on the right, spread evenly. Change as you like.
set in_ports  [get_db [get_db ports -if {.direction == in}]  .name]
set out_ports [get_db [get_db ports -if {.direction == out}] .name]

if {[llength $in_ports]} {
    edit_pin -pin $in_ports -side Left -layer $PIN_LAYER \
        -spread_type center -spacing 2.0 -unit micron \
        -fix_overlap 1 -fixed_pin 1
}
if {[llength $out_ports]} {
    edit_pin -pin $out_ports -side Right -layer $PIN_LAYER \
        -spread_type center -spacing 2.0 -unit micron \
        -fix_overlap 1 -fixed_pin 1
}

# ---------- 3. Power rings ----------
# Offset from core to the INNER edge of the VDD ring = MARGIN - 14 = 6 um.
# CHECK: in add_rings, offset is measured from the core boundary to the ring
# edge closest to the core. Verify with the ruler (key k): the outer edge of
# VSS must be exactly 4 um from the die edge.
# CHECK: order in -nets decides which ring is outer (VSS must be outside).
set RING_OFFSET [expr {$MARGIN - $B_W}]
add_rings -nets [list $GND $PWR] -type core_rings -follow core \
    -layer [list top $LH bottom $LH left $LV right $LV] \
    -width $W_RING -spacing $S_RING -offset $RING_OFFSET

# ---------- 4. PG pin connection and SRoute (Follow Pins) ----------
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

# ---------- 5. Frame of 4 hard placement blockages, 14 um wide ----------
set B $B_W
create_place_blockage -type hard -rects [list $x0 $y0 [expr {$x0+$B}] $y1]            ;# left
create_place_blockage -type hard -rects [list [expr {$x1-$B}] $y0 $x1 $y1]            ;# right
create_place_blockage -type hard -rects [list [expr {$x0+$B}] $y0 [expr {$x1-$B}] [expr {$y0+$B}]]  ;# bottom
create_place_blockage -type hard -rects [list [expr {$x0+$B}] [expr {$y1-$B}] [expr {$x1-$B}] $y1]  ;# top

# ---------- 6. Checks ----------
catch {check_connectivity -type special}   ;# CHECK: PG shorts/opens
puts "INFO: die  = [die_bbox]"
puts "INFO: core = [core_bbox]"
puts "INFO: check manually: rings are closed, corner vias exist, no VDD/VSS shorts"

# ---------- 7. Save ----------
write_floorplan ${DESIGN}_floorplan_4.fp   ;# CHECK: copy the command from the console after File -> Save -> Floorplan
puts "DONE: floorplan_4"
