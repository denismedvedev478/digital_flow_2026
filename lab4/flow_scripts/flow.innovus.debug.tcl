read_db $::env(ENV_DB)
gui_show
gui_fit

group_path -name reg2reg -from [all_registers] -to [all_registers]

report_timing -late  -path_type full_clock -max_paths 1 -group reg2reg >> eco_base_exp.rpt
report_timing -early -path_type full_clock -max_paths 1 -group reg2reg >> eco_base_exp_h.rpt

set design_name [get_db current_design .name]

set eco_start     sum_reg[2]
set eco_end       sum_reg[30]
set eco_view      typ
set eco_sink_pin  {add_18_25_g2892__2883/Y}
set eco_cell      sg13g2_buf_4
set eco_tag       fix_setup_buffer
set eco_report_dir ./reports/ECO.${eco_tag}

file mkdir ./db
file mkdir $eco_report_dir

write_db ./db/DB.${design_name}.pre_eco.enc

delete_filler -prefix FILLER

set_db eco_honor_dont_touch        true
set_db eco_honor_dont_use          true
set_db eco_honor_fixed_status      true
set_db eco_honor_fixed_wires       true
set_db eco_inherit_net_attribute   true
set_db eco_check_logical_equivalence true
set_db eco_refine_place            false
set_db eco_update_timing           false
set_db eco_prefix                  ECO

eco_add_repeater -cells $eco_cell -pins $eco_sink_pin

place_detail -eco true
check_place
route_eco

add_fillers -base_cells $::env(ENV_FILLER_CELLS) -prefix FILLER
check_place

check_connectivity -type all -out_file ${eco_report_dir}/connectivity.rpt
check_drc          -check_only all -out_file ${eco_report_dir}/drc.rpt

reset_parasitics
extract_rc
report_timing -late  -path_type full_clock -max_paths 1 -group reg2reg >> eco_0_exp.rpt
report_timing -early -path_type full_clock -max_paths 1 -group reg2reg >> eco_0_exp_h.rpt

select_obj FE_ECOC0_add_18_25_n_159

set_db eco_refine_place  true
set_db eco_update_timing true

write_db ./db/DB.${design_name}.pre_eco_0.enc
suspend

set_db eco_refine_place  false
set_db eco_update_timing false

delete_filler -prefix FILLER
eco_delete_repeater -insts FE_ECOC0_add_18_25_n_159

place_detail -eco true
check_place
route_eco

add_fillers -base_cells $::env(ENV_FILLER_CELLS) -prefix FILLER
check_place

set_db eco_refine_place  true
set_db eco_update_timing true

reset_parasitics
extract_rc
report_timing -late  -path_type full_clock -max_paths 1 -group reg2reg >> eco_1_exp.rpt
report_timing -early -path_type full_clock -max_paths 1 -group reg2reg >> eco_1_exp_h.rpt

write_db ./db/DB.${design_name}.pre_eco_1.enc
suspend

set_db eco_refine_place  false
set_db eco_update_timing false

delete_filler -prefix FILLER
eco_update_cell -insts g8040 -cells sg13g2_inv_2

place_detail -eco true
check_place
route_eco

add_fillers -base_cells $::env(ENV_FILLER_CELLS) -prefix FILLER
check_place

set_db eco_refine_place  true
set_db eco_update_timing true

reset_parasitics
extract_rc
report_timing -late  -path_type full_clock -max_paths 1 -group reg2reg >> eco_2_exp.rpt
report_timing -early -path_type full_clock -max_paths 1 -group reg2reg >> eco_2_exp_h.rpt

write_db ./db/DB.${design_name}.pre_eco_2.enc
suspend