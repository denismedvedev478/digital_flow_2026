transcript on

if {[file exists rtl_work]} {
        vdel -lib rtl_work -all
}
vlib rtl_work
vmap work rtl_work

vlog -sv -work work ./processing_unit.sv
vlog -sv -work work ./processing_unit_tb.sv

vsim -t 1ps -L work -do do.tcl -voptargs="+acc" processing_unit_tb
