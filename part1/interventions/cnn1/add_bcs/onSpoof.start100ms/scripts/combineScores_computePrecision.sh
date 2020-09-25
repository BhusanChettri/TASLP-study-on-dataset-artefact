#!/bin/bash

positive='genuine'  #class for FAR
negative='spoof'
workDir=$PWD

trainThreshold=0.5
devThreshold=0.6663
evalThreshold=0.7467

echo 'Make sure to create soft links to DATASET !!'
codeBase=$workDir/../../../../../../codebase/
audioBasePath=$workDir/../../../../../../../datasets/ASVSpoof2017_v2.0/   #Dataset folder must be created with symbolic link
weightsPath=$workDir/../../../../../original/light_cnn/model/
codeDir=$codeBase/python/mycodes/

trainProtocal=$audioBasePath'/protocol_V2/ASVspoof2017_V2_train.trn.txt'
devProtocal=$audioBasePath'/protocol_V2/ASVspoof2017_V2_dev.trl.txt'
evalProtocal=$audioBasePath'/protocol_V2/ASVspoof2017_V2_eval.trl.txt'

output=$workDir/../results/predictions/
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
  
  originalScores=$weightsPath'/predictions/'$testset'_prediction.txt'
  interventionFile=$workDir/../results/$testset/explanations_all.txt

  python3 combine_new_scores_and_get_eer.py --subset $testset --originalScoreFile $originalScores --interventionScoreFile $interventionFile --protocal $useProtocal --output $output

  scoreFile=$output/$testset'_prediction.txt'

  python3 precision_recall_fmeasure.py --protocal $useProtocal --scoreFile $scoreFile --threshold $threshold --positive $positive --negative $negative --outputFile $outputFile  

done
