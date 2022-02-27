#!/bin/bash 
#SBATCH -t 150:00:00
#SBATCH --nodes=1 --ntasks-per-node=20

#script provided by Dan Bock

screen -d -m -S Anolis_k1_1 bash -c 'structure -K 1 -m mainparams -o k1/Anolis_k1_run1 2>&1 | tee log/k1/Anolis_k1_run1.log'
sleep 10
screen -d -m -S Anolis_k1_2 bash -c 'structure -K 1 -m mainparams -o k1/Anolis_k1_run2 2>&1 | tee log/k1/Anolis_k1_run2.log'
sleep 10
screen -d -m -S Anolis_k1_3 bash -c 'structure -K 1 -m mainparams -o k1/Anolis_k1_run3 2>&1 | tee log/k1/Anolis_k1_run3.log'
sleep 10
screen -d -m -S Anolis_k1_4 bash -c 'structure -K 1 -m mainparams -o k1/Anolis_k1_run4 2>&1 | tee log/k1/Anolis_k1_run4.log'
sleep 10
screen -d -m -S Anolis_k1_5 bash -c 'structure -K 1 -m mainparams -o k1/Anolis_k1_run5 2>&1 | tee log/k1/Anolis_k1_run5.log'
sleep 10
screen -d -m -S Anolis_k1_6 bash -c 'structure -K 1 -m mainparams -o k1/Anolis_k1_run6 2>&1 | tee log/k1/Anolis_k1_run6.log'
sleep 10
screen -d -m -S Anolis_k1_7 bash -c 'structure -K 1 -m mainparams -o k1/Anolis_k1_run7 2>&1 | tee log/k1/Anolis_k1_run7.log'
sleep 10
screen -d -m -S Anolis_k1_8 bash -c 'structure -K 1 -m mainparams -o k1/Anolis_k1_run8 2>&1 | tee log/k1/Anolis_k1_run8.log'
sleep 10
screen -d -m -S Anolis_k1_9 bash -c 'structure -K 1 -m mainparams -o k1/Anolis_k1_run9 2>&1 | tee log/k1/Anolis_k1_run9.log'
sleep 10
screen -d -m -S Anolis_k1_10 bash -c 'structure -K 1 -m mainparams -o k1/Anolis_k1_run10 2>&1 | tee log/k1/Anolis_k1_run10.log'
sleep 10
screen -d -m -S Anolis_k1_11 bash -c 'structure -K 1 -m mainparams -o k1/Anolis_k1_run11 2>&1 | tee log/k1/Anolis_k1_run11.log'
sleep 10
screen -d -m -S Anolis_k1_12 bash -c 'structure -K 1 -m mainparams -o k1/Anolis_k1_run12 2>&1 | tee log/k1/Anolis_k1_run12.log'
sleep 10
screen -d -m -S Anolis_k1_13 bash -c 'structure -K 1 -m mainparams -o k1/Anolis_k1_run13 2>&1 | tee log/k1/Anolis_k1_run13.log'
sleep 10
screen -d -m -S Anolis_k1_14 bash -c 'structure -K 1 -m mainparams -o k1/Anolis_k1_run14 2>&1 | tee log/k1/Anolis_k1_run14.log'
sleep 10
screen -d -m -S Anolis_k1_15 bash -c 'structure -K 1 -m mainparams -o k1/Anolis_k1_run15 2>&1 | tee log/k1/Anolis_k1_run15.log'
sleep 10
screen -d -m -S Anolis_k1_16 bash -c 'structure -K 1 -m mainparams -o k1/Anolis_k1_run16 2>&1 | tee log/k1/Anolis_k1_run16.log'
sleep 10
screen -d -m -S Anolis_k1_17 bash -c 'structure -K 1 -m mainparams -o k1/Anolis_k1_run17 2>&1 | tee log/k1/Anolis_k1_run17.log'
sleep 10
screen -d -m -S Anolis_k1_18 bash -c 'structure -K 1 -m mainparams -o k1/Anolis_k1_run18 2>&1 | tee log/k1/Anolis_k1_run18.log'
sleep 10
screen -d -m -S Anolis_k1_19 bash -c 'structure -K 1 -m mainparams -o k1/Anolis_k1_run19 2>&1 | tee log/k1/Anolis_k1_run19.log'
sleep 10
screen -d -m -S Anolis_k1_20 bash -c 'structure -K 1 -m mainparams -o k1/Anolis_k1_run20 2>&1 | tee log/k1/Anolis_k1_run20.log'
sleep 10
while pidof structure > /dev/null ; do sleep 5 ; done
