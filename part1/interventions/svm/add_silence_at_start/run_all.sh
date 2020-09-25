#!/bin/bash

cd correctlyDetectedSpoof.10ms/scripts/
bash run_all.sh

cd ../../onMisclassifiedGenuine.10ms/scripts/
bash run_all.sh

cd ../../onMisclassifiedGenuine.100ms/scripts/
bash run_all.sh
