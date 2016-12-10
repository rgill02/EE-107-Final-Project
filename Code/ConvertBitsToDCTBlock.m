function [dct_block] = ConvertBitsToDCTBlock(bits)
%ConvertBitsToDCTBlock Converts 512 bits to a single dct block
%   
%   Inputs:
%       bits = vector of 512 bits
%   Outputs:
%       dct_block = dct block of bits

%convert bits to bytes
dct_line = zeros(1, 64);
for ii = 1:64
    temp = (ii-1)*8 + 1;
    dct_line(ii) = bi2de(bits(temp:temp+7));
end

%reshape into block
dct_block = zeros(8, 8);
for ii = 1:8
    for jj = 1:8
        dct_block(ii, jj) = dct_line((ii-1)*8 + jj);
    end
end

end

