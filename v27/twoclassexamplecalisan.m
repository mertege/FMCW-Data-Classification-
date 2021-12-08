clear all;clc;

[XTrain,YTrain] = japaneseVowelsTrainData;

% make 2 class
XTrainnew = XTrain(1:60);
YTrainnew = YTrain(1:60);
YTrainnew=categorical(double(YTrainnew)-1);


% find lndices w.r.t each label
class1Ind = find(YTrainnew==categorical(0));
class2Ind = find(YTrainnew==categorical(1));
 
% divide into train, val, test for each label
trainRatio=0.8;
valRatio=0.2;
testRatio=0;
[trainf,valf,testf] = dividerand(numel(class1Ind),trainRatio,valRatio,testRatio);
[trains,vals,tests] = dividerand(numel(class2Ind),trainRatio,valRatio,testRatio);
 
% get final indices
trainInd = [class1Ind(trainf); class2Ind(trains)];
valInd = [class1Ind(valf); class2Ind(vals)];
 
TrainData= XTrainnew(trainInd);
ValData= XTrainnew(valInd);
 
 
TrainY = categorical(double(YTrain(trainInd))-1);
ValY =  categorical(double(YTrain(valInd))-1);




%%


numFeatures = size(XTrainnew{1},1);

inputSize = 12;
numHiddenUnits = 100;
numClasses = 2;

layers = [ ...
    sequenceInputLayer(inputSize)
    lstmLayer(numHiddenUnits,'OutputMode','last')
    fullyConnectedLayer(numClasses)
    softmaxLayer
    classificationLayer];

maxEpochs = 70;
miniBatchSize = 27;

options = trainingOptions('adam', ...
    'ExecutionEnvironment','cpu', ...
    'MaxEpochs',maxEpochs, ...
    'MiniBatchSize',miniBatchSize, ...
    'ValidationData',{ValData,ValY}, ...
    'GradientThreshold',1, ...
    'Verbose',false, ...
    'Plots','training-progress');


net = trainNetwork(TrainData,TrainY,layers,options);



%%

[XTest,YTest] = japaneseVowelsTestData;

XTestnew= XTest(1:66);
YTestnew= YTest(1:66);

%%

YTestnew=categorical(double(YTestnew)-1);
YPred = classify(net,XTestnew,'MiniBatchSize',miniBatchSize);

acc = sum(YPred == YTestnew)./numel(YTestnew)*100


