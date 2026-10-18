# ------------------------------------------------------------------------------
# Start
# ------------------------------------------------------------------------------

source $::env(FLOW_DIR)/steps.genus.tcl

step_genus_host_info
step_genus_global_options

step_genus_read_hdl
step_genus_read_mmmc
step_genus_elaborate
step_genus_init_design

step_genus_gen
step_genus_map
step_genus_opt

step_genus_lec /home/zzomda/Desktop/syn_digtl/digital_flow_2026/lab2/run/genus/outputs/syn_opt/statistics_unit.v;

# ------------------------------------------------------------------------------
# Finish
# ------------------------------------------------------------------------------
puts "============================"
puts "Synthesis Finished"
puts "============================"

gui_show
# quit