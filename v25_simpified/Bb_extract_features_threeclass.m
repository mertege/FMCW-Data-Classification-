clear;clc;close all
tic
% % load('Spectrogram_fast.mat');
% load('C:\Users\ogunes\Documents\MATLAB\realdata\codes\v9_train_two_feature_lstm\allspectrograms.mat');
% load('F:\oytun_Calisma\data\spectrograms1_new.mat');
% load('F:\oytun_Calisma\data\spectrograms2_new.mat');
% load('F:\oytun_Calisma\data\spectrograms3_new.mat');
% 
load('F:\oytun_Calisma\data\spectrograms_fast1notaugmented.mat');
spectrograms1=spectrograms;
load('F:\oytun_Calisma\data\spectrograms_slow1notaugmented.mat');
spectrograms2=spectrograms;
load('F:\oytun_Calisma\data\spectrograms_slowwithpocket1notaugmented.mat');
spectrograms3=spectrograms;


%%
spectrograms1 = spectrograms1(:,:,[1:49,51:57]); % remove 50th ?? 

spectrogramtemp = cat(3,spectrograms1,spectrograms2);
spectrograms = cat(3,spectrogramtemp,spectrograms3);

clear spectrograms1
clear spectrograms2
clear spectrograms3
clear spectrogramtemp

%%
% make them dB and normalized
% treshold=0.74;
label1={'fast'}; % ilk 4 
label2={'slow'}; % ikinci 4
label3={'slowwithpocket'};
%  
% %add labels
for i =1:170    
    if(i<=56)
        myspectrogram.labels(i,1)=label1;
    elseif(57<=i && i<=(57+56)) 
        myspectrogram.labels(i,1)=label2;
    else
        myspectrogram.labels(i,1)=label3;

    end%     
end

testlabel = categorical(myspectrogram.labels);

indexnew= 1;
for index=1: 170  
        index
        spectrogram=spectrograms(:,:,index);
        myspectrogram = 10*log10(abs(spectrogram));
        spect2= helperPreProcess(myspectrogram);
%         time=linspace(0,16,length(t));
        time=linspace(0,16,size(spectrogram,2)); 
        %extract other features
        meanspect = mean(spect2); % mean
%         meanabs = meanabs(spect2); % meanabs
        stddev = std(spect2);
        rmsspect = rms(spect2); 
        for i =1: size(spect2,2)
            dopvec=spect2(:,i);
            absmean(i) = meanabs(dopvec);
            myskewness(i) = skewness(dopvec);
%             myentropy(i) = -sum(dopvec.*log2(dopvec)); entropy calismiyor
            mykurtosis(i) = kurtosis(dopvec);
            peakvalue(i) = max(dopvec);
            peaktopeakvalue(i) = max(dopvec)-min(dopvec);
            myvariance(i) =var(dopvec);
            sum2 = 0;
            for j =1 :length(dopvec)
                sum2 =sum2 + sqrt(abs(dopvec(j)));                
            end
            myroot(i) = (1/length(dopvec)*sum2).^2;
        end        
        shapefactor = rmsspect./absmean;
        crestfactor = peakvalue./rmsspect;
        impulsefactor = peakvalue./absmean;
        clearancefactor = peakvalue./myroot;       
      
        XTrain{index,1} = [meanspect;stddev;rmsspect;myskewness;mykurtosis;peakvalue;peaktopeakvalue;myvariance;myroot;shapefactor;crestfactor;impulsefactor;clearancefactor];

%     

          indexnew = indexnew +1;

end
YTrain = testlabel;

toc




save('F:\oytun_Calisma\data\Traindatathreeclass_features_19_11_2021_newspectrograms.mat','XTrain','YTrain');
  
% Elapsed time is 172 sec


