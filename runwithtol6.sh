#!/bin/bash
for ptol in 1d-6
do
    #for p in 2 1 1.5 1.1 1.01 1.001 1.0001 1.00001 0.99 0.9
    for p in 1
    do
	for n in 2 4 6 8 10 20 50 100 200 1000
	do
	    for m in 5 10 20
	    do
		echo $ptol $p $n $m
		#./rosenbrockp $m $n $p $ptol >> OUTPUTS/res1d6.txt
		./rosenbrockp $m $n $p $ptol
	    done
	done
    done
done

exit 0;

