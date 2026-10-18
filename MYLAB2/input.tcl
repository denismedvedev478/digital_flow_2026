file mkdir ./out/10_syn_gen
file mkdir ./out/20_syn_map
file mkdir ./out/30_syn_opt

set script_path [file normalize [file dirname [info script]]]
set rtl_dir ${script_path}/../rtl
set sdc_dir ${script_path}/../sdc

set_db init_hdl_search_path ${rtl_dir}
set_db timing_report_unconstrained false

read_hdl -sv -f ${rtl_dir}/filelist.f
read_mmmc $::env(ENV_MMMC_PATH)



set DESIGN_NAME madr_top
elaborate ${DESIGN_NAME}

read_sdc ${sdc_dir}/madr_top.sdc
check_timing_intent

syn_generic

write_snapshot -outdir ./out -tag 10_syn_gen/${DESIGN_NAME}
write_hdl > ./out/10_syn_gen/${DESIGN_NAME}_gen.v

report timing -lint > ./out/10_syn_gen/${DESIGN_NAME}_timing_lint.rpt
report gates > ./out/10_syn_gen/${DESIGN_NAME}_gates.rpt
report area > ./out/10_syn_gen/${DESIGN_NAME}_area.rpt
write_sdc > ./out/10_syn_gen/${DESIGN_NAME}_new_sdc.sdc

syn_map

write_snapshot -outdir ./out -tag 20_syn_map/${DESIGN_NAME}
write_hdl > ./out/20_syn_map/${DESIGN_NAME}_mapped.v

report timing > ./out/20_syn_map/${DESIGN_NAME}_timing.rpt
report gates > ./out/20_syn_map/${DESIGN_NAME}_gates.rpt

syn_opt

write_snapshot -outdir ./out -tag 30_syn_opt/${DESIGN_NAME}
write_hdl > ./out/30_syn_opt/${DESIGN_NAME}_opt.v

report timing > ./out/30_syn_opt/${DESIGN_NAME}_timing.rpt
report gates > ./out/30_syn_opt/${DESIGN_NAME}_gates.rpt
report area > ./out/30_syn_opt/${DESIGN_NAME}_area.rpt



write_do_lec -golden_design rtl -revised_design $output_netlist -log_file $::env(GENUS_REPORT_DIR)/rtl2final.lec.log  \
> $::env(GENUS_OUTPUT_DIR)/rtl2final.lec.do


