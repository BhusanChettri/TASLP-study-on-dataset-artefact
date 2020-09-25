#!/bin/bash

# Train GMMs

workDir=$PWD

components=512
iteration=100
cmvn=1
featType='CQCC'
useOnlySpeech=0    #Flag variable to discard nonspeech/silence before and after speech utterance

echo 'Make sure to create soft links to DATASET !!'
codeBase=$workDir/../../../../codebase/
audioBasePath=$workDir/../../../../datasets/ASVSpoof2017_v2.0/   #Dataset folder must be created with symbolic link
gmmPath=$workDir/../model/
matlabDir=$codeBase/matlab/mycodes/
   
# We pass the following files as protocals
trainProtocol=$workDir/../../../../datasets/ASVSpoof2017_v2.0/protocol_V2/ASVspoof2017_V2_train.trn.txt
devProtocol=$workDir/../../../../datasets/ASVSpoof2017_v2.0/protocol_V2/ASVspoof2017_V2_dev.trl.txt
evalProtocol=$workDir/../../../../datasets/ASVSpoof2017_v2.0/protocol_V2/ASVspoof2017_V2_eval.trl.txt

cd $matlabDir
protocolFile=$trainProtocol
matlab -nodesktop -nosplash -nodisplay -r "try, train_gmm_model('$components','$gmmPath','$protocolFile','$audioBase','$cmvn','$featType','$useOnlySpeech','$iteration'); end; quit"

# TEST the GMM
for subset in 'train' 'dev' 'eval'
do
   if [ $subset == 'train' ];
   then
       protocolFile=$trainProtocol
   elif [ $subset == 'dev' ];
   then
       protocolFile=$devProtocol
   else
       protocolFile=$evalProtocol
   fi

   audioFolder=$audioBase/'ASVspoof2017_V2_'$subset/
   savePath=$workDir/../results/predictions/
   filename=$subset'_prediction.txt'
   scoreFile=$savePath/$filename

   # Evaluate
   matlab -nodesktop -nosplash -nodisplay -r "try, test_gmm_model('$savePath','$protocolFile','$audioFolder','$gmmPath','$cmvn','$filename','$featType','$useOnlySpeech'); end; quit"

   # Compute EER
   matlab -nodesktop -nosplash -nodisplay -r "try, compute_eer('$scoreFile','$savePath','$subset'); end; quit"
done


