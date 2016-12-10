function [Ztres, block_height, block_width, pixel_height, pixel_width, minval, maxval]=ImagePreProcess()

load trees
Z=ind2gray(X(1:200,1:200),gray);
%figure;
imshow(Z);

%% take DCT in 8x8 blocks and quantize it into 8-bit numbers
fun = @dct2;
temp=blkproc(Z,[8 8],fun);
% scale DCT to [0,1]
minval = min(min(temp));
maxval = max(max(temp));
xformed = (temp-minval)/(maxval-minval);
% quantize DCT coefficients to 256 levels
Zt=im2uint8(xformed);

%% reshape DCT into 8x8 blocks for ease of transmission
[pixel_height, pixel_width] = size(Zt);
block_height=floor(pixel_height/8); block_width=floor(pixel_width/8);
Ztres = reshape(permute(reshape(Zt,8,block_height,8,block_width), [1 3 2 4]), 8,8,block_height*block_width);