clear all;clc;
no_bits=100; % number of bits
tt_ratio=0.4; % time truncation ratio for plot the signal
bit_rate=4; % bit rate in bit per second / bps
Ts=1/bit_rate; %sample period

M=4; % QPSK
Ac=1; % Amplitude of carrier wave
fc=4; % carrier frequency
theta_0=pi/10; % carrier phase offset

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
plot(t(1:tt_ratio*length(message_signal)),message_signal(1:tt_ratio*length(message_signal)),'lineWidth',2);
title('Random Message signal');
xlabel('time [s]');
ylabel('voltage [V]');
hold on;
line([t(1,length(t))*tt_ratio 0],[0 0],'LineStyle','--');
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
figure;
subplot(5,1,2);
stem(I_bit(1:length(I_bit)*tt_ratio))
title('In-phase bit stream');
xlabel('discrete time');
ylabel('logical bit');
xlim([1 length(I_bit)*tt_ratio]);

subplot(5,1,4);
stem(Q_bit(1:length(Q_bit)*tt_ratio))
title('Quadrature-phase bit stream');
xlabel('discrete time');
ylabel('logical bit');
xlim([1 length(Q_bit)*tt_ratio]);

subplot(5,1,1);
stem(message_bit_stream(1:length(message_bit_stream)*tt_ratio))
title('Random Message Bits stream before S/P');
xlabel('discrete time');
ylabel('logical bit');
xlim([1 length(message_bit_stream)*tt_ratio]);

[t_I,I_signal]=pnrz(I_bit,bit_rate/log2(M));
subplot(5,1,3);
plot(t_I(1:tt_ratio*length(I_signal)),I_signal(1:tt_ratio*length(I_signal)),'lineWidth',2);
xlim([0 t_I(1,length(t_I))*tt_ratio]);
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

%% BPSK Modulation
Ts_analog=(1/bit_rate)/100; % analog sampling period

% bandpass modulation
S=Ac*cos(2*pi*fc*t_I+theta_0).*I_signal-Ac*sin(2*pi*fc*t_Q+theta_0).*Q_signal;
figure;
plot(t_I(1:tt_ratio*length(I_signal)),S(1:tt_ratio*length(S)),'lineWidth',2);
title('BPSK Modulated Signal');
xlabel('time [s]');
ylabel('voltage [V]');
line([t_I(1,length(t_I))*tt_ratio 0],[0 0],'LineStyle','--');


