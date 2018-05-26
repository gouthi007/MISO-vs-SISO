clc;
clear;
close all;

SNR = -6:2:12;
error = zeros(length(SNR));
Mt = 2;

%FOR THE MISO SYSTEM
%Using the orthogonal space-time codes ie, the Alamouti scheme, in which x1 and x2 are chosen, in random, from QPSK signals {1, -1, j, -j}

x = [ 1,-1,i,-i ];
pos1 = randi(length(x));
x1 = x(pos1);
pos2 = randi(length(x));
x2 = x(pos2);
Co = [x1, x2; -conj(x2),conj(x1)];
pos3 = randi(length(x));
x3 = x(pos3);
pos4 = randi(length(x));
x4 = x(pos4);
C1 = [x3, x4; -conj(x4),conj(x3)];
 
% Calculating p and randomizing the selection of ST signals
for i = 1:length(SNR)
    p = 10.^(0.1*SNR(i));
      for j = 1:100000
        out = randi(2);
        if out == 1
            C_out = Co;
        else 
            C_out = C1;
        end
% Simulation using the equation
        H = [sqrt(1/2)*randn(1) + i*sqrt(1/2)*rand(1); sqrt(1/2)*randn(1) + i*sqrt(1/2)*rand(1)];
        symbol = (sqrt(p/Mt)*C_out)*H;
        N = [sqrt(1/2)*randn(1) + i*sqrt(1/2)*rand(1); sqrt(1/2)*randn(1) + i*sqrt(1/2)*rand(1)];
        Y = sqrt(p/Mt)*C_out*H + N;
        Co_rcvd = (norm(Y - sqrt(p/Mt)*Co*H))^2;
        C1_rcvd = (norm(Y- sqrt(p/Mt)*C1*H))^2;
        opvalue = min(Co_rcvd, C1_rcvd);
   
         if opvalue == Co_rcvd
         final_rcvd = Co;
         else
         final_rcvd = C1;
         end
         if (( final_rcvd - C_out)~=0)
         error(i) = error(i)+1;
         end
      end
   c = error(i);
   error(i)=error(i)/100000;
end

figure (1) 
semilogy(SNR,error,'Linewidth',2);
hold on
grid on

%QPSK SISO SYSTEM
 
N = 10^5;
SNR = -6:2:12;
err = zeros(length(SNR));
Mt1 = 1; 
%Randomizing the Selection of the QPSK Signals
pos11 = randi(length(x));
Co1 = x(pos11);
pos21 = randi(length(x));
C11 = x(pos21);
 
for i = 1:length(SNR)
   p = 10.^(0.1*SNR(i));
   for j = 1:100000
        out = randi(2);
        if out == 1
            C_out1 = Co1;
        else 
            C_out1 = C11;
        end
%C_out 
     H1 = sqrt(1/2)*randn(1) + i*sqrt(1/2)*rand(1);
     symbol1 = (sqrt(p/Mt1)*C_out1)*H1;
     
%Symbol
     N1 = sqrt(1/2)*randn(1) + i*sqrt(1/2)*rand(1);
     Y1 = sqrt(p/Mt1)*C_out1*H1 + 1 ;
     Co_rcvd1 = (norm(Y1 - sqrt(p/Mt1)*Co1*H1))^2;
     C1_rcvd1 = (norm(Y1- sqrt(p/Mt1)*C11*H1))^2;
     opvalue1 = min(Co_rcvd1, C1_rcvd1);
     if opvalue1 == Co_rcvd1
        final_rcvd1 = Co1;
     else
        final_rcvd1 = C11;
     end
     if (( final_rcvd1 - C_out1)~=0)
        err(i) = err(i)+1;
     end
   end
   c = err(i);
   err(i)=err(i)/100000;
end
 
semilogy(SNR,err,'Linewidth',2);
grid on
legend('MISO with Mt=2','SISO');
xlabel('Signal to Noise Ratio in dB');
ylabel('Bit Error Rate ');
title('BER vs SNR ');