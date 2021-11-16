

% load FinalTraindata.mat;
clc;close all;clear all;
numberofrun=5;
% dataname='Traindatatwoclass_15features_11_11_2021_oversampled_normalized';
dataname ='Traindatatwoclass_15features_29_09_2021_oversampled_normalized';
% load('F:\oytun_Calisma\data\Traindatatwoclass_15features_29_09_2021_oversampled_normalized.mat');
% load('F:\oytun_Calisma\data\Traindatatwoclass_15features_16_10_2021_oversampled_normalized.mat');
% load('F:\oytun_Calisma\data\Traindatatwoclass_15features_24_10_2021_augmentedJitter_var_002.mat');
load(['F:\oytun_Calisma\data\', dataname]);

% load('F:\oytun_Calisma\data\Traindatatwoclass_15features_29_09_2021_oversampled_normalized.mat');

gpuDevice(2); 
%remove 
disp(['Experiment Results , Day:', date, ',  DataName: ',dataname ]);
disp(['Train Accuracy, Validation Accuracy,Test Accuracy, Precision, Recall, F1-score']);
rng(0); % fix random seed

% make for augmented data
% TrainData = OverallTrainData;
% TrainY= OverallTrainY;

showprogress ='none'; %%'training-progress', none



    for iii =15:15 % to 15
    featurevec= [1:5,7:iii]; % 6.feature bozuldugu icin bunu tercih ettik
%     featurevec= [1:iii];

    numberoffeatures=length(featurevec);

    for i = 1 :length(TrainData)

        a = TrainData{i,1};
        a2 = a(featurevec,:); 
        TrainDatanew{i,1}=a2;   
      
    end
    
    for i = 1 :length(ValData)
        b = ValData{i,1};        
        b2 = b(featurevec,:);
        ValDatanew{i,1}=b2;       
    end

    

    for i = 1 :length(TestData)        
        c = TestData{i,1};
        c2 = c(featurevec,:);     
        TestDatanew{i,1}=c2;               
    end

% disp([num2str(numberoffeatures),' Feature Set']);

%%
tic
for runindex =1 :numberofrun

    %   load('SavedData_251120.mat')
    % shuffle data
%     indexvec = randperm(length(TrainData));


%% %%
    % split data

    % shuffle data

    % Choose a mini-batch size of 27 to divide the training data evenly and reduce the amount of padding in the mini-batches. The following figure illustrates the padding added to the sequences.
    miniBatchSize = 128; % 80

    % Define LSTM Network Architecture
    % Define the LSTM network architecture. Specify the input size to be sequences of size 12 (the dimension of the input data). Specify an bidirectional LSTM layer with 100 hidden units, and output the last element of the sequence. Finally, specify nine classes by including a fully connected layer of size 9, followed by a softmax layer and a classification layer.
    % If you have access to full sequences at prediction time, then you can use a bidirectional LSTM layer in your network. A bidirectional LSTM layer learns from the full sequence at each time step. If you do not have access to the full sequence at prediction time, for example, if you are forecasting values or predicting one time step at a time, then use an LSTM layer instead.
    inputSize = numberoffeatures;
    numHiddenUnits = 30;
    numClasses = 2;

    layers = [ ...
        sequenceInputLayer(inputSize)
        lstmLayer(numHiddenUnits,'OutputMode','last')
        fullyConnectedLayer(numClasses)
        softmaxLayer
        classificationLayer];
    % Now, specify the training options. Specify the solver to be 'adam', the gradient threshold to be 1, and the maximum number of epochs to be 100. To reduce the amount of padding in the mini-batches, choose a mini-batch size of 27. To pad the data to have the same length as the longest sequences, specify the sequence length to be 'longest'. To ensure that the data remains sorted by sequence length, specify to never shuffle the data.
    % Since the mini-batches are small with short sequences, training is better suited for the CPU. Specify 'ExecutionEnvironment' to be 'cpu'. To train on a GPU, if available, set 'ExecutionEnvironment' to 'auto' (this is the default value).
    maxEpochs = 200;  
    
    
    


%     options = trainingOptions('adam', ...
%         'ExecutionEnvironment','gpu', ...
%         'GradientThreshold',1, ...
%         'InitialLearnRate',3e-1,...
%         'MaxEpochs',maxEpochs, ...
%         'ValidationData',{XVal,YVal}, ...
%         'ValidationFrequency',30,...
%         'ValidationPatience',5,...  
%         'L2Regularization',1e-2,...
%         'MiniBatchSize',miniBatchSize, ...
%         'SequenceLength','longest', ...
%         'Shuffle','never', ...
%         'Verbose',0, ...
%         'Plots','training-progress');%'training-progress', none
%     
     options = trainingOptions('adam', ...
        'ExecutionEnvironment','gpu', ...
        'GradientThreshold',1, ...
        'InitialLearnRate',1e-2,...
        'MaxEpochs',maxEpochs, ...
        'ValidationData',{ValDatanew,ValY}, ...
        'ValidationFrequency',30,...
        'ValidationPatience',5,...  
        'L2Regularization',1e-4,...
        'MiniBatchSize',miniBatchSize, ...
        'SequenceLength','longest', ...
        'Shuffle','never', ...
        'Verbose',0, ...
        'Plots',showprogress);%'training-progress', none
    % 
    % Train LSTM Network
    % Train the LSTM network with the specified training options by using trainNetwork.
    net = trainNetwork(TrainDatanew,TrainY,layers,options);
    
    
    %

    % Test Network

    miniBatchSize = 128;


    [trainaccout,valaccout,test_accuracy_out,confusionMat,precisionout,recallout,f1scoreout] = evaluate_classifier(net,miniBatchSize,TrainDatanew,ValDatanew,TestDatanew,TrainY,ValY,TestY);
    
    
    trainacc(runindex)=trainaccout;
    valacc(runindex)= valaccout;
    test_accuracy(runindex) =test_accuracy_out;
     

    % << for an existing Confision Matrix 'ConfusionMat' >>
    precision(runindex) = precisionout; % And another for recall
    recall(runindex)= recallout;
    f1score(runindex) =f1scoreout;


    disp([addComma(trainacc(runindex)*100),' ', addComma(valacc(runindex)*100),' ', addComma(test_accuracy(runindex)*100),' ', addComma(precision(runindex)),' ',addComma(recall(runindex)),' ',addComma(f1score(runindex))]);

end



%% write to excel files

% disp(' Train Accuracy, Validation Accuracy Test Accuracy, Precision, Recall, F1-score');
% 
% disp(['Mean: ',addComma(mean(trainacc)*100),' ',addComma(mean(valacc)*100),' ',addComma(mean(test_accuracy)*100),' ',addComma(mean(precision)),' ',addComma(mean(recall)),' ',addComma(mean(f1score))]);
% disp(['Min: ',addComma(min(trainacc)*100),' ',addComma(min(valacc)*100),' ',addComma(min(test_accuracy)*100),' ',addComma(min(precision)),' ',addComma(min(recall)),' ',addComma(min(f1score))]);
% disp(['Max: ',addComma(max(trainacc)*100),' ',addComma(max(valacc)*100),' ',addComma(max(test_accuracy)*100),' ',addComma(max(precision)),' ',addComma(max(recall)),' ',addComma(max(f1score))]);
% disp(['STD: ',addComma(std(trainacc)),' ',addComma(std(valacc)),' ',addComma(std(test_accuracy)),' ',addComma(std(precision)),' ',addComma(std(recall)),' ',addComma(std(f1score))]);

disp([num2str(numberoffeatures),' Feature Set']);


disp(' Test Accuracy: Mean, Min,    Max ,   STD ');
disp([ addComma(mean(test_accuracy)*100),' ',addComma(min(test_accuracy)*100),' ', addComma(max(test_accuracy)*100),' ',addComma(std(test_accuracy))]);


toc
    end
% plotconfusion(Ytestcat,Ypredcat)
 
layers
options


