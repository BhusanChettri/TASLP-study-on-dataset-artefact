DETAILS OF THE DIRECTORIES AND FILES
====================================

1) CNN1
     - model
       - the CNN model, scores and eer
     - results
       - precision, recall, FAR, FRR
     - scripts
       - extract_spectrograms.sh : extracting power spectrogram features used by CNN1
       - train_test_cnn.sh : train and test the CNN model
       - evaluate_eer.sh : to compute the EER using Bosaris toolkit 
       - computePrecision.sh: to compute FAR, FRR, precision and recall

  Execution order: (1) extract_spectrograms.sh (2) train_test_cnns.sh (3) evaluate_eer.sh (4) computePrecision.sh

2) CNN2
    - has the same structure, folders and files as in CNN1 shown above
-----------------------------------------------------------------------------------

3) GMM  
    - model
     - the bonafide and spoof GMM   
    - results
     - scores, eer, precision, recall,   
    - scripts
     - train_test_model.sh 
     - computePrecision.sh
 
  Execution order: (1) train_test_cosine.sh (2) computePrecision.sh 

-----------------------------------------------------------------------------------

4) Cosine
    - ivectors
     - ivectors for training, development and evaluation sets, i-vector model and normalisation parameters
    - model
     -  T matrix and UBM
    - results
     - prediction scores, precision, recall, FAR, FRR
    - scripts
     - computePrecision.sh
     - extract_ivectors.sh
     - train_test_cosine.sh
     - train_UBM_TVM.sh 

    Execution order: (1) train_UBM_TVM.sh (2) extract_ivectors.sh (3) train_test_cosine.sh (4) computePrecision.sh

-----------------------------------------------------------------------------------

5) SVM
   - model
    - prediction scores and svm model
   - results
    - FAR, FRR, precision
   - scripts
    - train_test.sh
    - computePrecision.sh
   Note: SVM uses the same i-vectors extracted during Cosine modelling
   Execution order: (1) train_test_cosine.sh (2) computePrecision.sh
-----------------------------------------------------------------------------------




