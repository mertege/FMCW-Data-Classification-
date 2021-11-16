clear;clc;


% parfor goruntuyu bozuyor, gpu bozmuyor
gpuDevice(2)
reqSNRdB=50;
numberofsamples=4;
type='fast';
augmentationtype='normal'; %'convexhulled';
index=1;savefile=0;
tic
[spectrogramsfast] = createallspectrograms(numberofsamples,reqSNRdB,augmentationtype,type,index,savefile);
toc
type='slow';
[spectrogramsslow] = createallspectrograms(numberofsamples,reqSNRdB,augmentationtype,type,index,savefile);
type='slowwithpocket';
[spectrogramsslowwithpocket] = createallspectrograms(numberofsamples,reqSNRdB,augmentationtype,type,index,savefile);


temp = cat(3,spectrogramsfast,spectrogramsslow);
spectrograms = cat(3,temp,spectrogramsslowwithpocket);

%%
% %visualize with parfor
% spectrogram=spectrogramsfast;
% myspectrogram = 10*log10(abs(spectrogram));
% spect2= helperPreProcess(myspectrogram);
% doppler = linspace(-8000,8000,size(spect2,1));
% time=linspace(0,16,size(spect2,2));
% T=time;
% F=doppler;
% subplot(1,2,2)
% imagesc(T,F,spect2);
% 
% title('With GPU');

% figure(2)
%% visualize spectrograms 
% clear all
% load('F:\oytun_Calisma\data\spectrograms_visualize_notjittered_v2.mat');

myindex = [1:12];
for index=1: length(myindex)  

    spectrogram=spectrograms(:,:,myindex(index));
    myspectrogram = 10*log10(abs(spectrogram));
    spect2= helperPreProcess(myspectrogram);
    doppler = linspace(-8000,8000,size(spect2,1));    
    time=linspace(0,16,size(spect2,2));
    T=time;
    F=doppler;
    subplot(3,4,index)
    imagesc(T,F,spect2);
    xlabel('Time(s)');
    ylabel('Frequency(Hz)')
    colorbar
    
    
    if(index<=4)
         title('Fast Walk');
    elseif(5<=index && index<=8)
         title('Slow Walk');
    else
         title('Slow Walk with Pockets');
    end

     
end     
% 
% load(['F:\oytun_Calisma\data\spectrograms_visualize_jittered_',num2str(reqSNRdB),'dB.mat']);
% 
% figure(3)
% %% visualize spectrograms slow walk
% 
% 
% myindex = [1:12];
% for index=1: length(myindex)  
% 
%     spectrogram=spectrograms(:,:,myindex(index));
%     myspectrogram = 10*log10(abs(spectrogram));
%     spect2= helperPreProcess(myspectrogram);
%     doppler = linspace(-8000,8000,size(spect2,1));    
%     time=linspace(0,16,size(spect2,2));
%     T=time;
%     F=doppler;
%     subplot(3,4,index)
%     imagesc(T,F,spect2);
%     xlabel('Time(s)');
%     ylabel('Frequency(Hz)')
%     colorbar
%     
%     
%     if(index<=4)
%          title('Fast Walk');
%     elseif(5<=index && index<=8)
%          title('Slow Walk');
%     else
%          title('Slow Walk with Pockets');
%     end
% 
%      
% end     
%      
%     
% 
% 
% 
% 
