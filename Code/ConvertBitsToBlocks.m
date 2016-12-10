function [dct_blocks] = ConvertBitsToBlocks(bits)
%ConvertBitsToBlocks Converts a bitstream to a bunch of dct blocks
%   
%   Inputs:
%       bits = vector of bits
%   Outputs:
%       dct_blocks = array of 8x8 dct blocks

dct_blocks = zeros(8, 8, length(bits) / (64*8));
jj = 1;
for ii = 1:64*8:length(bits)
    dct_blocks(:,:,jj) = ConvertBitsToDCTBlock(bits(ii:ii+(64*8)-1));
    jj = jj + 1;
end

end

