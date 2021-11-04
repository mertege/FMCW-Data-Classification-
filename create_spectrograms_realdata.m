clear all;clc;close all;
 
jittered=0;
reqSNRdB=50;
rng(0);  %fix random seed
 
gpuDevice(2); 
 
numberofsamples=4;
type='fast';
[spectrogramsfast1_original] = createallspectrograms(numberofsamples,reqSNRdB,jittered,type);
 
% save(['F:\oytun_Calisma\data\spectrogramsfast1_original_',num2str(reqSNRdB),'dB.mat'], 'spectrogramsfast1_original');
 
% [spectrogramsfast2_original] = createfastspectrograms(numberofsamplesfast,reqSNRdB,jittered);
% 
% save(['F:\oytun_Calisma\data\spectrogramsfast2_original_',num2str(reqSNRdB),'dB.mat'], 'spectrogramsfast2_original');
% 
% [spectrogramsfast3_original] = createfastspectrograms(numberofsamplesfast,reqSNRdB,jittered);
% 
% save(['F:\oytun_Calisma\data\spectrogramsfast3_original_',num2str(reqSNRdB),'dB.mat'], 'spectrogramsfast3_original');
 
numberofsamples=4;
type='slow';
[spectrogramsslow_original] = createallspectrograms(numberofsamples,reqSNRdB,jittered,type);
% save(['F:\oytun_Calisma\data\spectrogramsslow_original',num2str(reqSNRdB),'dB.mat'], 'spectrogramsslow_original');
 
type='slowwithpocket';
[spectrogramsslowwithpocket_original] = createallspectrograms(numberofsamples,reqSNRdB,jittered,type);
% save(['F:\oytun_Calisma\data\spectrogramsslowwithpocket_original',num2str(reqSNRdB),'dB.mat'], 'spectrogramsslowwithpocket_original');
 
 
temp = cat(3,spectrogramsfast1_original,spectrogramsslow_original);
spectrograms = cat(3,temp,spectrogramsslowwithpocket_original);
save('F:\oytun_Calisma\data\spectrograms_visualize_notjittered_v2.mat', 'spectrograms');
 
 

