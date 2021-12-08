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
% 
% % delete(findall(0));
% |======================================================================================================================|
% |  Epoch  |  Iteration  |  Time Elapsed  |  Mini-batch  |  Validation  |  Mini-batch  |  Validation  |  Base Learning  |
% |         |             |   (hh:mm:ss)   |   Accuracy   |   Accuracy   |     Loss     |     Loss     |      Rate       |
% |======================================================================================================================|
% |       1 |           1 |       00:00:03 |       34.38% |       58.82% |       0.8096 |       0.6990 |          0.0100 |
% |       1 |           2 |       00:00:03 |       46.88% |       76.47% |       0.7273 |       0.6397 |          0.0100 |
% |       1 |           3 |       00:00:04 |       68.75% |       82.35% |       0.6518 |       0.5804 |          0.0100 |
% |       1 |           4 |       00:00:04 |       71.88% |       82.35% |       0.5541 |       0.5357 |          0.0100 |
% |       2 |           5 |       00:00:04 |       81.25% |       82.35% |       0.4670 |       0.5052 |          0.0100 |
% |       2 |           6 |       00:00:05 |       56.25% |       76.47% |       0.7086 |       0.4997 |          0.0100 |
% |       2 |           7 |       00:00:05 |       75.00% |       70.59% |       0.5566 |       0.4923 |          0.0100 |
% |       2 |           8 |       00:00:05 |       75.00% |       70.59% |       0.5185 |       0.4871 |          0.0100 |
% |       3 |           9 |       00:00:06 |       87.50% |       70.59% |       0.4089 |       0.4832 |          0.0100 |
% |       3 |          10 |       00:00:06 |       59.38% |       70.59% |       0.6519 |       0.4845 |          0.0100 |
% |       3 |          11 |       00:00:06 |       78.13% |       70.59% |       0.5186 |       0.4744 |          0.0100 |
% |       3 |          12 |       00:00:06 |       78.13% |       70.59% |       0.5058 |       0.4667 |          0.0100 |
% |       4 |          13 |       00:00:07 |       90.63% |       70.59% |       0.3957 |       0.4538 |          0.0100 |
% |       4 |          14 |       00:00:07 |       65.63% |       70.59% |       0.6197 |       0.4522 |          0.0100 |
% |       4 |          15 |       00:00:07 |       81.25% |       70.59% |       0.4629 |       0.4433 |          0.0100 |
% |       4 |          16 |       00:00:08 |       78.13% |       70.59% |       0.4940 |       0.4356 |          0.0100 |
% |       5 |          17 |       00:00:08 |       90.63% |       70.59% |       0.3838 |       0.4212 |          0.0100 |
% |       5 |          18 |       00:00:08 |       68.75% |       70.59% |       0.6338 |       0.4328 |          0.0100 |
% |       5 |          19 |       00:00:08 |       78.13% |       70.59% |       0.4331 |       0.4514 |          0.0100 |
% |       5 |          20 |       00:00:09 |       78.13% |       70.59% |       0.4842 |       0.4702 |          0.0100 |
% |       6 |          21 |       00:00:09 |       90.63% |       70.59% |       0.3586 |       0.4759 |          0.0100 |
% |       6 |          22 |       00:00:09 |       62.50% |       70.59% |       0.5786 |       0.4769 |          0.0100 |
% |       6 |          23 |       00:00:10 |       81.25% |       70.59% |       0.4272 |       0.4667 |          0.0100 |
% |       6 |          24 |       00:00:10 |       78.13% |       70.59% |       0.4753 |       0.4587 |          0.0100 |
% |       7 |          25 |       00:00:10 |       90.63% |       70.59% |       0.3314 |       0.4454 |          0.0100 |
% |       7 |          26 |       00:00:11 |       71.88% |       70.59% |       0.5510 |       0.4406 |          0.0100 |
% |       7 |          27 |       00:00:11 |       81.25% |       70.59% |       0.3990 |       0.4387 |          0.0100 |
% |       7 |          28 |       00:00:11 |       81.25% |       70.59% |       0.4504 |       0.4403 |          0.0100 |
% |       8 |          29 |       00:00:12 |       84.38% |       70.59% |       0.3268 |       0.4405 |          0.0100 |
% |       8 |          30 |       00:00:12 |       71.88% |       70.59% |       0.5208 |       0.4592 |          0.0100 |
% |       8 |          31 |       00:00:12 |       81.25% |       70.59% |       0.3832 |       0.4838 |          0.0100 |
% |       8 |          32 |       00:00:12 |       78.13% |       70.59% |       0.4431 |       0.5029 |          0.0100 |
% |       9 |          33 |       00:00:13 |       87.50% |       70.59% |       0.3322 |       0.4912 |          0.0100 |
% |       9 |          34 |       00:00:13 |       75.00% |       70.59% |       0.4727 |       0.4747 |          0.0100 |
% |       9 |          35 |       00:00:13 |       81.25% |       70.59% |       0.3773 |       0.4590 |          0.0100 |
% |       9 |          36 |       00:00:14 |       84.38% |       70.59% |       0.4281 |       0.4519 |          0.0100 |
% |      10 |          37 |       00:00:14 |       87.50% |       70.59% |       0.3093 |       0.4462 |          0.0100 |
% |      10 |          38 |       00:00:14 |       78.13% |       70.59% |       0.4411 |       0.4547 |          0.0100 |
% |      10 |          39 |       00:00:14 |       81.25% |       70.59% |       0.3550 |       0.4796 |          0.0100 |
% |      10 |          40 |       00:00:15 |       81.25% |       70.59% |       0.4127 |       0.4870 |          0.0100 |
% |      11 |          41 |       00:00:15 |       96.88% |       76.47% |       0.2572 |       0.4876 |          0.0100 |
% |      11 |          42 |       00:00:15 |       81.25% |       76.47% |       0.4030 |       0.4949 |          0.0100 |
% |      11 |          43 |       00:00:15 |       87.50% |       76.47% |       0.3172 |       0.5028 |          0.0100 |
% |      11 |          44 |       00:00:16 |       84.38% |       76.47% |       0.4061 |       0.4264 |          0.0100 |
% |      12 |          45 |       00:00:16 |       96.88% |       76.47% |       0.2266 |       0.3750 |          0.0100 |
% |      12 |          46 |       00:00:16 |       84.38% |       76.47% |       0.4062 |       0.3798 |          0.0100 |
% |      12 |          47 |       00:00:17 |       90.63% |       76.47% |       0.3028 |       0.4013 |          0.0100 |
% |      12 |          48 |       00:00:17 |       87.50% |       82.35% |       0.4028 |       0.4164 |          0.0100 |
% |      13 |          49 |       00:00:17 |       93.75% |       82.35% |       0.2430 |       0.4511 |          0.0100 |
% |      13 |          50 |       00:00:17 |       81.25% |       82.35% |       0.3617 |       0.4878 |          0.0100 |
% |      13 |          51 |       00:00:18 |       93.75% |       76.47% |       0.2871 |       0.5694 |          0.0100 |
% |      13 |          52 |       00:00:18 |       87.50% |       76.47% |       0.3685 |       0.5752 |          0.0100 |
% |      14 |          53 |       00:00:18 |       96.88% |       76.47% |       0.2246 |       0.5621 |          0.0100 |
% |      14 |          54 |       00:00:19 |       81.25% |       70.59% |       0.4027 |       0.6106 |          0.0100 |
% |      14 |          55 |       00:00:19 |       87.50% |       70.59% |       0.3013 |       0.6448 |          0.0100 |
% |      14 |          56 |       00:00:19 |       90.63% |       70.59% |       0.3420 |       0.6259 |          0.0100 |
% |      15 |          57 |       00:00:19 |       93.75% |       70.59% |       0.2110 |       0.6089 |          0.0100 |
% |      15 |          58 |       00:00:20 |       81.25% |       70.59% |       0.3419 |       0.6253 |          0.0100 |
% |      15 |          59 |       00:00:20 |       87.50% |       70.59% |       0.2846 |       0.6461 |          0.0100 |
% |      15 |          60 |       00:00:20 |       90.63% |       64.71% |       0.3348 |       0.6702 |          0.0100 |
% |      16 |          61 |       00:00:20 |       96.88% |       64.71% |       0.1817 |       0.7005 |          0.0100 |
% |      16 |          62 |       00:00:21 |       87.50% |       64.71% |       0.3094 |       0.6651 |          0.0100 |
% |      16 |          63 |       00:00:21 |       93.75% |       64.71% |       0.2543 |       0.6119 |          0.0100 |
% |      16 |          64 |       00:00:21 |       93.75% |       64.71% |       0.3133 |       0.5536 |          0.0100 |
% |      17 |          65 |       00:00:22 |       96.88% |       64.71% |       0.1467 |       0.5434 |          0.0100 |
% |      17 |          66 |       00:00:22 |       78.13% |       70.59% |       0.3218 |       0.5763 |          0.0100 |
% |      17 |          67 |       00:00:22 |       96.88% |       70.59% |       0.2165 |       0.6371 |          0.0100 |
% |      17 |          68 |       00:00:22 |       90.63% |       70.59% |       0.2971 |       0.6841 |          0.0100 |
% |      18 |          69 |       00:00:23 |       96.88% |       70.59% |       0.1148 |       0.7270 |          0.0100 |
% |      18 |          70 |       00:00:23 |       84.38% |       70.59% |       0.2876 |       0.7249 |          0.0100 |
% |      18 |          71 |       00:00:23 |       96.88% |       70.59% |       0.2079 |       0.7004 |          0.0100 |
% |      18 |          72 |       00:00:23 |       93.75% |       76.47% |       0.2647 |       0.6211 |          0.0100 |
% |      19 |          73 |       00:00:24 |       93.75% |       70.59% |       0.1689 |       0.5468 |          0.0100 |
% |      19 |          74 |       00:00:24 |       84.38% |       64.71% |       0.2637 |       0.5378 |          0.0100 |
% |      19 |          75 |       00:00:24 |       93.75% |       64.71% |       0.2352 |       0.5414 |          0.0100 |
% |      19 |          76 |       00:00:25 |       93.75% |       70.59% |       0.2357 |       0.5324 |          0.0100 |
% |      20 |          77 |       00:00:25 |      100.00% |       76.47% |       0.0998 |       0.5638 |          0.0100 |
% |      20 |          78 |       00:00:25 |       87.50% |       70.59% |       0.4168 |       0.6245 |          0.0100 |
% |      20 |          79 |       00:00:25 |       96.88% |       70.59% |       0.1817 |       0.6447 |          0.0100 |
% |      20 |          80 |       00:00:26 |       90.63% |       70.59% |       0.3097 |       0.6832 |          0.0100 |
% |      21 |          81 |       00:00:26 |      100.00% |       64.71% |       0.0644 |       0.7193 |          0.0100 |
% |      21 |          82 |       00:00:26 |       81.25% |       58.82% |       0.2535 |       0.6985 |          0.0100 |
% |      21 |          83 |       00:00:26 |       96.88% |       58.82% |       0.1674 |       0.6663 |          0.0100 |
% |      21 |          84 |       00:00:27 |       90.63% |       64.71% |       0.3210 |       0.6452 |          0.0100 |
% |      22 |          85 |       00:00:27 |       96.88% |       70.59% |       0.1701 |       0.5597 |          0.0100 |
% |      22 |          86 |       00:00:27 |       78.13% |       76.47% |       0.3783 |       0.5276 |          0.0100 |
% |      22 |          87 |       00:00:28 |       90.63% |       76.47% |       0.2655 |       0.6634 |          0.0100 |
% |      22 |          88 |       00:00:28 |       90.63% |       76.47% |       0.2728 |       0.7418 |          0.0100 |
% |      23 |          89 |       00:00:28 |       96.88% |       76.47% |       0.1007 |       0.7902 |          0.0100 |
% |      23 |          90 |       00:00:28 |       90.63% |       76.47% |       0.3005 |       0.7375 |          0.0100 |
% |      23 |          91 |       00:00:29 |       90.63% |       76.47% |       0.2451 |       0.6815 |          0.0100 |
% |      23 |          92 |       00:00:29 |       93.75% |       82.35% |       0.2246 |       0.6724 |          0.0100 |
% |      24 |          93 |       00:00:29 |      100.00% |       76.47% |       0.1166 |       0.7140 |          0.0100 |
% |      24 |          94 |       00:00:29 |       93.75% |       76.47% |       0.2326 |       0.7289 |          0.0100 |
% |      24 |          95 |       00:00:30 |       96.88% |       76.47% |       0.1578 |       0.6961 |          0.0100 |
% |      24 |          96 |       00:00:30 |       93.75% |       82.35% |       0.2273 |       0.6097 |          0.0100 |
% |      25 |          97 |       00:00:30 |      100.00% |       82.35% |       0.0769 |       0.5379 |          0.0100 |
% |      25 |          98 |       00:00:31 |       96.88% |       82.35% |       0.1612 |       0.4932 |          0.0100 |
% |      25 |          99 |       00:00:31 |       93.75% |       82.35% |       0.1721 |       0.4487 |          0.0100 |
% |      25 |         100 |       00:00:31 |       87.50% |       82.35% |       0.2322 |       0.4295 |          0.0100 |
% |      26 |         101 |       00:00:31 |      100.00% |       76.47% |       0.0575 |       0.4427 |          0.0100 |
% |      26 |         102 |       00:00:32 |       96.88% |       76.47% |       0.1402 |       0.4727 |          0.0100 |
% |      26 |         103 |       00:00:32 |       93.75% |       76.47% |       0.1411 |       0.5014 |          0.0100 |
% |      26 |         104 |       00:00:32 |       93.75% |       82.35% |       0.1785 |       0.5305 |          0.0100 |
% |      27 |         105 |       00:00:33 |       96.88% |       82.35% |       0.1287 |       0.5542 |          0.0100 |
% |      27 |         106 |       00:00:33 |       96.88% |       82.35% |       0.1328 |       0.5032 |          0.0100 |
% |      27 |         107 |       00:00:33 |       96.88% |       82.35% |       0.1122 |       0.4777 |          0.0100 |
% |      27 |         108 |       00:00:33 |       96.88% |       82.35% |       0.1538 |       0.4643 |          0.0100 |
% |      28 |         109 |       00:00:34 |      100.00% |       82.35% |       0.0701 |       0.4482 |          0.0100 |
% |      28 |         110 |       00:00:34 |       93.75% |       82.35% |       0.1458 |       0.4525 |          0.0100 |
% |      28 |         111 |       00:00:34 |       96.88% |       76.47% |       0.1267 |       0.5412 |          0.0100 |
% |      28 |         112 |       00:00:34 |       96.88% |       70.59% |       0.1333 |       0.6781 |          0.0100 |
% |      29 |         113 |       00:00:35 |      100.00% |       70.59% |       0.0666 |       0.7268 |          0.0100 |
% |      29 |         114 |       00:00:35 |       96.88% |       70.59% |       0.0906 |       0.7600 |          0.0100 |
% |      29 |         115 |       00:00:35 |       96.88% |       64.71% |       0.0962 |       0.7832 |          0.0100 |
% |      29 |         116 |       00:00:36 |       93.75% |       64.71% |       0.1653 |       0.8339 |          0.0100 |
% |      30 |         117 |       00:00:36 |      100.00% |       64.71% |       0.0458 |       0.8564 |          0.0100 |
% |      30 |         118 |       00:00:36 |       96.88% |       64.71% |       0.0968 |       0.8134 |          0.0100 |
% |      30 |         119 |       00:00:36 |       93.75% |       70.59% |       0.1336 |       0.7838 |          0.0100 |
% |      30 |         120 |       00:00:37 |       96.88% |       64.71% |       0.1080 |       0.8335 |          0.0100 |
% |      31 |         121 |       00:00:37 |      100.00% |       64.71% |       0.0392 |       0.9222 |          0.0100 |
% |      31 |         122 |       00:00:37 |       96.88% |       58.82% |       0.0834 |       0.9784 |          0.0100 |
% |      31 |         123 |       00:00:37 |       96.88% |       58.82% |       0.0881 |       1.0094 |          0.0100 |
% |      31 |         124 |       00:00:38 |       96.88% |       58.82% |       0.1101 |       1.0854 |          0.0100 |
% |      32 |         125 |       00:00:38 |      100.00% |       58.82% |       0.0330 |       1.2080 |          0.0100 |
% |      32 |         126 |       00:00:38 |      100.00% |       58.82% |       0.0541 |       1.2607 |          0.0100 |
% |      32 |         127 |       00:00:39 |       96.88% |       58.82% |       0.0713 |       1.2633 |          0.0100 |
% |      32 |         128 |       00:00:39 |       87.50% |       58.82% |       0.2646 |       1.3429 |          0.0100 |
% |      33 |         129 |       00:00:39 |      100.00% |       58.82% |       0.0233 |       1.3480 |          0.0100 |
% |      33 |         130 |       00:00:39 |       96.88% |       58.82% |       0.0776 |       1.3292 |          0.0100 |
% |      33 |         131 |       00:00:40 |       96.88% |       58.82% |       0.0796 |       1.3463 |          0.0100 |
% |      33 |         132 |       00:00:40 |       96.88% |       58.82% |       0.0858 |       1.3249 |          0.0100 |
% |      34 |         133 |       00:00:40 |      100.00% |       58.82% |       0.0277 |       1.2912 |          0.0100 |
% |      34 |         134 |       00:00:41 |      100.00% |       58.82% |       0.0497 |       1.2334 |          0.0100 |
% |      34 |         135 |       00:00:41 |       96.88% |       58.82% |       0.0604 |       1.1827 |          0.0100 |
% |      34 |         136 |       00:00:41 |       96.88% |       58.82% |       0.0997 |       1.1265 |          0.0100 |
% |      35 |         137 |       00:00:41 |      100.00% |       58.82% |       0.0105 |       1.0736 |          0.0100 |
% |      35 |         138 |       00:00:42 |      100.00% |       58.82% |       0.0448 |       1.0476 |          0.0100 |
% |      35 |         139 |       00:00:42 |       96.88% |       58.82% |       0.0521 |       1.0334 |          0.0100 |
% |      35 |         140 |       00:00:42 |       96.88% |       58.82% |       0.0791 |       1.0388 |          0.0100 |
% |      36 |         141 |       00:00:42 |      100.00% |       58.82% |       0.0086 |       1.0393 |          0.0100 |
% |      36 |         142 |       00:00:43 |      100.00% |       58.82% |       0.0338 |       1.0433 |          0.0100 |
% |      36 |         143 |       00:00:43 |      100.00% |       58.82% |       0.0448 |       1.0503 |          0.0100 |
% |      36 |         144 |       00:00:43 |       96.88% |       58.82% |       0.0649 |       1.0303 |          0.0100 |
% |      37 |         145 |       00:00:44 |      100.00% |       58.82% |       0.0108 |       0.9957 |          0.0100 |
% |      37 |         146 |       00:00:44 |      100.00% |       58.82% |       0.0289 |       0.9742 |          0.0100 |
% |      37 |         147 |       00:00:44 |      100.00% |       64.71% |       0.0383 |       0.9600 |          0.0100 |
% |      37 |         148 |       00:00:44 |       96.88% |       64.71% |       0.0515 |       0.9414 |          0.0100 |
% |      38 |         149 |       00:00:45 |      100.00% |       70.59% |       0.0060 |       0.9207 |          0.0100 |
% |      38 |         150 |       00:00:45 |      100.00% |       70.59% |       0.0262 |       0.8922 |          0.0100 |
% |      38 |         151 |       00:00:45 |      100.00% |       70.59% |       0.0330 |       0.8737 |          0.0100 |
% |      38 |         152 |       00:00:46 |       96.88% |       70.59% |       0.0412 |       0.8711 |          0.0100 |
% |      39 |         153 |       00:00:46 |      100.00% |       64.71% |       0.0047 |       0.8656 |          0.0100 |
% |      39 |         154 |       00:00:46 |      100.00% |       64.71% |       0.0283 |       0.8831 |          0.0100 |
% |      39 |         155 |       00:00:46 |      100.00% |       64.71% |       0.0208 |       0.8983 |          0.0100 |
% |      39 |         156 |       00:00:47 |      100.00% |       64.71% |       0.0281 |       0.9137 |          0.0100 |
% |      40 |         157 |       00:00:47 |      100.00% |       64.71% |       0.0042 |       0.9213 |          0.0100 |
% |      40 |         158 |       00:00:47 |      100.00% |       64.71% |       0.0210 |       0.9734 |          0.0100 |
% |      40 |         159 |       00:00:47 |       96.88% |       64.71% |       0.0330 |       1.1035 |          0.0100 |
% |      40 |         160 |       00:00:48 |      100.00% |       58.82% |       0.0263 |       1.2210 |          0.0100 |
% |      41 |         161 |       00:00:48 |      100.00% |       58.82% |       0.0046 |       1.2684 |          0.0100 |
% |      41 |         162 |       00:00:48 |      100.00% |       58.82% |       0.0183 |       1.2826 |          0.0100 |
% |      41 |         163 |       00:00:49 |      100.00% |       58.82% |       0.0160 |       1.2837 |          0.0100 |
% |      41 |         164 |       00:00:49 |      100.00% |       58.82% |       0.0379 |       1.2556 |          0.0100 |
% |      42 |         165 |       00:00:49 |      100.00% |       58.82% |       0.0043 |       1.1831 |          0.0100 |
% |      42 |         166 |       00:00:50 |       93.75% |       64.71% |       0.1759 |       1.1396 |          0.0100 |
% |      42 |         167 |       00:00:50 |       96.88% |       58.82% |       0.1922 |       1.1545 |          0.0100 |
% |      42 |         168 |       00:00:50 |       96.88% |       64.71% |       0.1513 |       1.2244 |          0.0100 |
% |      43 |         169 |       00:00:51 |      100.00% |       64.71% |       0.0090 |       1.2372 |          0.0100 |
% |      43 |         170 |       00:00:51 |      100.00% |       58.82% |       0.0178 |       1.3741 |          0.0100 |
% |      43 |         171 |       00:00:51 |      100.00% |       64.71% |       0.0208 |       1.2235 |          0.0100 |
% |      43 |         172 |       00:00:52 |       93.75% |       58.82% |       0.0686 |       1.3450 |          0.0100 |
% |      44 |         173 |       00:00:52 |      100.00% |       76.47% |       0.0180 |       1.1275 |          0.0100 |
% |      44 |         174 |       00:00:52 |      100.00% |       76.47% |       0.0113 |       1.0448 |          0.0100 |
% |      44 |         175 |       00:00:52 |      100.00% |       76.47% |       0.0212 |       0.9823 |          0.0100 |
% |      44 |         176 |       00:00:53 |       96.88% |       76.47% |       0.0566 |       0.9202 |          0.0100 |
% |      45 |         177 |       00:00:53 |      100.00% |       76.47% |       0.0120 |       0.9012 |          0.0100 |
% |      45 |         178 |       00:00:53 |       93.75% |       70.59% |       0.0854 |       0.9108 |          0.0100 |
% |      45 |         179 |       00:00:54 |      100.00% |       76.47% |       0.0263 |       0.8735 |          0.0100 |
% |      45 |         180 |       00:00:54 |       96.88% |       82.35% |       0.0757 |       0.7887 |          0.0100 |
% |      46 |         181 |       00:00:54 |      100.00% |       76.47% |       0.0095 |       0.7532 |          0.0100 |
% |      46 |         182 |       00:00:54 |       93.75% |       82.35% |       0.1667 |       0.8667 |          0.0100 |
% |      46 |         183 |       00:00:55 |       96.88% |       64.71% |       0.0306 |       1.1055 |          0.0100 |
% |      46 |         184 |       00:00:55 |       96.88% |       64.71% |       0.1147 |       1.2339 |          0.0100 |
% |      47 |         185 |       00:00:55 |      100.00% |       64.71% |       0.0070 |       1.3298 |          0.0100 |
% |      47 |         186 |       00:00:55 |      100.00% |       64.71% |       0.0348 |       1.2345 |          0.0100 |
% |      47 |         187 |       00:00:56 |      100.00% |       64.71% |       0.0162 |       1.1510 |          0.0100 |
% |      47 |         188 |       00:00:56 |      100.00% |       64.71% |       0.0355 |       1.1511 |          0.0100 |
% |      48 |         189 |       00:00:56 |       96.88% |       64.71% |       0.1134 |       1.5016 |          0.0100 |
% |      48 |         190 |       00:00:57 |      100.00% |       64.71% |       0.0397 |       1.5957 |          0.0100 |
% |      48 |         191 |       00:00:57 |      100.00% |       64.71% |       0.0141 |       1.6677 |          0.0100 |
% |      48 |         192 |       00:00:57 |       96.88% |       64.71% |       0.0733 |       1.5598 |          0.0100 |
% |      49 |         193 |       00:00:57 |      100.00% |       58.82% |       0.0116 |       1.4205 |          0.0100 |
% |      49 |         194 |       00:00:58 |      100.00% |       70.59% |       0.0154 |       1.2354 |          0.0100 |
% |      49 |         195 |       00:00:58 |      100.00% |       70.59% |       0.0283 |       1.1941 |          0.0100 |
% |      49 |         196 |       00:00:58 |      100.00% |       70.59% |       0.0436 |       1.1406 |          0.0100 |
% |      50 |         197 |       00:00:59 |      100.00% |       70.59% |       0.0089 |       1.0849 |          0.0100 |
% |      50 |         198 |       00:00:59 |       96.88% |       64.71% |       0.0806 |       1.2039 |          0.0100 |
% |      50 |         199 |       00:00:59 |      100.00% |       64.71% |       0.0248 |       1.3636 |          0.0100 |
% |      50 |         200 |       00:00:59 |      100.00% |       70.59% |       0.0243 |       1.4148 |          0.0100 |
% |======================================================================================================================|
% trainacc
% valacc
% testacc
% 
% trainacc =
% 
%    97.7941
% 
% 
% valacc =
% 
%    70.5882
% 
% 
% testacc =
% 
%    64.7059