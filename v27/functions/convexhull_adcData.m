
function [augmenteddata] = convexhull_adcData(adcdata,numberofaugmenteddata)
augmenteddata=zeros(size(adcdata,1),numberofaugmenteddata);
%CONVEXHULL Summary of this function goes here
%   Detailed explanation goes here

alpha=2;
    for i =1: numberofaugmenteddata
        randvectorall=randperm(size(adcdata,2));    
        display(num2str(i))
        lambda = betarnd(alpha,alpha);  
        firstindex=randvectorall(1);        
        secondindex=randvectorall(2);%remove the first data
        firstdata = adcdata(:,firstindex);
        seconddata = adcdata(:,secondindex);
        augmenteddata(:,i) = lambda*firstdata+(1-lambda)*seconddata;
    end

end

