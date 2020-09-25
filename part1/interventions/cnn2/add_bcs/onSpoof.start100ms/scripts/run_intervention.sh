#!/bin/bash

# We know the thresholds now:
trainThreshold=0.52
devThreshold=0.6
evalThreshold=0.842

workDir=$PWD
searchCondition='spoof'
interveneClass='spoof'
scoreidx=0

echo 'Make sure to create soft links to DATASET !!'
codeBase=$workDir/../../../../../../codebase/
audioBasePath=$workDir/../../../../../../../datasets/ASVSpoof2017_v2.0/   #Dataset folder must be created with symbolic link
weightsPath=$workDir/../../../../../original/small_cnn/model/
codeDir=$codeBase/python/mycodes/

modelId=2  #is the light cnn model
duration=3
fft=512

trainProtocal=$audioBasePath'/protocol_V2/ASVspoof2017_V2_train.trn.txt'
devProtocal=$audioBasePath'/protocol_V2/ASVspoof2017_V2_dev.trl.txt'
evalProtocal=$audioBasePath'/protocol_V2/ASVspoof2017_V2_eval.trl.txt'

interventionType='addBCS'
sampleBCSFile='T_1001039.wav'  #This file 'ok google' showed the highest impact when we removed 100ms signal. So, we take this as sample.

interveneOnlyMisclassified=1
interveneDuration=100    #milliseconds
interveneAtStart=1
interveneAtEnd=0
verbosity=0

cd $codeDir
for testset in 'train' 'dev' 'eval'
do
   if [ $testset == 'train' ]; then
      protocal=$trainProtocal
      theta=$trainThreshold
   elif [ $testset == 'dev' ]; then
      protocal=$devProtocal
      theta=$devThreshold
   elif [ $testset == 'eval' ]; then
      protocal=$evalProtocal   
      theta=$evalThreshold
   else
      echo 'No match found !'
      exit 1
   fi

   savePath=$workDir/../results/$testset/
   mkdir -p $savePath

   python3 cnn_intervention_BCS.py --outputPath $savePath --modelPath $weightsPath --verbose $verbosity --modelId $modelId --interventionType $interventionType --interveneDuration $interveneDuration --subset $testset --interveneAtEnd $interveneAtEnd --interveneAtStart $interveneAtStart --protocalFile $protocal --condition $searchCondition --interveneClass $interveneClass --sampleBCSFile $sampleBCSFile --interveneOnlyMisclassified $interveneOnlyMisclassified --theta $theta --basePath $audioBasePath --duration $duration --fft $fft --scoreidx $scoreidx

done


