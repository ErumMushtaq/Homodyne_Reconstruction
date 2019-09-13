close all; clear all;
%% Parameters
ACS = 24; % Number of ACS lines
R = 2;  % Acceleration factor outside ACS region
data_folder = '/Users/erummushtaq/Implementation/New_Testing/llu_data'; % Provide the directory of Wesley's data.
%% First Track the folder of Wesley/any other Dataset
fullfile(data_folder, 'asl*');
folder_info = dir(fullfile(data_folder, 'asl*'));
data_name = {folder_info(1:length(folder_info)).name}; % Subject File name
numData = length(data_name);
%% Track each subject separately
for iData = 1:numData

%% For each Patient's Data rest/stress
 name = char(data_name(iData));
 data_directory = (fullfile(data_folder, name));
 %% If stress
 data_filename = 'stress';
%% Define the full path to a Pfile
pfilePath = fullfile(data_directory, data_filename)

%% Load Pfile
pfile  = GERecon('Pfile.Load', pfilePath);
header = GERecon('Pfile.Header', pfile)

%% Extract Parameters
nvx = pfile.xRes;
nvy = pfile.yRes;
nt  = pfile.slices;
nc  = pfile.channels;
%% Load k-space data
for t = 1:nt
    for c = 1:nc
        DATA(:,:,t,c) = GERecon('Pfile.KSpace', t, 1, c);
    end
end
%% Image Reconstruction
kspace(:,:,:,:) = permute(DATA(:, :, :, :), [1 2 4 3]);
fully_sampled_baseline = kspace(:,:,:,1);
%% Sampling Mask
center = floor(nvy/2)+1;
ACS_region = (-floor(ACS/2):ceil(ACS/2)-1)+center;  %center floor(nvy/2)+1
stop1 = -floor(ACS/2)+center-1; stop2 = ceil(ACS/2)-1+center;
mask =(zeros(nvx,nvy)); mask(:,1:R:stop1) = 1; mask(:,ACS_region) = 1; mask(:,stop2:R:96) = 1;
imagesc(mask);colormap gray; axis off; axis square;
%% Undersample the fully sampled data
kspace1 = kspace.*repmat(mask, [1 1 nc nt]);
kspace1(:,:,:,1) = fully_sampled_baseline;   %% Under-Sample data

%% Testing
Reference_im = ifft2c(kspace(:,:,3,3));subplot(1,4,1);imagesc(abs(Reference_im.'));axis square;colormap gray;axis off;title('Fully Sampled Image');hold on;
ZF_im = ifft2c(kspace1(:,:,3,3));subplot(1,4,2);imagesc(abs(ZF_im.'));axis square;colormap gray;axis off;title('Zero filled Reconstruction');hold on;
Recon_Im = HM_Func(kspace1(:,:,3,3),mask);subplot(1,4,3);imagesc(abs(Recon_Im.'));axis square;colormap gray;axis off;title('Homodyne Reconstructed Image');
subplot(1,4,4);imagesc(abs(Reference_im-Recon_Im).');axis off;axis square;colormap gray;title('Difference (Reference - Homodyne) Reconstructed Image');

%% Reconstruction of all the images (96x96x8x14)
for idy=1:1:nc  %% Track ALl coil images
    for idx = 1:nt   %% ALl slices nt =14 (Baseline, noise, Control and Tagged images)
    if idx ~= 1 || idx ~= 2            
    Data_G = (kspace1(:,:,idy,idx));                % nvx x nvy x nc 
    Rec_Hom(:,:,idy,idx) = HM_Func(Data_G, mask);   % Homodyne Reconstruction
    end
    if idx == 1 || idx == 2     %% First or second image are not under-sampled 
          Rec_Hom(:,:,idy,idx) = ifft2c(kspace1(:,:,idy,idx));
          Rec_Hom(:,:,idy,idx) = ifft2c(kspace1(:,:,idy,idx));
    end
    end
end

cmaps = senseMap(Rec_Hom(:,:,:,1), 7);  %Estimate coil sensitivity maps from the reconstructed Images
for idx=1:nt
         ImgR(:,:,idx) = senseR1(Rec_Hom(:,:,:,idx), cmaps, eye(nc));  % Coil Combination
end
figure;imagesc(abs(ImgR(:,:,3))); axis off;axis square;colormap gray;title('Coil Combined Image');
end


