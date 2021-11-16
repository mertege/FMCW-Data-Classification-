clear;clc;

load('F:\oytun_Calisma\data\rangedopplers_tovisualize_notaugmented.mat')


%% visualize spectrograms slow walk
figure(2)

myindex = [1:12];
for index=1: length(myindex)  
    index
    rdoppler=rangedopplers(:,:,myindex(index));
%     myspectrogram = 10*log10(abs(spectrogram));
%     spect2= helperPreProcess(myspectrogram);
%     doppler = linspace(-8000,8000,size(spect2,1));    
%     time=linspace(0,16,size(spect2,2));
%     T=time;
%     F=doppler;
    subplot(3,4,index)
    imagesc(rdoppler);
    xlabel('Range(m)');
    ylabel('Doppler(Hz)')
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
