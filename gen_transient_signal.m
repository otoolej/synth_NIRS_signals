%-------------------------------------------------------------------------------
% gen_transient_signal: generate signal with impulse waveforms 
%
% Syntax: x=gen_transient_signal(dur_sec,Fs)
%
% Inputs: 
%     dur_sec  - duration in seconds (default = 12*60*60 seconds)
%     Fs       - sampling frequency (default = 1/6 Hz)
%
% Outputs: 
%     x            - signal with transient waveforms
%     N_total_imp  - total number of impulses used to generate signal
%
% Example:
%     x_trans=gen_transient_signal(12*60*60,1/6);
%
%     figure(1); hold all; 
%     ttime=(1:length(x_trans))./600;
%     plot(ttime,x_trans); 
%     xlabel('time (hours)');

% John M. O' Toole, University College Cork
% Started: 19-05-2017
%
% last update: Time-stamp: <2018-04-18 16:39:34 (otoolej)>
%-------------------------------------------------------------------------------
function [x,N_total_imp]=gen_transient_signal(dur_secs,Fs)
if(nargin<1 || isempty(dur_secs)), dur_secs=12*60*60; end
if(nargin<2 || isempty(Fs)), Fs=1/6; end


N=floor(dur_secs*Fs);
x=zeros(1,N);
N_total_imp=0;  

%---------------------------------------------------------------------
% generate IMPULSE-like transients
%---------------------------------------------------------------------
% a) number of transients:
N_impulse=randi([1 5],1,1);
N_cluster=randi([0 4],1,N_impulse);
itime_points=randi(N,1,N_impulse);
amp_impulse=randi([10 40],1,N_impulse);


% b) set in place:
for n=1:N_impulse
    x_tmp=zeros(1,N);
    x_tmp(itime_points(n))=amp_impulse(n);
    for p=1:N_cluster(n)
        step=randi((Fs*60).*[10 100],1,1);
        if((itime_points(n)+step)>1 && (itime_points(n)+step)<=N)
            x_tmp(itime_points(n)+step)=amp_impulse(n)*(randi([1 11],1,1)./10);
            N_total_imp=N_total_imp+1;
        end
    end
    L_win=randi((Fs*60).*[2 15],1,1);
    win=flattopwin(L_win);
    x_tmp=conv(x_tmp,win,'same');    
    
    
    x=x+x_tmp;
end
x=-x(:)';


% if nothing there, do again:
if(all(x==0))
    [x,N_total_imp,N_total_step]=gen_transient_signal;
end




    
        

