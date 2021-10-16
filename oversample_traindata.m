%%

clear all;clc;close all;
load('F:\oytun_Calisma\data\Traindatatwoclass_15features_29_09_2021_oversampled_normalized.mat');% load('F:\oytun_Calisma\data\Traindatatwoclass_threefeature.mat');


%% normalize data

%convert from cell to numbeofsamples x numberoffeatures x XTrain
for i =1: length(XTrain)
    XTraintemp=normalize(XTrain{i}');
    XTrainnew{i,1}=XTraintemp';

end

%%



% oversample the fast one
numberofclass1=56;
numberofclass2=114;

 aa=randperm(numberofclass1); % shuffle class 1
 bb=randperm(numberofclass2)+56; % shuffle class s2
%  valsize=0.1;

YTrainnew2(1:56)= 0; % fast
YTrainnew2(57:170)= 1;% slow
YTrainnew2 = YTrainnew2';

% make sure that val and test comes from the same distribution
 valandtestlength=20;
 valindexclass1=aa(1:(valandtestlength/2)); % fast for validation
 valindexclass2=bb(1:(valandtestlength/2));% fast for validation

 testindexclass1= aa((valandtestlength/2+1):valandtestlength); % fast for test
 testindexclass2= bb((valandtestlength/2+1):valandtestlength); % slow for test
 
 %
 
valindex=[valindexclass1, valindexclass2];
testindex=[testindexclass1, testindexclass2];
trainindex =[aa((valandtestlength+1): numberofclass1), bb((valandtestlength+1):numberofclass2)];
  
TrainData=XTrainnew(trainindex);
ValData= XTrainnew(valindex);
TestData= XTrainnew(testindex);
% 

TrainY=YTrain(trainindex);
ValY=YTrain(valindex);
TestY=YTrain(testindex);

sum(TrainY =='fast')
sum(TrainY =='slow')

%% now oversample fast

numberofminority =sum(TrainY== 'fast');
numberofmajorty = sum(TrainY== 'slow');
% %oversample the minority class in training data
startindex = 131;

for i=1: (numberofmajorty - numberofminority)
    index= randi(numberofminority);
    TrainData(startindex)=TrainData(index); 
    TrainY(startindex) = 'fast'; % label of minority is 0, fast
    startindex = startindex +1;
end

sum(TrainY =='fast')
sum(TrainY =='slow')


save('F:\oytun_Calisma\data\Traindatatwoclass_15features_29_09_2021_oversampled_normalized.mat','TrainData','ValData','TestData','TrainY','ValY','TestY');
