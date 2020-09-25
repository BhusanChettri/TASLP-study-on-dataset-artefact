#!/bin/bash

positive='genuine'  #class for FAR
negative='spoof'
workDir=$PWD

scoreFormat='three-column'

# Thresholds of the original GMM systems
trainThreshold=0.327
devThreshold=0.3334
evalThreshold=0.712

echo 'Make sure to create soft links to DATASET !!'
codeBase=$workDir/../../../../../../codebase/
audioBasePath=$workDir/../../../../../../../datasets/ASVSpoof2017_v2.0/   #Dataset folder must be created with symbolic link
weightsPath=$workDir/../../../../../original/gmm/model/
codeDir=$codeBase/python/mycodes/

trainProtocal=$audioBasePath'/protocol_V2/ASVspoof2017_V2_train.trn.txt'
devProtocal=$audioBasePath'/protocol_V2/ASVspoof2017_V2_dev.trl.txt'
evalProtocal=$audioBasePath'/protocol_V2/ASVspoof2017_V2_eval.trl.txt'

output=$workDir/../results/predictions/
outputFile=$output/'posClass_'$positive'_results.txt'

mkdir -p $output

cd $codeDir 

for testset in 'dev' 'eval' #'train'
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

  interventionFile=$workDir/../results/predictions/$testset'_prediction_explanation.txt'


  python3 combine_new_scores_and_get_eer.py --subset $testset --originalScoreFile $originalScores --interventionScoreFile $interventionFile --protocal $useProtocal --output $output --scoreFormat $scoreFormat

  scoreFile=$output/$testset'_prediction.txt'

  python3 precision_recall_fmeasure.py --protocal $useProtocal --scoreFile $scoreFile --threshold $threshold --positive $positive --negative $negative --outputFile $outputFile  

done
