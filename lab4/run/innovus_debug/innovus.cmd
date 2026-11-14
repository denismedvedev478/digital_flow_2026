#######################################################
#                                                     
#  Innovus Command Logging File                     
#  Created on Sat Nov 14 15:02:27 2026                
#                                                     
#######################################################

#@(#)CDS: Innovus v21.14-s109_1 (64bit) 06/29/2022 09:53 (Linux 3.10.0-693.el7.x86_64)
#@(#)CDS: NanoRoute 21.14-s109_1 NR220628-1629/21_14-UB (database version 18.20.582) {superthreading v2.17}
#@(#)CDS: AAE 21.14-s031 (64bit) 06/29/2022 (Linux 3.10.0-693.el7.x86_64)
#@(#)CDS: CTE 21.14-s031_1 () Jun 22 2022 10:32:17 ( )
#@(#)CDS: SYNTECH 21.14-s014_1 () May 29 2022 20:47:50 ( )
#@(#)CDS: CPE v21.14-s062
#@(#)CDS: IQuantus/TQuantus 21.1.1-w001 (64bit) Wed Jun 1 22:42:35 PDT 2022 (Linux 3.10.0-693.el7.x86_64)

#@ source /home/zzomda/Desktop/syn_digtl/digital_flow_2026/lab4/flow_scripts/flow.innovus.debug.tcl
#@ Begin verbose source (pre): source /home/zzomda/Desktop/syn_digtl/digital_flow_2026/lab4/flow_scripts/flow.innovus.debug.tcl
read_db $::env(ENV_DB) 
gui_show
gui_fit
report_timing -late -path_type full_clock -max_paths 1
report_timing -early -path_type full_clock -max_paths 1
set design_name [get_db current_design .name]
#@ End verbose source: /home/zzomda/Desktop/syn_digtl/digital_flow_2026/lab4/flow_scripts/flow.innovus.debug.tcl
gui_select -point {57.03400 183.79400}
report_timing -late -path_type full_clock -max_paths 1 -group reg2reg
man report_timing -late -path_type full_clock -max_paths 1 -
report_timing -late -path_type full_clock -max_paths 1 -group reg2reg
report_timing -late -path_type full_clock -max_paths 1 -group r2r
report_timing -late -path_type full_clock -max_paths 1 -group r2r
report_path_groups
all_registers
all_registers
report_timing -late -path_type full_clock -max_paths 1 -from [all_registers] -to [all_registers]
set design_name [get_db current_design .name]
