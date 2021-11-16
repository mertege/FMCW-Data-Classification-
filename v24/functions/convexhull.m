function [augmenteddata] = convexhull(complexvec,numberofaugmenteddata)
augmenteddata=zeros(numberofaugmenteddata,1);
%CONVEXHULL Summary of this function goes here
%   Detailed explanation goes here
    parfor i =1: numberofaugmenteddata
        i
        lambda=rand;
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

