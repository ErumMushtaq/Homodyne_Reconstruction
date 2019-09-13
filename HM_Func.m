function [image] = HM_Func(kspace, mask)


    [kx, ky] = size(kspace); 
%% Partial Fourier Sampling Reconstruction 
    mask = sum(mask,1);
    zf_size = sum(mask==0); % Size of zero-filled region    
    sym_ind = zf_size + 1: ky-zf_size;  %Index of Symmetric Region
    zf_ind = 1:zf_size;           %Index of Assymetric region, not including symetric region
    asym_ind = ky-zf_size+1:ky;

    %% Weighting Factor
    W = zeros(1,ky);
    W(asym_ind) = 2;
    % W( [sym_ind(1)-1 sym_ind sym_ind(end)+1] ) = 1;
    W( [sym_ind(1)-1 sym_ind sym_ind(end)+1] ) = linspace(0,2, length(sym_ind)+2);
    W = repmat(W, [kx, 1]);
    %% Phase
    kdata_lr = kspace; %Low-Res k-space data
    kdata_lr(:,[asym_ind zf_ind],:,:,:) = 0;
    Phi = exp(-1j*angle(ifft2c(kdata_lr))); %Phase of low-res image
    image = (Phi.*ifft2c(kspace.*W));    
% %% GRAPPA Sampling Reconstruction %%
% 

%  %% Find ACS (Symmetric) region Index
%  x = mask(1,:); % Pick any phase encode
%  f = find(diff([0,x,0]==1));  % find indeces of no difference (to find ACS) 
%  ACS_Start= f(diff(f)>1);  % ACS Start Index
%  [aa index] = find(diff(f)>1);
%  ACS_end = f(index+1)-1;  % ACS end Index
%  sym_ind = ACS_Start:1:ACS_end;  %Index of Symmetric Region
%  zf_Index = find(x==0);
%  %% Find A symmetric Region Index
%  zf_ind = 1:ACS_Start-1;           
%  asym_ind1 = ky-size(zf_ind,2)+1:ky;  %Index of Asymmetric region before ACS region
%  asym_ind2 = zf_ind;  %Index of Asymmetric region after ACS region
%  
% %% Weighting Function
%     W = zeros(1,ky);
%     W(asym_ind1) = 2;   % Weight 2 in asymmetric Region
%     W(asym_ind2) = 2;   % Weight 2 in asymmetric Region
%     W(zf_Index) = 0;    % Weight 0 in not acquired samples.
%     W([sym_ind]) = 1; % Weight 1 in ACS region %linspace(0,2, length(sym_ind)+2);
%     W = repmat(W, [kx, 1]);
% %     figure;imagesc(W)
%     kdata_lr = kspace; 
%     kdata_lr(:,[asym_ind2 asym_ind1]) = 0;   %Keep ACS region only (k-space) 
% %% Phase Correction
%     Phi = exp(-1j*angle(ifft2c(kdata_lr))); %Phase of low-res image
% %     image = (ifftnd(kspace.*W, [1 2], 1));
%     image = (Phi.*ifft2c(kspace.*W));  %Reconstruction
  
end