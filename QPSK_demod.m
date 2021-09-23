% QPSK Demodulator
% phase offset can be set to simulate
% Ensures the grey encoding

% Copyright (c) 2021 Navodika Karunasingha <navodikaefac@gmail.com>
function [z,r] = QPSK_demod(t,p,S,T)
t_H = T-t;
p_t=[t;p];
h=[]; 
% Calculating impulse response of Matched filter
    for ii=1:length(t_H)
        idx=find(p_t(1,:)==t_H(ii));
        if isempty(idx)
            h(1,ii)=0;
        else
            h(1,ii)=p_t(2,idx);
        end
    end
r=conv(S,h);
z=downsample(r,100);
end