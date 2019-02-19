% EE 193HIP, HW 2, problems 2 and 3
close all;
clear;
clc;

load('../hw2_data.mat');
% You can use `whos` to see the variables and their sizes/datatypes
% Hopefully the names are self-explanatory

cone_response1 = cone_response;
cone_response2 = cone_response;

cone_response1(:,1) = cone_response1(:,1) .* light_d65';% under D65
cone_response1(:,2) = cone_response1(:,2) .* light_d65';
cone_response1(:,3) = cone_response1(:,3) .* light_d65';

figure(2);
plot(wavelength,cone_response1(:,1),'r'); hold on
plot(wavelength,cone_response1(:,2),'g'); hold on
plot(wavelength,cone_response1(:,3),'b')
xlabel('wavelength, nm');ylabel('cone response')
title('cone response under daylight(D65)')

cone_response2(:,1) = cone_response2(:,1) .* light_fluorescent';% under
cone_response2(:,2) = cone_response2(:,2) .* light_fluorescent';
cone_response2(:,3) = cone_response2(:,3) .* light_fluorescent';

figure(3);
plot(wavelength,cone_response2(:,1),'r'); hold on
plot(wavelength,cone_response2(:,2),'g'); hold on
plot(wavelength,cone_response2(:,3),'b')
xlabel('wavelength, nm');ylabel('cone response')
title('cone response under fluorescent')

%% daylight cow
cow = im2double(cow);        % convert unit16 to double
new_cow1 = zeros(420,600,3);  % new image after adjustment

for x = 1:420
    for y = 1:600
        for i = 1:71
            new_cow1(x,y,1) = new_cow1(x,y,1) + cow(x,y,i) * cone_response1(i,1);
            new_cow1(x,y,2) = new_cow1(x,y,2) + cow(x,y,i) * cone_response1(i,2);
            new_cow1(x,y,3) = new_cow1(x,y,3) + cow(x,y,i) * cone_response1(i,3);
        end
    end
end

new_cow1 = new_cow1 /(max(new_cow1(:)) - min(new_cow1(:)));% normalization
new_cow1 = imadjust(new_cow1,[],[],1/2.4); % add gamma correction
figure(4)
imshow(new_cow1)
title('daylight cow')
%% fluoresent cow
new_cow2 = zeros(420,600,3);  % new image after adjustment

for x = 1:420
    for y = 1:600
        for i = 1:71
            new_cow2(x,y,1) = new_cow2(x,y,1) + cow(x,y,i) * cone_response2(i,1);
            new_cow2(x,y,2) = new_cow2(x,y,2) + cow(x,y,i) * cone_response2(i,2);
            new_cow2(x,y,3) = new_cow2(x,y,3) + cow(x,y,i) * cone_response2(i,3);
        end
    end
end

new_cow2 = new_cow2 /(max(new_cow2(:)) - min(new_cow2(:)));
new_cow2 = imadjust(new_cow2,[],[],1/2.4);
figure(5)
imshow(new_cow2)
title('fluoresent cow')

%% Problem 3
my_spec = light_d65;
my_spec(1:25) = 0;     % set almost all the short cone to 0
figure(6)
plot(my_spec)
title('spectrum')

cone_response3 = cone_response;
cone_response3(:,1) = cone_response3(:,1) .* my_spec';
cone_response3(:,2) = cone_response3(:,2) .* my_spec';
cone_response3(:,3) = cone_response3(:,3) .* my_spec';
figure(7);
plot(wavelength,cone_response3(:,1),'r'); hold on
plot(wavelength,cone_response3(:,2),'g'); hold on
plot(wavelength,cone_response3(:,3),'b')
xlabel('wavelength, nm');ylabel('cone response')

new_cow3 = zeros(420,600,3);  % new image after adjustment

for x = 1:420
    for y = 1:600
        for i = 1:71
            new_cow3(x,y,1) = new_cow3(x,y,1) + cow(x,y,i) * cone_response3(i,1);
            new_cow3(x,y,2) = new_cow3(x,y,2) + cow(x,y,i) * cone_response3(i,2);
            new_cow3(x,y,3) = new_cow3(x,y,3) + cow(x,y,i) * cone_response3(i,3);
        end
    end
end

new_cow3 = new_cow3 /(max(new_cow3(:)) - min(new_cow3(:)));% normalization
new_cow3 = imadjust(new_cow3,[],[],1/2.4); % add gamma correction
figure(8)
imshow(new_cow3)
title('my cow')