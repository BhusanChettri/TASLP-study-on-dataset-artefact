#!/bin/bash

# Train adapted light-CNN using spectrograms

workDir=$PWD
audioBasePath=$workDir/../../../../datasets/ASVSpoof2017_v2.0/   #Dataset folder must be created with symbolic link
codeDir=$workDir/../../../../codebase/python/mycodes/
   
fft=1728
window_size=$fft
hop=160
duration=4

#'/import/c4dm-05/bc305/features/ASVspoof2017/power_spectrograms/original/'$duration'sec_'$fft'FFT/'

featureBase=$workDir/../../../../features/power_spectrograms/original/'$duration'sec_'$fft'FFT/

cd $codeDir

# Architecture to use
modelName='light_cnn'
train=1
test=1
test_dev=1
dropout=0.7
epochs=100
earlyStopEpoch=10
ignoreCorruptedFiles=0   #We train, test on all audio files in the dataset

totalRuns=5
for i in `seq 1 $totalRuns`
do
  modelPath=$workDir/../model/$i/
  python train_test.py --train $train --test $test --test_dev $test_dev --root $audioBasePath --dropout $dropout --featurePath $featureBase --modelPath $modelPath --duration $duration --fft $fft --earlyStopEpoch $earlyStopEpoch --architectureName $modelName --ignoreCorruptedFiles $ignoreCorruptedFiles --epochs $epochs  
done

