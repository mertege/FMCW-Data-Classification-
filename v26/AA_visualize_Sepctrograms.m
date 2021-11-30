clear all;clc;close all;

% jittered=0;
% reqSNRdB=50;
% rng(0);  %fix random seed
% 
% f = waitbar(0,'1','Name','Creating Spectrograms...',...
%     'CreateCancelBtn','setappdata(gcbf,''canceling'',1)');

gpuDevice(2); 
addpath('F:\oytun_Calisma\codes\v26\functions');



% numberofsamples=57;
% tic
% augmentationtype='convexhulled'; %'normal';
% index=1;savefile=1;


% type='fast';
% tic
% createAdcData(numberofsamples,type,savefile);
% toc
% 
% tic
% type='slow';
% createAdcData(numberofsamples,type,savefile);
% disp('Slow Completed');
% 
% type='slowwithpocket';
% createAdcData(numberofsamples,type,savefile);
% disp('slowwithpocket Completed');
% toc

load('F:\oytun_Calisma\data\adcdataallfast.mat')
adcdatafast=adcdataall;

%%
tic
% timesaugmentation=5;
numberofaugmenteddata=57;
[adcDataaugmented] = convexhull_adcData(adcdatafast,numberofaugmenteddata);
toc

%%
savefile=1;
augmentationtype='convexhulled';
type ='fast';
numberofaugmenteddata=2;
augmenteddatanew=augmenteddata(:,1:numberofaugmenteddata);
adcData2Spectrogram(augmenteddatanew,savefile,numberofaugmenteddata,augmentationtype,type)%10sample 4.7 sec with for
% 57 sample 24 sec with for

%% visualize

myindex = [1:2];
for index=1: length(myindex)  

    spectrogram=spectrograms(:,:,myindex(index));
    myspectrogram = 10*log10(abs(spectrogram));
    spect2= helperPreProcess(myspectrogram);
    doppler = linspace(-8000,8000,size(spect2,1));    
    time=linspace(0,16,size(spect2,2));
    T=time;
    F=doppler;
    subplot(1,2,index)
    imagesc(T,F,spect2);
    xlabel('Time(s)');
    ylabel('Frequency(Hz)')
    colorbar
    title('Fast Walk');
 
     
end     





%% slow spectrograms

tic
load('F:\oytun_Calisma\data\adcdataallslow.mat')
adcdataslow=adcdataall;
delete adcdataall;
% timesaugmentation=5;
%%
numberofaugmenteddata=2;
[adcDataaugmented] = convexhull_adcData(adcdataslow,numberofaugmenteddata);

%
savefile=1;
augmentationtype='convexhulled';
type ='slow';
augmenteddatanew=adcDataaugmented(:,1:numberofaugmenteddata);
adcData2Spectrogram(augmenteddatanew,savefile,numberofaugmenteddata,augmentationtype,type)%10sample 4.7 sec with for
toc

load('F:\oytun_Calisma\data\spectrograms_slowconvexhulled.mat')

myindex = [1:2];
for index=1: length(myindex)  

    spectrogram=spectrograms(:,:,myindex(index));
    myspectrogram = 10*log10(abs(spectrogram));
    spect2= helperPreProcess(myspectrogram);
    doppler = linspace(-8000,8000,size(spect2,1));    
    time=linspace(0,16,size(spect2,2));
    T=time;
    F=doppler;
    subplot(1,2,index)
    imagesc(T,F,spect2);
    xlabel('Time(s)');
    ylabel('Frequency(Hz)')
    colorbar
    title('Slow Walk');
  
end     




%% slow with pockets spectrograms
tic
load('F:\oytun_Calisma\data\adcdataallslowwithpocket.mat')
adcdataslowwithpocket=adcdataall;
delete adcdataall;
% timesaugmentation=5;

numberofaugmenteddata=2;
[adcDataaugmented] = convexhull_adcData(adcdataslowwithpocket,numberofaugmenteddata);

%
savefile=1;
augmentationtype='convexhulled';
type ='slowwithpocket';
augmenteddatanew=adcDataaugmented(:,1:numberofaugmenteddata);
adcData2Spectrogram(augmenteddatanew,savefile,numberofaugmenteddata,augmentationtype,type)%10sample 4.7 sec with for
toc

load('F:\oytun_Calisma\data\spectrograms_slowwithpocketconvexhulled.mat')

myindex = [1:2];
for index=1: length(myindex)  

    spectrogram=spectrograms(:,:,myindex(index));
    myspectrogram = 10*log10(abs(spectrogram));
    spect2= helperPreProcess(myspectrogram);
    doppler = linspace(-8000,8000,size(spect2,1));    
    time=linspace(0,16,size(spect2,2));
    T=time;
    F=doppler;
    subplot(1,2,index)
    imagesc(T,F,spect2);
    xlabel('Time(s)');
    ylabel('Frequency(Hz)')
    colorbar
    title('Slow with Pocket Walk');
  
end     

