# TASLP-study-on-dataset-artefact

This work is focused towards understanding how artefacts in training data impact model performance


The repository contains code used in our recent research work [1] on the ASVspoof 2017 version 2.0 replay spoofing dataset. In this work we aim to understand the ASVspoof 2017 version 2.0 dataset, various artefacts in this dataset and their impact on countermeasure models. This article has been accepted to IEEE/ACM Transactions on Audio Speech and Language Processing (TASLP), 2020.


[1] B. Chettri, E. Benetos, and B. L. Sturm, “Dataset artefacts in anti-spoofing systems: a case study on the asvspoof 2017 benchmark,” accepted to IEEE/ACM Transactions on Audio Speech and Language Processing (TASLP), 2020.


-- The source codes - both python and matlab are located under codebase directory.
The work in this paper is divided into two major parts. Part 1 consist of experimental setup and results for five different countermeasure models using the original dataset without any preprocessing. Part 2 on the other hand consist of our proposed approach of training countermeasure models on this dataset using speech endpoint detection during training and inference for robust and trustworthy predictions. 

Please look at the readme.txt files inside each of the experimental folders that provides further details.

