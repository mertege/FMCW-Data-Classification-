%% load data
load('F:\oytun_Calisma\data\spectrograms1_new.mat');
load('F:\oytun_Calisma\data\spectrograms2_new.mat');
load('F:\oytun_Calisma\data\spectrograms3_new.mat');

spectrograms1 = spectrograms1(:,:,[1:49,51:57]); % remove 50th ?? 
%convert 
% k = 50;
% 
% figure(1)
% imagesc(10*log(abs(spectrograms1(:,:,k))))
% figure(2)
% imagesc(10*log(abs(spectrograms2(:,:,k))))
% figure(3)
% imagesc(10*log(abs(spectrograms3(:,:,k))))
% kk = 45;
% figure(4)
% imagesc(10*log(abs(spectrograms1(:,:,kk))))
% figure(5)
% imagesc(10*log(abs(spectrograms2(:,:,kk))))
% figure(6)
% imagesc(10*log(abs(spectrograms3(:,:,kk))))

%%
spectrogram_fast = zeros(size(spectrograms1));
spectrogram_fast_label = ones(size(spectrograms1,3),1);

spectrogram_slow = zeros(size(spectrograms2));
spectrogram_slow_label = ones(size(spectrograms2,3),1);
spectrogram_slow_label(:) = 2;

spectrogram_slow_pocket = zeros(size(spectrograms3));
spectrogram_slow_pocket_label = ones(size(spectrograms3,3),1);
spectrogram_slow_pocket_label(:) = 3;


for ii = 1:size(spectrograms1,3)
    spectrogram_fast(:,:,ii) = 10*log(abs(spectrograms1(:,:,ii)));
end

    
for ii = 1:size(spectrograms2,3)
    spectrogram_slow(:,:,ii) = 10*log(abs(spectrograms2(:,:,ii)));
end

for ii = 1:size(spectrograms3,3)
    spectrogram_slow_pocket(:,:,ii) = 10*log(abs(spectrograms3(:,:,ii)));
end



%% downscale 
% spectrogram_fast_resized = zeros(250,250,size(spectrogram_fast,3));
% spectrogram_slow_resized = zeros(250,250,size(spectrogram_slow,3));
% spectrogram_slow_pocket_resized = zeros(250,250,size(spectrogram_slow_pocket,3));
% 
% for ii = 1:size(spectrogram_fast,3)
%     spectrogram_fast_resized(:,:,ii) = imresize(spectrogram_fast(:,:,ii),[250,250],'bicubic');
% end
% for ii = 1:size(spectrogram_slow,3)
%     spectrogram_slow_resized(:,:,ii) = imresize(spectrogram_slow(:,:,ii),[250,250],'bicubic');
% end
% for ii = 1:size(spectrogram_slow_pocket,3)
%     spectrogram_slow_pocket_resized(:,:,ii) = imresize(spectrogram_slow_pocket(:,:,ii),[250,250],'bicubic');
% end
%% downscale 0.1
spectrogram_fast_resized = zeros(52,423,size(spectrogram_fast,3));
spectrogram_slow_resized = zeros(52,423,size(spectrogram_slow,3));
spectrogram_slow_pocket_resized = zeros(52,423,size(spectrogram_slow_pocket,3));

for ii = 1:size(spectrogram_fast,3)
    spectrogram_fast_resized(:,:,ii) = imresize(spectrogram_fast(:,:,ii),0.1,'bicubic');
end
for ii = 1:size(spectrogram_slow,3)
    spectrogram_slow_resized(:,:,ii) = imresize(spectrogram_slow(:,:,ii),0.1,'bicubic');
end
for ii = 1:size(spectrogram_slow_pocket,3)
    spectrogram_slow_pocket_resized(:,:,ii) = imresize(spectrogram_slow_pocket(:,:,ii),0.1,'bicubic');
end
%%
% k = 56;
% figure(4)
% imagesc((spectrogram_fast_resized(:,:,k)))
% figure(5)
% imagesc((spectrogram_slow_resized(:,:,k)))
% figure(6)
% imagesc((spectrogram_slow_pocket_resized(:,:,k)))


% spectrograms = cat(3,spectrogram_fast,spectrogram_slow);
% spectrograms_label = cat(1,spectrogram_fast_label,spectrogram_slow_label);
% idx = randperm(size(spectrograms,3));
% spectrograms_shuffled = spectrograms(:,:,idx);
% spectrograms_label_shuffled = spectrograms_label(idx);


