# ------------------------------------------------------------------------------
# Start
# ------------------------------------------------------------------------------

source $::env(FLOW_DIR)/steps.genus.tcl

set script_dir [file normalize [file dirname [info script]]]


set ::env(ENV_DESIGN)                "top"
set ::env(ENV_DEFINE)                "SYNTHESIS"
set ::env(ENV_RTL_LIST)              [file join $script_dir "rtl" "filelist.f"]
set ::env(ENV_MMMC)                  [file join $script_dir "constraints" "mmmc.tcl"]
set ::env(ENV_INIT_HDL_SEARCH_PATH)  [list \
    [file join $script_dir "rtl"] \
    [file join $script_dir "include"] \
]

set ::env(GENUS_RUN_DIR)             [file join $script_dir "genus_run"]
set ::env(GENUS_REPORT_DIR)          [file join $::env(GENUS_RUN_DIR) "reports"]
set ::env(GENUS_OUTPUT_DIR)          [file join $::env(GENUS_RUN_DIR) "outputs"]

# directories
file mkdir $::env(GENUS_RUN_DIR)
file mkdir $::env(GENUS_REPORT_DIR)
file mkdir $::env(GENUS_OUTPUT_DIR)

foreach stage {syn_generic syn_map syn_opt} {
    file mkdir [file join $::env(GENUS_REPORT_DIR) $stage]
    file mkdir [file join $::env(GENUS_OUTPUT_DIR) $stage]
}


# synth flow
step_genus_host_info
step_genus_global_options

step_genus_read_hdl
step_genus_elaborate
step_genus_read_mmmc
step_genus_init_design

step_genus_gen
step_genus_map
step_genus_opt

# generate lec-do script
set final_netlist [file join $::env(GENUS_OUTPUT_DIR) syn_opt "$::env(ENV_DESIGN).v"]
step_genus_lec $final_netlist



# ------------------------------------------------------------------------------
# Finish
# ------------------------------------------------------------------------------
puts "============================"
puts "Synthesis Finished"
puts "============================"

gui_show
# quit
