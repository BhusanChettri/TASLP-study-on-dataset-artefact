#!/bin/bash

workDir=$PWD
interveneClass='genuine'

echo 'Make sure to create soft links to DATASET !!'
codeBase=$workDir/../../../../../../codebase/
audioBasePath=$workDir/../../../../../../../datasets/ASVSpoof2017_v2.0/   #Dataset folder must be created with symbolic link
weightsPath=$workDir/../../../../../original/small_cnn/model/
codeDir=$codeBase/python/mycodes/

trainProtocal=$audioBasePath'/protocol_V2/ASVspoof2017_V2_train.trn.txt'
devProtocal=$audioBasePath'/protocol_V2/ASVspoof2017_V2_dev.trl.txt'
evalProtocal=$audioBasePath'/protocol_V2/ASVspoof2017_V2_eval.trl.txt'

annotationBase=$workDir/../../../../../../data_annotations

verbosity=0
modelId=2  #is the small cnn model
fft=512
duration=3

cd $codeDir

for testset in 'train' 'dev' 'eval'
do
   if [ $testset == 'train' ]; then
      protocal=$trainProtocal
   elif [ $testset == 'dev' ]; then
      protocal=$devProtocal
   elif [ $testset == 'eval' ]; then
      protocal=$evalProtocal   
   else
      echo 'No match found !'
      exit 1
   fi
   annotationFile=$annotationBase/$testset/v2/detailed_annotations/annotations.txt

   savePath=$workDir/../results/$testset/
   mkdir -p $savePath

   python3 cnn_intervention_patternDifference.py --outputPath $savePath --modelPath $weightsPath --verbose $verbosity --modelId $modelId --subset $testset --protocalFile $protocal --annotationFile $annotationFile --interveneClass $interveneClass --basePath $audioBasePath --fft $fft --duration  $duration
done


