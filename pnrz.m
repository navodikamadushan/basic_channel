% Bi-polar non return to zero line coder
% Bit rate should be essential for computing sample time
% time linespace and dense digital bit will be provided as output

% Copyright (c) 2021 Navodika Karunasingha <navodikaefac@gmail.com>
function [t,x] = pnrz(bits,bitrate)
Ts= 1/bitrate; % sample time
n = 100; %number of samples per bit
N = n*length(bits);
dt = Ts/n;
t = 0:dt:length(bits)*Ts;
x = zeros(1,length(t)); % output signal
for i = 0:length(bits)-1
  if bits(i+1) == 1
    x(i*n+1:(i+1)*n) = 1;
  else
    x(i*n+1:(i+1)*n) = -1;
  end
end