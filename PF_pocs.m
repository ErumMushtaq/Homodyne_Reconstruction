function [im_reconp] = PF_pocs(kspace, index)
[nvx nvy] = size(kspace);
%% Under sampling mask
mask =(zeros(nvx,nvy));
mask(:,1:1:index) = 0;
mask(:,index+1:1:nvy) = 1;
% figure;subplot(1,3,1);imagesc(mask);display();


%% Undersample the fully Sampled Data
kspace_us = kspace.*mask;
im_zf = ifft2c(kspace_us);

%% Find indices
center = floor(nvy/2)+1;

 for iter =1:1:150
 %% Find Phase from ACS
kdata_lr = kspace_us; %Low-Res k-space data
kdata_lr(:,[1:1:index nvy-index:1:nvy]) = 0;  % Kepp ACS region only    
Phi = exp(1j*angle(ifft2c(kdata_lr))); %Phase of low-res image
im_reconp = (Phi.*abs(ifft2c(kspace_us)));
kspace_recon = fft2c(im_reconp);
kspace(:,1:1:index) = kspace_recon(:,1:1:index);  %% Keep under-sampled/zero-filled indeces data only
 end
 
%  
%  
%  
% %% GRAPPA Sampling Reconstruction
%  %% Find ACS (Symmetric) region Index
%  x = mask(1,:); % Pick any phase encode
%  f = find(diff([0,x,0]==1));
%  ACS_Start= f(diff(f)>1);  % ACS Start Index
%  [aa index] = find(diff(f)>1);
%  ACS_end = f(index+1)-1;  % ACS end Index
%  sym_ind = ACS_Start:1:ACS_end;  %Index of Symmetric Region
%  zf_Index = find(x==0);
%  %% Find A symmetric Region Index
%  zf_ind = 1:ACS_Start-1;           
%  asym_ind1 = ky-size(zf_ind,2)+1:ky;  %Index of Asymmetric region after ACS region
%  asym_ind2 = zf_ind;  %Index of Asymmetric region before ACS region
% 
%  for iter =1:1:50
%  %% Find Phase from ACS
%     kdata_lr = kspace; %Low-Res k-space data
%     kdata_lr(:,[asym_ind2 asym_ind1]) = 0; % Kepp ACS Region Only
%     Phi = exp(1j*angle(ifft2c(kdata_lr))); %Phase of low-res image
%     image = (Phi.*abs(ifft2c(kspace)));
%     Recon_Kspace = fft2c(image);
%     kspace(:,zf_Index) = Recon_Kspace(:,zf_Index);  %% Keep under-sampled/zero-filled indeces data only
%  end
end