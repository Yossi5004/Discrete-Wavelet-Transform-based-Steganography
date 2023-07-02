% Optimized Discrete Wavelet Transform based Steganography
% Yosef Cohen

%%%%%%%%%%%%% Procedure for embedding using single level wavelet decomposition %%%%%%%%%%%%%

% Importing cover and embedded images.
[name, path, ~] = uigetfile('*.jpg;*jpeg;*.png;*.tiff;*.gif','Choose a cover image');
cover_im = imread(strcat(path, name));
[name, path, ~] = uigetfile('*.jpg;*jpeg;*.png;*.tiff;*.gif','Choose a secret image');
secret_im = imread(strcat(path, name));
figure; subplot(2,2,1), imshow(cover_im);
title('Cover Image');
subplot(2,2,2), imshow(secret_im);
title('secret Image');

%Match the size of the images.
[row_cover,col_cover,layers_cov] = size(cover_im);
[row_secret,col_secret,layers__secret] = size(secret_im);
if row_cover > row_secret
    secret_im = padarray(secret_im,(row_cover-row_secret),0, 'post');
elseif row_secret > row_cover
    cover_im  = padarray(cover_im ,(row_secret-row_cover),0, 'post');
end

if col_cover > col_secret
    secret_im = padarray(secret_im,[0 (col_cover-col_secret)],0, 'post');
elseif col_secret > col_cover
    cover_im = padarray(cover_im,[0 (col_secret-col_cover)],0, 'post');
end

% Split the cover and secret images to RGB channels.
[R_ch_cover , G_ch_cover , B_ch_cover] = imsplit(cover_im);
[R_ch_secret , G_ch_secret , B_ch_secret] = imsplit(secret_im);

% Performing single level 2D DWT decomposition for each channel of the cover and secret images.
wavelet_func = 'db1';
[cA_R_cover,cH_R_cover,cV_R_cover,cD_R_cover] = dwt2(R_ch_cover,wavelet_func);
[cA_G_cover,cH_G_cover,cV_G_cover,cD_G_cover] = dwt2(G_ch_cover,wavelet_func);
[cA_B_cover,cH_B_cover,cV_B_cover,cD_B_cover] = dwt2(B_ch_cover,wavelet_func);
[cA_R_secret,cH_R_secret,cV_R_secret,cD_R_secret] = dwt2(R_ch_secret,wavelet_func);
[cA_G_secret,cH_G_secret,cV_G_secret,cD_G_secret] = dwt2(G_ch_secret,wavelet_func);
[cA_B_secret,cH_B_secret,cV_B_secret,cD_B_secret] = dwt2(B_ch_secret,wavelet_func);

% Assume a - the embedding co-efficient of value ranging from 0 to 1, large increase in robustness, small increase in transparency.
a = 0.04;

% Finding the co-efficient of the embedded image
cA_R_embedded = (1-a)*cA_R_cover + a*cA_R_secret;
cH_R_embedded = (1-a)*cH_R_cover + a*cH_R_secret;
cV_R_embedded = (1-a)*cV_R_cover + a*cV_R_secret;
cD_R_embedded = (1-a)*cD_R_cover + a*cD_R_secret;

cA_G_embedded = (1-a)*cA_G_cover + a*cA_G_secret;
cH_G_embedded = (1-a)*cH_G_cover + a*cH_G_secret;
cV_G_embedded = (1-a)*cV_G_cover + a*cV_G_secret;
cD_G_embedded = (1-a)*cD_G_cover + a*cD_G_secret;

cA_B_embedded = (1-a)*cA_B_cover + a*cA_B_secret;
cH_B_embedded = (1-a)*cH_B_cover + a*cH_B_secret;
cV_B_embedded = (1-a)*cV_B_cover + a*cV_B_secret;
cD_B_embedded = (1-a)*cD_B_cover + a*cD_B_secret;

% Perform single level 2D- Daubechies inverse DWT decomposition
R_ch_embedded_double = idwt2(cA_R_embedded,cH_R_embedded,cV_R_embedded,cD_R_embedded,wavelet_func);
G_ch_embedded_double = idwt2(cA_G_embedded,cH_G_embedded,cV_G_embedded,cD_G_embedded,wavelet_func);
B_ch_embedded_double = idwt2(cA_B_embedded,cH_B_embedded,cV_B_embedded,cD_B_embedded,wavelet_func);

