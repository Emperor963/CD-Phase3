#!/bin/bash

echo Run dff_tb
iverilog -g2012 dv/dff_tb.v dff.v && vvp a.out -fst

echo Run pldff_tb
iverilog -g2012 dv/pldff_tb.v pldff.v && vvp a.out -fst

echo Run memory4c_tb
iverilog -g2012 dv/memory4c_tb.v memory4c.v && vvp a.out -fst

echo Run arrays_tb
iverilog -g2012 -y . dv/arrays_tb.v && vvp a.out -fst

