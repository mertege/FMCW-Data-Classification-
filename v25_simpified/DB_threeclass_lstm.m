

% load FinalTraindata.mat;
clc;close all;clear all;
numberofrun=1;
dataname='Traindatathreeclass_13features_19_11_2021_normalized_newspectrograms';

% dataname='Traindatatwoclass_15features_17_11_2021_oversampled_normalized';
% dataname ='Traindatatwoclass_15features_29_09_2021_oversampled_normalized';
% load('F:\oytun_Calisma\data\Traindatatwoclass_15features_29_09_2021_oversampled_normalized.mat');
% load('F:\oytun_Calisma\data\Traindatatwoclass_15features_16_10_2021_oversampled_normalized.mat');
% load('F:\oytun_Calisma\data\Traindatatwoclass_15features_24_10_2021_augmentedJitter_var_002.mat');
load(['F:\oytun_Calisma\data\', dataname]);

%%

% load('F:\oytun_Calisma\data\Traindatatwoclass_15features_29_09_2021_oversampled_normalized.mat');

gpuDevice(2); 
%remove 
disp(['Experiment Results , Day:', date, ',  DataName: ',dataname ]);
disp(['Train Accuracy, Validation Accuracy,Test Accuracy, Precision, Recall, F1-score']);
rng(0); % fix random seed

% make for augmented data
% TrainData = OverallTrainData;
% TrainY= OverallTrainY;

showprogress ='training-progress'; %%'training-progress', none
numberoffeatures=13;
%


%
tic
for runindex =1 :numberofrun

    %   load('SavedData_251120.mat')
    % shuffle data
%     indexvec = randperm(length(TrainData));


%
    % split data

    % shuffle data

    % Choose a mini-batch size of 27 to divide the training data evenly and reduce the amount of padding in the mini-batches. The following figure illustrates the padding added to the sequences.
    miniBatchSize = 128; % 80

    % Define LSTM Network Architecture
    % Define the LSTM network architecture. Specify the input size to be sequences of size 12 (the dimension of the input data). Specify an bidirectional LSTM layer with 100 hidden units, and output the last element of the sequence. Finally, specify nine classes by including a fully connected layer of size 9, followed by a softmax layer and a classification layer.
    % If you have access to full sequences at prediction time, then you can use a bidirectional LSTM layer in your network. A bidirectional LSTM layer learns from the full sequence at each time step. If you do not have access to the full sequence at prediction time, for example, if you are forecasting values or predicting one time step at a time, then use an LSTM layer instead.
    inputSize = numberoffeatures;
    numHiddenUnits = 30;
    numClasses = 3;

    layers = [ ...
        sequenceInputLayer(inputSize)
        lstmLayer(numHiddenUnits,'OutputMode','last')
        fullyConnectedLayer(numClasses)
        softmaxLayer
        classificationLayer];
    % Now, specify the training options. Specify the solver to be 'adam', the gradient threshold to be 1, and the maximum number of epochs to be 100. To reduce the amount of padding in the mini-batches, choose a mini-batch size of 27. To pad the data to have the same length as the longest sequences, specify the sequence length to be 'longest'. To ensure that the data remains sorted by sequence length, specify to never shuffle the data.
    % Since the mini-batches are small with short sequences, training is better suited for the CPU. Specify 'ExecutionEnvironment' to be 'cpu'. To train on a GPU, if available, set 'ExecutionEnvironment' to 'auto' (this is the default value).
    maxEpochs = 200;  

%     
     options = trainingOptions('adam', ...
        'ExecutionEnvironment','gpu', ...
        'GradientThreshold',1, ...
        'InitialLearnRate',1e-2,...
        'MaxEpochs',maxEpochs, ...
        'ValidationData',{ValData,ValY}, ...
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
    net = trainNetwork(TrainData,TrainY,layers,options);


    % Test Network

    miniBatchSize = 128;


     YPred = classify(net,TrainData, ...
        'MiniBatchSize',miniBatchSize, ...
        'SequenceLength','longest');

    trainacc(runindex) = sum(YPred == TrainY)./numel(TrainY);
    
    
    YPred = classify(net,ValData, ...
        'MiniBatchSize',miniBatchSize, ...
        'SequenceLength','longest');
     valacc(runindex) = sum(YPred == ValY)./numel(ValY);
    

   YPred = classify(net,TestData, ...
        'MiniBatchSize',miniBatchSize, ...
        'SequenceLength','longest');
    % Calculate the classification accuracy of the predictions.
    test_accuracy(runindex) = sum(YPred == TestY)./numel(TestY);

    YPred = double(YPred);
    for i = 1:length(YPred)  
        if(YPred(i) == 1)
            Ypredcell(i,1) = {'fast'};

        elseif(YPred(i) == 2)
             Ypredcell(i,1) = {'slow'};

        else
             Ypredcell(i,1) = {'slowwithpockets'};
        end
    end

    Ypredcat = categorical(Ypredcell); 
    


    YTest = double(TestY);
    for i = 1:length(YTest)  
        if(YTest(i) == 1)
            Ytestcell(i,1) = {'fast'};

        elseif(YTest(i) == 2)
             Ytestcell(i,1) = {'slow'};

        else
             Ytestcell(i,1) = {'slowwithpockets'};
        end
    end

    Ytestcat= categorical(Ytestcell);

    % %%
    confusionMat = confusionmat(Ytestcat,Ypredcat,'Order',{'fast','slow','slowwithpockets'});

%     confusionchart(confusionMat)

%     precisionvec =  diag(confusionMat)./sum(confusionMat,1)';
%     % And another for recall
%     recallvec = diag(confusionMat)./sum(confusionMat,2);
%     f1scorevec = 2 * precisionvec.*recallvec./(precisionvec+recallvec);


    % << for an existing Confision Matrix 'ConfusionMat' >>
    precision(runindex) =  mean(diag(confusionMat)./sum(confusionMat,1)');
    % And another for recall
    recall(runindex)= mean(diag(confusionMat)./sum(confusionMat,2));

    f1score(runindex) = 2 * precision(runindex) *recall(runindex)/(precision(runindex)+recall(runindex));


    disp([addComma(trainacc(runindex)*100),' ', addComma(valacc(runindex)*100),' ', addComma(test_accuracy(runindex)*100),' ', addComma(precision(runindex)),' ',addComma(recall(runindex)),' ',addComma(f1score(runindex))]);
   
end



%% write to excel files

disp([num2str(numberoffeatures),' Feature Set']);


disp(' Test Accuracy: Mean, Min,    Max ,   STD ');
disp([ addComma(mean(test_accuracy)*100),' ',addComma(min(test_accuracy)*100),' ', addComma(max(test_accuracy)*100),' ',addComma(std(test_accuracy))]);


disp(' F1 score : Mean, Min,    Max ,   STD ');
disp([ addComma(mean(f1score)),' ',addComma(min(f1score)),' ', addComma(max(f1score)),' ',addComma(std(f1score))]);



toc
%     end
% plotconfusion(Ytestcat,Ypredcat)
 
layers
options


