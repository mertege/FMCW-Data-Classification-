% add jitter augmentation to train data

% load oversampled and normalized data
load ('F:\oytun_Calisma\data\Traindatatwoclass_15features_16_10_2021_oversampled_normalized.mat')

variance = 0.02; % Variance of the gauissan noise
mean = 0;% mean of the gauissan noise
x=sqrt(variance).* randn(1,4225)+mean;
AugmentedData={}; % create empty cell
for i=1:length(TrainData)
    TrainDatatemp = cell2mat(TrainData(i));
    Augmentedtemp = TrainDatatemp+x; % add noise for each time step have different distribution
    AugmentedData{i,1} =num2cell(Augmentedtemp);

end

% combine cell arrays
OverallTrainData=[TrainData;AugmentedData];
OverallTrainY = [TrainY;TrainY];

% visualize augmented data on first feature
figure
plot(TrainDatatemp(1,1810:2010));
hold on
plot(Augmentedtemp(1,1810:2010));
legend('TrainData','AugmentedData(Jittered)')

save ('F:\oytun_Calisma\data\Traindatatwoclass_15features_23_10_2021_augmentedJitter_var_002.mat','OverallTrainData','ValData','TestData','OverallTrainY','ValY','TestY')
