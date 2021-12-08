
function [] = createAdcData(numberofsamples,type,savefile)


% spectrograms = zeros(512,4225,numberofsamples); % first 57 of each, fast, slow, slowwithpockets
adcdataall=zeros(26214400,numberofsamples);
% plot all fast
for ii =1:numberofsamples
% waitbar(ii/numberofsamples,sprintf('%12.9f',ii))
display(['adcData Number:', num2str(ii),'/',num2str(numberofsamples)]);

load(['F:\oytun_Calisma\',type,'\',num2str(ii),'\adc_Data.mat']);

adcDataRX1 = adc_DataTable.adc_DataRX1; 
adcDataRX2 = adc_DataTable.adc_DataRX2; 
adcDataRX3 = adc_DataTable.adc_DataRX3; 
adcDataRX4 = adc_DataTable.adc_DataRX4; 
adcData = adcDataRX1+adcDataRX2+adcDataRX3+adcDataRX4;
adcdataall(:,ii)=adcData;

end
% save file
if(savefile)
    
    save(['F:\oytun_Calisma\data\adcdataall',type,'.mat'], 'adcdataall','-v7.3');


else
end
