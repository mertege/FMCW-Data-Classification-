clear;clc;


%
gpuDevice(2)
reqSNRdB=50;
numberofsamples=1;
type='fast';
augmentationtype='convexhulled'; %convexhulled, normal, jittered
index=1;savefile=0;
tic
[spectrogramsfast] = parfor_of_createallspectrograms(numberofsamples,reqSNRdB,augmentationtype,type,index,savefile);
toc

% Elapsed time is 185.334251 seconds. for 4 samples with normal = not
% augmented

tic
type='slow';
[spectrogramsslow] = parfor_of_createallspectrograms(numberofsamples,reqSNRdB,augmentationtype,type,index,savefile);
toc
type='slowwithpocket';
tic
[spectrogramsslowwithpocket] = parfor_of_createallspectrograms(numberofsamples,reqSNRdB,augmentationtype,type,index,savefile);
toc
temp = cat(3,spectrogramsfast,spectrogramsslow);
spectrograms = cat(3,temp,spectrogramsslowwithpocket);


%% visualize spectrograms 

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
% 
% 
% 