R_ch_embedded = uint8(R_ch_embedded_double); 
G_ch_embedded = uint8(G_ch_embedded_double);
B_ch_embedded = uint8(B_ch_embedded_double);

%Concatenate Red (R), Green (G) plane and Blue (B) plane to get the embedded image
embedded_im = cat(3,R_ch_embedded,G_ch_embedded,B_ch_embedded);
embedded_im_double = cat(3,R_ch_embedded_double,G_ch_embedded_double,B_ch_embedded_double);

subplot(2,2,[3 4]), imshow(embedded_im);
title('Embedde Image');

% Save the embedded image
imwrite(embedded_im,'embedded_im.tif');


%%%%%%%%%%%%% Procedure for extracting using single level wavelet decomposition %%%%%%%%%%%%%

cover_im_ex = cover_im;
embedded_im_ex =embedded_im_double;

% Split the cover and embedded images to RGB channels.
[R_ch_cover_ex , G_ch_cover_ex , B_ch_cover_ex] = imsplit(cover_im_ex);
[R_ch_embedded_ex , G_ch_embedded_ex , B_ch_embedded_ex] = imsplit(embedded_im_ex);

% Performing single level 2D DWT decomposition for each channel of the cover and embedded images.
wavelet_func_ex = 'db1';
[cA_R_cover_ex,cH_R_cover_ex,cV_R_cover_ex,cD_R_cover_ex] = dwt2(R_ch_cover_ex,wavelet_func_ex);
[cA_G_cover_ex,cH_G_cover_ex,cV_G_cover_ex,cD_G_cover_ex] = dwt2(G_ch_cover_ex,wavelet_func_ex);
[cA_B_cover_ex,cH_B_cover_ex,cV_B_cover_ex,cD_B_cover_ex] = dwt2(B_ch_cover_ex,wavelet_func_ex);

[cA_R_embedded_ex,cH_R_embedded_ex,cV_R_embedded_ex,cD_R_embedded_ex] = dwt2(R_ch_embedded_ex,wavelet_func_ex);
[cA_G_embedded_ex,cH_G_embedded_ex,cV_G_embedded_ex,cD_G_embedded_ex] = dwt2(G_ch_embedded_ex,wavelet_func_ex);
[cA_B_embedded_ex,cH_B_embedded_ex,cV_B_embedded_ex,cD_B_embedded_ex] = dwt2(B_ch_embedded_ex,wavelet_func_ex);

%  Match the size of the matrixes.
[row_cover_ex,col_cover_ex] = size(cA_R_cover_ex);
[row_embedded_ex,col_embedded_ex] = size(cA_R_embedded_ex);
if row_cover_ex > row_embedded_ex
    cA_R_embedded_ex = padarray(cA_R_embedded_ex,(row_cover_ex-row_embedded_ex),0, 'post');
    cH_R_embedded_ex = padarray(cH_R_embedded_ex,(row_cover_ex-row_embedded_ex),0, 'post');
    cV_R_embedded_ex = padarray(cV_R_embedded_ex,(row_cover_ex-row_embedded_ex),0, 'post');
    cD_R_embedded_ex = padarray(cD_R_embedded_ex,(row_cover_ex-row_embedded_ex),0, 'post');
    cA_G_embedded_ex = padarray(cA_G_embedded_ex,(row_cover_ex-row_embedded_ex),0, 'post');
    cH_G_embedded_ex = padarray(cH_G_embedded_ex,(row_cover_ex-row_embedded_ex),0, 'post');
    cV_G_embedded_ex = padarray(cV_G_embedded_ex,(row_cover_ex-row_embedded_ex),0, 'post');
    cD_G_embedded_ex = padarray(cD_G_embedded_ex,(row_cover_ex-row_embedded_ex),0, 'post');
    cA_B_embedded_ex = padarray(cA_B_embedded_ex,(row_cover_ex-row_embedded_ex),0, 'post');
    cH_B_embedded_ex = padarray(cH_B_embedded_ex,(row_cover_ex-row_embedded_ex),0, 'post');
    cV_B_embedded_ex = padarray(cV_B_embedded_ex,(row_cover_ex-row_embedded_ex),0, 'post');
    cD_B_embedded_ex = padarray(cD_B_embedded_ex,(row_cover_ex-row_embedded_ex),0, 'post');
