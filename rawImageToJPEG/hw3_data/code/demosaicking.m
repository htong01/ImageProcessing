function rgb = demosaicking(img)
n = size(img, 2);
m = size(img, 1);

R = zeros(m,n);
G = zeros(m,n);
B = zeros(m,n);
bits = 12;
bitrange = 2^bits;
% seperate each channel according to the CFA pattern
for i = 1:m
    for j = 1:n
        if mod(i,2) == 0 && mod(j,2) == 1 %G
            G(i,j) = img(i,j)/bitrange;
        elseif mod(i,2) == 1 && mod(j,2) == 0
            G(i,j) = img(i,j)/bitrange;
        elseif mod(i,2) == 1 %R
            R(i,j) = img(i,j)/bitrange;
        else %B
            B(i,j) = img(i,j)/bitrange;
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

rgb = cat(3, R, G, B);
rgb = rgb /(max(rgb(:)) - min(rgb(:)));