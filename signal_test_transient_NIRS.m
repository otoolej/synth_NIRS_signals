%-------------------------------------------------------------------------------
% signal_test_transient_NIRS: generate synthetic NIRS-like signal with transient
%                             waveforms observed in preterm infants during first
%                             few days of life. See [1] for more details.
%
%
% Syntax: [x, x_tran, x_res]=signal_test_transient_NIRS(dur_sec, Fs, N_iter)
%
% Inputs: 
%     dur_sec  - total duration of signal in seconds (default = 12*60*60 seconds)
%     Fs       - sampling frequency (default = 1/6 Hz)
%     N_iter   - number of signals to generate (default = 1)
% 
% Outputs: 
%     x_st - structure array containing synthetic rcSO2 signals:
%            .x           : synthetic rcSO2 signal
%            .x_noise     : noise component 
%            .x_tran      : transient component with impulse-like waveforms
%            .N_total_imp : total number of impulse components
%            .Fs          : sampling frequency (Hz)
%            .dur_sec     : duration in seconds
%
% Example:
%     dur=12*3600; Fs=1/6;
%     x_st=signal_test_transient_NIRS(dur, Fs, 10);
%
%
% [1] JM O' Toole, EM Dempsey, and GB Boylan "Extracting transients from cerebral
%  oxygenation signals of preterm infants: a new singular-spectrum analysis method",
%  Int. Conf. IEEE Eng. Med. Biol. Society (EMBC), Honolulu, HI; IEEE, July 2018.
      

% John M. O' Toole, University College Cork
% Started: 19-05-2017
%
% last update: Time-stamp: <2018-04-18 13:03:05 (otoolej)>
%-------------------------------------------------------------------------------
function [x_st]=signal_test_transient_NIRS(dur_sec, Fs, N_iter)
if(nargin<1 || isempty(dur_sec)), dur_sec=12*60*60; end
if(nargin<2 || isempty(Fs)), Fs=1/6; end
if(nargin<3 || isempty(N_iter)), N_iter=1; end


% stationary or non-stationary noise?
STATIONARY=0;

X_MEAN=randi([70 80], 1, 1);


for n=1:N_iter
    %---------------------------------------------------------------------
    % 1. generate transient-like signal 
    %---------------------------------------------------------------------
    [x_tran, N_total_imp]=gen_transient_signal(dur_sec, Fs);
    N=length(x_tran);
    x_tran=x_tran+X_MEAN;

    %---------------------------------------------------------------------
    % 2. non-stationary 1/f noise pocesses 
    %---------------------------------------------------------------------
    x_noise=gen_noise(N, STATIONARY, Fs);

    % add noise:
    x=x_noise+x_tran;

    % hard-limit:
    x(x>95)=95;
    x(x<15)=15;

    % quantize:
    x=round(x);


    DBplot=1;
    if(DBplot)
        figure(2); clf;
        ttime=(0:(N-1))./(Fs*60*60);
        hx(1)=subplot(4, 1, [1 2]); 
        plot(ttime, x); ylim([10 100]);
        ylabel('rcSO_2 (%)');
        hx(2)=subplot(4, 1, 3); plot(ttime, x_noise);
        hx(3)=subplot(4, 1, 4); plot(ttime, x_tran);
        set(hx(1:2), 'xticklabel', []);
        xlabel('time (hours)');
        linkaxes(hx, 'x');
        if(N_iter>1)
            disp('--- paused; hit key to continue ---'); pause;
        end
    end

    
    x_st(n).x=x; x_st(n).x_noise=x_noise; x_st(n).x_tran=x_tran;
    x_st(n).N_total_imp=N_total_imp; 
    x_st(n).Fs=Fs; x_st(n).dur_sec=dur_sec;
end




function y=gen_noise(N, STATIONARY, Fs)
%---------------------------------------------------------------------
% generate 1/f noise, either stationary of non-stationary
%---------------------------------------------------------------------
if(STATIONARY)

    alpha=1.1; NOISE_VAR=randi([2 5], 1, 1)^2;
    y=noise_1overf(alpha, N, Fs, 'FIR', sqrt(NOISE_VAR));

    y=y(:)';

else
    EPOCH_SIZE=1000; % sample points
    OVERLAP=25; % in percentage

    [L_hop, L_epoch, win_epoch]=gen_epoch_window(OVERLAP, EPOCH_SIZE, 'tukey', 1);

    N_epochs=ceil( (N-L_epoch)/L_hop );
    % extend right to the end:
    N_epochs=N_epochs+1;
    nw=0:L_epoch-1;

    N_pad=(N_epochs-1)*L_hop+L_epoch;
    if(N_pad<=N)
        N_pad=N; 
    end

    x_noise=zeros(1, N_pad); 
    win_summed=zeros(1, N_pad);

    for k=0:N_epochs-1
        nf=mod(nw+k*L_hop, N_pad);
        
        alpha=1.0 + (1.8-1.0)*rand(1, 1);
        NOISE_VAR=randi([10 15], 1, 1);
        y=cnoise_1overf(alpha, length(nf), sqrt(NOISE_VAR));
        y=y(:)';
        
        x_noise(nf+1)=x_noise(nf+1)+y.*win_epoch';
        win_summed(nf+1)=win_summed(nf+1)+win_epoch.';            
    end
    x_noise=x_noise./win_summed;
    x_noise(isnan(x_noise))=[];	

    y=x_noise(1:N);
end
