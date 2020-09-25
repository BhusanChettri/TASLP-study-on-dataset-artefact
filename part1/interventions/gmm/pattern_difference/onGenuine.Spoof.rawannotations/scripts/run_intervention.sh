#!/bin/bash

# Using our annotation file, remove non speech samples from start and end and perform inference
# This way we ensure that all different artefacts are removed from the test signal.

# Thresholds of the original GMM systems
trainThreshold=0.327
devThreshold=0.3334
evalThreshold=0.712

cmvn=1
workDir=$PWD

echo 'Make sure to create soft links to DATASET !!'
codeBase=$workDir/../../../../../../codebase/
audioBasePath=$workDir/../../../../../../../datasets/ASVSpoof2017_v2.0/   #Dataset folder must be created with symbolic link
gmmPath=$workDir/../../../../../original/gmm/model/
annotationBase=$workDir/../../../../../../data_annotations
codeDirectory=$codeBase/matlab/mycodes/

trainProtocal=$audioBasePath'/protocol_V2/ASVspoof2017_V2_train.trn.txt'
devProtocal=$audioBasePath'/protocol_V2/ASVspoof2017_V2_dev.trl.txt'
evalProtocal=$audioBasePath'/protocol_V2/ASVspoof2017_V2_eval.trl.txt'

cd $codeDirectory

predictionFolder=$workDir/../results/predictions/

for subset in 'dev' 'eval' #'train' 'dev' 'eval'
do
  if [ $subset == 'eval' ]; then
     protocolFile=$evalAnnotations
  elif [ $subset == 'dev' ]; then
     protocolFile=$devAnnotations
  elif [ $subset == 'train' ]; then
     protocolFile=$trainAnnotations
  else
     echo 'No matching subset found !'
     exit 1 

  fi 
 
  filename=$subset'_prediction_explanation.txt'


  annotationFile=$annotationBase/$subset/v2/detailed_annotations/annotations.txt
  audioFolder=$audioBasePath/ASVspoof2017_V2_$subset/ 
  matlab -nodesktop -nosplash -nodisplay -r "try, gmm_intervention_PatternDifference('$predictionFolder','$annotationFile','$audioFolder','$gmmPath','$cmvn','$filename'); end; quit"

done

