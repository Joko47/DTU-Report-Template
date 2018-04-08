%% Downsample filter
% FIR filter til downsampling af 44.1 kHz til 22.05 kHz
% Filteret benyttes som basis for polyphase filterne.

clear all
show_fig_1 = false;

% For at kore talesignal, indkommenter folgende:
[Tale, f_sample]= audioread('Talesignal1.m4a');
TaleSize = size(Tale);
TaleMono = Tale([1:TaleSize(1)],1);
TaleAmp=10*TaleMono; %forstaerker signalet, saa det kan hores

% For at tilfoje hvid stoj til signalet, indkommenter folgende:
TaleAmp = awgn(TaleAmp, 40);

% For at kore en delta puls igennem filteret, indkommenter folgende:
%TaleAmp = zeros(100000,1);
%TaleAmp(1,1) = 1;


%% 
% Konstanter
f_s = 44.1*10^3;% sample frekvens
f_ny = f_s/2;   % nyquist frekvens
f_cut = 10*10^3;% cutoff frekvens
M = 10;         % orden = 2*M + 1
f_cut_norm = (pi*f_cut)/f_ny; % normaliseret cutoff frekvens

%%
% Bestemmelse af overforings funktion (norm. frekvens)
for cnt = [1:1:M+1] % index 0 - M
    
    % definer det onskede amplitude spectrum her:
    % hvis Omega_k er under cutoff
    if (2*pi*(cnt))/(2*M+2) <= f_cut_norm     
        H_k(cnt) = 1;
    % hvis Omega_k er over cutoff
    elseif  (2*pi*(cnt))/(2*M+2) > f_cut_norm 
        H_k(cnt) = 0;
    end
end

%%
% Udregning af af filter koefficienterne (1/2)
for cnt_n = [1:1:M+1]   % index 0 - M
    temp = 0;           % bruges til summen nedenfor
    for cnt_k = [1:1:M] % sum 1 - M
        temp = temp + H_k(cnt_k)*cos((2*pi*cnt_k*((cnt_n-1)-M))...
                                                        /(2*M +1));
    end
    h(cnt_n) = (1/(2*M+1))*(H_k(1) + 2*temp);
end

%%
% Udregning af af filter koefficienterne (2/2)
% Her udnyttes symetrien i FIR filter koefficienter
for cnt_n = [M+2:1:2*M+1]
    h(cnt_n) = h(2*M+2 - cnt_n);
end

%% Polyphase filtre
% Design af selve polyphase filtrene 
%%
% konstanter:
downsample_factor = 2;
order = 2*M + 1;

%%
% init af array til polyphase filtre, rho(koef_nr, filter_nr)
rho = zeros([ceil(order/downsample_factor), downsample_factor]);
% taelle var, for h() ikke gar over index
cnt_len = 1; 

%%
% fordeling af koef.

% F.eks.
% rho_1: h(1), h(3)
% rho_2: h(2), h(4)

% index 0 - downsample_factor-1
for cnt_k = [1:1:downsample_factor] 
   % index 0 - (2*M+1)/downsample_factor
   for cnt_n = [1:1:ceil(order/downsample_factor)] 
      if cnt_len <= length(h)
         rho(cnt_n, cnt_k) = h((cnt_n*downsample_factor -1) ...
                                                    + (cnt_k -1));
      end
      cnt_len = cnt_len + 1;
   end
end

%% Filtrering af lyd m. polyphase
% Filtreing af et talesignal eller en deltapuls
    
% Definer en matrix til at holde signalet. Fyld denne med 0'er. 
TaleAmpSplit = zeros(ceil(length(TaleAmp)/downsample_factor), ... 
                                                downsample_factor);

% Counter, for at undga index overflow i folgende for-lokke.
cnt_len = 1; 

% Signalet deles op i 2 dele med hvert andet sample, svarende til 
% 2 polyphase filter banke.
for cnt_B = [1:1:downsample_factor]
    for cnt_A = [1:1:ceil(length(TaleAmp)/downsample_factor)]
        if cnt_len <= length(TaleAmp)
            TaleAmpSplit(cnt_A, cnt_B) =  ...
                    TaleAmp(cnt_A*downsample_factor +cnt_B -2, 1);
        end
        cnt_len = cnt_len + 1;
    end
end

% Index til signal og filter koef. Disse bruges til at "hive" en 
% vektor ud af matricen med polyphase filtre eller dele at signaler.
vect_index = size(TaleAmpSplit);
filt_index = size(rho);

% Definer en matrix til at holde outputtet. Fyld denne med 0'er. 
out_len = length(TaleAmpSplit) + length(rho) - 1;
out = zeros(out_len, 1);

% Signalet 2 dele foldes med de tilhorende polyphase filters
% coeficienter, og disse ligges sammen undervejs.
for cnt_vect_index = [1:1:downsample_factor]
  out = out + conv(TaleAmpSplit(1:vect_index(1), cnt_vect_index),... 
                            rho(1:filt_index(1), cnt_vect_index));
end

% Indkommenter for at hore den downsamplede og filtrede lyd:
sound(out, 22.05*10^3)

%% Plot af filtre
% Plot FFT af outputtet:

bin_res = (f_s/length(out))*10^-3;% frekvens kasse oplosning i kHz
f_bins = 0:bin_res:(length(out)-1)*bin_res; 

figure(1)
plot(f_bins, abs( (2/length(out)) * fft(out)), 'b', 'Linewidth', 4)
hold on;

% Filtrering af lyd m. FIR filter
TaleFilt = conv(TaleAmp, h);
    
for cnt_n = [1:1:ceil(length(TaleFilt)/2)]
    out_filt(cnt_n) = TaleFilt(cnt_n*2 - 1);
end
    
plot(f_bins, abs( (2/length(out_filt)) * fft(out_filt)),'r', ...
                                                    'Linewidth',1.8)
legend('Polyphase', 'FIR')
axis([0,length(f_bins)*bin_res,0,25*10^-6]);
xlabel('Frekvens [kHz]');
ylabel('Amplitude')
grid; grid MINOR;
%%
% Det oprindelige FIR filters respons
if show_fig_1 == true
    figure(2);
    freqz(h, 1, 2^10, f_s)
end