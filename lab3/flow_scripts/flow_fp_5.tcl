#  ___       _ _   
# |_ _|_ __ (_) |_ 
#  | || '_ \| | __|
#  | || | | | | |_ 
# |___|_| |_|_|\__|

source $::env(FLOW_DIR)/steps.innovus.tcl

user_init_design
user_read_floorplan


global_net

set SITE     CoreSite
set UTIL     0.5
set MARGIN   20.0

set PIN_LAYER 1

#-no_snap_to_grid
create_floorplan -site $SITE -core_density_size 1.0 $UTIL $MARGIN $MARGIN $MARGIN $MARGIN

set in_ports  [get_db [get_db ports -if {.direction == in}]  .name]
set out_ports [get_db [get_db ports -if {.direction == out}] .name]

if {[llength $in_ports]} {
    edit_pin -pin $in_ports -side Left -layer $PIN_LAYER \
        -spread_type center -spacing 5.0 -unit track \
        -fix_overlap 1 -fixed_pin 1
}
if {[llength $out_ports]} {
    edit_pin -pin $out_ports -side Right -layer $PIN_LAYER \
        -spread_type center -spacing 5.0 -unit track \
        -fix_overlap 1 -fixed_pin 1
}

add_rings -nets {VDD VSS} -type core_rings -follow core -layer {top TopMetal1 bottom TopMetal1 left TopMetal2 right TopMetal2} -width {top 4 bottom 4 left 4 right 4} -spacing {top 2 bottom 2 left 2 right 2} -offset {top 6 bottom 6 left 6 right 6} -center 0 -threshold 0 -jog_distance 0 -snap_wire_center_to_grid none


set_db edit_wire_nets {VDD}
set_db edit_wire_layer_horizontal {TopMetal1}
set_db edit_wire_layer_vertical {TopMetal2}
set_db edit_wire_type special
set_db edit_wire_width_horizontal {4}
set_db edit_wire_width_vertical {4}
edit_add_route_point 97.0 194.0
edit_end_route_point 97.0 6.0

set_db edit_wire_nets {VSS}
edit_add_route_point 103.0 188.0
edit_end_route_point 103.0 12.0

split_row -area 0 0 16 200
split_row -area 16 0 200 16
split_row -area 184 16 200 200
split_row -area 16 182 184 184

route_special -connect {block_pin pad_pin pad_ring core_pin floating_stripe} -layer_change_range { Metal1(1) TopMetal2(7) } -block_pin_target {nearest_target} -pad_pin_port_connect {all_port one_geom} -pad_pin_target {nearest_target} -core_pin_target {first_after_row_end} -floating_stripe_target {block_ring pad_ring ring stripe ring_pin block_pin followpin} -allow_jogging 1 -crossover_via_layer_range { Metal1(1) TopMetal2(7) } -nets { VDD VSS } -allow_layer_change 1 -block_pin use_lef -target_via_layer_range { Metal1(1) TopMetal2(7) }

create_place_blockage -type hard -rects {{40 114 72 148}} -no_cut_by_core
create_route_blockage -area 130 54 162 88

write_floorplan statistics_unit_5.fp

gui_show
gui_fit


