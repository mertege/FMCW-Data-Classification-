function [] = adcData2Spectrogram(adcDataaugmented,savefile,numberofaugmenteddata,augmentationtype,type)
%ADCDATA2SPECTROGRAM Summary of this function goes here
%   Detailed explanation goes here

 

spectrograms = zeros(512,4225,numberofaugmenteddata); % first 57 of each, fast, slow, slowwithpockets

for spectrogramindex =1 :numberofaugmenteddata
    
spectrogramindex
adcData =adcDataaugmented(:,spectrogramindex);
adcMatrix = reshape(adcData, 512, []);

% rangeDoppler = fft2(adcMatrix); 

% imagesc(10.*log10(abs(rangeDoppler)));

 RangeMatrix = fft(adcMatrix);
% imagesc(10.*log10(abs(RangeMatrix)));
fs=1e7;

[spect,f,t,p] = spectrogram(RangeMatrix(1, :), 512, 500, 512,fs,'centered','yaxis');

parfor a = 2 : 512
    a
    [s,f,t,p] = spectrogram(RangeMatrix(a, :), 512, 500, 512,fs,'centered','yaxis'); 
    spect = spect + s;

end
spectrograms(:,:,spectrogramindex) =spect;

end

if(savefile)

save(['F:\oytun_Calisma\data\spectrograms_',type,augmentationtype,'.mat'], 'spectrograms','-v7.3');
end




end

