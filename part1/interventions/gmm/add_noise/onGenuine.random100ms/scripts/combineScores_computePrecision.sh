#!/bin/bash

# Thresholds of the original GMM systems
trainThreshold=0.327
devThreshold=0.3334
evalThreshold=0.712

positive='genuine'  #class for FAR
negative='spoof'

workDir=$PWD

echo 'Make sure to create soft links to DATASET !!'
codeBase=$workDir/../../../../../../codebase/
audioBasePath=$workDir/../../../../../../../datasets/ASVSpoof2017_v2.0/   #Dataset folder must be created with symbolic link
weightsPath=$workDir/../../../../../original/gmm/model/
pythonScriptPath=$codeBase/python/mycodes/

trainProtocal=$audioBasePath'/protocol_V2/ASVspoof2017_V2_train.trn.txt'
devProtocal=$audioBasePath'/protocol_V2/ASVspoof2017_V2_dev.trl.txt'
evalProtocal=$audioBasePath'/protocol_V2/ASVspoof2017_V2_eval.trl.txt'

cd $pythonScriptPath

for snr in 10 #0 #6
do
  predictionFolder=$workDir/../snr$snr/predictions/
  prec_recall_directory=$workDir/../snr$snr/precision_recall/

  if [ ! -d $prec_recall_directory ]; then
  mkdir $prec_recall_directory
  fi
  
  for positive in 'genuine'
  do
    outputFile=$prec_recall_directory/'posClass_'$positive'_results.txt'
    for subset in 'train' 'dev' 'eval'
    do
      if [ $subset == 'train' ]; 
      then
        useProtocal=$trainProtocal
        threshold=$trainThreshold 
      elif [ $subset == "dev" ];
      then
        useProtocal=$devProtocal
        threshold=$devThreshold
      else
        useProtocal=$evalProtocal
        threshold=$evalThreshold 
      fi
      
      # Merge original and new scores
      oldScores=$weightsPath/predictions/$subset'_prediction.txt'
      interventionFile=$predictionFolder/$subset'_bonafide_prediction.txt'
      python3 combine_new_scores_and_get_eer.py --subset $subset --originalScoreFile $oldScores --interventionScoreFile $interventionFile --protocal $useProtocal --output $predictionFolder
    
      # Compute the metrics
      scoreFile=$predictionFolder/$subset'_prediction.txt'
      python3 precision_recall_fmeasure.py --protocal $useProtocal --scoreFile $scoreFile --threshold $threshold --positive $positive --negative $negative --outputFile $outputFile 
    done
  done
done

