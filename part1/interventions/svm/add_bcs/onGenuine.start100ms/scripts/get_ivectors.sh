#!/bin/bash

# In this intervention we add BCS to the misclassified genuine test files
# Extract i-vectors first

samplestoAdd=100   #100 ms noise samples to add
operation='add'
wheretoAdd='random';
interveneOn='genuine'
cmvn=1
workDir=$PWD
normalise=1     # Whether to post normalise ivectors or not

echo 'Make sure to create soft links to DATASET !!'
codeBase=$workDir/../../../../../../codebase/
audioBasePath=$workDir/../../../../../../../datasets/ASVSpoof2017_v2.0/   #Dataset folder must be created with symbolic link
sampleBCSFile=$audioBasePath/ASVspoof2017_V2_train/T_1001039.wav

cosinePath=$workDir/../../../../../original/cosine/model/   # We need tvm and ubm for ivector extraction
tvmPath=$cosinePath/tvm100.mat
ubmPath=$cosinePath/ubm64.mat  

matlabDir=$codeBase/matlab/mycodes/
   
# We pass the following files as protocals
trainAnnotations=$PWD/../../useFiles/misclassified_genuine/train_prediction.txt
devAnnotations=$PWD/../../useFiles/misclassified_genuine/dev_prediction.txt
evalAnnotations=$PWD/../../useFiles/misclassified_genuine/eval_prediction.txt

newivectorPath=$PWD/../intervened_ivectors/
mkdir $newivectorPath

cd $matlabDir

for subset in 'eval' 'dev' 'train'
do
  if [ $subset == 'eval' ]; then
     protocolFile=$evalAnnotations    
  elif [ $subset == 'dev' ]; then
     protocolFile=$devAnnotations
  else
     protocolFile=$trainAnnotations
  fi 

  audioFolder=$audioBasePath/ASVspoof2017_V2_$subset/
  matlab -nodesktop -nosplash -nodisplay -r "try, gmm_intervention_BCS_ivectorExtraction('$operation','$newivectorPath','$protocolFile','$audioFolder','$ubmPath','$tvmPath','$interveneOn','$cmvn','$subset','$sampleBCSFile','$samplestoAdd'); end; quit"

done



