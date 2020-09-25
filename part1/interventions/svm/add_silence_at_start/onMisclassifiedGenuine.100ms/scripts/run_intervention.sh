#!/bin/bash

# Test the intervened i-vectors using the original SVM model
# Intervened ivectors have been extracted

workDir=$PWD
extn='mat'
interveneOn='genuine'

echo 'Make sure to create soft links to DATASET !!'
codeBase=$workDir/../../../../../../codebase/
modelPath=$workDir/../../../../../original/svm/model/
newivectorPath=$PWD/../intervened_ivectors/
pythonDir=$codeBase/python/mycodes/

cd $pythonDir

predictionFolder=$workDir/../result/predictions/
ivectorPath=$newivectorPath/

for testset in 'train' 'dev' 'eval'
  do
    python3 svm_intervention.py --featurePath $ivectorPath --savePath $predictionFolder --testset $testset --fileExtension $extn --modelPath $modelPath
done





