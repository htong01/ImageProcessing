
% %% Example to load metadata provided by the camera
% metafile = [datapath imgname '.csv'];
% metadata = load_metadata(metafile);
% iso = metadata_value(metadata, 'ISO');

%% load image
clear;
clc;

datapath = '../data/';
imgname = 'yosemite';

I = imread([datapath imgname '.tif']);
n = size(I, 2);
m = size(I, 1);
K = im2double(I);                % convert unit16 to double
K = K /(max(K(:)) - min(K(:)));  % normalization
% imshow(K);

%% Black-level and white-level correction
% Max = max(K(:));
% Min = min(K(:));
% range_h = 0.9;
% range_l = 0.1;
% for i = 1:m
%     for j = 1:n
%         value = (K(i,j) - Min) / (Max - Min);
%         
%         if value > range_h
%             K(i,j) = range_h;
%         elseif value < range_l
%             K(i,j) = range_l;
%         else
%             K(i,j) = value;
%         end
%     end
% end
% 
K = imadjust(K,[0.05 0.95],[]);
imshow(K)

%% Demosaicking
R = zeros(m,n);
G = zeros(m,n);
B = zeros(m,n);
bits = 12;
bitrange = 2^bits;
% seperate each channel according to the CFA pattern
for i = 1:m
    for j = 1:n
        if mod(i,2) == 0 && mod(j,2) == 1 %G
            G(i,j) = K(i,j)/bitrange;
        elseif mod(i,2) == 1 && mod(j,2) == 0
            G(i,j) = K(i,j)/bitrange;
        elseif mod(i,2) == 1 %R
            R(i,j) = K(i,j)/bitrange;
        else %B
            B(i,j) = K(i,j)/bitrange;
        end
    end
end

% blue at red pixels
B1 = imfilter(B,[1 0 1; 0 0 0; 1 0 1]/4);
% blue at green pixels
B2 = imfilter(B+B1,[0 1 0; 1 0 1; 0 1 0]/4);
B = B + B1 + B2;
% red at blue pixels
R1 = imfilter(R,[1 0 1; 0 0 0; 1 0 1]/4);
% red at green pixels   
R2 = imfilter(R+R1,[0 1 0; 1 0 1; 0 1 0]/4);
R = R + R1 + R2;
% interpolate for green
G= G + imfilter(G, [0 1 0; 1 0 1; 0 1 0]/4);

% use freeman method to improve the interpolation result
R = G + medfilt2(R - G);
B = G + medfilt2(B - G);

figure(4)
rgb = cat(3, R, G, B);
rgb = rgb /(max(rgb(:)) - min(rgb(:)));
imshow(rgb);
%% Color correction
% A_lin = rgb2lin(Image);
% % Estimate illuminant using principal component analysis (PCA)
% illuminant = illumpca(A_lin);
% B_lin = chromadapt(A_lin,illuminant,'ColorSpace','linear-rgb');
% B = lin2rgb(B_lin);
% imshow(B)
%% Gray World algorithm

Rave = mean(mean(R)); 
Gave = mean(mean(G)); 
Bave = mean(mean(B));
Kave = (Rave + Gave + Bave) / 3;

R1 = (Kave/Rave)*R; G1 = (Kave/Gave)*G; B1 = (Kave/Bave)*B;  
RGB_white_out = cat(3, R1, G1, B1);
RGB_white_out = RGB_white_out /(max(RGB_white_out(:)) - min(RGB_white_out(:)));

imshow(RGB_white_out)
%% Gamma mapping
K = RGB_white_out;
K = imadjust(K,[],[],1/1.5); % Gamma = 1.5
imshow(K)
%%
Rave = mean2(R); 
Gave = mean2(G); 
Bave = mean2(B);
gray = rgb2gray(Image);
Gray = mean2(gray);
R1 = R * Gray / Rave;
G1 = G * Gray / Gave;
B1 = R * Gray / Bave;

RGB_white_out = cat(3, R1, G1, B1);
K = RGB_white_out;
K = imadjust(K,[],[],1/1.5);
imshow(K)
% imshow(RGB_white_out)
%% Color correction and/or white balance
% datapath = '../data/';
% imgname = 'yosemite';
% Ref = imread([datapath imgname '.jpg']);% set original pic to be the reference color
% 
% cc = imhistmatch(B,Ref);
% cc = cc /(max(cc(:)) - min(cc(:)));
% figure(5)
% imshow(cc)
%% Sharping
b = imsharpen(cc,'Radius',1,'Amount',0.8);
figure(7)
imshow(b)
%% Denoisinghttps
% bb = imnoise(b,'salt & pepper',0.02);
% imshow(bb,0.8     % show where the noise

Kmedian_R = medfilt2(b(:,:,1));
Kmedian_G = medfilt2(b(:,:,2));
Kmedian_B = medfilt2(b(:,:,3));
Kmedian = cat(3,Kmedian_R,Kmedian_G,Kmedian_B);
figure(8)
imshow(Kmedian)

%% Reference
% https://www.mathworks.com/help/images/ref/imadjust.html
% % Demosaicking method:
% http://www.cis.upenn.edu/~danielkh/files/2013_2014_demosaicing/demosaicing.html
% https://pdfs.semanticscholar.org/6798/3c25e967361979873cdb05a8056cff1808a4.pdf
% % Color correction
% https://www.mathworks.com/help/images/ref/imhistmatch.html



