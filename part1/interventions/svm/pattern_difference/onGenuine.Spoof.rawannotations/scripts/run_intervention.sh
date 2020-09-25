#!/bin/bash

# Test the intervened i-vectors using the original SVM model
# We have already extracted intervened i-vectors during Cosine experiment. We use them here.

workDir=$PWD
extn='mat'
ivectorPath=$workDir/../../../../cosine/pattern_difference/onGenuine.Spoof.rawannotations/intervened_ivectors/  #Use already extracted ivecs during cosine experiments

echo 'Make sure to create soft links to DATASET !!'
codeBase=$workDir/../../../../../../codebase/
modelPath=$workDir/../../../../../original/svm/model/
pythonDir=$codeBase/python/mycodes/

predictionFolder=$workDir/../results/predictions/ 
mkdir $predictionFolder

cd $pythonDir

for testset in 'dev' 'eval' #'train'
do
  python3 svm_intervention.py --featurePath $ivectorPath --savePath $predictionFolder --testset $testset --fileExtension $extn --modelPath $modelPath
done



