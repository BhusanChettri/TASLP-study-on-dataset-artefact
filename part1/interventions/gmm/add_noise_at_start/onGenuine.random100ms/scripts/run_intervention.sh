#!/bin/bash

# In this intervention we add Gaussian Noise with SNR 0, 6 to misclassified Genuine test files

samplestoAdd=100   #100 ms noise samples to add
wheretoAdd='start';
interveneOn='genuine'
cmvn=1
workDir=$PWD

echo 'Make sure to create soft links to DATASET !!'
codeBase=$workDir/../../../../../../codebase/
audioBasePath=$workDir/../../../../../../../datasets/ASVSpoof2017_v2.0/   #Dataset folder must be created with symbolic link
gmmPath=$workDir/../../../../../original/gmm/model/
matlabDir=$codeBase/matlab/mycodes/
   
# We pass the following files as protocals
trainAnnotations=$PWD/../../useFiles/misclassified_genuine/train_prediction.txt
devAnnotations=$PWD/../../useFiles/misclassified_genuine/dev_prediction.txt
evalAnnotations=$PWD/../../useFiles/misclassified_genuine/eval_prediction.txt

cd $matlabDir

for snr in 0 6 10
do
  predictionFolder=$workDir/../snr$snr/predictions/
  for subset in 'train' 'dev' 'eval' 
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

    matlab -nodesktop -nosplash -nodisplay -r "try, gmm_intervention_scaledNoise('$snr','$wheretoAdd','$predictionFolder','$protocolFile','$audioFolder','$gmmPath','$interveneOn','$cmvn','$filename','$samplestoAdd'); end; quit"

  done
done

#TODO: no need to pass user as such. Each matlab code now can access the same library path (using the absolute path)


