%-------------------------------------------------------------------------------
% cnoise_1overf: 1-over-f coloured Gaussian noise using FIR approach in [1]
%
% Syntax: x=cnoise_1overf(alpha, N, Q_d)
%
% Inputs: 
%     N,alpha,Q_d - 
%
% Outputs: 
%     alpha  - α parameter (default = 1)
%     N      - number of samples (default = 256)
%     Q_d    - standard deviation (default = 1)
%     DBplot - plot? true/false (default = false)
%    
%
% Example:
%     N=1024;  alpha=1.2;  Q_d=12;
%     ns=cnoise_1overf(alpha, N, Q_d, 1);
%     
%
% [1] Kasdin, N. Jeremy. "Discrete simulation of colored noise and stochastic processes
%     and 1/f^α power law noise generation." Proc. IEEE, 83(5), 802-827, 1995


% John M. O' Toole, University College Cork
% Started: 17-04-2018
%
% last update: Time-stamp: <2018-04-18 11:00:29 (otoolej)>
%-------------------------------------------------------------------------------
function n=cnoise_1overf(alpha, N, Q_d, DBplot)
if(nargin<1 || isempty(alpha)) alpha=1; end
if(nargin<2 || isempty(N)) N=256; end
if(nargin<3 || isempty(Q_d)) Q_d=1; end
if(nargin<4 || isempty(DBplot)), DBplot=0; end



%---------------------------------------------------------------------
% 1. white Gaussian noise as source
%---------------------------------------------------------------------
noise_source=randn(1, N);


%---------------------------------------------------------------------
% 2. generate FIR filter
%---------------------------------------------------------------------
h=zeros(1, N);    

h(1)=1; 
for n=2:N
    h(n)=h(n-1)*(alpha/2+(n-2)) / (n-1);
end


%---------------------------------------------------------------------
% 3. filter
%---------------------------------------------------------------------
n=filter(h, 1, noise_source);


% scale with standard deviation Q_d:
n=Q_d.*(n./std(n));



%---------------------------------------------------------------------
% 4. plot?
%---------------------------------------------------------------------
if(DBplot)
    noise_spec=fft(n);
    Fs=1;
    
    figure(11); clf;
    subplot(511);
    k=1:ceil(length(noise_spec)/2);
    f=k./(length(noise_spec)/Fs);
    plot(f, abs(noise_spec(k)).^2);
    xlabel('normalised frequency'); ylabel('|N(f)|^2');
    subplot(513);    
    plot(f, angle(noise_spec(k))); 
    xlabel('normalised frequency'); ylabel('phase');
    
    subplot(512);
    loglog(f, abs(noise_spec(k)).^2); grid on;
    xlabel('frequency (log)'); ylabel('dB');
    
    subplot(514);
    t=(0:N-1).*Fs;
    plot(t, n);
    xlabel('time (seconds)');
    
    subplot(515);
    [acf, lags]=xcorr(n(:)');
    il=find(lags==0);
    plot(lags(il:end), acf(il:end));
    xlabel('lag (samples)');
    ylabel('auto-correlation');
end
