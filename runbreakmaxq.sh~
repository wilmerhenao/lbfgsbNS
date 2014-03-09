#!/bin/bash

for p in 2 1.1 1.01 1.001 1.0001 1.00001 1.000001 1.0000001 1.00000001 1.000000001 1.0000000001 1.00000000001
do
    for m in 5 6 7 8 9 10 11 12 13 14 15 16 17 18 19 20
    do
	echo 10 2000 $p
	~/Documents/thesis/lbfgsfortran/./rosenbrockp $m 2000 $p >> outputBreak/breakrosenbrockweak.txt
	#~/Documents/thesis/lbfgsfortran/./rosenbrockStrongp 10 2000 $p >> outputBreak/breakrosenbrockStrong$p.txt
    done
done

exit 0;

