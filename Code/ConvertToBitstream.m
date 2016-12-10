function [bit_matrix] = ConvertToBitstream(Ztres, N)
%ConvertToBitstream Converts array of dct blocks into bitstreams made of N
%dct blocks
%   
%   Inputs:
%       Ztres = array of 8x8 dct blocks
%       N = number
%   Outputs:
%       bit_matrix = matrix of bits where each row represents N dct blocks

%create matrix to hold bits
width = 8*8*8*N;    %number of bits in N blocks
height = size(Ztres, 3) / N;
bit_matrix = zeros(height, width);
jj = 1;
for ii = 1:N:size(Ztres, 3)
    bit_matrix(jj,:) = ConvertBlocksToBits(Ztres(:,:,(ii:(ii+N-1))));
    jj = jj + 1;
end

end

