#!/bin/bash

# In this intervention we add Gaussian Noise with SNR 0, 6 to correctly classified Spoof test files
samplestoAdd=100   #100 ms noise samples to add
wheretoAdd='random';
interveneOn='spoof'
cmvn=1
workDir=$PWD

echo 'Make sure to create soft links to DATASET !!'
codeBase=$workDir/../../../../../../codebase/
audioBasePath=$workDir/../../../../../../../datasets/ASVSpoof2017_v2.0/   #Dataset folder must be created with symbolic link
gmmPath=$workDir/../../../../../original/gmm/model/
matlabDir=$codeBase/matlab/mycodes/
   
# We pass the following files as protocals
trainAnnotations=$PWD/../../useFiles/correctly_classified_spoof/train_prediction.txt
devAnnotations=$PWD/../../useFiles/correctly_classified_spoof/dev_prediction.txt
evalAnnotations=$PWD/../../useFiles/correctly_classified_spoof/eval_prediction.txt

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


