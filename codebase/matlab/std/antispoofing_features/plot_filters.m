% Parameters for SCMC extraction
Window_Length=20;
No_Filter=20;
Fs=16000;
NFFT=512;

% MFCC filters
f=(Fs/2)*linspace(0,1,NFFT/2+1);
fmel=2595*log10(1+f./700); % CONVERTING TO MEL SCALE
fmelmax=max(fmel);
fmelmin=min(fmel);
filbandwidthsmel=linspace(fmelmin,fmelmax,No_Filter+2);
filbandwidthsf=700*(10.^(filbandwidthsmel/2595)-1);

filterbank=zeros((NFFT/2)+1,No_Filter);
for i=1:No_Filter
    filterbank(:,i)=trimf(f,[filbandwidthsf(i),filbandwidthsf(i+1),...
        filbandwidthsf(i+2)]);
end

mkdir filters;
save('filters/mfcc_filter.mat','filterbank','-v6');

%%%%%%%%%%%%%%%%%%%