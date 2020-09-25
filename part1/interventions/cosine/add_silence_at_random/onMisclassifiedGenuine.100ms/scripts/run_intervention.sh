#!/bin/bash

# In this intervention we add 100ms silence to the start of audio file before computing CQCC features and ivectors
# We do this on all the misclassified Genuine test files
# WE use the script: cosine_intervention_zeros_ivectorExtraction for extracting the new ivectors

samplestoAdd=100   #100 ms noise samples to add

wheretoAdd='random';
interveneOn='genuine'
cmvn=1
workDir=$PWD
normalise=1     # Whether to post normalise ivectors or not

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

savePath=$PWD/../intervened_ivectors/

cd $matlabDir

predictionFolder=$workDir/../result/predictions/
newivectorPath=$savePath/

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

# Now train and test cosine distance classifier
# We pass both original i-vectors path and new ivectors path to compute cosine distance metric and save the scores.
matlab -nodesktop -nosplash -nodisplay -r "try, train_test_cosine_ivector_intervention('$predictionFolder','$cosinePath','$newivectorPath', '$normalise'); end; quit"






