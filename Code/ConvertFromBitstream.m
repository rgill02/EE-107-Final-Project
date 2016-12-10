function [Z_rec] = ConvertFromBitstream(bit_matrix, N)
%ConvertFromBitStream Converts the bits of sets of N dct blocks to an array
%of dct blocks
%   
%   Inputs:
%       bit_matrix = array of sets of N dct blocks in bits
%       N = number
%   Outputs:
%       Z_rec = array of 8x8 dct blocks

Z_rec = zeros(8, 8, 625);
for ii = 1:size(bit_matrix, 1)
    Z_rec(:,:,((ii-1)*N + 1):(ii*N)) = ConvertBitsToBlocks(bit_matrix(ii,:));
end
    
%convert from double to uint8
Z_rec = uint8(Z_rec);

end

