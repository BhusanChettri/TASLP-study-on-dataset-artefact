#!/bin/bash

# Test the intervened i-vectors using the original SVM model
# Intervened ivectors have been extracted

workDir=$PWD
extn='mat'
interveneOn='spoof'

echo 'Make sure to create soft links to DATASET !!'
codeBase=$workDir/../../../../../../codebase/
modelPath=$workDir/../../../../../original/svm/model/
ivectorPath=$PWD/../intervened_ivectors/
pythonDir=$codeBase/python/mycodes/

predictionFolder=$workDir/../results/predictions/
mkdir $predictionFolder

cd $pythonDir

for testset in 'train' 'dev' 'eval'
do
  python3 svm_intervention.py --featurePath $ivectorPath --savePath $predictionFolder --testset $testset --fileExtension $extn --modelPath $modelPath
done





