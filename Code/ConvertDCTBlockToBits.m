function [bits] = ConvertDCTBlockToBits(dct_block)
%ConvertDCTBlockToBits Converts a single dct block to bits
%   
%   Inputs:
%       dct_block = single dct block
%   Outputs:
%       bits = vector of 512 bits

%reshape block into line
dct_line = zeros(1, 64);
for ii = 1:8
    for jj = 1:8
        dct_line((ii-1)*8 + jj) = dct_block(ii, jj);
    end
end

%turn bytes to bits
bits = [];
for ii = 1:length(dct_line)
    bits = [bits de2bi(dct_line(ii), 8)];
end

end

