#!/bin/bash

# Evaluate EER on Dev and Eval sets

workDir=$PWD
totalRuns=5
codeDir=$workDir/../../../../codebase/matlab/mycodes/

for i in `seq 2 $totalRuns`
do
  scorePath=$workDir/../model/$i/predictions/

  for set in 'dev' 'eval'
  do
    scoreFile=$scorePath/$set'_prediction.txt'

    cd $codeDir
    matlab -nodesktop -nosplash -nodisplay -r "try, compute_eer('$scoreFile','$scorePath','$subset'); end; quit"
  done
done


