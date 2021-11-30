function [rangeDopplers] = createallrangedopplers(numberofsamples,reqSNRdB,jittered,type)

index=1;


rangeDopplers = zeros(512,51200,numberofsamples,'single'); % first 57 of each, fast, slow, slowwithpockets

% plot all fast
for ii =1:numberofsamples
index
load(['F:\oytun_Calisma\',type,'\',num2str(ii),'\adc_Data.mat']);
% load('C:\Users\ogunes\Documents\MATLAB\realdata\lindamodification_v2\slow1\adc_Data.mat');

adcDataRX1 = adc_DataTable.adc_DataRX1; 
adcDataRX2 = adc_DataTable.adc_DataRX2; 
adcDataRX3 = adc_DataTable.adc_DataRX3; 
adcDataRX4 = adc_DataTable.adc_DataRX4; 
% 
adcData = adcDataRX1+adcDataRX2+adcDataRX3+adcDataRX4;

%%

if(jittered)
    NoisySig = awgn(adcData,reqSNRdB,'measured');
    adcMatrix = reshape(NoisySig, 512, []);
else
    adcMatrix = reshape(adcData, 512, []);
end

rangeDoppler = single(10.*log10(abs(fft2(adcMatrix))));  % since datasize is too high each contains 5GB data.


% imagesc(rangeDoppler);

rangedopplernew= [rangeDoppler(1:512,(51200/2+1):(51200)), rangeDoppler(1:512,1:(51200/2))];

rangeDopplers(:,:,index) =rangedopplernew;

% imagesc(rangedopplernew);

index=index+1;
end


end