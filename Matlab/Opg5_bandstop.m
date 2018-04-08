
%% undersoeg downsamplet signal
 %fft 
 plot(abs(2/length(out)*fft(out,22050)))
 ylabel('Magnitude')
 xlabel('Frequency (Hz)')
 axis([0,200,0,0.0019]);

%% frekvensrespons af notch
 freqz(b,a,22050,22050)
 subplot(211)
 axis([0,11025,-125,25])
 subplot(212)
 axis([0,11025,-100,100])
 
%% frekvensrespons af notch (zoomet)
 freqz(b,a,22050,22050)
 subplot(211)
 axis([0,200,-125,25]);
 subplot(212)
 axis([0,200,-100,100]);
%% 2. ordens Pole-zero placement (notch)
 
 %Overfoerings funktions taellere
 b=[1.058938864 -2.117662774 1.058938864];
 %overfoering funktions naevnere
 a=[1 -1.992673940 0.9928888943];
 %filtrer det downsamplet signal
 out2 = filter(b,a,out);
 %plotter fft foer efter filteret for 0-200 hz
 plot(abs(2/length(out)*fft(out,22050)))
 axis([0,200,0,0.0019]);
 hold on
 plot(abs(2/length(out2)*fft(out2,22050)))
 axis([0,200,0,0.0019]);
 hold off
 ylabel('Magnitude')
 xlabel('Frequency (Hz)')
 legend('Original Signal','Bandstop Signal')
 
%% frekvensrespons af Butterworth baandstop
 freqz(b1,a1,22050,22050)
 subplot(211)
 axis([0,11025,-50,10])
 subplot(212)
 axis([0,11025,-400,0])
%% frekvensrespons af Butterworth baandstop (zoomet)
 freqz(b1,a1,22050,22050)
 subplot(211)
 axis([0,200,-50,10])
 subplot(212)
 axis([0,200,-400,0])
 
%% Butterworth baandstop filter

 %Overfoerings funktions taellere
 b1=[.9916396730 -3.966156106 5.949032907 -3.966156106 .9916396730];
 %overfoering funktions naevnere
 a1=[1 -3.982805171 5.948963011 -3.949507041 .9833492444];
 %filtrer det downsamplet signal
 out7 = filter(b1,a1,out);
 %plotter fft foer efter filteret for 0-200 hz
 plot(abs(2/length(out)*fft(out,22050)))
 axis([0,200,0,0.0019]);
 hold on
 plot(abs(2/length(out7)*fft(out7,22050)))
 axis([0,200,0,0.0019]);
 hold off
 ylabel('Magnitude')
 xlabel('Frequency (Hz)')
 legend('Original Signal','Bandstop Signal')
 
%% fft noise 
 %filtrerer signalet med Notch filteret
 out_noise1 = filter(b,a,out_noise);
 %plotter amplitude spektrum foer notch
 plot(abs(2/length(out_noise)*fft(out_noise,22050)))
 axis([0,200,0,0.0019]);
 hold on
 %plotter amplitude spektrum efter Notch
 plot(abs(2/length(out_noise1)*fft(out_noise1,22050)))
 axis([0,200,0,0.0019]);
 hold off
 ylabel('Magnitude')
 xlabel('Frequency (Hz)')
 legend('Original Signal','Bandstop Signal')
 
%% plot noise
 %plotter signalet foer Notch
  plot(out_noise)
  axis([0,120000,-0.2,0.2]);
 hold on
 %plotter signalet efter Notch
  plot(out_noise1)
  axis([0,120000,-0.2,0.2]);
 hold off