elseif row_embedded_ex > row_cover_ex
    cA_R_cover_ex = padarray(cA_R_cover_ex,(row_embedded_ex-row_cover_ex),0, 'post');
    cH_R_cover_ex = padarray(cH_R_cover_ex,(row_embedded_ex-row_cover_ex),0, 'post');
    cV_R_cover_ex = padarray(cV_R_cover_ex,(row_embedded_ex-row_cover_ex),0, 'post');
    cD_R_cover_ex = padarray(cD_R_cover_ex,(row_embedded_ex-row_cover_ex),0, 'post');
    cA_G_cover_ex = padarray(cA_G_cover_ex,(row_embedded_ex-row_cover_ex),0, 'post');
    cH_G_cover_ex = padarray(cH_G_cover_ex,(row_embedded_ex-row_cover_ex),0, 'post');
    cV_G_cover_ex = padarray(cV_G_cover_ex,(row_embedded_ex-row_cover_ex),0, 'post');
    cD_G_cover_ex = padarray(cD_G_cover_ex,(row_embedded_ex-row_cover_ex),0, 'post');
    cA_B_cover_ex = padarray(cA_B_cover_ex,(row_embedded_ex-row_cover_ex),0, 'post');
    cH_B_cover_ex = padarray(cH_B_cover_ex,(row_embedded_ex-row_cover_ex),0, 'post');
    cV_B_cover_ex = padarray(cV_B_cover_ex,(row_embedded_ex-row_cover_ex),0, 'post');
    cD_B_cover_ex = padarray(cD_B_cover_ex,(row_embedded_ex-row_cover_ex),0, 'post');
end

if col_cover_ex > col_embedded_ex
    cA_R_embedded_ex = padarray(cA_R_embedded_ex,[0 (col_cover_ex-col_embedded_ex)],0, 'post');
    cH_R_embedded_ex = padarray(cH_R_embedded_ex,[0 (col_cover_ex-col_embedded_ex)],0, 'post');
    cV_R_embedded_ex = padarray(cV_R_embedded_ex,[0 (col_cover_ex-col_embedded_ex)],0, 'post');
    cD_R_embedded_ex = padarray(cD_R_embedded_ex,[0 (col_cover_ex-col_embedded_ex)],0, 'post');
    cA_G_embedded_ex = padarray(cA_G_embedded_ex,[0 (col_cover_ex-col_embedded_ex)],0, 'post');
    cH_G_embedded_ex = padarray(cH_G_embedded_ex,[0 (col_cover_ex-col_embedded_ex)],0, 'post');
    cV_G_embedded_ex = padarray(cV_G_embedded_ex,[0 (col_cover_ex-col_embedded_ex)],0, 'post');
    cD_G_embedded_ex = padarray(cD_G_embedded_ex,[0 (col_cover_ex-col_embedded_ex)],0, 'post');
    cA_B_embedded_ex = padarray(cA_B_embedded_ex,[0 (col_cover_ex-col_embedded_ex)],0, 'post');
    cH_B_embedded_ex = padarray(cH_B_embedded_ex,[0 (col_cover_ex-col_embedded_ex)],0, 'post');
    cV_B_embedded_ex = padarray(cV_B_embedded_ex,[0 (col_cover_ex-col_embedded_ex)],0, 'post');
    cD_B_embedded_ex = padarray(cD_B_embedded_ex,[0 (col_cover_ex-col_embedded_ex)],0, 'post');
