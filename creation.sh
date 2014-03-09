#!/bin/bash
 
for i in {0..9}
do
    cat > pbs.script.$i <<EOF
 EOF
#!/bin/bash
 
#PBS -l nodes=1:ppn=1,walltime=600
 
cd \$PBS_O_WORKDIR
 
for ((i=$((i*100000)); i<$(((i+1)*100000)); i++))
 {
    echo "\$i" >> output.txt
 }
 
exit 0;
 
EOF
done
