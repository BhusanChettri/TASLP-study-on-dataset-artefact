#!/bin/bash

# In this intervention we add 10 ms silence to the misclassified genuine files
# Extract i-vectors first

samplestoAdd=10   #10 ms noise samples to add

wheretoAdd='start';
interveneOn='genuine'
cmvn=1
workDir=$PWD
normalise=1     # Whether to post normalise ivectors or not

echo 'Make sure to create soft links to DATASET !!'
codeBase=$workDir/../../../../../../codebase/
audioBasePath=$workDir/../../../../../../../datasets/ASVSpoof2017_v2.0/   #Dataset folder must be created with symbolic link

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

for subset in 'train' 'dev' 'eval'
  do
    if [ $subset == 'eval' ]; then
       protocolFile=$evalAnnotations
    elif [ $subset == 'dev' ]; then
       protocolFile=$devAnnotations
    else
       protocolFile=$trainAnnotations
    fi 
    audioFolder=$audioBasePath/ASVspoof2017_V2_$subset/
    matlab -nodesktop -nosplash -nodisplay -r "try, cosine_intervention_zeros_ivectorExtraction('$wheretoAdd','$newivectorPath','$protocolFile','$audioFolder','$ubmPath','$tvmPath','$interveneOn','$cmvn','$subset','$samplestoAdd'); end; quit"

done

# We use the code: cosine_intervention_noise_ivectorExtraction for ivector extraction and save (adding noise)





