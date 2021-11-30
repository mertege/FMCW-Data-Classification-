clear all;clc;close all;

% load functions
addpath('F:\oytun_Calisma\codes\v26\functions');

% parameters
savefile=1;
numberofaugmenteddata=57;
augmentationtype='convexhulled';

% load('F:\oytun_Calisma\data\adcdataallfast.mat')
% adcdatafast=adcdataall;
% delete adcdataall;
% [adcDataaugmented] = convexhull_adcData(adcdatafast,numberofaugmenteddata);
% type ='fast';
% adcData2Spectrogram(adcDataaugmented,savefile,numberofaugmenteddata,augmentationtype,type)
% display('Fast Done');
% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% 
% load('F:\oytun_Calisma\data\adcdataallslow.mat')
% adcdataslow=adcdataall;
% delete adcdataall;
% [adcDataaugmented] = convexhull_adcData(adcdataslow,numberofaugmenteddata);
% type ='slow';
% adcData2Spectrogram(adcDataaugmented,savefile,numberofaugmenteddata,augmentationtype,type)%10sample 4.7 sec with for
% display('Slow Done');
% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
tic
load('F:\oytun_Calisma\data\adcdataallslowwithpocket.mat')
adcdataslowwithpocket=adcdataall;
delete adcdataall;
[adcDataaugmented] = convexhull_adcData(adcdataslowwithpocket,numberofaugmenteddata);
type ='slowwithpocket';
adcData2Spectrogram(adcDataaugmented,savefile,numberofaugmenteddata,augmentationtype,type)%10sample 4.7 sec with for
display('Slow with Pockets Done');
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
toc

%  Time 
% GPU:  1 sample 1.09 sec, 5 sample 3.07 sec
% 57 sample 1980 sec  =33 min for all slow with pockets, 33*3 =99 min for 1
% set augmentation.

