#!/bin/bash

# DTMF intervention on Cosine-ivector system
# We use gmm_intervention_BCS_ivectorExtraction but pass 250 as parameter to remove samples

workDir=$PWD

operation='remove'
interveneOn='spoof'  # DTMF present only in spoof
samplestoRemove=250  

cmvn=1
normalise=1     # Whether to post normalise ivectors or not
trainOn='T';

echo 'Make sure to create soft links to DATASET !!'
codeBase=$workDir/../../../../../../codebase/
audioBasePath=$workDir/../../../../../../../datasets/ASVSpoof2017_v2.0/   #Dataset folder must be created with symbolic link
annotationBase=$workDir/../../../../../../data_annotations
sampleBCSFile='abc.txt'  #will not be use though, placeholder

cosinePath=$workDir/../../../../../original/cosine/model/
tvmPath=$cosinePath/tvm100.mat
ubmPath=$cosinePath/ubm64.mat  
matlabDir=$codeBase/matlab/mycodes/

predictionFolder=$workDir/../results/predictions/
newivectorPath=$PWD/../intervened_ivectors/

cd $matlabDir

for subset in 'dev' 'train' #'eval'  #We do not have DTMF annotations for Eval set
do
  protocolFile=$annotationBase/$subset/v2/detailed_annotations/dtmf_last_columns_removed.txt  #same as dtmf.txt but last columns removed for code compatibility 
  audioFolder=$audioBasePath/ASVspoof2017_V2_$subset/
  matlab -nodesktop -nosplash -nodisplay -r "try, gmm_intervention_BCS_ivectorExtraction('$operation','$newivectorPath','$protocolFile','$audioFolder','$ubmPath','$tvmPath','$interveneOn','$cmvn','$subset','$sampleBCSFile','$samplestoRemove'); end; quit" 

done

# Now train and test cosine distance classifier
# We pass both original i-vectors path and new ivectors path to compute cosine distance metric and save the scores.
matlab -nodesktop -nosplash -nodisplay -r "try, train_test_cosine_ivector_intervention('$predictionFolder','$cosinePath','$newivectorPath', '$normalise'); end; quit"


