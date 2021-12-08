clear;clc;close all

tic
% % load('Spectrogram_fast.mat');
% load('C:\Users\ogunes\Documents\MATLAB\realdata\codes\v9_train_two_feature_lstm\allspectrograms.mat');
% load('F:\oytun_Calisma\data\spectrograms1_new.mat');
% load('F:\oytun_Calisma\data\spectrograms2_new.mat');
% load('F:\oytun_Calisma\data\spectrograms3_new.mat'); 

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

% clear spectrograms1
% clear spectrograms2
% clear spectrograms3
% clear spectrogramtemp

%
% spectrograms = zeros(512,225,171); % first 57 of each, fast, slow, slowwithpockets

% make them dB and normalized
% treshold=0.74;
label1={'fast'}; % ilk 4 
label2={'slow'}; % ikinci 4
%  
% %add labels
for i =1:170    
    if(i<=56)
        myspectrogram.labels(i,1)=label1;
    elseif(57<=i && i<=171) 
        myspectrogram.labels(i,1)=label2;
    else
    end%     
end

testlabel = categorical(myspectrogram.labels);

% select



%
treshold = 0.7;
figureon=0;
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
        
%         skewness =         
%         shapefactor = rmsspect./meanabs;
        
        

        
        doppler = linspace(-8000,8000,size(spect2,1));
        ispositive = true;
        
        
%         [cuttedspectrogram,posenvelope,newy,T] =extract_envelope_new(spectrogram,figureon,index,ispositive); 
%         ispositive = false;
%         [cuttedspectrogram2,negenvelope,newy2,T] =extract_envelope_new(spectrogram,figureon,index,ispositive); 
%         aa=vertcat(cuttedspectrogram2,cuttedspectrogram);       
%         tu = treshold.*ones(size(aa,1),size(aa,2));
%         spectrogramabovetresh = double(aa >= tu);
%         eu=sum(spectrogramabovetresh.^2);
%         XTrain{index,1} = [posenvelope;negenvelope;eu];
%         XTrain{index,1} = [posenvelope;negenvelope];

        % more than 3 features
%         XTrain{index,1} = [eu;meanspect;stddev;rmsspect;myskewness;myentropy;mykurtosis;peakvalue;peaktopeakvalue;myvariance;myroot;shapefactor;crestfactor;impulsefactor;clearancefactor];
        XTrain{index,1} = [meanspect;stddev;rmsspect;myskewness;mykurtosis;peakvalue;peaktopeakvalue;myvariance;myroot;shapefactor;crestfactor;impulsefactor;clearancefactor];

%         XTrain{index,1} = [posenvelope;negenvelope;eu;meanspect;stddev;rmsspect;myskewness;myentropy];
        % make one hot encoded
% 
%         if(testlabel(index) == 'fast') % if it belongs to first class
%             Ytrainonehotcoded(:,index) =[1;0;0];
%         elseif(testlabel(index) == 'slow') 
%             Ytrainonehotcoded(:,index) =[0;1;0];
%         else
%             Ytrainonehotcoded(:,index) =[0;0;1];
%         end

          indexnew = indexnew +1;
    %     close(figure(1))
    %     close(figure(2))
    %     close(figure(3))
    %     close(figure(4))
    %     close(figure(5))

end
YTrain = testlabel;

toc


% % Elapsed time is 163.764533 seconds. with  XTrain{index,1} = [meanspect;stddev;rmsspect;myskewness;mykurtosis;peakvalue;peaktopeakvalue;myvariance;myroot;shapefactor;crestfactor;impulsefactor;clearancefactor];


save('F:\oytun_Calisma\data\Traindatatwoclass_features_02_12_2021_newspectrogramsparfor.mat','XTrain','YTrain');
  