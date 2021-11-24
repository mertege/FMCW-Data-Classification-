clear all;clc;close all;

jittered=0;
reqSNRdB=50;
rng(0);  %fix random seed

gpuDevice(2); 
numberofsamples=2;
type='fast';
augmentationtype='normal'; %'convexhulled';
index=1;savefile=0;
tic
[spectrogramsfast] = createallspectrograms(numberofsamples,reqSNRdB,augmentationtype,type,index,savefile);
toc 

%GPU:  
%  80  seconds - for 1 sample non augmented, 57*3*80 /60 = 228 minutes for
%  178  seconds - for 2 sample non augmented, 
%CPU with parfor
% -49.51 seconds - for 1 sample non augmented
% 74.716721 seconds for 2 sample non augmented

%visualize with gpu and parfor
spectrogram=spectrogramsfast(:,:,1);
myspectrogram = 10*log10(abs(spectrogram));
spect2= helperPreProcess(myspectrogram);
doppler = linspace(-8000,8000,size(spect2,1));
time=linspace(0,16,size(spect2,2));
T=time;
F=doppler;

subplot(2,2,1);

imagesc(T,F,spect2);

title('With GPU');



spectrogram=spectrogramsfast(:,:,2);
myspectrogram = 10*log10(abs(spectrogram));
spect2= helperPreProcess(myspectrogram);
doppler = linspace(-8000,8000,size(spect2,1));
time=linspace(0,16,size(spect2,2));
T=time;
F=doppler;


subplot(2,2,2);
imagesc(T,F,spect2);

title('With GPU');


tic
[spectrogramsfast] = parfor_of_createallspectrograms(numberofsamples,reqSNRdB,augmentationtype,type,index,savefile);
toc
%visualize with gpu and parfor
spectrogram=spectrogramsfast(:,:,1);
myspectrogram = 10*log10(abs(spectrogram));
spect2= helperPreProcess(myspectrogram);
doppler = linspace(-8000,8000,size(spect2,1));
time=linspace(0,16,size(spect2,2));
T=time;
F=doppler;


subplot(2,2,3);
imagesc(T,F,spect2);

title('With Parfor');


spectrogram=spectrogramsfast(:,:,2);
myspectrogram = 10*log10(abs(spectrogram));
spect2= helperPreProcess(myspectrogram);
doppler = linspace(-8000,8000,size(spect2,1));
time=linspace(0,16,size(spect2,2));
T=time;
F=doppler;


subplot(2,2,4);
imagesc(T,F,spect2);

title('With Parfor');




%%
% type='slow';
% [spectrogramsslow] = createallspectrograms(numberofsamples,reqSNRdB,augmentationtype,type,index,savefile);
% type='slowwithpocket';
% [spectrogramsslowwithpocket] = createallspectrograms(numberofsamples,reqSNRdB,augmentationtype,type,index,savefile);


% temp = cat(3,spectrogramsfast,spectrogramsslow);
% spectrograms = cat(3,temp,spectrogramsslowwithpocket);
% save('F:\oytun_Calisma\data\spectrograms_visualize_notjittered_vwithparfor.mat', 'spectrograms');
% Computation of   line     adctemp=convexhull(adcData,numberofaugmentation);




% Computation of   spectrograms     

%GPU:  
%  seconds - for 1 sample non augmented
%  seconds - for 5 samples non augmented
%   seconds - for 10 samples non augmented
%  seconds - for 100 samples non augmented


%CPU: 
% - seconds - for 1 sample non augmented
% - seconds - for 10 samples non augmented


% parfor but images are corrupted
% % Elapsed time is 11.18 seconds for 1 sample
% Elapsed time is 11.085376 seconds for 10 samples


% parfor cannot be used with load

