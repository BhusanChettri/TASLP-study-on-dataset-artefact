#!/bin/bash

workDir=$PWD
echo 'Make sure to create soft links to DATASET !!'
codeBase=$workDir/../../../../codebase/
audioBasePath=$workDir/../../../../datasets/ASVSpoof2017_v2.0/   #Dataset folder must be created with symbolic link
featPath=$workDir/../../cosine/ivectors/                         #Here we use the same ivectors extracted during cosine experiments

protocalPath=$audioBasePath'/protocol_V2/'
normalise=1
trainOn='train'
extn='mat'
penalty=1.0
resultFolder=$PWD/../
maximum_iterations=3000

# 1. Train the SVM model and save parameters
cd $codeBase/python/mycodes/

python3 svm_wrapper.py --protocalPath $protocalPath --featurePath $featPath --savePath $resultFolder --trainOn $trainOn --fileExtension $extn --penalty $penalty --normalise $normalise --maximum_iterations $maximum_iterations



