function [trainacc,valacc,test_accuracy,confusionMat,precisionout,recallout,f1scoreout] = evaluate_classifier(net,miniBatchSize,TrainDatanew,ValDatanew,TestDatanew,TrainY,ValY,TestY)
%EVALUATE_CLASSÝFÝER Summary of this function goes here
%   Detailed explanation goes here



   YPred = classify(net,TrainDatanew, ...
        'MiniBatchSize',miniBatchSize, ...
        'SequenceLength','longest');

    trainacc = sum(YPred == TrainY)./numel(TrainY);
    
    
    %%
    
     YPred = classify(net,ValDatanew, ...
        'MiniBatchSize',miniBatchSize, ...
        'SequenceLength','longest');
     valacc = sum(YPred == ValY)./numel(ValY);  
    

     %%

     YPred = classify(net,TestDatanew, ...
        'MiniBatchSize',miniBatchSize, ...
        'SequenceLength','longest');
    % Calculate the classification accuracy of the predictions.
    test_accuracy = sum(YPred == TestY)./numel(TestY);
    
    %%

    YPred = double(YPred);
    for i = 1:length(YPred)  
        if(YPred(i) == 1)
            Ypredcell(i,1) = {'fast'};

        elseif(YPred(i) == 2)
             Ypredcell(i,1) = {'slow'};

        else
        end
    end

    Ypredcat = categorical(Ypredcell);


%%

    TestY = double(TestY);
    for i = 1:length(TestY)  
        if(TestY(i) == 1)
            Ytestcell(i,1) = {'fast'};

        elseif(TestY(i) == 2)
             Ytestcell(i,1) = {'slow'};

        else
        end
    end

    Ytestcat= categorical(Ytestcell);

    % %%
    confusionMat = confusionmat(Ytestcat,Ypredcat,'Order',{'fast','slow'});
    % confusionchart(confusionMat)

  

    % << for an existing Confision Matrix 'ConfusionMat' >>
    precisionout =  mean(diag(confusionMat)./sum(confusionMat,1)');
    % And another for recall
    recallout= mean(diag(confusionMat)./sum(confusionMat,2));

    f1scoreout = 2 * precisionout *recallout/(recallout+recallout);


end

