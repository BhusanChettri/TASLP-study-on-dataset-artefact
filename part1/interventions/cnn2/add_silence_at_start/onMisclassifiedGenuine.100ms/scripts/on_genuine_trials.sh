#!/bin/bash

# Add silence 100ms at start

workDir=$PWD

trainThreshold=0.52
devThreshold=0.6
evalThreshold=0.842

interveneOnlyMisclassified=1   #intervene on misclassified genuine test signals
searchCondition='genuine'   # Defines whether intervention is on Genuine or Spoof class
interveneClass='genuine'

positive='genuine'

if [ $positive == 'genuine' ]; then
   negative='spoof'
else
   negative='genuine'
fi

echo 'Make sure to create soft links to DATASET !!'
codeBase=$workDir/../../../../../../codebase/
audioBasePath=$workDir/../../../../../../../datasets/ASVSpoof2017_v2.0/   #Dataset folder must be created with symbolic link
weightsPath=$workDir/../../../../../original/small_cnn/model/
codeDir=$codeBase/python/mycodes/
   
# Fixed parameters
trainProtocal=$audioBasePath'/protocol_V2/ASVspoof2017_V2_train.trn.txt'
devProtocal=$audioBasePath'/protocol_V2/ASVspoof2017_V2_dev.trl.txt'
evalProtocal=$audioBasePath'/protocol_V2/ASVspoof2017_V2_eval.trl.txt'
batch=100
verbosity=0

modelId=2  #is the small cnn model
fft=512
duration=3
#------------------------------------------------------------------------------------------------------------------
startSeedFixed=1  # 0 for false and 1 for true
randomseed=1      # random seed number = 1

# PARAMETERS RELATED TO ADDING NOISE AND TYPE OF NOISE
addNoise=1            # Append noise at the start
addNoiseAtEnd=0       # At the end
noiseType='zeros'    #'random'    #'zeros'
replaceAllSamples=0   # replace all samples by random noise
noiseDuration=0.1
sameNoise=0
addNoiseAtRandom=0   # To add noise at random time location

outputFileName='intervenedFiles'

          
for testset in 'train' 'dev' 'eval'
  do

     echo "Running intervention on " $testset

     if [ $testset == 'train' ];
     then     
        useProtocal=$trainProtocal
        threshold=$trainThreshold 

     elif [ $testset == "dev" ]
     then
        useProtocal=$devProtocal
        threshold=$devThreshold 
     else
        useProtocal=$evalProtocal
        threshold=$evalThreshold 
     fi
     originalScores=$weightsPath/predictions/$testset'_prediction.txt'

     savePath=$workDir/../result/$testset/

     mkdir -p $savePath
     cd $codeDir

     echo "Using SNR = $snr"    
     # 1. Perform noise addition/intervention    
     python3 cnn_intervention.py --subset $testset --basePath $audioBasePath --condition $searchCondition --outputPath $savePath --modelPath $weightsPath --batchSize $batch --verbose $verbosity --outputFileName $outputFileName --addNoise $addNoise --addNoiseAtEnd $addNoiseAtEnd --noiseType $noiseType --noiseToAdd $noiseDuration --replaceAllSignals $replaceAllSamples --fft $fft --duration  $duration --modelId $modelId --sameNoise $sameNoise --randomseed $randomseed --startSeedFixed $startSeedFixed --addNoiseAtRandom $addNoiseAtRandom --theta $threshold --interveneOnlyMisclassified $interveneOnlyMisclassified --protocalFile $useProtocal --interveneClass $interveneClass

     #--snr $snr

     # 2. Now combine old unupdated scores and the newly updated ones
     interventionFile=$savePath/intervenedFiles.txt  
     python3 combine_new_scores_and_get_eer.py --subset $testset --originalScoreFile $originalScores --interventionScoreFile $interventionFile --protocal $useProtocal --output $savePath
  
     cd $workDir
     
     # Keep the prediction organised into predictions folder     
     predictionFolder=$workDir/../result/predictions/
     if [ ! -d $predictionFolder ]; then
         mkdir $predictionFolder
     fi
     
     cp ../result/$testset/$testset'_prediction.txt' $predictionFolder/ 

     # Compute precision-recall and other stuffs -for the intervened score file
     prec_recall_directory=$workDir/../result/precision_recall/

     if [ ! -d $prec_recall_directory ]; then
         mkdir $prec_recall_directory
     fi

     outputFile=$prec_recall_directory/'posClass_'$positive'_results.txt'
     scoreFile=$predictionFolder/$testset'_prediction.txt'

     cd $codeDir
     echo '---------Computing Precision and Recall ----------------'
     #echo 'Score File used is'
     #echo $scoreFile
     #echo 'Threshold used is'
     #echo $threshold
     #echo 'Protocal used is '
     #echo $useProtocal
     #echo 'Positive class'
     #echo $positive

     python3 precision_recall_fmeasure.py --protocal $useProtocal --scoreFile $scoreFile --threshold $threshold --positive $positive --negative $negative --outputFile $outputFile

done

