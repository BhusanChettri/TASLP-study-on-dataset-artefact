#!/bin/bash

# In this intervention we add Gaussian Noise with SNR 0, 6 to misclassified Genuine test files
# Extract i-vectors first

samplestoAdd=100   #100 ms noise samples to add

wheretoAdd='random';
interveneOn='genuine'
cmvn=1
workDir=$PWD
normalise=1     # Whether to post normalise ivectors or not
user=$USER

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

cd $matlabDir

for snr in 0 6 10
do
  savePath=$newivectorPath/snr$snr/
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

    matlab -nodesktop -nosplash -nodisplay -r "try, cosine_intervention_noise_ivectorExtraction('$snr','$wheretoAdd','$savePath','$protocolFile','$audioFolder','$ubmPath','$tvmPath','$interveneOn','$cmvn','$subset','$samplestoAdd'); end; quit"
  done
done

# We use the code: cosine_intervention_noise_ivectorExtraction for ivector extraction and save (adding noise)





