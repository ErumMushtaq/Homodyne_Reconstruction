function [im_zf im_recon Phi] = PF_homodyne(kspace, index)
[nvx nvy] = size(kspace);
%% Under sampling mask
mask =(zeros(nvx,nvy));
mask(:,1:1:index) = 0;
mask(:,index+1:1:nvy) = 1;
figure;subplot(1,3,1);imagesc(mask);display();


%% Undersample the fully Sampled Data
kspace_us = kspace.*mask;
im_zf = ifft2c(kspace_us);

%% Find indices
center = floor(nvy/2)+1;

%% Weighting Factor
W = zeros(1,nvy);
W(nvy-index+1:1:nvy) = 2; 
W(index+1:1:nvy-index) = 1;  %linspace(0,2, length(sym_ind)+2);
% W( [sym(1)-1 sym sym(end)+1] ) = linspace(0,2, length(sym)+2);
% subplot(1,3,2);plot(W); %display();
W = repmat(W, [nvx, 1]);


%% Phase
kdata_lr = kspace_us; %Low-Res k-space data
kdata_lr(:,[1:1:index nvy-index:1:nvy]) = 0;  % Kepp ACS region only    
Phi = exp(-1j*angle(ifft2c(kdata_lr))); %Phase of low-res image

%% Reconstruction
im_recon = ((ifft2c(kspace_us.*W)));   % Image reconstruction
subplot(1,3,3);imshow((Phi)); display;
end