elseif col_embedded_ex > col_cover_ex
    cA_R_cover_ex = padarray(cA_R_cover_ex,[0 (col_embedded_ex-col_cover_ex)],0, 'post');
    cH_R_cover_ex = padarray(cH_R_cover_ex,[0 (col_embedded_ex-col_cover_ex)],0, 'post');
    cV_R_cover_ex = padarray(cV_R_cover_ex,[0 (col_embedded_ex-col_cover_ex)],0, 'post');
    cD_R_cover_ex = padarray(cD_R_cover_ex,[0 (col_embedded_ex-col_cover_ex)],0, 'post');
    cA_G_cover_ex = padarray(cA_G_cover_ex,[0 (col_embedded_ex-col_cover_ex)],0, 'post');
    cH_G_cover_ex = padarray(cH_G_cover_ex,[0 (col_embedded_ex-col_cover_ex)],0, 'post');
    cV_G_cover_ex = padarray(cV_G_cover_ex,[0 (col_embedded_ex-col_cover_ex)],0, 'post');
    cD_G_cover_ex = padarray(cD_G_cover_ex,[0 (col_embedded_ex-col_cover_ex)],0, 'post');
    cA_B_cover_ex = padarray(cA_B_cover_ex,[0 (col_embedded_ex-col_cover_ex)],0, 'post');
    cH_B_cover_ex = padarray(cH_B_cover_ex,[0 (col_embedded_ex-col_cover_ex)],0, 'post');
    cV_B_cover_ex = padarray(cV_B_cover_ex,[0 (col_embedded_ex-col_cover_ex)],0, 'post');
    cD_B_cover_ex = padarray(cD_B_cover_ex,[0 (col_embedded_ex-col_cover_ex)],0, 'post');
end

% Finding the co-efficient of the stego image
cA_R_secret_ex = (cA_R_embedded_ex-(1-a)*cA_R_cover_ex)/a;
cH_R_secret_ex = (cH_R_embedded_ex-(1-a)*cH_R_cover_ex)/a;
cV_R_secret_ex = (cV_R_embedded_ex-(1-a)*cV_R_cover_ex)/a;
cD_R_secret_ex = (cD_R_embedded_ex-(1-a)*cD_R_cover_ex)/a;

cA_G_secret_ex = (cA_G_embedded_ex-(1-a)*cA_G_cover_ex)/a;
cH_G_secret_ex = (cH_G_embedded_ex-(1-a)*cH_G_cover_ex)/a;
cV_G_secret_ex = (cV_G_embedded_ex-(1-a)*cV_G_cover_ex)/a;
cD_G_secret_ex = (cD_G_embedded_ex-(1-a)*cD_G_cover_ex)/a;

cA_B_secret_ex = (cA_B_embedded_ex-(1-a)*cA_B_cover_ex)/a;
cH_B_secret_ex = (cH_B_embedded_ex-(1-a)*cH_B_cover_ex)/a;
cV_B_secret_ex = (cV_B_embedded_ex-(1-a)*cV_B_cover_ex)/a;
cD_B_secret_ex = (cD_B_embedded_ex-(1-a)*cD_B_cover_ex)/a;

% Perform single level 2D- Daubechies inverse DWT decomposition
R_ch_secret_ex = idwt2(cA_R_secret_ex,cH_R_secret_ex,cV_R_secret_ex,cD_R_secret_ex,wavelet_func_ex);
G_ch_secret_ex = idwt2(cA_G_secret_ex,cH_G_secret_ex,cV_G_secret_ex,cD_G_secret_ex,wavelet_func_ex);
B_ch_secret_ex = idwt2(cA_B_secret_ex,cH_B_secret_ex,cV_B_secret_ex,cD_B_secret_ex,wavelet_func_ex);

R_ch_secret_ex = uint8(R_ch_secret_ex);
G_ch_secret_ex = uint8(G_ch_secret_ex);
B_ch_secret_ex = uint8(B_ch_secret_ex);

%Concatenate Red (R), Green (G) plane and Blue (B) plane to get the embedded image
secret_im_ex = cat(3,R_ch_secret_ex,G_ch_secret_ex,B_ch_secret_ex);

% Detecting the corner of the secret image for cropping it.
    secret_im_ex = padarray(secret_im_ex,[100 100],0, 'post');
    t = rgb2gray(secret_im_ex);
    corners = detectHarrisFeatures(t);
    c =ceil(corners.Location(end,end-1));
    r =ceil(corners.Location(end,end));
    secret_im_ex = secret_im_ex(1:r,1:c,:);

figure; imshow(secret_im_ex);
title('The Extracted secret Image');
