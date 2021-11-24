clear;clc;close all

% % load('Spectrogram_fast.mat');
% load('C:\Users\ogunes\Documents\MATLAB\realdata\codes\v9_train_two_feature_lstm\allspectrograms.mat');
% load('F:\oytun_Calisma\data\spectrograms1_new.mat');
% load('F:\oytun_Calisma\data\spectrograms2_new.mat');
% load('F:\oytun_Calisma\data\spectrograms3_new.mat');
% 
load('F:\oytun_Calisma\data\rangeDoppler_fast1_notaugmented.mat'); % rangeDopplersfast1
load('F:\oytun_Calisma\data\rangeDoppler_slow_notaugmented.mat');  %rangeDopplersslow
load('F:\oytun_Calisma\data\rangeDoppler_slowwithpocket_notaugmented.mat'); %rangeDopplers_slowwithpocket



%%

rdemp = cat(3,rangeDopplersfast1,rangeDopplersslow);
rangedopplers = cat(3,rdemp,rangeDopplers_slowwithpocket);

clear rangeDopplersfast1
clear rangeDopplersslow
clear rangeDopplers_slowwithpocket
clear rdemp

%% %add labels
% make them dB and normalized
% treshold=0.74;
label1={'fast'}; % ilk 4 
label2={'slow'}; % ikinci 4

numberofsamples=size(rangedopplers,3);

for i =1:numberofsamples   
    if(i<=57)
        myspectrogram.labels(i,1)=label1;
    elseif(57<=i && i<=(numberofsamples)) 
        myspectrogram.labels(i,1)=label2;
    else
        
        
    end%     
end

%%
tic
testlabel = categorical(myspectrogram.labels);

% select
XTrain = cell(numberofsamples,1);
indexnew= 1;
for index=1: numberofsamples  
        index    
        rangedoppler=rangedopplers(:,:,index);

        %extract other features
        meanspect = mean(rangedoppler); % mean
%         meanabs = meanabs(spect2); % meanabs
        stddev = std(rangedoppler);
        rmsspect = rms(rangedoppler); 
        for i =1: size(rangedoppler,2)
            dopvec=rangedoppler(:,i);
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
        indexnew = indexnew +1;


end
YTrain = testlabel;

toc


% % Elapsed time is 163.764533 seconds. with  XTrain{index,1} = [meanspect;stddev;rmsspect;myskewness;mykurtosis;peakvalue;peaktopeakvalue;myvariance;myroot;shapefactor;crestfactor;impulsefactor;clearancefactor];


save('F:\oytun_Calisma\data\Traindatatwoclass_features_20_11_2021_rangedopplers.mat','XTrain','YTrain');
  toc
  
%   Elapsed time is 1209.586403 seconds.
