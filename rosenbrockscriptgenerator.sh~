#!/bin/bash

#for i in {2 1.1 1.01 1.001 1.0001 1.00001 1.000001 1.0000001 1.00000001 1.000000001 1.0000000001 1.00000000001 0.5}
for i in {0..14}
do
  cat > pbs.script.rosenbrock.$i <<EOF
#!/bin/bash

#PBS -l nodes=1:ppn=8,walltime=48:00:00
#PBS -m abe
#PBS -M weh227@nyu.edu
#PBS -N rosenbrockHD$((i))

module load gcc/4.7.3

cd /scratch/weh227/rosenbrock/
p=$(bc -l <<< "1+10 ^(-$((i)))")
for n in 1000 100000 1000000 10000000 100000000
do
   echo 10 \$n \$p
   ~/Documents/thesis/lbfgsfortran/./rosenbrockp 10 \$n \$p >> outputrosenbrock$((i)).txt
done

exit 0;

EOF
done
