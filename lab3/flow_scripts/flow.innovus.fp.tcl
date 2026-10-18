#  ___       _ _   
# |_ _|_ __ (_) |_ 
#  | || '_ \| | __|
#  | || | | | | |_ 
# |___|_| |_|_|\__|

source $::env(FLOW_DIR)/steps.innovus.tcl

user_init_design
user_read_floorplan

global_net

#-no_snap_to_grid
create_floorplan -no_snap_to_grid -site CoreSite -box_size 0.0 0.0 200.16 199.92 0.0 0.0 200.16 199.92 12.16 12.16 188.0 188.18

edit_pin -pin_width 10.0 -pin_depth 10.0 -fix_overlap 1 -unit micron -spread_direction clockwise -side Top -layer 3 -spread_type center -spacing 0.48 -pin clk
edit_pin -pin_width 2.0 -pin_depth 10.0 -fix_overlap 1 -unit micron -spread_direction clockwise -side Bottom -layer 3 -spread_type center -spacing 0.48 -pin {valid_in rst_n clear}
edit_pin -pin_width 1.0 -pin_depth 10.0 -fix_overlap 1 -spread_direction clockwise -edge 0 -layer 3 -spread_type range -offset_end 70 -offset_start 70 -pin {{data_in[0]} {data_in[1]} {data_in[2]} {data_in[3]} {data_in[4]} {data_in[5]} {data_in[6]} {data_in[7]} {data_in[8]} {data_in[9]} {data_in[10]} {data_in[11]} {data_in[12]} {data_in[13]} {data_in[14]} {data_in[15]} {data_in[16]} {data_in[17]} {data_in[18]} {data_in[19]} {data_in[20]} {data_in[21]} {data_in[22]} {data_in[23]} {data_in[24]} {data_in[25]} {data_in[26]} {data_in[27]} {data_in[28]} {data_in[29]} {data_in[30]} {data_in[31]}}
edit_pin -pin_width 0.2 -pin_depth 10.0 -fix_overlap 1 -spread_direction clockwise -edge 2 -layer 3 -spread_type range -offset_end 20 -offset_start 20 -pin {{count[0]} {count[1]} {count[2]} {count[3]} {count[4]} {count[5]} {count[6]} {count[7]} {count[8]} {count[9]} {count[10]} {count[11]} {count[12]} {count[13]} {count[14]} {count[15]} {max[0]} {max[1]} {max[2]} {max[3]} {max[4]} {max[5]} {max[6]} {max[7]} {max[8]} {max[9]} {max[10]} {max[11]} {max[12]} {max[13]} {max[14]} {max[15]} {max[16]} {max[17]} {max[18]} {max[19]} {max[20]} {max[21]} {max[22]} {max[23]} {max[24]} {max[25]} {max[26]} {max[27]} {max[28]} {max[29]} {max[30]} {max[31]} {min[0]} {min[1]} {min[2]} {min[3]} {min[4]} {min[5]} {min[6]} {min[7]} {min[8]} {min[9]} {min[10]} {min[11]} {min[12]} {min[13]} {min[14]} {min[15]} {min[16]} {min[17]} {min[18]} {min[19]} {min[20]} {min[21]} {min[22]} {min[23]} {min[24]} {min[25]} {min[26]} {min[27]} {min[28]} {min[29]} {min[30]} {min[31]} {sum[0]} {sum[1]} {sum[2]} {sum[3]} {sum[4]} {sum[5]} {sum[6]} {sum[7]} {sum[8]} {sum[9]} {sum[10]} {sum[11]} {sum[12]} {sum[13]} {sum[14]} {sum[15]} {sum[16]} {sum[17]} {sum[18]} {sum[19]} {sum[20]} {sum[21]} {sum[22]} {sum[23]} {sum[24]} {sum[25]} {sum[26]} {sum[27]} {sum[28]} {sum[29]} {sum[30]} {sum[31]}}

add_rings -nets {VDD VSS} -type core_rings -follow io -layer {top TopMetal1 bottom TopMetal1 left TopMetal2 right TopMetal2} -width {top 4 bottom 4 left 4 right 4} -spacing {top 2 bottom 2 left 2 right 2} -offset {top 4 bottom 4 left 4 right 4} -center 0 -threshold 0 -jog_distance 0 -snap_wire_center_to_grid none

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


