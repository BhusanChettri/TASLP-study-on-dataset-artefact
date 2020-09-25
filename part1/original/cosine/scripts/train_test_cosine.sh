#!/bin/bash

# Trains and Test ivector based cosine distance classifier : using ivectors derived

workDir=$PWD

useOnlySpeech=0  #This will enable/disable use of Protocal. The same code can be used for training GMM on original data
trainOn='T';
wccn=1     #normalise wccn or not

echo 'Make sure to create soft links to DATASET !!'
matlabDir=$workDir/../../../../codebase/matlab/mycodes/
pythonDir=$workDir/../../../../codebase/python/mycodes/

ivectorPath=$workDir/../ivectors/
predictionFolder=$workDir/../results/predictions/

audioBase=$workDir/../../../../datasets/ASVSpoof2017_v2.0/   #Dataset folder must be created with symbolic link

# We pass the following files as protocals
trainProtocal=$audioBase'/protocol_V2/ASVspoof2017_V2_train.trn.txt'
devProtocal=$audioBase'/protocol_V2/ASVspoof2017_V2_dev.trl.txt'
evalProtocal=$audioBase'/protocol_V2/ASVspoof2017_V2_eval.trl.txt'


# 1. Score usig Cosine model
cd $matlabDir
matlab -nodesktop -nosplash -nodisplay -r "try, train_test_cosine_ivector('$trainOn','$predictionFolder','$ivectorPath','$wccn','$useOnlySpeech'); end; quit"

# 2. Compute EERs
for subset in 'train' 'dev' 'eval'
do  
   if [ $subset == 'train' ]
   then
      annotation=$trainProtocal
   elif [ $subset == 'dev' ]
   then 
      annotation=$devProtocal
   elif [ $subset == 'eval' ] 
   then
      annotation=$evalProtocal
   else
      echo "wrong subset !!"
      exit 1 
   fi

   #Format the raw scores to be able to use EER script
   cd $pythonDir
   python format_scores.py --annotation $annotation --scorePath $predictionFolder --subset $subset
   
   cd $matlabDir
   scoreFile=$predictionFolder/$subset'_prediction.txt'
   matlab -nodesktop -nosplash -nodisplay -r "try, compute_eer('$scoreFile','$predictionFolder','$subset'); end; quit"
done


