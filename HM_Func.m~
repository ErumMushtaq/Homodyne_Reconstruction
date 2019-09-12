function [image] = HM_Func(kspace, mask)

 [kx, ky] = size(kspace);
 %% Find ACS (Symmetric) region Index
 x = mask(1,:); % Pick any phase encode
 f = find(diff([0,x,0]==1));
 ACS_Start= f(diff(f)>1);  % ACS Start Index
 [aa index] = find(diff(f)>1);
 ACS_end = f(index+1)-1;  % ACS end Index
 sym_ind = ACS_Start:1:ACS_end;  %Index of Symmetric Region
 zf_Index = find(x==0);
 %% Find A symmetric Region Index
 zf_ind = 1:ACS_Start-1;           
 asym_ind1 = ky-size(zf_ind,2)+1:ky;  %Index of Asymmetric region before ACS region
 asym_ind2 = zf_ind;  %Index of Asymmetric region after ACS region
 
%% Weighting Function
    W = zeros(1,ky);
    W(asym_ind1) = 2;
    W(asym_ind2) = 2;
    W(zf_Index) = 0;
    W([sym_ind(1)-1 sym_ind sym_ind(end)+1]) = 1; %linspace(0,2, length(sym_ind)+2);
    W = repmat(W, [kx, 1]);
%     figure;imagesc(W)
    kdata_lr = kspace; %Low-Res k-space data
    kdata_lr(:,[asym_ind2 asym_ind1]) = 0;
%% Phase Correction
    Phi = exp(-1j*angle(ifft2c(kdata_lr))); %Phase of low-res image
%     image = (ifftnd(kspace.*W, [1 2], 1));
    image = (Phi.*ifft2c(kspace.*W));
end