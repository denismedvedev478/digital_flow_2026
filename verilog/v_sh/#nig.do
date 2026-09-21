transcript on

if {[file exists rtl_work]} {
        vdel -lib rtl_work -all
}
vlib rtl_work
vmap work rtl_work

vlog -sv -work work ./statistic_unit.v
vlog -sv -work work ./statistic_unit_tb.v

vsim -t 1ps -L work -do do.tcl -voptargs="+acc" tb
