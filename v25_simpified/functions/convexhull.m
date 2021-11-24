function [augmenteddata] = convexhull(complexvec,numberofaugmenteddata)
augmenteddata=zeros(numberofaugmenteddata,1);
%CONVEXHULL Summary of this function goes here
%   Detailed explanation goes here
alpha=2;
    parfor i =1: numberofaugmenteddata
        display(num2str(i))
        lambda = betarnd(alpha,alpha);
        tempvec = complexvec;
        lengthofcomplexnumbers = length(tempvec);
        firstindex=randi(lengthofcomplexnumbers);
        firstdata = tempvec(firstindex);
        tempvec(firstindex)=[]; %remove the first data
        secondindex=randi(lengthofcomplexnumbers-1);%remove the first data
        seconddata= tempvec(secondindex);
        augmenteddata(i,1) = lambda*firstdata+(1-lambda)*seconddata;
    end

end

