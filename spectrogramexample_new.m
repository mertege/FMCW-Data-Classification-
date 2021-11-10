
clear all;


%
fs = 1e3;
t = 0:1/fs:2;
y = chirp(t,0,1,150);

[s2,f2,t2,p2]= spectrogram(y,256,200,256,1000,'centered','yaxis'); % Display the spectrogram

% [s2,f2,t2,p2] = (x,256,250,256,fs,'yaxis','centered');
subplot(1,2,1);
surf(t2, f2, 10*log10(abs(s2)), 'EdgeColor', 'none');
axis xy;
axis tight;
% colormap(jet);
view(0,90);
xlabel('Time (secs)');
colorbar;
ylabel('Frequency(HZ)');
title('Spectrogram');




%   EXAMPLE 6: Compute a complex-valued linear chirp
t = 0:0.001:2;                    % 2 s at 1 kHz sample rate
fo = 0;                         % Start at -50 Hz,
t1 = 1;
f1 = 150;                         % cross 200 Hz at t = 1 s
y= chirp(t,fo,t1,f1,'complex');
[s2,f2,t2,p2]= spectrogram(y,256,200,256,1000,'centered','yaxis'); % Display the spectrogram

subplot(1,2,2);

% [s2,f2,t2,p2] = spectrogram(x,256,250,256,fs,'yaxis','centered');
surf(t2, f2, 10*log10(abs(s2)), 'EdgeColor', 'none');
axis xy;
axis tight;
% colormap(jet);
view(0,90);
xlabel('Time (secs)');
colorbar;
ylabel('Frequency(HZ)');
title('Spectrogram Complex');
