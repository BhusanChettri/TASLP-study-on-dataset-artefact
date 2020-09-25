#!/bin/bash

# BCS intervention on Misclassified Genuine files by the Cosine-ivector system
# We extract the file-list offline

operation='add'
interveneOn='genuine'
samplestoRemove=100  # 100 ms samples

cmvn=1
normalise=1     # Whether to post normalise ivectors or not
trainOn='T';
workDir=$PWD

echo 'Make sure to create soft links to DATASET !!'
codeBase=$workDir/../../../../../../codebase/
audioBasePath=$workDir/../../../../../../../datasets/ASVSpoof2017_v2.0/   #Dataset folder must be created with symbolic link
cosinePath=$workDir/../../../../../original/cosine/model/
tvmPath=$cosinePath/tvm100.mat
ubmPath=$cosinePath/ubm64.mat  
matlabDir=$codeBase/matlab/mycodes/
   
# We pass the following files as protocals
trainAnnotations=$PWD/../../useFiles/misclassified_genuine/train_prediction.txt
devAnnotations=$PWD/../../useFiles/misclassified_genuine/dev_prediction.txt
evalAnnotations=$PWD/../../useFiles/misclassified_genuine/eval_prediction.txt

sampleBCSFile=$audioBasePath/ASVspoof2017_V2_train/T_1001039.wav

newivectorPath=$PWD/../intervened_ivectors/
predictionFolder=$workDir/../results/predictions/

cd $matlabDir
for subset in 'eval' 'dev' 'train'
do
  if [ $subset == 'eval' ]; then
     protocolFile=$evalAnnotations    
  elif [ $subset == 'dev' ]; then
     protocolFile=$devAnnotations
  elif [ $subset == 'train' ]; then
     protocolFile=$trainAnnotations
  else
     echo 'No matching subset';
  fi 

  audioFolder=$audioBasePath/ASVspoof2017_V2_$subset/
  matlab -nodesktop -nosplash -nodisplay -r "try, gmm_intervention_BCS_ivectorExtraction('$operation','$newivectorPath','$protocolFile','$audioFolder','$ubmPath','$tvmPath','$interveneOn','$cmvn','$subset','$sampleBCSFile','$samplestoRemove'); end; quit"

done

# Now train and test cosine distance classifier
# We pass both original i-vectors path and new ivectors path to compute cosine distance metric and save the scores.
matlab -nodesktop -nosplash -nodisplay -r "try, train_test_cosine_ivector_intervention('$predictionFolder','$cosinePath','$newivectorPath', '$normalise'); end; quit"


