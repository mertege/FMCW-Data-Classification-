clear all;clc;close all; % deneme

numberofsamplesfast=57*3;
numberofsampleseach=57;
spectrograms = zeros(512,4225,numberofsampleseach*5); % first 57 of each, fast, slow, slowwithpockets

%visualize
% numberofsamplesfast=4;
% numberofsampleseach=4;
% spectrograms = zeros(512,4225,12); % first 57 of each, fast, slow, slowwithpockets

spectrogramindex =1;
jittered=1;
reqSNRdB=50;
rng(0);

gpuDevice(2); 

tic
% plot all fast
for ii =1:numberofsamplesfast
spectrogramindex
load(['F:\oytun_Calisma\fast\',num2str(ii),'\adc_Data.mat']);


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


for ii =1:numberofsampleseach
spectrogramindex
load(['F:\oytun_Calisma\slow\',num2str(ii),'\adc_Data.mat']);


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



for ii =1:numberofsampleseach
spectrogramindex
load(['F:\oytun_Calisma\slowwithpocket\',num2str(ii),'\adc_Data.mat']);


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
% 
spectrograms(:,:,spectrogramindex)  =spect;
% 
spectrogramindex=spectrogramindex+1;
% 
end

toc

indexfast=1:numberofsamplesfast;
indexslow=(numberofsamplesfast+1):(numberofsamplesfast+numberofsampleseach);
indexslowwithpockets= (numberofsamplesfast+numberofsampleseach+1):(numberofsamplesfast+2*numberofsampleseach);
% 

% save(['F:\oytun_Calisma\data\spectrograms_visualize_jittered_',num2str(reqSNRdB),'dB.mat'], 'spectrograms','t','f');

spectrograms1_jittered = spectrograms(:,:,indexfast);
spectrograms2_jittered = spectrograms(:,:,indexslow);
spectrograms3_jittered = spectrograms(:,:,indexslowwithpockets);

save(['F:\oytun_Calisma\data\spectrograms1_jittered_',num2str(reqSNRdB),'dB.mat'], 'spectrograms1_jittered','t','f');
save(['F:\oytun_Calisma\data\spectrograms2_jittered_',num2str(reqSNRdB),'dB.mat'], 'spectrograms2_jittered','t','f');
save(['F:\oytun_Calisma\data\spectrograms3_jittered_',num2str(reqSNRdB),'dB.mat'], 'spectrograms3_jittered','t','f');
