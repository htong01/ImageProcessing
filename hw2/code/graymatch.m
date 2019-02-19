% EE 193HIP, HW 2, problem 1
% Experiments with gamma

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
%%
figure(2)
gamma = 2.2;        % standard gamma value
lin = linspace(0,255,256);
y = (lin.^gamma) / (255^gamma);% gamma correction also with normalization
plot(lin,y);hold on 
hline = refline([0 0.5]);   %add a reference line to mark the intermediate velue
hline.Color = 'r';
% gray value is 186 according to the plot
plot(186,0.5,'o')
xlabel('sRGB');ylabel('luminance');
title('Problem1');
