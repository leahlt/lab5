onerror {resume}
quietly WaveActivateNextPane {} 0
add wave -noupdate -divider CPU
add wave -noupdate /cpu_tb/in
add wave -noupdate /cpu_tb/clk
add wave -noupdate /cpu_tb/reset
add wave -noupdate /cpu_tb/s
add wave -noupdate /cpu_tb/err
add wave -noupdate /cpu_tb/out
add wave -noupdate /cpu_tb/N
add wave -noupdate /cpu_tb/V
add wave -noupdate /cpu_tb/Z
add wave -noupdate /cpu_tb/w
add wave -noupdate -divider Datapath
add wave -noupdate /cpu_tb/DUT/DP/mdata
add wave -noupdate /cpu_tb/DUT/DP/sximm8
add wave -noupdate /cpu_tb/DUT/DP/sximm5
add wave -noupdate /cpu_tb/DUT/DP/datapath_out
add wave -noupdate /cpu_tb/DUT/DP/write
add wave -noupdate /cpu_tb/DUT/DP/loada
add wave -noupdate /cpu_tb/DUT/DP/loadb
add wave -noupdate /cpu_tb/DUT/DP/asel
add wave -noupdate /cpu_tb/DUT/DP/bsel
add wave -noupdate /cpu_tb/DUT/DP/loadc
add wave -noupdate /cpu_tb/DUT/DP/loads
add wave -noupdate /cpu_tb/DUT/DP/clk
add wave -noupdate /cpu_tb/DUT/DP/readnum
add wave -noupdate /cpu_tb/DUT/DP/writenum
add wave -noupdate /cpu_tb/DUT/DP/shift
add wave -noupdate /cpu_tb/DUT/DP/ALUop
add wave -noupdate /cpu_tb/DUT/DP/PC
add wave -noupdate /cpu_tb/DUT/DP/vsel
add wave -noupdate /cpu_tb/DUT/DP/Z_out
add wave -noupdate /cpu_tb/DUT/DP/Zal
add wave -noupdate /cpu_tb/DUT/DP/Z
add wave -noupdate /cpu_tb/DUT/DP/N
add wave -noupdate /cpu_tb/DUT/DP/V
add wave -noupdate /cpu_tb/DUT/DP/data_in
add wave -noupdate /cpu_tb/DUT/DP/data_out
add wave -noupdate /cpu_tb/DUT/DP/Aload
add wave -noupdate /cpu_tb/DUT/DP/Bload
add wave -noupdate /cpu_tb/DUT/DP/sout
add wave -noupdate /cpu_tb/DUT/DP/Ain
add wave -noupdate /cpu_tb/DUT/DP/Bin
add wave -noupdate /cpu_tb/DUT/DP/out
add wave -noupdate -divider FSM
add wave -noupdate /cpu_tb/DUT/con/present_state
add wave -noupdate /cpu_tb/DUT/con/clk
add wave -noupdate /cpu_tb/DUT/con/s
add wave -noupdate /cpu_tb/DUT/con/reset
add wave -noupdate /cpu_tb/DUT/con/opcode
add wave -noupdate /cpu_tb/DUT/con/op
add wave -noupdate /cpu_tb/DUT/con/loada
add wave -noupdate /cpu_tb/DUT/con/loadb
add wave -noupdate /cpu_tb/DUT/con/loadc
add wave -noupdate /cpu_tb/DUT/con/write
add wave -noupdate /cpu_tb/DUT/con/asel
add wave -noupdate /cpu_tb/DUT/con/bsel
add wave -noupdate /cpu_tb/DUT/con/loads
add wave -noupdate /cpu_tb/DUT/con/nsel
add wave -noupdate /cpu_tb/DUT/con/vsel
add wave -noupdate /cpu_tb/DUT/con/w
TreeUpdate [SetDefaultTree]
WaveRestoreCursors {{Cursor 1} {513 ps} 0}
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
WaveRestoreZoom {0 ps} {1 ns}
