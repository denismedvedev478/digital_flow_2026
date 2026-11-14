#  ___       _ _   
# |_ _|_ __ (_) |_ 
#  | || '_ \| | __|
#  | || | | | | |_ 
# |___|_| |_|_|\__|

source $::env(FLOW_DIR)/steps.innovus.tcl

user_init_design
global_net

user_read_floorplan

user_3_otchet
# gunzip 

suspend

user_preplace

user_place

user_clock_tree_synthesis

suspend

user_route

user_extract_rc

user_sta

user_write_netlist
user_write_def
user_write_lef       $::env(TOP_CTS_LAYER_num)   
user_write_spef
user_write_gds       
user_write_sdf       typ           
user_write_lib       typ typ

write_db ./db/DB.$::env(ENV_DESIGN).final.enc

gui_show
gui_fit


