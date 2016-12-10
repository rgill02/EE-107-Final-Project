function [bits] = ConvertBlocksToBits(dct_blocks)
%ConvertBlocksToBits Converts dct blocks to bitstream
%   
%   Inputs:
%       dct_blocks = array of 8x8 dct blocks
%   Outputs:
%       bits = vector of bits

bits = [];
for ii = 1:size(dct_blocks, 3)
    bits = [bits ConvertDCTBlockToBits(dct_blocks(:,:,ii))];
end

end

