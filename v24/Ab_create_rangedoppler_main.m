clear all;clc;close all;

jittered=0;
reqSNRdB=50;
rng(0);  %fix random seed

gpuDevice(2); 


% % CPU: 1 sample  23 secs, 2 sample 45 sec, GPU: 1 sample 11 sec,2 sample 23
% % sec, 659 sec 57 samples

numberofsamples=4;
type='fast';
tic
[rangeDopplersfast1] = createallrangedopplers(numberofsamples,reqSNRdB,jittered,type);
% imagesc(rangeDopplersfast1);
% toc 
% % 
% save('F:\oytun_Calisma\data\rangeDoppler_fast1_notaugmented.mat', 'rangeDopplersfast1','-v7.3');
% 


%%
type='slow';
tic
[rangeDopplersslow] = createallrangedopplers(numberofsamples,reqSNRdB,jittered,type);
toc 
% 
% 
% save('F:\oytun_Calisma\data\rangeDoppler_slow_notaugmented.mat', 'rangeDopplersslow','-v7.3');
%
% save(['F:\oytun_Calisma\data\rangeDoppler_slow_notaugmented_',num2str(reqSNRdB),'dB.mat'], 'rangeDopplersslow');



type='slowwithpocket';
tic
[rangeDopplers_slowwithpocket] = createallrangedopplers(numberofsamples,reqSNRdB,jittered,type);
toc 
% 
% % save(['F:\oytun_Calisma\data\rangeDopplers_slowwithpocket_notaugmented_',num2str(reqSNRdB),'dB.mat'], 'rangeDopplers_slowwithpocket');
% % 
% save('F:\oytun_Calisma\data\rangeDoppler_slowwithpocket_notaugmented.mat', 'rangeDopplers_slowwithpocket','-v7.3');
% 
% 

temp = cat(3,rangeDopplersfast1,rangeDopplersslow);
rangedopplers = cat(3,temp,rangeDopplers_slowwithpocket);
save('F:\oytun_Calisma\data\rangedopplers_tovisualize_notaugmented_parfor.mat', 'rangedopplers');


