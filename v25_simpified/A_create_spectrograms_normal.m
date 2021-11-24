clear all;clc;close all;

jittered=0;
reqSNRdB=50;
rng(0);  %fix random seed
% 
% f = waitbar(0,'1','Name','Creating Spectrograms...',...
%     'CreateCancelBtn','setappdata(gcbf,''canceling'',1)');

gpuDevice(2); 
numberofsamples=57;
tic
augmentationtype='convexhulled'; %'normal';
index=1;savefile=1;


%%
type='fast';
[spectrogramsfast] = parfor_of_createallspectrograms(numberofsamples,reqSNRdB,augmentationtype,type,index,savefile);
disp('Fast Completed');


tic
type='slow';
parfor_of_createallspectrograms(numberofsamples,reqSNRdB,augmentationtype,type,index,savefile);
disp('Slow Completed');
type='slowwithpocket';
parfor_of_createallspectrograms(numberofsamples,reqSNRdB,augmentationtype,type,index,savefile);
disp('slowwithpocket Completed');
toc


% Computation of   line     adctemp=convexhull(adcData,numberofaugmentation);


%GPU:  

%CPU with parfor
% 154 seconds. - for 3 sample non augmented of fast slow and slow with pockets

%2543 sec for 57 samples
% Elapsed time is 7422.653535 seconds. f



% 



%%



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

