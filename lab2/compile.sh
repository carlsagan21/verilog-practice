#! /bin/bash

tb=$1
outext="vp"
vvpfile=$tb$outext

iverilog -o $vvpfile $tb
vvp $vvpfile

