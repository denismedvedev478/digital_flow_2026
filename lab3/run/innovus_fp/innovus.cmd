#######################################################
#                                                     
#  Innovus Command Logging File                     
#  Created on Sun Oct 18 13:20:23 2026                
#                                                     
#######################################################

#@(#)CDS: Innovus v21.14-s109_1 (64bit) 06/29/2022 09:53 (Linux 3.10.0-693.el7.x86_64)
#@(#)CDS: NanoRoute 21.14-s109_1 NR220628-1629/21_14-UB (database version 18.20.582) {superthreading v2.17}
#@(#)CDS: AAE 21.14-s031 (64bit) 06/29/2022 (Linux 3.10.0-693.el7.x86_64)
#@(#)CDS: CTE 21.14-s031_1 () Jun 22 2022 10:32:17 ( )
#@(#)CDS: SYNTECH 21.14-s014_1 () May 29 2022 20:47:50 ( )
#@(#)CDS: CPE v21.14-s062
#@(#)CDS: IQuantus/TQuantus 21.1.1-w001 (64bit) Wed Jun 1 22:42:35 PDT 2022 (Linux 3.10.0-693.el7.x86_64)

#@ source /home/zzomda/Desktop/syn_digtl/digital_flow_2026/lab3/flow_scripts/flow.innovus.fp.tcl
#@ Begin verbose source (pre): source /home/zzomda/Desktop/syn_digtl/digital_flow_2026/lab3/flow_scripts/flow.innovus.fp.tcl
#@ source $::env(FLOW_DIR)/steps.innovus.tcl
#@ Begin verbose source /home/zzomda/Desktop/syn_digtl/digital_flow_2026/lab3/flow_scripts/steps.innovus.tcl (pre)
proc user_init_design {} \
{
 
    # ------------------
    # Init design
    # ------------------
    if {[info exists ::env(TECH_SIZE)] && $::env(TECH_SIZE) ne ""} {
        set_db design_process_node $::env(TECH_SIZE)
    }

    set_db init_netlist_files  $::env(ENV_NETLIST)
    set_db init_lef_files      $::env(ENV_LEF_FILES)
    set_db init_power_nets     $::env(ENV_POWER_NETS)
    set_db init_ground_nets    $::env(ENV_GROUND_NETS)
    set_db init_mmmc_files     $::env(ENV_MMMC)

    read_mmmc     $::env(ENV_MMMC)
    read_physical -lef $::env(ENV_LEF_FILES)

    read_netlist  $::env(ENV_NETLIST) -top $::env(ENV_DESIGN)
    init_design


}
proc user_read_floorplan {} {
    # ----------------------------------------------------------
    # Floorplan file Ã¡Ã¥Ã°Â¸Ã¬ Ã¨Ã§ ENV_FLOORPLAN_FILE (Ã±Ã¬. Makefile)
    # ENV_INNOVUS_FP Â Ã½Ã²Ã® Ã¨Ã¬Ã¿ Ã§Ã Ã¯Ã³Ã±ÃªÃ Ã¥Ã¬Ã®Ã© Ã³Ã²Ã¨Ã«Ã¨Ã²Ã», ÃÃ Ã´Ã Ã©Ã« floorplan
    # ----------------------------------------------------------
    set fp_file ""

    if {[info exists ::env(ENV_FLOORPLAN_FILE)] && $::env(ENV_FLOORPLAN_FILE) ne ""} {
        set fp_file $::env(ENV_FLOORPLAN_FILE)
    }

    if {$fp_file eq ""} {
        puts "WARN: ENV_FLOORPLAN_FILE is not set, skip read_floorplan"
        return
    }

    if {![file exists $fp_file]} {
        puts "WARN: floorplan file not found: $fp_file"
        return
    }

    # ÃÃ¨Ã²Ã Ã¥Ã¬ floorplan
    read_floorplan $fp_file

    # ÃÃ®Ã¯Ã¨Ã°Ã³Ã¥Ã¬ Ã¨Ã±ÃµÃ®Ã¤Ã­Ã»Ã© .fp Ã¨ Ã¥Ã£Ã® .spr (Ã¥Ã±Ã«Ã¨ Ã¥Ã±Ã²Ã¼) Ã¢ ./in
proc global_net {} \
{
    connect_global_net VDD -type pg_pin -pin_base_name vdd -inst_base_name *
    connect_global_net VSS -type pg_pin -pin_base_name gnd -inst_base_name *
    connect_global_net VSS -type pg_pin -pin_base_name vss -inst_base_name *



}
#@ End verbose source /home/zzomda/Desktop/syn_digtl/digital_flow_2026/lab3/flow_scripts/steps.innovus.tcl
user_init_design
#@ Begin verbose source /home/zzomda/Desktop/syn_digtl/digital_flow_2026/lab2/data/example_rtl/counter/mmmc.view (pre)
set lib_list_typ {}
lappend lib_list_typ  " $::env(PDK_DIR)/IHP_Open_PDK/sg13g2_stdcell/lib/sg13g2_stdcell_typ_1p20V_25C.lib"
create_rc_corner -name typ -temperature {25} -pre_route_res {1} -pre_route_cap {1} -pre_route_clock_res {0} -pre_route_clock_cap {0} -post_route_res {1} -post_route_cap {1} -post_route_cross_cap {1} -post_route_clock_res {0} -post_route_clock_cap {0}
create_library_set -name typ -timing $lib_list_typ
create_opcond -name typ -process {1} -voltage {1.20} -temperature {25}
create_timing_condition -name typ -opcond {typ} -library_sets {typ}
create_delay_corner -name typ -timing_condition {typ} -rc_corner {typ}
create_constraint_mode -name func -sdc_files "/home/zzomda/Desktop/syn_digtl/digital_flow_2026/lab2/data/blockB/statistics_unit.sdc"
create_analysis_view -name typ -constraint_mode {func} -delay_corner {typ}
set_analysis_view -setup {typ} -hold {typ}
#@ End verbose source /home/zzomda/Desktop/syn_digtl/digital_flow_2026/lab2/data/example_rtl/counter/mmmc.view
user_read_floorplan
global_net
global_net
gui_show
gui_fit
#@ End verbose source: /home/zzomda/Desktop/syn_digtl/digital_flow_2026/lab3/flow_scripts/flow.innovus.fp.tcl
gui_select -point {94.73400 126.07700}
