%% Homodyne Reconstruction Demo
clear;
close all;
clc

%% single-channel T2-weighted data
load 'T2_single_channel' % Image borrowed from package https://mr.usc.edu/download/loraks2/

% Display gold standard
figure;
imagesc([abs(ifft2c(kData))]);
% imagesc([abs(fftshift(ifft2(ifftshift(kspace)))),(angle(fftshift(ifft2(ifftshift(kspace))))+pi)/2/pi]);
axis equal;axis off;colormap(gray);
caxis([0,1]);
title('Gold Standard');
[nvx nvy] = size(kData);
%% Sampling Mask
ACS = 24;
R = 2;
center = floor(nvy/2)+1;
ACS_region = (-floor(ACS/2):ceil(ACS/2)-1)+center;  %center floor(nvy/2)+1
stop1 = -floor(ACS/2)+center-1; stop2 = ceil(ACS/2)-1+center;
mask =(zeros(nvx,nvy)); mask(:,1:R:stop1) = 1; mask(:,ACS_region) = 1; mask(:,stop2:R:96) = 1;
figure;imagesc(mask);colormap gray; axis off; axis square;

%% Check Complementary Sampling %% 
figure;plot(imag(fft2c(mask(1,:)))); title('Image (Wky) of sampling Mask');
%% Undersample the fully sampled data
kData1 = kData.*(mask);
%% Testing
figure;
Reference_im = ifft2c(kData);subplot(1,4,1);imagesc(abs(Reference_im));axis square;colormap gray;axis off;title('Fully Sampled Image');hold on;
ZF_im = ifft2c(kData1);subplot(1,4,2);imagesc(abs(ZF_im));axis square;colormap gray;axis off;title('Zero filled Reconstruction');hold on;
Recon_Im = HM_Func(kData1,mask);subplot(1,4,3);imagesc(abs(Recon_Im));axis square;colormap gray;axis off;title('Homodyne Reconstructed Image');
subplot(1,4,4);imagesc(abs(Reference_im-Recon_Im));axis off;axis square;colormap gray;title('Difference (Reference - Homodyne) Reconstructed Image');
