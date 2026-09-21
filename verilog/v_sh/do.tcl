onerror {resume}
quietly WaveActivateNextPane {} 0
add wave -noupdate /tb/clk
add wave -noupdate /tb/rst
add wave -noupdate /tb/clr
add wave -noupdate /tb/v_in
add wave -noupdate /tb/data_in
add wave -noupdate /tb/rstn
add wave -noupdate /tb/DUT/count
add wave -noupdate /tb/DUT/sum
add wave -noupdate /tb/DUT/min
add wave -noupdate /tb/DUT/max
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
run -all
