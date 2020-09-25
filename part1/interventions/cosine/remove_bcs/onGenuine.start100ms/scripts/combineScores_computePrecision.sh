#!/bin/bash

# Thresholds of the original ivector Cosine systems
trainThreshold=0.045
devThreshold=0.125
evalThreshold=0.181

scoreFormat='three-column'
workDir=$PWD

echo 'Make sure to create soft links to DATASET !!'
codeBase=$workDir/../../../../../../codebase/
audioBasePath=$workDir/../../../../../../../datasets/ASVSpoof2017_v2.0/   #Dataset folder must be created with symbolic link
weightsPath=$workDir/../../../../../original/cosine/model/
pythonScriptPath=$codeBase/python/mycodes/
annotationBase=$workDir/../../../../../../data_annotations
   
trainProtocal=$audioBasePath'/protocol_V2/ASVspoof2017_V2_train.trn.txt'
devProtocal=$audioBasePath'/protocol_V2/ASVspoof2017_V2_dev.trl.txt'
evalProtocal=$audioBasePath'/protocol_V2/ASVspoof2017_V2_eval.trl.txt'

predictionFolder=$workDir/../results/predictions/
prec_recall_directory=$workDir/../results/precision_recall/
mkdir $prec_recall_directory

savePath=$workDir/../results/
cd $pythonScriptPath


for positive in 'genuine'
do
  outputFile=$prec_recall_directory/'posClass_'$positive'_results.txt'

  if [ $positive == 'genuine' ]; then 
     negative='spoof'
  fi

  if [ $positive == 'spoof' ]; then  
     negative='genuine'
  fi

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
   useAnnotations=$annotationBase/$subset/v2/detailed_annotations/bcs_start_file_last_columns_removed_genuine.txt  #This is same as 'bcs_start_file.txt' but last column removed for script compatibility

   #1. First, format the scores to match the way script: combine_new_scores_and_get_eer.py works
   python3 format_scores.py --annotations $useAnnotations --scorePath $predictionFolder --subset $subset

   # Merge original and new scores
   oldScores=$weightsPath/predictions/$subset'_prediction.txt'
   interventionFile=$predictionFolder/$subset'_prediction.txt'
   python3 combine_new_scores_and_get_eer.py --subset $subset --originalScoreFile $oldScores --interventionScoreFile $interventionFile --protocal $useProtocal --output $predictionFolder --scoreFormat $scoreFormat

   scoreFile=$predictionFolder/$subset'_prediction.txt'   
   python3 precision_recall_fmeasure.py --protocal $useProtocal --scoreFile $scoreFile --threshold $threshold --positive $positive --negative $negative --outputFile $outputFile

  done
done
