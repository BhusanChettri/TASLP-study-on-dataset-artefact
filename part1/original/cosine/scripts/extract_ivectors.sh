#!/bin/bash

# Then extract i-vectors for the entire dataset

workDir=$PWD

useOnlySpeech=0  #This will enable/disable use of Protocal. The same code can be used for training GMM on original data
components=64
iteration=10   # For UBM, we used only 10 EM (surprising though !!)
cmvn=1
featType='CQCC'
tvm_dim=100

echo 'Make sure to create soft links to DATASET !!'
codeBase=$workDir/../../../../codebase/
audioBase=$workDir/../../../../datasets/ASVSpoof2017_v2.0/   #Dataset folder must be created with symbolic link

ubm=$workDir'/../model/ubm'$components'.mat'
tvm=$workDir'/../model/tvm'$tvm_dim'.mat'

outputPath=$workDir/../ivectors/
matlabDir=$codeBase/matlab/mycodes/

# We pass the following files as protocals
trainProtocal=$audioBase'/protocol_V2/ASVspoof2017_V2_train.trn.txt'
devProtocal=$audioBase'/protocol_V2/ASVspoof2017_V2_dev.trl.txt'
evalProtocal=$audioBase'/protocol_V2/ASVspoof2017_V2_eval.trl.txt'

cd $matlabDir

for subset in 'dev' 'eval' #'train'
do
  if [ $subset == 'train' ]; 
  then
      protocolFile=$trainProtocal
  elif [ $subset == 'dev' ]; 
  then
     protocolFile=$devProtocal
  elif [ $subset == 'eval' ]; 
  then
     protocolFile=$evalProtocal  
  else
     echo 'No matching subset found'
     exit
  fi

  matlab -nodesktop -nosplash -nodisplay -r "try, extract_ivectors('$ubm','$tvm','$outputPath','$subset','$protocolFile','$audioBase','$cmvn','$featType','$useOnlySpeech'); end; quit"
done


