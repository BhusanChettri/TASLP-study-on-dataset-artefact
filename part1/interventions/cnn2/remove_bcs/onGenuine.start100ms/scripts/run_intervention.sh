#!/bin/bash

workDir=$PWD
searchCondition='genuine'
interveneClass='genuine'
scoreidx=0

echo 'Make sure to create soft links to DATASET !!'
codeBase=$workDir/../../../../../../codebase/
audioBasePath=$workDir/../../../../../../../datasets/ASVSpoof2017_v2.0/   #Dataset folder must be created with symbolic link
weightsPath=$workDir/../../../../../original/small_cnn/model/
codeDir=$codeBase/python/mycodes/

annotationBase=$workDir/../../../../../../data_annotations

trainProtocal=$audioBasePath'/protocol_V2/ASVspoof2017_V2_train.trn.txt'
devProtocal=$audioBasePath'/protocol_V2/ASVspoof2017_V2_dev.trl.txt'
evalProtocal=$audioBasePath'/protocol_V2/ASVspoof2017_V2_eval.trl.txt'

interventionType='removeBCS'
interveneDuration=100    #milliseconds
interveneAtStart=1
interveneAtEnd=0
verbosity=0

modelId=2  #is the small cnn model
duration=3
fft=512

savePath=$PWD/$testset/
mkdir -p $savePath

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
   searchCondition=$annotationBase/$testset/v2/detailed_annotations/bcs_start_file.txt 

   savePath=$workDir/../results/$testset/
   mkdir -p $savePath

   python3 cnn_intervention_BCS.py --outputPath $savePath --modelPath $weightsPath --verbose $verbosity --modelId $modelId --interventionType $interventionType --interveneDuration $interveneDuration --subset $testset --interveneAtEnd $interveneAtEnd --interveneAtStart $interveneAtStart --protocalFile $protocal --condition $searchCondition --interveneClass $interveneClass --basePath $audioBasePath --duration $duration --fft $fft --scoreidx $scoreidx

done

