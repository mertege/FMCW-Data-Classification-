clear all;
clc;
close all;

numOfSamples = 10;
a = rand(2,1) * 5; % create random 10 numbers
b = rand(2,1) * -8;% create random 10 numbers
complexvec = complex(a,b); % create random 10 complex numbers
numberofaugmenteddata=5;

[augmenteddata] = convexhull(complexvec,numberofaugmenteddata);