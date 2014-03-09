#!/bin/bash

for n in 10 100 1000 10000 100000 1000000 10000000 100000000
do
    for m in 5 6 7 8 9 10 11 12 13 14 15 16 17 18 19 20
    do
	echo $m $n
	~/Documents/thesis/lbfgsfortran/./maxq $m $n 2 >> outputBreak/maxq.txt
	#~/Documents/thesis/lbfgsfortran/./rosenbrockStrongp 10 2000 $p >> outputBreak/breakrosenbrockStrong$p.txt
    done
done

exit 0;

