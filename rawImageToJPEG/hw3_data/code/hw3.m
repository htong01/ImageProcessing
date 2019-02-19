%% load image
clear;
clc;
close all;

datapath = '../data/';
imgname = 'newyear';

I = imread([datapath imgname '.tif']);
K = im2double(I);                % convert unit16 to double
K = K /(max(K(:)) - min(K(:)));  % normalization
%% Demosaicking
figure(2)
rgb = demosaicking(K);
imshow(rgb)

% figure(3)
% J = demosaic(im2uint16(K),'rggb');
% imshow(J);
%% Color correction
figure(3)
correctedRGB = color_correction(rgb,datapath,imgname);
correctedRGB = real(correctedRGB);
% correctedRGB = imadjust(correctedRGB,stretchlim(correctedRGB),[]);
imshow(correctedRGB)

%% Gray World algorithm
figure(4)
RGB_white_out = grayworld(correctedRGB);
diff = 1 - max(RGB_white_out(:));
RGB_white_out = RGB_white_out + diff/2;

RGB = real(RGB_white_out);
RGB = imadjust(RGB,[0.05 0.95],[]);     
% RGB = imadjust(RGB,stretchlim(RGB),[]);
imshow(RGB)

%% color correction
Ref = imread([datapath imgname '.jpg']);
% imhist(RGB)
cc = imhistmatch(RGB,Ref);
cc = cc /(max(cc(:)) - min(cc(:)));
figure(5)
imshow(cc)
%% All the other thing
% HSV = rgb2hsv(RGB);
% % "20% more" saturation:
% HSV(:, :, 2) = HSV(:, :, 2) * 1.2;
% HSV(HSV > 1) = 1;  % Limit values
% RGB = hsv2rgb(HSV);
% figure(5)
% imshow(RGB)

% cc = RGB;
% figure(6)
% RGB = imadjust(cc,[0.1 0.9],[]);
% imshow(RGB)

% Sharping
b = imsharpen(cc,'Radius',1,'Amount',0.8);
figure(7)
imshow(b)

% Denoising

% bb = imnoise(b,'salt & pepper',0.02);
% imshow(bb,0.8     % show where the noise

Kmedian_R = medfilt2(b(:,:,1));
Kmedian_G = medfilt2(b(:,:,2));
Kmedian_B = medfilt2(b(:,:,3));
Kmedian = cat(3,Kmedian_R,Kmedian_G,Kmedian_B);
figure(8)
imshow(Kmedian)

%% 
imhist(RGB(:,:,1))
imhist(cc(:,:,1))
imhist(RGB(:,:,1));hold on 
imhist(cc(:,:,1))
figure(2)
imhist(RGB(:,:,2));hold on
imhist(cc(:,:,2))
figure(3)
imhist(RGB(:,:,3));hold on
imhist(cc(:,:,3))