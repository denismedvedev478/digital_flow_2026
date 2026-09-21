onerror {resume}
quietly WaveActivateNextPane {} 0
add wave -noupdate /processing_unit_tb/dut/clk
add wave -noupdate /processing_unit_tb/dut/rst_n
add wave -noupdate /processing_unit_tb/dut/valid_in
add wave -noupdate /processing_unit_tb/dut/data_a
add wave -noupdate /processing_unit_tb/dut/data_b
add wave -noupdate /processing_unit_tb/dut/operation
add wave -noupdate /processing_unit_tb/dut/valid_out
add wave -noupdate /processing_unit_tb/dut/result
add wave -noupdate /processing_unit_tb/dut/res_nx
TreeUpdate [SetDefaultTree]
WaveRestoreCursors {{Cursor 1} {16265 ps} 0}
quietly wave cursor active 1
configure wave -namecolwidth 150
configure wave -valuecolwidth 100
configure wave -justifyvalue left
configure wave -signalnamewidth 0
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
WaveRestoreZoom {0 ps} {130123 ps}
