#!/bin/bash

#steps:
#1. cosine_intervention_PatternDifference_ivectorExtraction() function is called to perform intervention on raw audio
#        and extract CQCC features and then extract i-vectors. These i-vectors are saved on the disk.
#2. train_test_cosine_ivector_intervention () is then called passing the old and new ivector paths and scoring performed
#   and scores are written on the disk. Here we should be fine. Later we need to combine evaluation set scores with original spoof
#   scores. Just read the score and add 7 spaces or * and put score in 8th column -- todo (to make our combine scores script work)

cmvn=1
normalise=1     # Whether to post normalise ivectors or not
trainOn='T';
workDir=$PWD

echo 'Make sure to create soft links to DATASET !!'
codeBase=$workDir/../../../../../../codebase/
audioBasePath=$workDir/../../../../../../../datasets/ASVSpoof2017_v2.0/   #Dataset folder must be created with symbolic link
annotationBase=$workDir/../../../../../../data_annotations

cosinePath=$workDir/../../../../../original/cosine/model/
tvmPath=$cosinePath/tvm100.mat
ubmPath=$cosinePath/ubm64.mat  
matlabDir=$codeBase/matlab/mycodes/
   
newivectorPath=$PWD/../intervened_ivectors/
predictionFolder=$workDir/../results/predictions/

cd $matlabDir

for subset in 'dev' 'eval' #'eval' #'train' 'dev' 'eval' 
do
  if [ $subset == 'eval' ]; then     
     filename=$subset'_bonafide_prediction.txt'
  elif [ $subset == 'dev' ]; then     
     filename=$subset'_prediction.txt'
  else     
     filename=$subset'_prediction.txt'
  fi 
  audioFolder=$audioBasePath/ASVspoof2017_V2_$subset/
  protocolFile=$annotationBase/$subset/v2/detailed_annotations/annotations.txt

  matlab -nodesktop -nosplash -nodisplay -r "try, cosine_intervention_PatternDifference_ivectorExtraction('$newivectorPath','$protocolFile','$audioFolder','$ubmPath','$tvmPath','$cmvn','$subset'); end; quit"

done

# Now train and test cosine distance classifier
# We pass both original i-vectors path and new ivectors path to compute cosine distance metric and save the scores.
matlab -nodesktop -nosplash -nodisplay -r "try, train_test_cosine_ivector_intervention('$predictionFolder','$cosinePath','$newivectorPath','$normalise'); end; quit"

