onerror {resume}
quietly WaveActivateNextPane {} 0
add wave -noupdate -divider {TB}
add wave -noupdate /top_tb/iCLK
add wave -noupdate /top_tb/inRST
add wave -noupdate -radix unsigned /top_tb/oLED
add wave -noupdate -divider {Instruction Mem}
add wave -noupdate -radix unsigned /top_tb/uut/cpu_top_i/sPC
add wave -noupdate /top_tb/uut/cpu_top_i/iINSTR
add wave -noupdate /top_tb/uut/cpu_top_i/sPC_LOAD
add wave -noupdate -radix unsigned /top_tb/uut/cpu_top_i/sPC_IN
add wave -noupdate -divider {Control Unit}
add wave -noupdate -radix unsigned /top_tb/uut/cpu_top_i/cu_i/sY
add wave -noupdate -radix unsigned /top_tb/uut/cpu_top_i/cu_i/sX
add wave -noupdate -radix unsigned /top_tb/uut/cpu_top_i/cu_i/sZ
add wave -noupdate -radix unsigned /top_tb/uut/cpu_top_i/cu_i/sA
add wave -noupdate /top_tb/uut/cpu_top_i/cu_i/sI
add wave -noupdate /top_tb/uut/cpu_top_i/cu_i/sO
add wave -noupdate /top_tb/uut/cpu_top_i/cu_i/sT
add wave -noupdate /top_tb/uut/cpu_top_i/cu_i/iZERO
add wave -noupdate /top_tb/uut/cpu_top_i/cu_i/iSIGN
add wave -noupdate /top_tb/uut/cpu_top_i/cu_i/iCARRY
add wave -noupdate -divider {Muxes}
add wave -noupdate -radix unsigned /top_tb/uut/cpu_top_i/sMUXA_SEL
add wave -noupdate -radix unsigned /top_tb/uut/cpu_top_i/sMUXB_SEL
add wave -noupdate -radix unsigned /top_tb/uut/cpu_top_i/sMUXA
add wave -noupdate -radix unsigned /top_tb/uut/cpu_top_i/sMUXB
add wave -noupdate -divider {ALU}
add wave -noupdate -radix unsigned /top_tb/uut/cpu_top_i/alu_i/iA
add wave -noupdate -radix unsigned /top_tb/uut/cpu_top_i/alu_i/iB
add wave -noupdate -radix unsigned /top_tb/uut/cpu_top_i/alu_i/oC
add wave -noupdate -radix unsigned /top_tb/uut/cpu_top_i/alu_i/oZERO
add wave -noupdate -radix unsigned /top_tb/uut/cpu_top_i/alu_i/oSIGN
add wave -noupdate -radix unsigned /top_tb/uut/cpu_top_i/alu_i/oCARRY
add wave -noupdate -divider {Regs}
add wave -noupdate /top_tb/uut/cpu_top_i/sREG_WE
add wave -noupdate -radix unsigned /top_tb/uut/cpu_top_i/sR0
add wave -noupdate -radix unsigned /top_tb/uut/cpu_top_i/sR1
add wave -noupdate -radix unsigned /top_tb/uut/cpu_top_i/sR2
add wave -noupdate -radix unsigned /top_tb/uut/cpu_top_i/sR3
add wave -noupdate -radix unsigned /top_tb/uut/cpu_top_i/sR4
add wave -noupdate -radix unsigned /top_tb/uut/cpu_top_i/sR5
add wave -noupdate -radix unsigned /top_tb/uut/cpu_top_i/sR6
add wave -noupdate -radix unsigned /top_tb/uut/cpu_top_i/sR7
add wave -noupdate -divider {Data Mem}
add wave -noupdate -radix unsigned /top_tb/uut/cpu_top_i/oADDR
add wave -noupdate -radix unsigned /top_tb/uut/cpu_top_i/iDATA
add wave -noupdate -radix unsigned /top_tb/uut/cpu_top_i/oDATA
add wave -noupdate /top_tb/uut/cpu_top_i/oMEM_WE
add wave -noupdate -radix unsigned /top_tb/uut/data_ram_i/rMEM(0)
add wave -noupdate -radix unsigned /top_tb/uut/data_ram_i/rMEM(1)
add wave -noupdate -radix unsigned /top_tb/uut/data_ram_i/rMEM(2)
add wave -noupdate -divider {Other}
TreeUpdate [SetDefaultTree]
WaveRestoreCursors {{Cursor 1} {1000000 ps} 0}
quietly wave cursor active 1
configure wave -namecolwidth 407
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
configure wave -timelineunits ns
update
WaveRestoreZoom {0 ps} {2 us}
