clear all;
clc;
close all;

numOfSamples = 10;
numofSamples= 2621400;  %2621400; % samples;
a = rand(numofSamples,1) * 5; % create random 10 numbers
b = rand(numofSamples,1) * -8;% create random 10 numbers
complexvec = complex(a,b); % create random 10 complex numbers
numberofaugmenteddata=10000;

tic
[augmenteddata] = convexhull(complexvec,numberofaugmenteddata);
toc 

% 1 sample Elapsed time is 1.05 seconds.
% 2 sample Elapsed time is 1.23 seconds.
% 10 sample 1.69 sec
% 100 sample 2.79 sec
% 1000 sample 15.58 sec
% 10 000 sample  154.. sec
% 2 621 400 samples  approximately 154 *250  38500 seconds = 641.6667 min - 10 hour for
% each augmentation

