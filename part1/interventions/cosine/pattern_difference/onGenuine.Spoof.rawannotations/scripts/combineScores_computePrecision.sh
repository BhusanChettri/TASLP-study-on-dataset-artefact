#!/bin/bash

workDir=$PWD

# Thresholds of the original ivector Cosine systems
trainThreshold=0.045
devThreshold=0.125
evalThreshold=0.181

scoreFormat='three-column'

echo 'Make sure to create soft links to DATASET !!'
codeBase=$workDir/../../../../../../codebase/
audioBasePath=$workDir/../../../../../../../datasets/ASVSpoof2017_v2.0/   #Dataset folder must be created with symbolic link
annotationBase=$workDir/../../../../../../data_annotations
cosinePath=$workDir/../../../../../original/cosine/model/
pythonScriptPath=$codeBase/python/mycodes/

trainProtocal=$audioBasePath'/protocol_V2/ASVspoof2017_V2_train.trn.txt'
devProtocal=$audioBasePath'/protocol_V2/ASVspoof2017_V2_dev.trl.txt'
evalProtocal=$audioBasePath'/protocol_V2/ASVspoof2017_V2_eval.trl.txt'

predictionFolder=$workDir/../results/predictions/
evalAnnotations=$annotationBase/eval/v2/detailed_annotations/annotations.txt
originalScores=$cosinePath/predictions/

cd $pythonScriptPath

# Format the scores to match the way script: combine_new_scores_and_get_eer.py accepts
python3 format_scores.py --annotations $evalAnnotations --scorePath $predictionFolder --subset 'eval'

originalScores=$originalScores/eval_prediction.txt
interventionFile=$predictionFolder/eval_prediction.txt  #eval_bonafide_prediction.txt

# Now we first combine 1298 genuine scores with the spoof original scores of the same model and create new eval_prediction.txt score file
python3 combine_new_scores_and_get_eer.py --subset 'eval' --originalScoreFile $originalScores --interventionScoreFile $interventionFile --protocal $evalProtocal --output $predictionFolder --scoreFormat $scoreFormat

# Compute precision-recall and other stuffs -for the intervened score file
prec_recall_directory=$workDir/../results/precision_recall/

if [ ! -d $prec_recall_directory ]; then
  mkdir $prec_recall_directory
fi

for positive in 'genuine'
do
  outputFile=$prec_recall_directory/'posClass_'$positive'_results.txt'

  if [ $positive == 'genuine' ]; then 
     negative='spoof'
  fi

  if [ $positive == 'spoof' ]; then  
     negative='genuine'
  fi

  for subset in 'dev' 'eval'  #'train'
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
   scoreFile=$predictionFolder/$subset'_prediction.txt'
   python3 precision_recall_fmeasure.py --protocal $useProtocal --scoreFile $scoreFile --threshold $threshold --positive $positive --negative $negative --outputFile $outputFile

  done
done
