#!/bin/bash

# In this intervention we add BCS to misclassified Genuine test files
# We use the same BCS sample file that was used in DNN experiments

samplestoAdd=100      #in milliseconds

operation='add'       #same scripts just pass this flag and signatureBCS file
interveneOn='genuine'
cmvn=1

workDir=$PWD
predictionFolder=$workDir/../results/predictions/

echo 'Make sure to create soft links to DATASET !!'
codeBase=$workDir/../../../../../../codebase/
audioBasePath=$workDir/../../../../../../../datasets/ASVSpoof2017_v2.0/   #Dataset folder must be created with symbolic link
gmmPath=$workDir/../../../../../original/gmm/model/
matlabDir=$codeBase/matlab/mycodes/
   
# We pass the following files as protocals
trainAnnotations=$PWD/../../useFiles/misclassified_genuine/train_prediction.txt
devAnnotations=$PWD/../../useFiles/misclassified_genuine/dev_prediction.txt
evalAnnotations=$PWD/../../useFiles/misclassified_genuine/eval_prediction.txt
sampleBCSFile=$audioBasePath/ASVspoof2017_V2_train/T_1001039.wav

cd $matlabDir

for subset in 'eval' 'dev' 'train'
do
  if [ $subset == 'eval' ]; then
     protocolFile=$evalAnnotations
     filename=$subset'_bonafide_prediction.txt'
  elif [ $subset == 'dev' ]; then
     protocolFile=$devAnnotations
     filename=$subset'_bonafide_prediction.txt'
  else
     protocolFile=$trainAnnotations
     filename=$subset'_bonafide_prediction.txt'
  fi 
  audioFolder=$audioBasePath/ASVspoof2017_V2_$subset/
  matlab -nodesktop -nosplash -nodisplay -r "try, gmm_intervention_BCS('$operation','$predictionFolder','$protocolFile','$audioFolder','$gmmPath','$interveneOn','$cmvn','$filename','$sampleBCSFile','$samplestoAdd'); end; quit"

done

