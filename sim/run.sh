#!/bin/bash
BASE=".."
TEST="$1"

if [[ $# -ne 1 ]]; then
	printf "Usage:\n  ./run.sh testname # corresponds to ../testcases/testname.list\n"
	exit
fi

LIST="$BASE/testcases/${TEST}.list"
if [[ ! -f $LIST ]]; then
	printf "$LIST does not exist. Exiting."
	exit
fi

perl $BASE/WISC-assembler/assembler.pl $LIST > loadfile_instr.img
touch loadfile_data.img # empty data memory image

# This is for Icarus Verilog
iverilog -g2012 -I $BASE/design -Y .sv -Y .v -Y .vh -y $BASE/dv -y $BASE/design -y $BASE/ip $BASE/dv/phase2_cpu_tb.v && vvp a.out -fst

mv verilogsim.log $TEST.log
mv verilogsim.trace $TEST.trace
