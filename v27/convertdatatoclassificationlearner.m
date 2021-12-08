clear all;


load('F:\oytun_Calisma\data\Traindatatwoclass_features_02_12_2021_newspectrogramsparfor');

% create table



% features=["f1";"f2";"f3";"f4";"f5","f6";"f7";"f8";"f9";"f10","f11","f12","f13"];
% featuresname=["f1";"f2"];
numberoffeatures=13;
for ii=1:length(XTrain)  
    data=cell2mat(XTrain(ii));
    for jj=1:numberoffeatures
        features(:,jj)=data(jj,:)';
    end
    
end
feature1= features(:,1);
feature2= features(:,2);
feature3= features(:,3);
feature4= features(:,4);
feature5= features(:,5);
feature6= features(:,6);
feature7= features(:,7);
feature8= features(:,8);
feature9= features(:,9);
feature10= features(:,10);
feature11= features(:,11);
feature12= features(:,12);
feature13= features(:,13);



% 
XTrain = table( feature1,feature2,feature3,feature4,feature5,feature6,feature7,feature8,feature9,feature10,feature11,feature12,feature13);


