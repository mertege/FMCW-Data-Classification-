%% load data
clear all;close all;clc
load('F:\oytun_Calisma\data\rangeDoppler_fast1_notaugmented.mat');
load('F:\oytun_Calisma\data\rangeDoppler_slow_notaugmented.mat');
load('F:\oytun_Calisma\data\rangeDoppler_slowwithpocket_notaugmented.mat');
rangeDopplersfast1 = rangeDopplersfast1(:,:,[1:49,51:57]); 
%% plot 
% k = 8;
% figure(1)
% imagesc((rangeDopplersfast1(:,:,k)))
% figure(2)
% imagesc((rangeDopplersslow(:,:,k)))
% figure(3)
% imagesc((rangeDopplers_slowwithpocket(:,:,k)))

%% labelling operation
range_doppler_fast_label = ones(size(rangeDopplersfast1,3),1);

range_doppler_slow_label = zeros(size(rangeDopplersslow,3),1);
range_doppler_slow_label(:) = 2;

range_doppler_pocket_label = ones(size(rangeDopplers_slowwithpocket,3),1);
range_doppler_pocket_label(:) = 3;

%% downscale
% range_doppler_fast_resized = zeros(250,250,size(rangeDopplersfast1,3));
% range_doppler_slow_resized = zeros(250,250,size(rangeDopplersslow,3));
% range_doppler_slow_pocket_resized = zeros(250,250,size(rangeDopplers_slowwithpocket,3));
% 
% for ii = 1:size(range_doppler_fast,3)
%     range_doppler_fast_resized(:,:,ii) = imresize(rangeDopplersfast1(:,:,ii),[250,250],'bicubic');
% end
% for ii = 1:size(range_doppler_slow,3)
%     range_doppler_slow_resized(:,:,ii) = imresize(rangeDopplersslow(:,:,ii),[250,250],'bicubic');
% end
% for ii = 1:size(range_doppler_slow_pocket,3)
%     range_doppler_slow_pocket_resized(:,:,ii) = imresize(rangeDopplers_slowwithpocket(:,:,ii),[250,250],'bicubic');
% end
%% downscale
range_doppler_fast_resized = zeros(52,5120,size(rangeDopplersfast1,3));
range_doppler_slow_resized = zeros(52,5120,size(rangeDopplersslow,3));
range_doppler_slow_pocket_resized = zeros(52,5120,size(rangeDopplers_slowwithpocket,3));

for ii = 1:size(range_doppler_fast_resized,3)
    range_doppler_fast_resized(:,:,ii) = imresize(rangeDopplersfast1(:,:,ii),0.1,'bicubic');
end
for ii = 1:size(range_doppler_slow_resized,3)
    range_doppler_slow_resized(:,:,ii) = imresize(rangeDopplersslow(:,:,ii),0.1,'bicubic');
end
for ii = 1:size(range_doppler_slow_pocket_resized,3)
    range_doppler_slow_pocket_resized(:,:,ii) = imresize(rangeDopplers_slowwithpocket(:,:,ii),0.1,'bicubic');
end
%% save data
% save('range_doppler_fast_resized.mat','range_doppler_fast_resized');
% save('range_doppler_slow_resized.mat','range_doppler_slow_resized');
% save('range_doppler_slow_pocket_resized.mat','range_doppler_slow_pocket_resized');

%%


doppler = linspace(-8000,8000,size(range_doppler_fast_resized,1));    
range=linspace(0,12,size(range_doppler_fast_resized,2));

k = 1;
figure(4)
imagesc(doppler,range,range_doppler_fast_resized(:,:,k))
xlabel('Doppler(Hz)');
ylabel('Range(m)');
set(gca,'YtickLabel',[12:-2:0]);
colorbar

figure(5)
imagesc(doppler,range,range_doppler_slow_resized(:,:,k))
xlabel('Doppler(Hz)');
ylabel('Range(m)');
set(gca,'YtickLabel',[12:-2:0]);
 colorbar
        

% figure(6)
% imagesc((range_doppler_slow_pocket_resized(:,:,k)))