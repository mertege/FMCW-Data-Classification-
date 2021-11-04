function [spectrograms] = createallspectrograms(numberofsamples,reqSNRdB,jittered,type)

spectrogramindex=1;


spectrograms = zeros(512,4225,numberofsamples); % first 57 of each, fast, slow, slowwithpockets

% plot all fast
for ii =1:numberofsamples
spectrogramindex
load(['F:\oytun_Calisma\',type,'\',num2str(ii),'\adc_Data.mat']);


% load('C:\Users\ogunes\Documents\MATLAB\realdata\lindamodification_v2\slow1\adc_Data.mat');
% 

adcDataRX1 = adc_DataTable.adc_DataRX1; 
adcDataRX2 = adc_DataTable.adc_DataRX2; 
adcDataRX3 = adc_DataTable.adc_DataRX3; 
adcDataRX4 = adc_DataTable.adc_DataRX4; 
% 
adcData = adcDataRX1+adcDataRX2+adcDataRX3+adcDataRX4;

%%
% load('adcDataSlow.mat');
% load('/Users/oytungunes/OneDrive - ee.bilkent.edu.tr/Research_TIK3tensonra/Problem1-RealData/lindadangelenkod/adcData.mat');
if(jittered)
    NoisySig = awgn(adcData,reqSNRdB,'measured');
    adcMatrix = reshape(NoisySig, 512, []);
else
    adcMatrix = reshape(adcData, 512, []);
end

rangeDoppler = fft2(adcMatrix); 

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


end