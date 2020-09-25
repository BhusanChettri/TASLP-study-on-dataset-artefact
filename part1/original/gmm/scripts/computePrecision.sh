#!/bin/bash

positive='genuine'  #class for FAR
negative='spoof'
workDir=$PWD

# Thresholds of the original GMM systems
trainThreshold=0.327
devThreshold=0.3334
evalThreshold=0.712

columnsPerLine=3

echo 'Make sure to create soft links to DATASET !!'
codeBase=$workDir/../../../../codebase/
audioBasePath=$workDir/../../../../datasets/ASVSpoof2017_v2.0/   #Dataset folder must be created with symbolic link
weightsPath=$workDir/../model/
codeDir=$codeBase/python/mycodes/

trainProtocal=$audioBasePath'/protocol_V2/ASVspoof2017_V2_train.trn.txt'
devProtocal=$audioBasePath'/protocol_V2/ASVspoof2017_V2_dev.trl.txt'
evalProtocal=$audioBasePath'/protocol_V2/ASVspoof2017_V2_eval.trl.txt'

output=$workDir/../results/
outputFile=$output/'posClass_'$positive'_results.txt'

mkdir -p $output

cd $codeDir 

for testset in 'train' 'dev' 'eval'
do
  if [ $testset == 'train' ];
  then     
     useProtocal=$trainProtocal
     threshold=$trainThreshold
  elif [ $testset == "dev" ]
  then
     useProtocal=$devProtocal
     threshold=$devThreshold
  else
     useProtocal=$evalProtocal
     threshold=$evalThreshold
  fi
  
  #scoreFile=$weightsPath'/predictions/'$testset'_prediction.txt'
  scoreFile=$output'/predictions/'$testset'_prediction.txt'
  echo $scoreFile

  python3 precision_recall_fmeasure.py --protocal $useProtocal --scoreFile $scoreFile --threshold $threshold --positive $positive --negative $negative --outputFile $outputFile --columnsPerLine $columnsPerLine 

done
