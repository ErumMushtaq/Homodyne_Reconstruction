%% Homodyne Reconstruction Demo
clear;
close all;
clc

%% single-channel T2-weighted data
% load 'T2_single_channel' % Image borrowed from package https://mr.usc.edu/download/loraks2/
% kspace = kData;  % K space
% [nvx nvy] = size(kspace);


%% single-channel Baseline Cardiac Image
load 'Cardiac_FS_Image' 
kspace = Cardiac_FS_image;
[nvx nvy] = size(kspace);

%% Homodyne Reconstruction
[im_zf im_recon Phi] = PF_homodyne(kspace, 20);


%% Reference Image
im_ref = ifft2c(kspace);
figure;
    subplot(3,3,1);
    imagesc(abs(im_ref.'));    
    display();
    title('Reference');
    
%% Zeros-filled Reconstruction
    subplot(3,3,2);
    imagesc(abs(im_zf.'));  % KN:  naming should be im_zf and im_ho rather than the other way around.. so that they are togetehr in the data browser
    display();
    title('Zero filled');   

%% Error of Zero-filled Reconstruction
    subplot(3,3,3);
    imagesc(abs((im_ref-im_zf).'));  % KN:  naming should be im_zf and im_ho rather than the other way around.. so that they are togetehr in the data browser
    display();
    title('Error'); 
    
%% Homodyne Recon  
    subplot(3,3,4);
    imagesc(abs(im_ref.'));    
    display();
    title('Reference');
    
    subplot(3,3,5);
    imagesc(abs(im_recon.'));  
    display();
    title('Homodyne');   

    subplot(3,3,6);
    imagesc(abs(im_recon - im_ref).'); 
    display();
    title('Error Homodyne');
    
%% POCS
im_recon = PF_pocs(kspace, 20);
  
    subplot(3,3,7);
    imagesc(abs(im_ref.'));    
    display();
    title('Reference');
    
    subplot(3,3,8);
    imagesc(abs(im_recon.'));  
    display();
    title('POCS');   

    subplot(3,3,9);
    imagesc(abs(im_recon - im_ref).'); 
    display();
    title('Error POCS');

