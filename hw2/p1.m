close all;
clear;
clc;

x = zeros(200,200);
x(1:200,100:200) = 0.5;  % set the color gray (right part
for i = 1:200
    if rem(i,2) ~= 0     % To make an alternative strip, set even part to be white and odd pixel to black
        x(i,1:99) = 1;  % white of left part
    end
end
figure;
imshow(x);
mean_alt = mean2(x(1:200,1:99)) * 255; % mean luminance of alternative strip
mean_sol = mean2(x(1:200,100:200)) * 255;% for solid gray part