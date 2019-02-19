function RGB_white_out = grayworld(img)
r = img(:,:,1);
g = img(:,:,2);
b = img(:,:,3);

Rave = mean2(r);  % mean value of each channel
Gave = mean2(g); 
Bave = mean2(b);
Kave = (Rave + Gave + Bave) / 3; % mean value of gray channel

R1 = (Kave/Rave)*r; G1 = (Kave/Gave)*g; B1 = (Kave/Bave)*b;  % multiple by factor
% RGB_white_out = cat(3, R1, G1, B1);

% R1 = histeq(R1);
% G1 = histeq(G1);
% B1 = histeq(B1);
RGB_white_out = cat(3, R1, G1, B1);