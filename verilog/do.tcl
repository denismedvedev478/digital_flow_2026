onerror {resume}
quietly WaveActivateNextPane {} 0
add wave -noupdate /processing_system_tb/dut/clk
add wave -noupdate /processing_system_tb/dut/rst_n
add wave -noupdate /processing_system_tb/dut/clear
add wave -noupdate -radix decimal /processing_system_tb/dut/data_a
add wave -noupdate -radix decimal /processing_system_tb/dut/data_b
add wave -noupdate /processing_system_tb/dut/operation
add wave -noupdate /processing_system_tb/dut/valid_in
add wave -noupdate -radix decimal /processing_system_tb/dut/range_limit
add wave -noupdate /processing_system_tb/dut/valid_out
add wave -noupdate -radix decimal /processing_system_tb/dut/result
add wave -noupdate /processing_system_tb/dut/result_valid
add wave -noupdate -radix decimal /processing_system_tb/dut/count
add wave -noupdate -radix decimal /processing_system_tb/dut/sum
add wave -noupdate -radix decimal /processing_system_tb/dut/min
add wave -noupdate -radix decimal /processing_system_tb/dut/max
add wave -noupdate -radix decimal /processing_system_tb/dut/range
add wave -noupdate /processing_system_tb/dut/range_exceeded
add wave -noupdate /processing_system_tb/dut/valid_ps
add wave -noupdate -radix decimal /processing_system_tb/dut/result_ps
TreeUpdate [SetDefaultTree]
WaveRestoreCursors {{Cursor 1} {239 ps} 0}
quietly wave cursor active 1
configure wave -namecolwidth 150
configure wave -valuecolwidth 100
configure wave -justifyvalue left
configure wave -signalnamewidth 1
configure wave -snapdistance 10
configure wave -datasetprefix 0
configure wave -rowmargin 4
configure wave -childrowmargin 2
configure wave -gridoffset 0
configure wave -gridperiod 1
configure wave -griddelta 40
configure wave -timeline 0
configure wave -timelineunits ps
update
WaveRestoreZoom {0 ps} {585 ps}
