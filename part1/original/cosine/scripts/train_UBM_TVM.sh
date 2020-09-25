#!/bin/bash

# Train UBM and T-matrix on training data (CQCC features) 

workDir=$PWD

useOnlySpeech=0  #This will enable/disable use of annotations. The same code can be used for training GMM on original data
components=64
iteration=10   # For UBM, we used only 10 EM (surprising though !!)
cmvn=1
featType='CQCC'
tvm_dim='100';

echo 'Make sure to create soft links to DATASET !!'
codeBase=$workDir/../../../../codebase/
audioBase=$workDir/../../../../datasets/ASVSpoof2017_v2.0/   #Dataset folder must be created with symbolic link
gmmPath=$workDir/../model/
matlabDir=$codeBase/matlab/mycodes/

# We pass the following files as protocals
trainProtocal=$audioBase'/protocol_V2/ASVspoof2017_V2_train.trn.txt'
devProtocal=$audioBase'/protocol_V2/ASVspoof2017_V2_dev.trl.txt'
evalProtocal=$audioBase'/protocol_V2/ASVspoof2017_V2_eval.trl.txt'

cd $matlabDir

protocolFile=$trainProtocal

# 1. Train UBM and T-Matrix
echo 'Training UBM and T-matrix'
matlab -nodesktop -nosplash -nodisplay -r "try, train_UBM_TVM('$components','$tvm_dim','$gmmPath','$protocolFile','$audioBase','$cmvn','$featType','$useOnlySpeech','$iteration'); end; quit"
