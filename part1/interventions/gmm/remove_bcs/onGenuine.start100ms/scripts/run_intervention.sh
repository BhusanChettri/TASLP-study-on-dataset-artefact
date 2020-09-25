#!/bin/bash

# In this intervention we remove BCS from the test files

operation='remove'
interveneOn='genuine'
cmvn=1
workDir=$PWD
predictionFolder=$workDir/../results/predictions/
samplestoRemove=100  # 100 ms samples

echo 'Make sure to create soft links to DATASET !!'
codeBase=$workDir/../../../../../../codebase/
audioBasePath=$workDir/../../../../../../../datasets/ASVSpoof2017_v2.0/   #Dataset folder must be created with symbolic link
gmmPath=$workDir/../../../../../original/gmm/model/
codeDirectory=$codeBase/matlab/mycodes/
annotationBase=$workDir/../../../../../../data_annotations

sampleBCSFile=$audioBasePath/ASVspoof2017_V2_train/T_1001039.wav

cd $codeDirectory

for subset in 'eval' 'dev' 'train'
do
  filename=$subset'_bonafide_prediction.txt'
  protocolFile=$annotationBase/$subset/v2/detailed_annotations/bcs_start_file_last_columns_removed.txt  #This is same as 'bcs_start_file.txt' but last column removed for script compatibility
  audioFolder=$audioBasePath/ASVspoof2017_V2_$subset/
  
  matlab -nodesktop -nosplash -nodisplay -r "try, gmm_intervention_BCS('$operation','$predictionFolder','$protocolFile','$audioFolder','$gmmPath','$interveneOn','$cmvn','$filename','$sampleBCSFile','$samplestoRemove'); end; quit"

done

