clear all;clc;
no_bits=100; % number of bits
tt_ratio=0.2; % time truncation ratio for plot the signal
bit_rate=1; % bit rate in bit per second / bps


%bit generation
message_bit_stream = randi([0 1],1, no_bits);
figure;
stem(message_bit_stream(1:tt_ratio*no_bits))
title('Random Message Bits stream');
xlabel('discrete time');
ylabel('logical bit');

[t,message_signal]=pnrz(message_bit_stream,bit_rate);
figure;
plot(t(1:tt_ratio*length(message_signal)),message_signal(1:tt_ratio*length(message_signal)));
title('Random Message signal');
xlabel('time [s]');
ylabel('voltage [V]');
hold on;
line([tt_ratio*no_bits 0],[0 0],'LineStyle','--');