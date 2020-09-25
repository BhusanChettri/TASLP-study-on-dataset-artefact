function [stat,delta,double_delta]=extract_imfcc_2(speech,Fs,Window_Length,NFFT,No_Filter) 

% Small change: instead of file path, pass the processed audio samples
% where we drop the nonspeech/silence parts

% Function for computing IMFCC features 
% Usage: [stat,delta,double_delta]=extract_imfcc(speech,Fs,Window_Length,No_Filter) 
%
% Input: speech=audio samples
%        Fs=Sampling frequency in Hz
%        Window_Length=Window length in ms
%        NFFT=No of FFT bins
%        No_Filter=No of filter
%
%Output: stat=Static IMFCC (Size: NxNo_Filter where N is the number of frames)
%        delta=Delta IMFCC (Size: NxNo_Filter where N is the number of frames)
%        double_delta=Double Delta IMFCC (Size: NxNo_Filter where N is the number of frames)
%
%        Written by Md Sahidullah at School of Computing, University of
%        Eastern Finland (email: sahid@cs.uef.fi)
%        
%        Implementation details are available in the following paper:
%        M. Sahidullah, T. Kinnunen, C. Hanil�i, �A comparison of features 
%        for synthetic speech detection�, Proc. Interspeech 2015, 
%        pp. 2087--2091, Dresden, Germany, September 2015.

%speech=readwav(file_path,'s',-1);
%rng('default');
%speech=speech+randn(size(speech))*eps;                           %dithering
%-------------------------- PRE-EMPHASIS ----------------------------------
speech = filter( [1 -0.97], 1, speech);
%---------------------------FRAMING & WINDOWING----------------------------
frame_length_inSample=(Fs/1000)*Window_Length;
framedspeech=buffer(speech,frame_length_inSample,frame_length_inSample/2,'nodelay')';

w=hamming(frame_length_inSample);

%y_framed=framedspeech.*repmat(w',size(framedspeech,1),1);   %% This line was working perfectly fine before. But now it throws following error

%Error using  .* 
%Matrix dimensions must agree.
%Error in extract_imfcc (line 38)
%y_framed=framedspeech.*repmat(w',size(framedspeech,1),1);   %% This line was working perfectly fine before.

% Having closely looked at it, there seems to be issue with repmat. I changed to following to make the dimension similar for element wise multiplication

a=repmat(w, size(framedspeech,1), 1);   %Here first parameter w has got [1*320] dimension.
% Second parameter, size(framedspeech,1) returns rows (which is total frames in this file) say R.
% Third parameter, is a scalar 1, which specifies number of columns to copy
% repmat copies w into R rows and 1 columns.
% Finally the size of a = R * 320
% This R matches with the first dimension of framedspeech. Hence now there will be no conflict in dimension when doing element wise multiplication.
y_framed=framedspeech.*a;

% b=repmat(w',size(framedspeech,1),1)
% c=framedspeech.*b
%c=repmat(w', 1,180);
%c=repmat(w', 1,size(framedspeech,1));

%disp('extracting imfcc..')

%--------------------------------------------------------------------------
f=(Fs/2)*linspace(0,1,NFFT/2+1);
fmel=2595*log10(1+f./700); % CONVERTING TO MEL SCALE
fmelmax=max(fmel);
fmelmin=min(fmel);
filbandwidthsmel=linspace(fmelmin,fmelmax,No_Filter+2);
filbandwidthsf=700*(10.^(filbandwidthsmel/2595)-1);
fr_all=(abs(fft(y_framed',NFFT))).^2;
fa_all=fr_all(1:(NFFT/2)+1,:)';
fa_all=fliplr(fa_all); %Modification for IMFCC
filterbank=zeros((NFFT/2)+1,No_Filter);
for i=1:No_Filter
    filterbank(:,i)=trimf(f,[filbandwidthsf(i),filbandwidthsf(i+1),...
        filbandwidthsf(i+2)]);
end
filbanksum=fa_all*filterbank(1:end,:);
%-------------------------Calculate Static Cepstral------------------------
t=dct(log10(filbanksum'+eps));
t=(t(1:No_Filter,:));
stat=t'; 
delta=deltas(stat',3)';
double_delta=deltas(delta',3)';
%--------------------------------------------------------------------------
