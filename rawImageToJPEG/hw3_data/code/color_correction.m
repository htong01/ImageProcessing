function correctedRGB = color_correction(img,datapath,imgname)

% read color correction matrix from file
metafile = [datapath imgname '.csv'];
metadata = load_metadata(metafile);
ccm = metadata_value(metadata, 'Color Matrix');
ccm = sscanf(ccm,'%f');
ccm = reshape(ccm,[3,3])';
% ccm = ccm/(max(ccm(:)) - min(ccm(:))); % normalize
ccm = ccm / 256;

[my, mx, mc] = size(img);          % rows, columns, colors (3)
imageRGB = reshape(img,my*mx,mc);  % Change to 2D to apply matrix
correctedRGB = imageRGB*ccm;       % apply ccm

% corr = [0.5,0.5,1];
% correctedRGB = correctedRGB .* corr;
correctedRGB = correctedRGB.^(1/2.2);% Apply gamma for sRGB

correctedRGB = reshape(correctedRGB, my, mx, mc); 