#!/bin/bash

cd onMisclassifiedGenuine.100ms/scripts/
bash on_genuine_trials.sh

cd ../../onMisclassifiedGenuine.10ms/scripts/
bash on_genuine_trials.sh

cd ../../correctlyDetectedSpoof.100ms/scripts/
bash on_spoof_trials.sh

cd ../../correctlyDetectedSpoof.10ms/scripts/
bash on_spoof_trials.sh

