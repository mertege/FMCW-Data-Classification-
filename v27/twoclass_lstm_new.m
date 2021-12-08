clear all;clc;close all;
load('F:\oytun_Calisma\data\Traindatatwoclass_features_02_12_2021_newspectrogramsparfor');

% normalize data
gpuDevice(2); 

%convert from cell to numbeofsamples x numberoffeatures x XTrain
for i =1: length(XTrain)
    XTraintemp=normalize(XTrain{i}');
    XTrainnew{i,1}=XTraintemp';

end
%
% find lndices w.r.t each label
fastInd = find(YTrain==categorical("fast"));
slowInd = find(YTrain==categorical("slow"));

  % divide into train, val, test for each label
    trainRatio=0.8;
    valRatio=0.1;
    testRatio=0.1;

for run =1: 1
    rng(0);

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
    
    inputSize = 13;
    numHiddenUnits = 18;
    numClasses = 2;
    valfreq=1;

    layers = [ ...
        sequenceInputLayer(inputSize)
        lstmLayer(numHiddenUnits,'OutputMode','last')
        fullyConnectedLayer(numClasses)
        softmaxLayer
        classificationLayer];

    maxEpochs = 50;
    miniBatchSize = 32;
    learnrate=0.01;

    options = trainingOptions('adam', ...
        'ExecutionEnvironment','gpu', ...
        'MaxEpochs',maxEpochs, ...
        'MiniBatchSize',miniBatchSize, ...
        'ValidationData',{ValData,ValY}, ...
        'ValidationFrequency',valfreq,...
         'L2Regularization',0,...
        'InitialLearnRate',learnrate,...
        'GradientThreshold',1, ...
        'Verbose',true, ...
        'Plots','training-progress');%training-progress

    %     'ValidationData',{ValData,ValY}, ...
    %     'ValidationFrequency',valfreq,...
%         'ValidationPatience',3,...

    net = trainNetwork(TrainData,TrainY,layers,options);

    % calculate train accuracy:
    YPred = classify(net,TrainData,'MiniBatchSize',miniBatchSize);
    trainacc(run) = sum(YPred == TrainY)./numel(TrainY)*100;

    % calculate train accuracy:
    YPred = classify(net,ValData,'MiniBatchSize',miniBatchSize);
    valacc(run) = sum(YPred == ValY)./numel(ValY)*100;

    YPred = classify(net,TestData,'MiniBatchSize',miniBatchSize);
    testacc(run) = sum(YPred == TestY)./numel(TestY)*100;
end
trainacc
valacc
testacc

% delete(findall(0));
% 
% trainacc =97.7941
% valacc = 70.5882
% testacc =64.7059
% 
% layers = 
% 
%   5x1 Layer array with layers:
% 
%      1   ''   Sequence Input          Sequence input with 13 dimensions
%      2   ''   LSTM                          LSTM with 18 hidden units
%      3   ''   Fully Connected          2 fully connected layer
%      4   ''   Softmax                       softmax
%      5   ''   Classification Output   crossentropyex
% 
% options = 
% 
%   TrainingOptionsADAM with properties:
% 
%            GradientDecayFactor: 0.9000
%     SquaredGradientDecayFactor: 0.9990
%                        Epsilon: 1.0000e-08
%               InitialLearnRate: 0.0100
%              LearnRateSchedule: 'none'
%            LearnRateDropFactor: 0.1000
%            LearnRateDropPeriod: 10
%               L2Regularization: 0
%        GradientThresholdMethod: 'l2norm'
%              GradientThreshold: 1
%                      MaxEpochs: 50
%                  MiniBatchSize: 32
%                        Verbose: 1
%               VerboseFrequency: 50
%                 ValidationData: {{17×1 cell}  [17×1 categorical]}
%            ValidationFrequency: 1
%             ValidationPatience: Inf
%                        Shuffle: 'once'
%                 CheckpointPath: ''
%           ExecutionEnvironment: 'gpu'
%                     WorkerLoad: []
%                      OutputFcn: []
%                          Plots: 'training-progress'
%                 SequenceLength: 'longest'
%           SequencePaddingValue: 0
%       SequencePaddingDirection: 'right'
%           DispatchInBackground: 0
%        ResetInputNormalization: 1
% 
