% QPSK Modulator
% phase offset can be set to simulate
% Ensures the grey encoding

% Copyright (c) 2021 Navodika Karunasingha <navodikaefac@gmail.com>
function [S,p_1,p_2] = QPSK_mod(t,I_signal,Q_signal,fc,Ac,theta_0)
p_1=Ac*cos(2*pi*fc*t+theta_0);
p_2=Ac*sin(2*pi*fc*t+theta_0);
S=p_1.*I_signal+p_2.*Q_signal;% grey encoding
end