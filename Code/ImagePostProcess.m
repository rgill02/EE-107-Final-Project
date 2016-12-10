function []=ImagePostProcess(newZtres, block_height, block_width, pixel_height, pixel_width, minval, maxval)

%% invert the reshaping operation
newZt = reshape(permute(reshape(newZtres,8,8,block_height,block_width), [1 3 2 4]), pixel_height,pixel_width);

%%
%%%%%%%%%% IMAGE POST-PROCESSING %%%%%%%%%%%%%%%%
temp=im2double(newZt)*(maxval-minval)+minval;
fun=@idct2;
newZ=blkproc(temp,[8 8],fun);

figure;
imshow(newZ);