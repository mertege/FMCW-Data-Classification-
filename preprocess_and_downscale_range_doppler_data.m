load('F:\oytun_Calisma\data\rangeDoppler_fast1_notaugmented.mat');
load('F:\oytun_Calisma\data\rangeDoppler_slow_notaugmented.mat');
load('F:\oytun_Calisma\data\rangeDoppler_slowwithpocket_notaugmented.mat');
rangeDopplersfast1 = rangeDopplersfast1(:,:,[1:49,51:57]); 

range_doppler_fast_label = ones(size(rangeDopplersfast1,3),1);

range_doppler_slow_label = zeros(size(rangeDopplersslow,3),1);
range_doppler_slow_label(:) = 2;

range_doppler_pocket_label = ones(size(rangeDopplers_slowwithpocket,3),1);
range_doppler_pocket_label(:) = 3;


range_doppler_fast_resized = zeros(250,250,size(rangeDopplersfast1,3));
range_doppler_slow_resized = zeros(250,250,size(rangeDopplersslow,3));
range_doppler_slow_pocket_resized = zeros(250,250,size(rangeDopplers_slowwithpocket,3));

for ii = 1:size(range_doppler_fast,3)
    range_doppler_fast_resized(:,:,ii) = imresize(rangeDopplersfast1(:,:,ii),[250,250],'bicubic');
end
for ii = 1:size(range_doppler_slow,3)
    range_doppler_slow_resized(:,:,ii) = imresize(rangeDopplersslow(:,:,ii),[250,250],'bicubic');
end
for ii = 1:size(range_doppler_slow_pocket,3)
    range_doppler_slow_pocket_resized(:,:,ii) = imresize(rangeDopplers_slowwithpocket(:,:,ii),[250,250],'bicubic');
end
