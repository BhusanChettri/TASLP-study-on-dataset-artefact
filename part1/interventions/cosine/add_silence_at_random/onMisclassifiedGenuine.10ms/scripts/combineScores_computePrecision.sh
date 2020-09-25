#!/bin/bash

# Thresholds of the original ivector Cosine systems
trainThreshold=0.045
devThreshold=0.125
evalThreshold=0.181

positive='genuine'  #class for FAR
negative='spoof'

scoreFormat='three-column'

workDir=$PWD

echo 'Make sure to create soft links to DATASET !!'
codeBase=$workDir/../../../../../../codebase/
audioBasePath=$workDir/../../../../../../../datasets/ASVSpoof2017_v2.0/   #Dataset folder must be created with symbolic link
weightsPath=$workDir/../../../../../original/cosine/model/
pythonScriptPath=$codeBase/python/mycodes/

trainProtocal=$audioBasePath'/protocol_V2/ASVspoof2017_V2_train.trn.txt'
devProtocal=$audioBasePath'/protocol_V2/ASVspoof2017_V2_dev.trl.txt'
evalProtocal=$audioBasePath'/protocol_V2/ASVspoof2017_V2_eval.trl.txt'

# We pass the following files as protocals
trainAnnotations=$PWD/../../useFiles/misclassified_genuine/train_prediction.txt
devAnnotations=$PWD/../../useFiles/misclassified_genuine/dev_prediction.txt
evalAnnotations=$PWD/../../useFiles/misclassified_genuine/eval_prediction.txt


cd $pythonScriptPath

predictionFolder=$workDir/../result/predictions/
prec_recall_directory=$workDir/../result/precision_recall/

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
        useAnnotations=$trainAnnotations  
      elif [ $subset == "dev" ];
      then
        useProtocal=$devProtocal
        threshold=$devThreshold
        useAnnotations=$devAnnotations
      else
        useProtocal=$evalProtocal
        threshold=$evalThreshold 
        useAnnotations=$evalAnnotations
      fi

      #1. First, format the scores to match the way script: combine_new_scores_and_get_eer.py works
      python3 format_scores.py --annotations $useAnnotations --scorePath $predictionFolder --subset $subset
      
      # Merge original and new scores
      oldScores=$weightsPath/predictions/$subset'_prediction.txt'
      #interventionFile=$predictionFolder/$subset'_bonafide_prediction.txt'
      interventionFile=$predictionFolder/$subset'_prediction.txt'
      python3 combine_new_scores_and_get_eer.py --subset $subset --originalScoreFile $oldScores --interventionScoreFile $interventionFile --protocal $useProtocal --output $predictionFolder --scoreFormat $scoreFormat
    
      # Compute the metrics
      scoreFile=$predictionFolder/$subset'_prediction.txt'
      python3 precision_recall_fmeasure.py --protocal $useProtocal --scoreFile $scoreFile --threshold $threshold --positive $positive --negative $negative --outputFile $outputFile 
    done
done

