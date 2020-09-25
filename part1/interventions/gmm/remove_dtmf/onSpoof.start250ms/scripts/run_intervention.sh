#!/bin/bash

# In this intervention we remove DTMF (250 ms samples from all the test files in the dtmf file list)
# We use the same BCS intervention code but pass parameter appropriately

operation='remove'  
samplestoRemove=250  # 250 ms samples
interveneOn='spoof'  # DTMF is present in spoof class only

cmvn=1
workDir=$PWD
predictionFolder=$workDir/../results/predictions/

echo 'Make sure to create soft links to DATASET !!'
codeBase=$workDir/../../../../../../codebase/
audioBasePath=$workDir/../../../../../../../datasets/ASVSpoof2017_v2.0/   #Dataset folder must be created with symbolic link
gmmPath=$workDir/../../../../../original/gmm/model/
codeDirectory=$codeBase/matlab/mycodes/
annotationBase=$workDir/../../../../../../data_annotations

sampleBCSFile=$audioBasePath/ASVspoof2017_V2_train/T_1001039.wav

cd $codeDirectory

for subset in 'dev' 'train' #'eval'  #We do not have DTMF annotations for Eval set
do
  filename=$subset'_bonafide_prediction.txt'
  protocolFile=$annotationBase/$subset/v2/detailed_annotations/dtmf_last_columns_removed.txt  #same as dtmf.txt but last columns removed for code compatibility 
  audioFolder=$audioBasePath/ASVspoof2017_V2_$subset/
  
  matlab -nodesktop -nosplash -nodisplay -r "try, gmm_intervention_BCS('$operation','$predictionFolder','$protocolFile','$audioFolder','$gmmPath','$interveneOn','$cmvn','$filename','$sampleBCSFile','$samplestoRemove'); end; quit"

done
