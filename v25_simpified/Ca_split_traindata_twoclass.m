%%

clear all;clc;close all;
% load('F:\oytun_Calisma\data\Traindatatwoclass_15features_16_10_2021.mat');% load('F:\oytun_Calisma\data\Traindatatwoclass_threefeature.mat');

load('F:\oytun_Calisma\data\Traindatatwoclass_features_20_11_2021_rangedopplers.mat')



%% normalize data

%convert from cell to numbeofsamples x numberoffeatures x XTrain
for i =1: length(XTrain)
    XTraintemp=normalize(XTrain{i}');
    XTrainnew{i,1}=XTraintemp';

end


% find lndices w.r.t each label
fastInd = find(YTrain==categorical("fast"));
slowInd = find(YTrain==categorical("slow"));

%% divide into train, val, test for each label
trainRatio=0.8;
valRatio=0.1;
testRatio=0.1;
[trainf,valf,testf] = dividerand(numel(fastInd),trainRatio,valRatio,testRatio);
[trains,vals,tests] = dividerand(numel(slowInd),trainRatio,valRatio,testRatio);

%% get final indices
trainInd = [fastInd(trainf); slowInd(trains)];
valInd = [fastInd(valf); slowInd(vals)];
testInd = [fastInd(testf); slowInd(tests)];

TrainData= XTrainnew(trainInd);
ValData= XTrainnew(valInd);
TestData= XTrainnew(testInd);


TrainY = YTrain(trainInd);
ValY =  YTrain(valInd);
TestY =  YTrain(testInd);

%% now oversample fast


save('F:\oytun_Calisma\data\Traindatathreeclass_13features_21_11_2021_normalized_rdopplers.mat','TrainData','ValData','TestData','TrainY','ValY','TestY');
