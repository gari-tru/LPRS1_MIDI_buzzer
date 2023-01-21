
# All is relative to simulation/modelsim/

restart -force
delete wave *

set wf top_tb_wave.do

if {[file exists wave.do]} {
	file delete ../../$wf
	file copy wave.do ../../$wf
}

do $wf

# Ignoring uninitialized signals warnings before reset activated.
set StdArithNoWarnings 1
set NumericStdNoWarnings 1
run 2ps
set StdArithNoWarnings 0
set NumericStdNoWarnings 0

# Run frame
proc rf {} {
	run 133333 ns
}

rf
