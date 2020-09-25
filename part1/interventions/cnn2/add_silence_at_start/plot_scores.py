import os
import numpy as np
import matplotlib.pyplot as plt

pwd=os.getcwd()

      
for snr in [0, 6]:
  for subset in ['dev', 'eval']:
    for folder in ['onGenuine.random100ms', 'onSpoof.random100ms']:
       fig = plt.figure(figsize=(8, 5))
       plt.subplot(1, 1, 1)

       title=folder+'_ snr='+ str(snr)+', on '+ subset

       score=pwd+'/'+folder+'/snr_'+str(snr)+'/'+subset+'/intervenedFiles.txt'

       original=np.loadtxt(score,usecols=7,dtype=float)
       intervened=np.loadtxt(score,usecols=8,dtype=float)

       plt.plot(original,'.-',label='original')
       plt.plot(intervened,'.-',label='intervened')
       plt.title(title)
       plt.xlabel('file id')
       plt.ylabel('genuine-class score/prediction')
       plt.legend()
       plt.savefig(folder+'/snr_'+str(snr)+'_'+subset+'.png', dpi=300)
       




