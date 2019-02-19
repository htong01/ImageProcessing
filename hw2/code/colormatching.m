% EE 193HIP, HW 2, problem 4
%
% Primary matches for columns of `tristimulus`:
% 1) [1.331208155391494e+03, 1.077529788908537e+03, 9.367535807887853e+02]
% 2) Not exist
% 3) [8.947383179628770e+03, 1.350914014260741e+03, 3.799444387681030e+02]
% 4) [725.362543746578, 847.928211020031, 2350.54529137550]

close all;
clear;
clc;
load('../hw2_data.mat');

x = zeros(3,4); % intensity
A = cone_response' * display_primaries;
for i = 1:4
    x(:,i) = A \ tristimulus(:,i);
end
