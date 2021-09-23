clear all;clc;
no_bits=30; % number of bits
tt_ratio=1; % time truncation ratio for plot the signal
bit_rate=1; % bit rate in bit per second / bps
Ts=1/bit_rate; %sample period

M=4; % QPSK
Ac=sqrt(2/(Ts*2)); % Amplitude of carrier wave (maintaining unit amplitude in S(t))
fc=4; % carrier frequency
theta_0=0; % carrier phase offset

%% bit generation
message_bit_stream = randi([0 1],1, no_bits);
figure(1);
subplot(2,1,1);
stem(message_bit_stream(1:tt_ratio*no_bits))
title('Random Message Bits stream');
xlabel('discrete time');
ylabel('logical bit');
%xlim([1 length(message_bit_stream)*tt_ratio]);

%% Line coding
[t,message_signal]=pnrz(message_bit_stream,bit_rate);

subplot(2,1,2);
plot(t(1:tt_ratio*length(message_signal)),message_signal(1:tt_ratio*length(message_signal)),'lineWidth',2);
title('Random Message signal');
xlabel('time [s]');
ylabel('voltage [V]');
hold on;
line([t(1,length(t))*tt_ratio 0],[0 0],'LineStyle','--');
%xlim([0 t(1,length(t))*tt_ratio]);

%% serial to parallel conversion
I_bit=[];
Q_bit=[];
for ii=1:log2(M):no_bits-1
   I_bit_temp=message_bit_stream(1,ii);
   Q_bit_temp=message_bit_stream(1,ii+1);
   I_bit=[I_bit I_bit_temp];
   Q_bit=[Q_bit Q_bit_temp];
end
figure(2);
subplot(5,1,2);
stem(I_bit(1:length(I_bit)*tt_ratio))
title('In-phase bit stream');
xlabel('discrete time');
ylabel('logical bit');
%xlim([1 length(I_bit)*tt_ratio]);

subplot(5,1,4);
stem(Q_bit(1:length(Q_bit)*tt_ratio))
title('Quadrature-phase bit stream');
xlabel('discrete time');
ylabel('logical bit');
%xlim([1 length(Q_bit)*tt_ratio]);

subplot(5,1,1);
stem(message_bit_stream(1:length(message_bit_stream)*tt_ratio))
title('Random Message Bits stream before S/P');
xlabel('discrete time');
ylabel('logical bit');
%xlim([1 length(message_bit_stream)*tt_ratio]);

[t_I,I_signal]=pnrz(I_bit,bit_rate/log2(M));
subplot(5,1,3);
plot(t_I(1:tt_ratio*length(I_signal)),I_signal(1:tt_ratio*length(I_signal)),'lineWidth',2);
%xlim([0 t_I(1,length(t_I))*tt_ratio]);
title('In-phase signal');
xlabel('time [s]');
ylabel('voltage [V]');
line([t_I(1,length(t_I))*tt_ratio 0],[0 0],'LineStyle','--');

[t_Q,Q_signal]=pnrz(Q_bit,bit_rate/log2(M));
subplot(5,1,5);
plot(t_Q(1:tt_ratio*length(Q_signal)),Q_signal(1:tt_ratio*length(Q_signal)),'lineWidth',2);
xlim([0 t_Q(1,length(t_Q))*tt_ratio]);
title('Quadrature-phase signal');
xlabel('time [s]');
ylabel('voltage [V]');
line([t_Q(1,length(t_Q))*tt_ratio 0],[0 0],'LineStyle','--');

%% QPSK Modulation
Ts_analog=(1/bit_rate)/100; % analog sampling period

% bandpass modulation
[S,p_1,p_2]=QPSK_mod(t_I,I_signal,Q_signal,fc,Ac,theta_0);

figure(3);
plot(t_I(1:tt_ratio*length(I_signal)),S(1:tt_ratio*length(S)),'lineWidth',2);
title('BPSK Modulated Signal');
xlabel('time [s]');
ylabel('voltage [V]');
line([t_I(1,length(t_I))*tt_ratio 0],[0 0],'LineStyle','--');

%% AWGN channel
%% QPSK Demodulator
T=1;
[z1,r1] = QPSK_demod(t_I,p_1,S,T);z1=normalize(z1(2:length(I_bit)+1));
[z2,r2] = QPSK_demod(t_I,p_2,S,T);z2=normalize(z2(2:length(Q_bit)+1));

figure(4);
subplot(4,1,1);
stem(r1)
subplot(4,1,2);
stem(z1)

subplot(4,1,3);
stem(r2)
subplot(4,1,4);
stem(z2)
%% Detector



