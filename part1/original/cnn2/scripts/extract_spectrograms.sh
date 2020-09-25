#!/bin/bash

# Extract 3 seconds unified power spectrograms

workDir=$PWD
audioBasePath=$workDir/../../../../datasets/ASVSpoof2017_v2.0/   #Dataset folder must be created with symbolic link
codeDir=$workDir/../../../../codebase/python/mycodes/
   
fft=512
window_size=$fft
hop=160
duration=3

featureBase=$workDir/../../../../features/power_spectrograms/original/'$duration'sec_'$fft'FFT/

cd $codeDir

for subset in 'train' 'dev' 'eval'
do
  
  echo $subset
  if [ $subset == 'train' ]
  then 
     protocol=$audioBasePath'/protocol_V2/ASVspoof2017_V2_train.trn.txt'
  elif [ $subset == 'dev' ]    
  then 
     protocol=$audioBasePath'/protocol_V2/ASVspoof2017_V2_dev.trl.txt'
  elif [ $subset == 'eval' ]    
  then 
     protocol=$audioBasePath'/protocol_V2/ASVspoof2017_V2_eval.trl.txt'
  else
     echo 'No matching subset found !'
     exit 1
  fi
  echo $protocol

  savePath=$featureBase/$subset/
    
  python3 extract_features.py --basePath $audioBasePath --outputPath $savePath --duration $duration --fft $fft --window $window_size --hop $hop --protocolFile $protocol --subset $subset
done
