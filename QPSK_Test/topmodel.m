clear all;clc;
no_bits=6; % number of bits
tt_ratio=1; % time truncation ratio for plot the signal
bit_rate=1; % bit rate in bit per second / bps
Ts=1/bit_rate; %sample period

M=4; % QPSK
Ac=sqrt(2/(Ts*2)); % Amplitude of carrier wave (maintaining unit amplitude in S(t))
fc=2; % carrier frequency
theta_0=0; % carrier phase offset

%bit generation
message_bit_stream = randi([0 1],1, no_bits);
figure;
subplot(2,1,1);
stem(message_bit_stream(1:tt_ratio*no_bits))
title('Random Message Bits stream');
xlabel('discrete time');
ylabel('logical bit');
xlim([1 length(message_bit_stream)*tt_ratio]);

%% Line coding
[t,message_signal]=pnrz(message_bit_stream,bit_rate);
subplot(2,1,2);
stem(t(1:tt_ratio*length(message_signal)),message_signal(1:tt_ratio*length(message_signal)),'lineWidth',2);
title('Random Message signal');
xlabel('time [s]');
ylabel('Amplitude');
hold on;
%line([t(1,length(t))*tt_ratio 0],[0 0],'LineStyle','--');
xlim([0 t(1,length(t))*tt_ratio]);

%% serial to parallel conversion
I_bit=[];
Q_bit=[];
for ii=1:log2(M):no_bits-1
   I_bit_temp=message_bit_stream(1,ii);
   Q_bit_temp=message_bit_stream(1,ii+1);
   I_bit=[I_bit I_bit_temp];
   Q_bit=[Q_bit Q_bit_temp];
end
Ts_I=(1/bit_rate)*log2(M);
Ts_Q=(1/bit_rate)*log2(M);
t_I = 0:Ts_I:(length(I_bit)-1)*Ts_I;
t_Q = 0:Ts_Q:(length(Q_bit)-1)*Ts_Q;

figure;
subplot(3,1,2);
stem(t_I(1:tt_ratio*length(I_bit)),I_bit(1:length(I_bit)*tt_ratio))
title('In-phase bit stream');
xlabel('discrete time');
ylabel('logical bit');
xlim([0 length(message_bit_stream)*tt_ratio]);

subplot(3,1,3);
stem(t_Q(1:tt_ratio*length(Q_bit)),Q_bit(1:length(Q_bit)*tt_ratio))
title('Quadrature-phase bit stream');
xlabel('time [s]');
ylabel('logical bit');
xlim([0 length(message_bit_stream)*tt_ratio]);

subplot(3,1,1);
stem(t(1:tt_ratio*length(message_signal)),message_bit_stream(1:length(message_bit_stream)*tt_ratio))
title('Random Message Bits stream before S/P');
xlabel('time [s]');
ylabel('logical bit');
xlim([0 length(message_bit_stream)*tt_ratio]);

%% QPSK Modulation

p_1=Ac*cos(2*pi*fc*t_I+theta_0);
p_2=Ac*sin(2*pi*fc*t_Q+theta_0);
S=-p_1.*I_bit+p_2.*Q_bit;% grey encoding

% figure;
% stem(t_I(1:tt_ratio*length(S)),S(1:tt_ratio*length(S)),'lineWidth',2);
% title('QPSK Modulated Signal');
% xlabel('time [s]');
% ylabel('Amplitude');
% %line([t_I(1,length(t_I))*tt_ratio 0],[0 0],'LineStyle','--');

%% AWGN channel

%% QPSK Demodulation
T=2;
t_H = T-t_I;
p1_tI=[t_I;p_1];
h1=[];
for ii=1:length(t_H)
    idx1=find(p1_tI(1,:)==t_H(ii));
    if isempty(idx1)
        h1(1,ii)=0;
    else
        h1(1,ii)=p1_tI(2,idx1);
    end
end
r1=conv(h1,S)


