function K = BlackWhiteLevel(img)

% Black-level and white-level correction
Max = max(K(:));
Min = min(K(:));
range_h = 0.9;
range_l = 0.1;
for i = 1:m
    for j = 1:n
        value = (K(i,j) - Min) / (Max - Min);
        
        if value > range_h
            K(i,j) = range_h;
        elseif value < range_l
            K(i,j) = range_l;
        else
            K(i,j) = value;
        end
    end
end
