% Bi-polar non return to zero line coder
% Bit rate should be essential for computing sample time
% time linespace and dense digital bit will be provided as output

% Copyright (c) 2021 Navodika Karunasingha <navodikaefac@gmail.com>
function [t,x] = pnrz(bits,bitrate)
Ts= 1/bitrate; % sample time
t = 0:Ts:(length(bits)-1)*Ts;
x = zeros(1,length(t)); % output signal
for i = 1:length(bits)
  if bits(i) == 1
    x(1,i) = 1;
  else
    x(1,i) = -1;
  end
end