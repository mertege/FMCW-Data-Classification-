function [spectrograms] = createallspectrograms(numberofsamples,reqSNRdB,augmentationtype,type,index,savefile)

spectrogramindex=1;

spectrograms = zeros(512,4225,numberofsamples); % first 57 of each, fast, slow, slowwithpockets

% plot all fast
for ii =1:numberofsamples
spectrogramindex
load(['F:\oytun_Calisma\',type,'\',num2str(ii),'\adc_Data.mat']);

adcDataRX1 = adc_DataTable.adc_DataRX1; 
adcDataRX2 = adc_DataTable.adc_DataRX2; 
adcDataRX3 = adc_DataTable.adc_DataRX3; 
adcDataRX4 = adc_DataTable.adc_DataRX4; 
% 
adcData = adcDataRX1+adcDataRX2+adcDataRX3+adcDataRX4;

numberofaugmentation=length(adcData);


switch augmentationtype
    case 'jittered' 
       NoisySig = awgn(adcData,reqSNRdB,'measured');
       adcMatrix = reshape(NoisySig, 512, []);
    case 'convexhulled'
       tic
       adctemp=convexhull(adcData,numberofaugmentation);
       toc
%        adcMatrix = reshape(adctemp, 512, []);
    otherwise        
       adcMatrix = reshape(adcData, 512, []);
end



% rangeDoppler = fft2(adcMatrix); 

% imagesc(10.*log10(abs(rangeDoppler)));

 RangeMatrix = fft(adcMatrix);
% imagesc(10.*log10(abs(RangeMatrix)));
fs=1e7;

[spect,f,t,p] = spectrogram(RangeMatrix(1, :), 512, 500, 512,fs,'centered','yaxis');

for a = 2 : 512
    [s,f,t,p] = spectrogram(RangeMatrix(a, :), 512, 500, 512,fs,'centered','yaxis'); 
    spect = spect + s;

end


spectrograms(:,:,spectrogramindex) =spect;

spectrogramindex=spectrogramindex+1;
end

%save file
if(savefile)
switch augmentationtype
    case 'jittered' 
       save(['F:\oytun_Calisma\data\spectrograms_',type,num2str(index),augmentationtype,'.mat'], 'spectrograms','-v7.3');
    case 'convexhulled'
       save(['F:\oytun_Calisma\data\spectrograms_',type,num2str(index),augmentationtype,'.mat'], 'spectrograms','-v7.3');
    otherwise        
       save(['F:\oytun_Calisma\data\spectrograms_',type,num2str(index),'notaugmented.mat'], 'spectrograms','-v7.3');
end

else
end


end