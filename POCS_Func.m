function [image] = POCS_Func(kspace, mask)

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
 asym_ind1 = ky-size(zf_ind,2)+1:ky;  %Index of Asymmetric region after ACS region
 asym_ind2 = zf_ind;  %Index of Asymmetric region before ACS region

 for iter =1:1:50
 %% Find Phase from ACS
    kdata_lr = kspace; %Low-Res k-space data
    kdata_lr(:,[asym_ind2 asym_ind1]) = 0; % Kepp ACS Region Only
    Phi = exp(1j*angle(ifft2c(kdata_lr))); %Phase of low-res image
    image = (Phi.*abs(ifft2c(kspace)));
    Recon_Kspace = fft2c(image);
    kspace(:,zf_Index) = Recon_Kspace(:,zf_Index);  %% Keep under-sampled/zero-filled indeces data only
 end
end