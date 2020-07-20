%% Testes do novo modelo com SRF 18/02/2019
clear all
clc




%% Funções para edição de figuras

addpath(genpath('altmany-export_fig-412662f/'));




%% Dados

C = 9000e-6;
N = 20;

SN = 100e6;
Vdc0 = 150e3;

L = 19e-3;
R = 1;

Lf = 20e-3;
Rf = 1;


f0 = 60;
w0 = 2*pi*f0;

Cf = 20e-6;


%% Definições

I = eye(3);

s = tf('s');

Ceq = C/N;

Z = L*s + R;
Zf = Lf*s + Rf;


W = [0 -w0 0;w0 0 0;0 0 0];
sdq = W + s.*I;




%% Controlador de corrente

kpi = 0.001;
Tii = 0.01;
kii = kpi/Tii;

Gi = kpi + kii/s;

Gidq = [Gi 0 0;0 Gi 0;0 0 0];

Didq = ((L+2*Lf)/Vdc0).*W;

%% Modelo Norton

Gchar = I + (4*Vdc0*Ceq.*sdq + (2*SN/(3*Vdc0)).*I)*Gidq + 4*Ceq*(Z+2*Zf).*sdq -(2*SN/(3*Vdc0)).*Didq;

Yac = 8*Ceq.*inv(Gchar)*sdq;

Gnorton = inv(Gchar)*(4*Vdc0*Ceq.*sdq + (2*SN/(3*Vdc0)).*I)*Gidq; % este é o Gicl


%% bode Yac_dd


psim_Y_ac =  csvread('Dados/psim_teste_dq/resp_freq_Yac_dd.csv',0,0);

Freq_Yac_psim = psim_Y_ac(:,4);

phase_Yac_psim = rad2deg(atan(psim_Y_ac(:,3)./psim_Y_ac(:,2))); 
phase_Yac_psim(1) = 74.13;

mag_Yac_psim = 20.*log10(2.*sqrt((psim_Y_ac(:,2)./0.7).^2+(psim_Y_ac(:,3)./0.7).^2)./1000);


%bode(Yac(1,1))

%psim_teste_dq


%% Resposta em frequencia para Y_ac_dd 

[mag_Y_ac_dd,phase_Y_ac_dd,wout_Y_ac_dd] = bode(Yac(1,1),{1*2*pi,1000*2*pi});
mag_Y_ac_dd = 20*log10(squeeze(mag_Y_ac_dd));
phase_Y_ac_dd = squeeze(phase_Y_ac_dd);




%% Comparação de Y_ac_dd com o resultado do  psim - Mudança de fonte

H = figure;
set(H,'Position',[50 100 1280 600]);

font = 28;

axes('Position',[0.09 0.58 0.89 0.4])
hold on
h1 = plot(wout_Y_ac_dd./(2*pi),mag_Y_ac_dd,'linewidth',2.0);
h2 = plot(Freq_Yac_psim,mag_Yac_psim,'or','linewidth',2.0);
hold off
xlim([1 1000])
ylim([-65 -35])
grid
set(gca,'FontSize',font, 'XScale', 'log','FontName','calibri Italic','TickLabelInterpreter','latex');
set(gca,'YTick',[-60 -50 -40 -35],'YTickLabel',{-60 -50 -40 '^' });

yl1 = ylabel('Magnitude - dB ','FontSize',font,'FontName','calibri Italic','Interpreter','latex')

set(gca,'XTickLabel',{})
set(gca,'GridAlpha',0.5,'MinorGridAlpha',0.8)
leg = legend('Linearized Model','Non-Linear Model','Location','southeast');
leg.FontSize = 0.8*font;
leg.Interpreter = 'latex';

axes('Position',[0.09 0.15 0.89 0.4])
hold on
h1 = plot(wout_Y_ac_dd./(2*pi),(phase_Y_ac_dd),'linewidth',2.0);
h2 = plot(Freq_Yac_psim,phase_Yac_psim,'or','linewidth',2.0);
hold off
xlim([1 1000])
grid
ylim([-100 100])

set(gca,'FontSize',font, 'XScale', 'log','FontName','calibri Italic','XTick',[1 10 100 1000],'TickLabelInterpreter','latex');
set(gca,'YTick',[-90 -45 0 45 90 100],'YTickLabel',{-90, -45, 0, 45, 90,'^'})
set(gca,'GridAlpha',0.5,'MinorGridAlpha',0.8)
xl1 = xlabel('Frequency - Hz','FontSize',font,'FontName','calibri','Interpreter','latex')
yl2 = ylabel('Phase - deg ','FontSize',font,'FontName','calibri','Interpreter','latex')


yl2.Position(1) = yl2.Position(1) - 0.03;
yl1.Position(1) = yl2.Position(1);

xl1.Position(2) = xl1.Position(2) +10;

%export_fig 'figs/artigo2/bode_Y_ca_dd' '-png' -transparent -painters -r400



%% bode Yac_0


psim_Y_ac_0 =  csvread('Dados/psim_teste_dq/resp_freq_Yac_0.csv',0,0);

Freq_Yac_psim_0 = psim_Y_ac_0(:,2);

phase_Yac_psim_0 = rad2deg(atan(psim_Y_ac_0(:,4)./psim_Y_ac_0(:,3))); 
phase_Yac_psim_0(1) = 101.3;
phase_Yac_psim_0(25) = -94.0900;
phase_Yac_psim_0(26) = -95.0100;
phase_Yac_psim_0(27) = -95.9100;
phase_Yac_psim_0(28) = -96.7800;
phase_Yac_psim_0(29) = -97.6400;

mag_Yac_psim_0 = 20.*log10(sqrt((psim_Y_ac_0(:,3)).^2+(psim_Y_ac_0(:,4)).^2)./1000);
mag_Yac_psim_0(1)= -32.6;



%% Resposta em frequencia para Y_ac_0 

[mag_Y_ac_0,phase_Y_ac_0,wout_Y_ac_0] = bode(Yac(3,3),{1*2*pi,1000*2*pi});
mag_Y_ac_0 = 20*log10(squeeze(mag_Y_ac_0));
phase_Y_ac_0 = squeeze(phase_Y_ac_0);




%% Comparação de Y_ac_0 com o resultado do  psim - mudança de fonte

H = figure;
set(H,'Position',[50 100 1280 600]);

font = 28;

axes('Position',[0.09 0.58 0.89 0.4])
hold on
h1 = plot(wout_Y_ac_0./(2*pi),mag_Y_ac_0,'linewidth',2.0);
h2 = plot(Freq_Yac_psim_0,mag_Yac_psim_0,'or','linewidth',2.0);
hold off
xlim([1 1000])
ylim([-50 5])
grid
set(gca,'FontSize',font, 'XScale', 'log','FontName','calibri Italic','TickLabelInterpreter','latex');
%set(gca,'YTick',[-50 -30 -10 0],'YTickLabel',{-50 -30 -10 '^' });
set(gca,'YTick',[-45 -30 -15 0 5],'YTickLabel',{-45 -30 -15 0 '^' });


yl1 = ylabel('Magnitude - dB ','FontSize',font,'FontName','calibri Italic','Interpreter','latex')

set(gca,'XTickLabel',{})
set(gca,'GridAlpha',0.5,'MinorGridAlpha',0.8)
leg = legend('Linearized Model','Non-Linear Model','Location','northeast');
leg.FontSize = 0.8*font;
leg.Interpreter = 'latex';

axes('Position',[0.09 0.15 0.89 0.4])
hold on
h1 = plot(wout_Y_ac_0./(2*pi),wrapTo180(phase_Y_ac_0),'linewidth',2.0);
h2 = plot(Freq_Yac_psim_0,phase_Yac_psim_0,'or','linewidth',2.0);
hold off
xlim([1 1000])
grid
ylim([-100 100])

set(gca,'FontSize',font, 'XScale', 'log','FontName','calibri Italic','XTick',[1 10 100 1000],'TickLabelInterpreter','latex');
set(gca,'YTick',[-90 -45 0 45 90 100],'YTickLabel',{-90, -45, 0, 45, 90,'^'})
set(gca,'GridAlpha',0.5,'MinorGridAlpha',0.8)
xl1 = xlabel('Frequency - Hz','FontSize',font,'FontName','calibri','Interpreter','latex')
yl2 = ylabel('Phase - deg ','FontSize',font,'FontName','calibri','Interpreter','latex')


yl2.Position(1) = yl2.Position(1) - 0.03;
yl1.Position(1) = yl2.Position(1);

xl1.Position(2) = xl1.Position(2) +10;

% export_fig 'figs/artigo2/bode_Y_ca_0' '-png' -transparent -painters -r400


%% bode Gi_dd


psim_Gi_dd =  csvread('Dados/psim_teste_dq/resp_freq_Gi_dd.csv',0,0);

Freq_Gi_dd_psim = psim_Gi_dd(:,4);

phase_Gi_dd_psim = rad2deg(atan(psim_Gi_dd(:,3)./psim_Gi_dd(:,2))); 
phase_Gi_dd_psim(1) = -0.9;

mag_Gi_dd_psim = 20.*log10(2.*sqrt((psim_Gi_dd(:,2)./0.7).^2+(psim_Gi_dd(:,3)./0.7).^2)./100);
mag_Gi_dd_psim(1) = -0.05;


%% Resposta em frequencia para Gi_dd 

[mag_Gi_dd,phase_Gi_dd,wout_Gi_dd] = bode(Gnorton(1,1),{1*2*pi,1000*2*pi});
mag_Gi_dd = 20*log10(squeeze(mag_Gi_dd));
phase_Gi_dd = squeeze(phase_Gi_dd);





%% Comparação de Gi_dd com o resultado do  psim - Mudança de fonte


H = figure;
set(H,'Position',[50 100 1280 600]);

font = 28;

axes('Position',[0.09 0.58 0.89 0.4])
hold on
h1 = plot(wout_Gi_dd./(2*pi),mag_Gi_dd,'linewidth',2.0);
h2 = plot(Freq_Gi_dd_psim,mag_Gi_dd_psim,'or','linewidth',2.0);
hold off
xlim([1 1000])
ylim([-10 1])
grid
set(gca,'FontSize',font, 'XScale', 'log','FontName','calibri Italic','TickLabelInterpreter','latex');
set(gca,'YTick',[-9 -6 -3 0 1],'YTickLabel',{-9 -6 -3 0 '^' });


yl1 = ylabel('Magnitude - dB ','FontSize',font,'FontName','calibri Italic','Interpreter','latex')

set(gca,'XTickLabel',{})
set(gca,'GridAlpha',0.5,'MinorGridAlpha',0.8)
leg = legend('Linearized Model','Non-Linear Model','Location','southwest');
leg.FontSize = 0.8*font;
leg.Interpreter = 'latex';

axes('Position',[0.09 0.15 0.89 0.4])
hold on
h1 = plot(wout_Gi_dd./(2*pi),wrapTo180(phase_Gi_dd),'linewidth',2.0);
h2 = plot(Freq_Gi_dd_psim,phase_Gi_dd_psim,'or','linewidth',2.0);
hold off
xlim([1 1000])
grid
%ylim([-100 100])
ylim([-100 10])

set(gca,'FontSize',font, 'XScale', 'log','FontName','calibri Italic','XTick',[1 10 100 1000],'TickLabelInterpreter','latex');
%set(gca,'YTick',[-90 -45 0 45 90 100],'YTickLabel',{-90, -45, 0, 45, 90,'^'})
set(gca,'YTick',[-90 -45 0 10],'YTickLabel',{-90, -45, 0,'^'})
set(gca,'GridAlpha',0.5,'MinorGridAlpha',0.8)
xl1 = xlabel('Frequency - Hz','FontSize',font,'FontName','calibri','Interpreter','latex')
yl2 = ylabel('Phase - deg ','FontSize',font,'FontName','calibri','Interpreter','latex')


yl2.Position(1) = yl2.Position(1) - 0.03;
yl1.Position(1) = yl2.Position(1);

xl1.Position(2) = xl1.Position(2) +10;

%export_fig 'figs/artigo2/bode_G_icl_dd' '-png' -transparent -painters -r400




%% bode Gi_dq


psim_Gi_dq =  csvread('Dados/psim_teste_dq/resp_freq_Gi_dq.csv',0,0);

Freq_Gi_dq_psim = psim_Gi_dq(:,4);

phase_Gi_dq_psim = rad2deg(atan(psim_Gi_dq(:,3)./psim_Gi_dq(:,2))); 
phase_Gi_dq_psim(1) = -0.9;

mag_Gi_dq_psim = 20.*log10(2.*sqrt((psim_Gi_dq(:,2)./0.7).^2+(psim_Gi_dq(:,3)./0.7).^2)./100);
mag_Gi_dq_psim(1) = -0.05;


%% Resposta em frequencia para Gi_dq 

[mag_Gi_dq,phase_Gi_dq,wout_Gi_dq] = bode(Gnorton(2,1),{1*2*pi,1000*2*pi});
mag_Gi_dq = 20*log10(squeeze(mag_Gi_dq));
phase_Gi_dq = squeeze(phase_Gi_dq);








%% Modelo de Thevenin


kpv = 0.01;
Tiv = 0.01;
kiv = kpv/Tiv;

Gv = kpv + kiv/s;

Gvdq = [Gv 0 0;0 Gv 0;0 0 0];

Gcharv = minreal(Gnorton*Gvdq + Yac);
Gcharv2 = minreal(Gnorton*Gvdq + Yac,0.1); % aproximação boa para o intervalo [1, 1000] Hz

Gcharvinv = minreal(inv(Gcharv));
Gcharvinv2 = minreal(inv(Gcharv2),0.1);  % aproximação boa para o intervalo [1, 1000] Hz
Gcharvinv3 = minreal(inv(Gcharv2),0.03);


%charV = I + Cf*Gcharvinv*sdq; % matlab acusa erro (não consegue calcular coisas tão grandes)
charV2 = I + Cf*Gcharvinv2*sdq;

%charVinv = inv(minreal(charV,0.2));
charVinv2 = inv(charV2);



Zth2 = charVinv2*Gcharvinv2;
Zth3 = charV2\Gcharvinv3;


Gth2 = (Zth3*Gnorton*Gvdq);


%% bode Zth_dq


psim_Zth_dq =  csvread('Dados/psim_teste_dq/resp_freq_Zthdq.csv',1,0);

Freq_Zth_dq_psim = psim_Zth_dq(:,6);

phase_Zth_dd_psim = rad2deg(atan(psim_Zth_dq(:,3)./psim_Zth_dq(:,2))); 
phase_Zth_dd_psim(1) = 86.4;
phase_Zth_dd_psim(29) = -89.3;

phase_Zth_dq_psim = rad2deg(atan2(psim_Zth_dq(:,5),psim_Zth_dq(:,4)));%rad2deg(atan(psim_Zth_dq(:,5)./psim_Zth_dq(:,4))); 
phase_Zth_dq_psim(1) = 170.5;

mag_Zth_dd_psim = 20.*log10(sqrt((psim_Zth_dq(:,2)).^2+(psim_Zth_dq(:,3)).^2)./100);
mag_Zth_dd_psim(1) = 20*log10(632.2/100);
mag_Zth_dd_psim(2) = 20*log10(5.5428e3/100);

mag_Zth_dq_psim = 20.*log10(sqrt((psim_Zth_dq(:,4)).^2+(psim_Zth_dq(:,5)).^2)./100);
mag_Zth_dq_psim(1) = 20*log10(30.52/100);
mag_Zth_dq_psim(2) = 20*log10(2.5934e3/100);



psim_Zth_0 =  csvread('Dados/psim_teste_dq/resp_freq_Zth0.csv',1,0);

Freq_Zth_0_psim = psim_Zth_dq(:,6);

phase_Zth_0_psim = rad2deg(atan2(psim_Zth_0(:,8),psim_Zth_0(:,7))); 
phase_Zth_0_psim(1) = -67.58;

mag_Zth_0_psim = 20.*log10(sqrt((psim_Zth_0(:,7)).^2+(psim_Zth_0(:,8)).^2)./1000);
mag_Zth_0_psim(1) = 20.*log10(4.1559e4/1000);


%% Resposta em frequencia para Zth_dq 

[mag_Zth_dd,phase_Zth_dd,wout_Zth_dd] = bode(Zth2(1,1),{1*2*pi,1000*2*pi});
mag_Zth_dd = 20*log10(squeeze(mag_Zth_dd));
phase_Zth_dd = squeeze(phase_Zth_dd);


[mag_Zth_dq,phase_Zth_dq,wout_Zth_dq] = bode(Zth2(1,2),{1*2*pi,1000*2*pi});
mag_Zth_dq = 20*log10(squeeze(mag_Zth_dq));
phase_Zth_dq = squeeze(phase_Zth_dq);

[mag_Zth_0,phase_Zth_0,wout_Zth_0] = bode(Zth2(3,3),{1*2*pi,1000*2*pi});
mag_Zth_0 = 20*log10(squeeze(mag_Zth_0));
phase_Zth_0 = squeeze(phase_Zth_0);


%% Comparação de Zth_dd com o resultado do  psim - Mudança de fonte


H = figure;
set(H,'Position',[50 100 1280 600]);

font = 28;

axes('Position',[0.09 0.58 0.89 0.4])
hold on
h1 = plot(wout_Zth_dd./(2*pi),mag_Zth_dd,'linewidth',2.0);
h2 = plot(Freq_Zth_dq_psim,mag_Zth_dd_psim,'or','linewidth',2.0);
hold off
xlim([1 1000])
ylim([16 38])
grid
set(gca,'FontSize',font, 'XScale', 'log','FontName','calibri Italic','TickLabelInterpreter','latex');
set(gca,'YTick',[20 25 30 35 38],'YTickLabel',{20 25 30 35 '^' });


yl1 = ylabel('Magnitude - dB ','FontSize',font,'FontName','calibri Italic','Interpreter','latex')

set(gca,'XTickLabel',{})
set(gca,'GridAlpha',0.5,'MinorGridAlpha',0.8)
leg = legend('Linearized Model','Non-Linear Model','Location','northwest');
leg.FontSize = 0.8*font;
leg.Interpreter = 'latex';

axes('Position',[0.09 0.15 0.89 0.4])
hold on
h1 = plot(wout_Zth_dd./(2*pi),wrapTo180(phase_Zth_dd),'linewidth',2.0);
h2 = plot(Freq_Zth_dq_psim,phase_Zth_dd_psim,'or','linewidth',2.0);
hold off
xlim([1 1000])
grid
ylim([-100 100])
%ylim([-100 10])

set(gca,'FontSize',font, 'XScale', 'log','FontName','calibri Italic','XTick',[1 10 100 1000],'TickLabelInterpreter','latex');
set(gca,'YTick',[-90 -45 0 45 90 100],'YTickLabel',{-90, -45, 0, 45, 90,'^'})
%set(gca,'YTick',[-90 -45 0 10],'YTickLabel',{-90, -45, 0,'^'})
set(gca,'GridAlpha',0.5,'MinorGridAlpha',0.8)
xl1 = xlabel('Frequency - Hz','FontSize',font,'FontName','calibri','Interpreter','latex')
yl2 = ylabel('Phase - deg ','FontSize',font,'FontName','calibri','Interpreter','latex')


yl2.Position(1) = yl2.Position(1) - 0.03;
yl1.Position(1) = yl2.Position(1);

xl1.Position(2) = xl1.Position(2) +10;

% export_fig 'figs/artigo2/bode_Z_th_dd' '-png' -transparent -painters -r400






%% Comparação de Zth_dq com o resultado do  psim - Mudança de fonte


H = figure;
set(H,'Position',[50 100 1280 600]);

font = 28;

axes('Position',[0.09 0.58 0.89 0.4])
hold on
h1 = plot(wout_Zth_dq./(2*pi),mag_Zth_dq,'linewidth',2.0);
h2 = plot(Freq_Zth_dq_psim,mag_Zth_dq_psim,'or','linewidth',2.0);
hold off
xlim([1 1000])
ylim([-14 34])
grid
set(gca,'FontSize',font, 'XScale', 'log','FontName','calibri Italic','TickLabelInterpreter','latex');
set(gca,'YTick',[-10 0 10 20 30 34],'YTickLabel',{-10 0 10 20 30 '^' });


yl1 = ylabel('Magnitude - dB ','FontSize',font,'FontName','calibri Italic','Interpreter','latex')

set(gca,'XTickLabel',{})
set(gca,'GridAlpha',0.5,'MinorGridAlpha',0.8)
leg = legend('Linearized Model','Non-Linear Model','Location','northwest');
leg.FontSize = 0.8*font;
leg.Interpreter = 'latex';

axes('Position',[0.09 0.15 0.89 0.4])
hold on
h1 = plot(wout_Zth_dq./(2*pi),wrapTo180(phase_Zth_dq),'linewidth',2.0);
h2 = plot(Freq_Zth_dq_psim,phase_Zth_dq_psim,'or','linewidth',2.0);
hold off
xlim([1 1000])
grid
%ylim([-100 100])
%ylim([-100 10])
ylim([-200 200])

set(gca,'FontSize',font, 'XScale', 'log','FontName','calibri Italic','XTick',[1 10 100 1000],'TickLabelInterpreter','latex');
set(gca,'YTick',[-180 -90 0 90 180 200],'YTickLabel',{-180 -90 0 90 180 '^'})
%set(gca,'YTick',[-90 -45 0 45 90 100],'YTickLabel',{-90, -45, 0, 45, 90,'^'})
%set(gca,'YTick',[-90 -45 0 10],'YTickLabel',{-90, -45, 0,'^'})
set(gca,'GridAlpha',0.5,'MinorGridAlpha',0.8)
xl1 = xlabel('Frequency - Hz','FontSize',font,'FontName','calibri','Interpreter','latex')
yl2 = ylabel('Phase - deg ','FontSize',font,'FontName','calibri','Interpreter','latex')


% yl2.Position(1) = yl2.Position(1) - 0.03;
yl2.Position(1) = yl2.Position(1) + 0.035;
yl1.Position(1) = yl2.Position(1);

xl1.Position(2) = xl1.Position(2) +10;


% export_fig 'figs/artigo2/bode_Z_th_dq' '-png' -transparent -painters -r400








%% Comparação de Zth_0 com o resultado do  psim - Mudança de fonte


H = figure;
set(H,'Position',[50 100 1280 600]);

font = 28;

axes('Position',[0.09 0.58 0.89 0.4])
hold on
h1 = plot(wout_Zth_0./(2*pi),mag_Zth_0,'linewidth',2.0);
h2 = plot(Freq_Zth_0_psim,mag_Zth_0_psim,'or','linewidth',2.0);
hold off
xlim([1 1000])
ylim([-2 62])
grid
set(gca,'FontSize',font, 'XScale', 'log','FontName','calibri Italic','TickLabelInterpreter','latex');
 set(gca,'YTick',[0 20 40 60 62],'YTickLabel',{0 20 40 60 '^' });


yl1 = ylabel('Magnitude - dB ','FontSize',font,'FontName','calibri Italic','Interpreter','latex')

set(gca,'XTickLabel',{})
set(gca,'GridAlpha',0.5,'MinorGridAlpha',0.8)
leg = legend('Linearized Model','Non-Linear Model','Location','northwest');
leg.FontSize = 0.8*font;
leg.Interpreter = 'latex';

axes('Position',[0.09 0.15 0.89 0.4])
hold on
h1 = plot(wout_Zth_0./(2*pi),wrapTo180(phase_Zth_0),'linewidth',2.0);
h2 = plot(Freq_Zth_0_psim,phase_Zth_0_psim,'or','linewidth',2.0);
hold off
xlim([1 1000])
grid
ylim([-100 100])
%ylim([-100 10])
% ylim([-200 200])

set(gca,'FontSize',font, 'XScale', 'log','FontName','calibri Italic','XTick',[1 10 100 1000],'TickLabelInterpreter','latex');
% set(gca,'YTick',[-180 -90 0 90 180 200],'YTickLabel',{-180 -90 0 90 180 '^'})
set(gca,'YTick',[-90 -45 0 45 90 100],'YTickLabel',{-90, -45, 0, 45, 90,'^'})
%set(gca,'YTick',[-90 -45 0 10],'YTickLabel',{-90, -45, 0,'^'})
set(gca,'GridAlpha',0.5,'MinorGridAlpha',0.8)
xl1 = xlabel('Frequency - Hz','FontSize',font,'FontName','calibri','Interpreter','latex')
yl2 = ylabel('Phase - deg ','FontSize',font,'FontName','calibri','Interpreter','latex')


yl2.Position(1) = yl2.Position(1) - 0.03;
% yl2.Position(1) = yl2.Position(1) + 0.035;
yl1.Position(1) = yl2.Position(1);

xl1.Position(2) = xl1.Position(2) +10;


% export_fig 'figs/artigo2/bode_Z_th_0' '-png' -transparent -painters -r400


%% bode Gth_dq


psim_Gth_dq =  csvread('Dados/psim_teste_dq/resp_freq_Gthdq.csv',1,0);

Freq_Gth_dq_psim = psim_Gth_dq(:,6);

phase_Gth_dd_psim = rad2deg(atan2(psim_Gth_dq(:,3),psim_Gth_dq(:,2))); 
phase_Gth_dd_psim(1) = -0.07;

phase_Gth_dq_psim = rad2deg(atan2(psim_Gth_dq(:,5),psim_Gth_dq(:,4)));%rad2deg(atan(psim_Zth_dq(:,5)./psim_Zth_dq(:,4))); 
phase_Gth_dq_psim(1) = 86.4;

mag_Gth_dd_psim = 20.*log10(sqrt((psim_Gth_dq(:,2)).^2+(psim_Gth_dq(:,3)).^2)./1000);
mag_Gth_dd_psim(1) = 20.*log10(1.0083e3/1000);


mag_Gth_dq_psim = 20.*log10(sqrt((psim_Gth_dq(:,4)).^2+(psim_Gth_dq(:,5)).^2)./1000);
mag_Gth_dq_psim(1) = 20.*log10(47.99/1000);


%% Resposta em frequencia para Gth_dq 

[mag_Gth_dd,phase_Gth_dd,wout_Gth_dd] = bode(Gth2(1,1),{1*2*pi,1000*2*pi});
mag_Gth_dd = 20*log10(squeeze(mag_Gth_dd));
phase_Gth_dd = squeeze(phase_Gth_dd);


[mag_Gth_dq,phase_Gth_dq,wout_Gth_dq] = bode(Gth2(1,2),{1*2*pi,1000*2*pi});
mag_Gth_dq = 20*log10(squeeze(mag_Gth_dq));
phase_Gth_dq = squeeze(phase_Gth_dq);







%% Comparação de Gth_dd com o resultado do  psim - Mudança de fonte


H = figure;
set(H,'Position',[50 100 1280 600]);

font = 28;

axes('Position',[0.09 0.58 0.89 0.4])
hold on
h1 = plot(wout_Gth_dd./(2*pi),mag_Gth_dd,'linewidth',2.0);
h2 = plot(Freq_Gth_dq_psim,mag_Gth_dd_psim,'or','linewidth',2.0);
hold off
xlim([1 1000])
ylim([-33 43])
grid
set(gca,'FontSize',font, 'XScale', 'log','FontName','calibri Italic','TickLabelInterpreter','latex');
set(gca,'YTick',[-20 0 20 40 43],'YTickLabel',{-20 0 20 40 '^' });


yl1 = ylabel('Magnitude - dB ','FontSize',font,'FontName','calibri Italic','Interpreter','latex')

set(gca,'XTickLabel',{})
set(gca,'GridAlpha',0.5,'MinorGridAlpha',0.8)
leg = legend('Linearized Model','Non-Linear Model','Location','northwest');
leg.FontSize = 0.8*font;
leg.Interpreter = 'latex';

axes('Position',[0.09 0.15 0.89 0.4])
hold on
h1 = plot(wout_Gth_dd./(2*pi),wrapTo180(phase_Gth_dd),'linewidth',2.0);
h2 = plot(Freq_Gth_dq_psim,phase_Gth_dd_psim,'or','linewidth',2.0);
hold off
xlim([1 1000])
grid
% ylim([-100 100])
%ylim([-100 10])
ylim([-200 200])

set(gca,'FontSize',font, 'XScale', 'log','FontName','calibri Italic','XTick',[1 10 100 1000],'TickLabelInterpreter','latex');
set(gca,'YTick',[-180 -90 0 90 180 200],'YTickLabel',{-180 -90 0 90 180 '^'})
% set(gca,'YTick',[-90 -45 0 45 90 100],'YTickLabel',{-90, -45, 0, 45, 90,'^'})
%set(gca,'YTick',[-90 -45 0 10],'YTickLabel',{-90, -45, 0,'^'})
set(gca,'GridAlpha',0.5,'MinorGridAlpha',0.8)
xl1 = xlabel('Frequency - Hz','FontSize',font,'FontName','calibri','Interpreter','latex')
yl2 = ylabel('Phase - deg ','FontSize',font,'FontName','calibri','Interpreter','latex')


%yl2.Position(1) = yl2.Position(1) - 0.03;
yl2.Position(1) = yl2.Position(1) + 0.035;
yl1.Position(1) = yl2.Position(1);

xl1.Position(2) = xl1.Position(2) +10;

%  export_fig 'figs/artigo2/bode_G_th_dd' '-png' -transparent -painters -r400



%% Comparação de Gth_dd com o resultado do  psim - Mudança de fonte

H = figure;
set(H,'Position',[50 100 1280 600]);

font = 28;

axes('Position',[0.09 0.58 0.89 0.4])
hold on
h1 = plot(wout_Gth_dq./(2*pi),mag_Gth_dq,'linewidth',2.0);
h2 = plot(Freq_Gth_dq_psim,mag_Gth_dq_psim,'or','linewidth',2.0);
hold off
xlim([1 1000])
ylim([-65 5])
grid
set(gca,'FontSize',font, 'XScale', 'log','FontName','calibri Italic','TickLabelInterpreter','latex');
set(gca,'YTick',[-60 -40 -20 0 5],'YTickLabel',{-60 -40 -20 0 '^' });


yl1 = ylabel('Magnitude - dB ','FontSize',font,'FontName','calibri Italic','Interpreter','latex')

set(gca,'XTickLabel',{})
set(gca,'GridAlpha',0.5,'MinorGridAlpha',0.8)
leg = legend('Linearized Model','Non-Linear Model','Location','southwest');
leg.FontSize = 0.8*font;
leg.Interpreter = 'latex';

axes('Position',[0.09 0.15 0.89 0.4])
hold on
h1 = plot(wout_Gth_dq./(2*pi),wrapTo180(phase_Gth_dq),'linewidth',2.0);
h2 = plot(Freq_Gth_dq_psim,phase_Gth_dq_psim,'or','linewidth',2.0);
hold off
xlim([1 1000])
grid
% ylim([-100 100])
%ylim([-100 10])
ylim([-200 200])

set(gca,'FontSize',font, 'XScale', 'log','FontName','calibri Italic','XTick',[1 10 100 1000],'TickLabelInterpreter','latex');
set(gca,'YTick',[-180 -90 0 90 180 200],'YTickLabel',{-180 -90 0 90 180 '^'})
% set(gca,'YTick',[-90 -45 0 45 90 100],'YTickLabel',{-90, -45, 0, 45, 90,'^'})
%set(gca,'YTick',[-90 -45 0 10],'YTickLabel',{-90, -45, 0,'^'})
set(gca,'GridAlpha',0.5,'MinorGridAlpha',0.8)
xl1 = xlabel('Frequency - Hz','FontSize',font,'FontName','calibri','Interpreter','latex')
yl2 = ylabel('Phase - deg ','FontSize',font,'FontName','calibri','Interpreter','latex')


%yl2.Position(1) = yl2.Position(1) - 0.03;
yl2.Position(1) = yl2.Position(1) + 0.035;
yl1.Position(1) = yl2.Position(1);

xl1.Position(2) = xl1.Position(2) +10;

% export_fig 'figs/artigo2/bode_G_th_dq' '-png' -transparent -painters -r400

%% Modelo de Ydc


kpcir = 0.01;
Ticir = 0.1;
kicir = kpcir/Ticir;

Gcir = kpcir + kicir/s;

Gcir2dq = [Gcir 0 0;0 Gcir 0;0 0 0];



s2dq = 2.*W + s.*I;

Gcharcir = I + 4*L*Ceq.*s2dq^2 + 4*R*Ceq.*s2dq + ((SN/(3*Vdc0))*I + 2*Vdc0*Ceq*s2dq)*Gcir2dq;

Gcharcir1 = I + 4*L*Ceq.*s2dq^2 + 4*R*Ceq.*s2dq;


Ydc = 2*Ceq.*inv(Gcharcir)*s2dq;
Ydc1 = 2*Ceq.*inv(Gcharcir1)*s2dq; % sem compensação de segundo harmonico



%% bode Ydc


psim_Y_dc =  csvread('Dados/psim_teste_dq/resp_freq_Ydc.csv',1,0);

Freq_Y_dc_psim = psim_Y_dc(:,6);

phase_Y_dc_psim = rad2deg(atan2(psim_Y_dc(:,8),psim_Y_dc(:,7))); 
phase_Y_dc_psim(1) = 75.16;


mag_Y_dc_psim = 20.*log10(sqrt((psim_Y_dc(:,7)).^2+(psim_Y_dc(:,8)).^2)./1000);
mag_Y_dc_psim(1) = 20.*log10(5.82/1000);


%% Resposta em frequencia para Y_dc 

[mag_Y_dc,phase_Y_dc,wout_Y_dc] = bode(Ydc(3,3),{1*2*pi,1000*2*pi});
mag_Y_dc = 20*log10(squeeze(mag_Y_dc));
phase_Y_dc = squeeze(phase_Y_dc);



[mag_Y_dc_dd,phase_Y_dc_dd,wout_Y_dc_dd] = bode(Ydc(1,1),{1*2*pi,1000*2*pi});
mag_Y_dc_dd = 20*log10(squeeze(mag_Y_dc_dd));
phase_Y_dc_dd = squeeze(phase_Y_dc_dd);


[mag_Y_dc_dd1,phase_Y_dc_dd1,wout_Y_dc_dd1] = bode(Ydc1(1,1),{1*2*pi,1000*2*pi});
mag_Y_dc_dd1 = 20*log10(squeeze(mag_Y_dc_dd1));
phase_Y_dc_dd1 = squeeze(phase_Y_dc_dd1);




[mag_Y_dc_dq,phase_Y_dc_dq,wout_Y_dc_dq] = bode(Ydc(1,2),{1*2*pi,1000*2*pi});
mag_Y_dc_dq = 20*log10(squeeze(mag_Y_dc_dq));
phase_Y_dc_dq = squeeze(phase_Y_dc_dq);


[mag_Y_dc_dq1,phase_Y_dc_dq1,wout_Y_dc_dq1] = bode(Ydc1(1,2),{1*2*pi,1000*2*pi});
mag_Y_dc_dq1 = 20*log10(squeeze(mag_Y_dc_dq1));
phase_Y_dc_dq1 = squeeze(phase_Y_dc_dq1);





%% Comparação de Y_dc com o resultado do  psim - Mudança de fonte


H = figure;
set(H,'Position',[50 100 1280 600]);

font = 28;

axes('Position',[0.09 0.58 0.89 0.4])
hold on
h1 = plot(wout_Y_dc./(2*pi),mag_Y_dc,'linewidth',2.0);
h2 = plot(Freq_Y_dc_psim,mag_Y_dc_psim,'or','linewidth',2.0);
hold off
xlim([1 1000])
ylim([-50 5])
grid
set(gca,'FontSize',font, 'XScale', 'log','FontName','calibri Italic','TickLabelInterpreter','latex');
set(gca,'YTick',[-45 -30 -15 0 5],'YTickLabel',{-45 -30 -15 0  '^' });


yl1 = ylabel('Magnitude - dB ','FontSize',font,'FontName','calibri Italic','Interpreter','latex')

set(gca,'XTickLabel',{})
set(gca,'GridAlpha',0.5,'MinorGridAlpha',0.8)
leg = legend('Linearized Model','Non-Linear Model','Location','northwest');
leg.FontSize = 0.8*font;
leg.Interpreter = 'latex';

axes('Position',[0.09 0.15 0.89 0.4])
hold on
h1 = plot(wout_Y_dc./(2*pi),wrapTo180(phase_Y_dc),'linewidth',2.0);
h2 = plot(Freq_Y_dc_psim,phase_Y_dc_psim,'or','linewidth',2.0);
hold off
xlim([1 1000])
grid
 ylim([-100 100])
% ylim([-100 10])
%ylim([-200 200])

set(gca,'FontSize',font, 'XScale', 'log','FontName','calibri Italic','XTick',[1 10 100 1000],'TickLabelInterpreter','latex');
% set(gca,'YTick',[-180 -90 0 90 180 200],'YTickLabel',{-180 -90 0 90 180 '^'})
set(gca,'YTick',[-90 -45 0 45 90 100],'YTickLabel',{-90, -45, 0, 45, 90,'^'})
%set(gca,'YTick',[-90 -45 0 10],'YTickLabel',{-90, -45, 0,'^'})
set(gca,'GridAlpha',0.5,'MinorGridAlpha',0.8)
xl1 = xlabel('Frequency - Hz','FontSize',font,'FontName','calibri','Interpreter','latex')
yl2 = ylabel('Phase - deg ','FontSize',font,'FontName','calibri','Interpreter','latex')


yl2.Position(1) = yl2.Position(1) - 0.03;
% yl2.Position(1) = yl2.Position(1) + 0.035;
yl1.Position(1) = yl2.Position(1);

xl1.Position(2) = xl1.Position(2) +10;



% export_fig 'figs/artigo2/bode_Y_dc' '-png' -transparent -painters -r400



%% Modelo de Thevenin single loop


kpvsl = 0.000001;
Tivsl = 0.01;
kivsl = kpvsl/Tivsl;

Gvsl = kpvsl + kivsl/s;

Gvdqsl = [Gvsl 0 0;0 Gvsl 0;0 0 0];

% Impedancias in SRF
Zdq = R*I + L*sdq; 
Zfdq = Rf*I + Lf*sdq; 

%Definiçoes
Gamma_vsl_in = 4*Ceq*sdq*(Zdq+2*Zfdq) + I;
Z_vsl_in = minreal(inv((4*Vdc0*Ceq*sdq + I*2*SN/(3*Vdc0))*Gvdqsl + 8*Ceq*sdq));
Gamma_vsl_out = minreal(Cf*Z_vsl_in*Gamma_vsl_in*sdq + I);


Gamma_vsl_out_inv = minreal(inv(Gamma_vsl_out));

% impedancia de Thevenin
Z_sl_th_1 = minreal(Z_vsl_in*Gamma_vsl_in);

Z_sl_th = minreal(Gamma_vsl_out_inv*Z_sl_th_1);



% ganho de Thevenin
G_sl_th_1 = minreal((4*Vdc0*Ceq*sdq + I*2*SN/(3*Vdc0))*Gvdqsl);
G_sl_th_2 = minreal(Z_vsl_in*G_sl_th_1);
G_sl_th = minreal(Gamma_vsl_out_inv*G_sl_th_2);
% minreal(Gamma_vsl_out_inv*Z_vsl_in);
% G_sl_th_2 = minreal(G_sl_th_1*); 


%% Resposta em frequencia para Zth_sl_dq 

[mag_Zth_sl_dd,phase_Zth_sl_dd,wout_Zth_sl_dd] = bode(Z_sl_th(1,1),{1*2*pi,1000*2*pi});
mag_Zth_sl_dd = 20*log10(squeeze(mag_Zth_sl_dd));
phase_Zth_sl_dd = squeeze(phase_Zth_sl_dd);


[mag_Zth_sl_dq,phase_Zth_sl_dq,wout_Zth_sl_dq] = bode(Z_sl_th(1,2),{1*2*pi,1000*2*pi});
mag_Zth_sl_dq = 20*log10(squeeze(mag_Zth_sl_dq));
phase_Zth_sl_dq = squeeze(phase_Zth_sl_dq);


[mag_Zth_sl_0,phase_Zth_sl_0,wout_Zth_sl_0] = bode(Z_sl_th(3,3),{1*2*pi,1000*2*pi});
mag_Zth_sl_0 = 20*log10(squeeze(mag_Zth_sl_0));
phase_Zth_sl_0 = squeeze(phase_Zth_sl_0);



[mag_Gth_sl_dd,phase_Gth_sl_dd,wout_Gth_sl_dd] = bode(G_sl_th(1,1),{1*2*pi,1000*2*pi});
mag_Gth_sl_dd = 20*log10(squeeze(mag_Gth_sl_dd));
phase_Gth_sl_dd = squeeze(phase_Gth_sl_dd);

[mag_Gth_sl_dq,phase_Gth_sl_dq,wout_Gth_sl_dq] = bode(G_sl_th(1,2),{1*2*pi,1000*2*pi});
mag_Gth_sl_dq = 20*log10(squeeze(mag_Gth_sl_dq));
phase_Gth_sl_dq = squeeze(phase_Gth_sl_dq);






%% bode Zth_sl_dq

psim_Zth_sl_dq = readtable('Dados/psim_teste_dq/resp_freq_Zthdq_sl.csv');
psim_Zth_sl_0 = readtable('Dados/psim_teste_dq/resp_freq_Zth0_sl.csv');
psim_Gth_sl_dq = readtable('Dados/psim_teste_dq/resp_freq_Gthdq_sl.csv');
%   Time,Vcc,Ssind,Scosd,Ssinq,Scosq,Ssin0,Scos0,Freq,S2.mpa,S2.mna   

Freq_Zth_sl_dq_psim = psim_Zth_sl_dq.Freq;
Freq_Zth_sl_0_psim = psim_Zth_sl_0.Freq;
Freq_Gth_sl_dq_psim = psim_Gth_sl_dq.Freq;
 
% 
mag_Zth_sl_dd_psim = 20.*log10(sqrt(psim_Zth_sl_dq.Ssind.^2 + psim_Zth_sl_dq.Scosd.^2)./100);
phase_Zth_sl_dd_psim = rad2deg(atan2(psim_Zth_sl_dq.Scosd,psim_Zth_sl_dq.Ssind)); 

mag_Zth_sl_dq_psim = 20.*log10(sqrt(psim_Zth_sl_dq.Ssinq.^2 + psim_Zth_sl_dq.Scosq.^2)./100);
phase_Zth_sl_dq_psim = rad2deg(atan2(psim_Zth_sl_dq.Scosq,psim_Zth_sl_dq.Ssinq)); 

mag_Zth_sl_0_psim = 20.*log10(sqrt(psim_Zth_sl_0.Ssin0.^2 + psim_Zth_sl_0.Scos0.^2)./100);
phase_Zth_sl_0_psim = rad2deg(atan2(psim_Zth_sl_0.Scos0,psim_Zth_sl_0.Ssin0)); 
% 


mag_Gth_sl_dd_psim = 20.*log10(sqrt(psim_Gth_sl_dq.Ssind.^2 + psim_Gth_sl_dq.Scosd.^2)./1000);
phase_Gth_sl_dd_psim = rad2deg(atan2(psim_Gth_sl_dq.Scosd,psim_Gth_sl_dq.Ssind)); 

mag_Gth_sl_dq_psim = 20.*log10(sqrt(psim_Gth_sl_dq.Ssinq.^2 + psim_Gth_sl_dq.Scosq.^2)./1000);
phase_Gth_sl_dq_psim = rad2deg(atan2(psim_Gth_sl_dq.Scosq,psim_Gth_sl_dq.Ssinq)); 



%% pos processamento
% O MATLAB, ás vezes, coloca uma fase em -180, mas o bode do modelo teorico indica +180 (que é a mesme coisa)
% Aqui estou corrigindo na marra essas coisas

phase_Zth_sl_dq_psim(find(Freq_Zth_sl_dq_psim==700)) = phase_Zth_sl_dq_psim(find(Freq_Zth_sl_dq_psim==700))-360;
phase_Zth_sl_dq_psim(find(Freq_Zth_sl_dq_psim==800)) = phase_Zth_sl_dq_psim(find(Freq_Zth_sl_dq_psim==800))-360;
phase_Zth_sl_dq_psim(find(Freq_Zth_sl_dq_psim==900)) = phase_Zth_sl_dq_psim(find(Freq_Zth_sl_dq_psim==900))-360;
phase_Zth_sl_dq_psim(find(Freq_Zth_sl_dq_psim==1000)) = phase_Zth_sl_dq_psim(find(Freq_Zth_sl_dq_psim==1000))-360;
phase_Zth_sl_dq_psim(find(Freq_Zth_sl_dq_psim==120)) = phase_Zth_sl_dq_psim(find(Freq_Zth_sl_dq_psim==120))+360;
phase_Zth_sl_dq_psim(find(Freq_Zth_sl_dq_psim==10)) = phase_Zth_sl_dq_psim(find(Freq_Zth_sl_dq_psim==10))-360;
phase_Zth_sl_dq_psim(find(Freq_Zth_sl_dq_psim==30)) = phase_Zth_sl_dq_psim(find(Freq_Zth_sl_dq_psim==30))-360;
phase_Zth_sl_dq_psim(find(Freq_Zth_sl_dq_psim==50)) = phase_Zth_sl_dq_psim(find(Freq_Zth_sl_dq_psim==50))-360;
phase_Zth_sl_dq_psim(find(Freq_Zth_sl_dq_psim==70)) = phase_Zth_sl_dq_psim(find(Freq_Zth_sl_dq_psim==70))-360;





%% Comparação de Zth_sl_dd com o resultado do  psim - Mudança de fonte


H = figure;
set(H,'Position',[50 100 1280 600]);

font = 28;

axes('Position',[0.09 0.58 0.89 0.4])
hold on
h1 = plot(wout_Zth_sl_dd./(2*pi),mag_Zth_sl_dd,'linewidth',2.0);
h2 = plot(Freq_Zth_sl_dq_psim,mag_Zth_sl_dd_psim,'or','linewidth',2.0);
hold off
xlim([1 1000])
ylim([-10 65])
grid
set(gca,'FontSize',font, 'XScale', 'log','FontName','calibri Italic','TickLabelInterpreter','latex');
set(gca,'YTick',[0 20 40 60 65],'YTickLabel',{0 20 40 60  '^' });


yl1 = ylabel('Magnitude - dB ','FontSize',font,'FontName','calibri Italic','Interpreter','latex')

set(gca,'XTickLabel',{})
set(gca,'GridAlpha',0.5,'MinorGridAlpha',0.8)
leg = legend('Linearized Model','Non-Linear Model','Location','northwest');
leg.FontSize = 0.8*font;
leg.Interpreter = 'latex';

axes('Position',[0.09 0.15 0.89 0.4])
hold on
h1 = plot(wout_Zth_sl_dd./(2*pi),wrapTo180(phase_Zth_sl_dd),'linewidth',2.0);
h2 = plot(Freq_Zth_sl_dq_psim,phase_Zth_sl_dd_psim,'or','linewidth',2.0);
hold off
xlim([1 1000])
grid
%ylim([-100 100])
%ylim([-100 10])
ylim([-120 120])

set(gca,'FontSize',font, 'XScale', 'log','FontName','calibri Italic','XTick',[1 10 100 1000],'TickLabelInterpreter','latex');
set(gca,'YTick',[-180 -90 0 90 180 200],'YTickLabel',{-180 -90 0 90 180 '^'})
%set(gca,'YTick',[-90 -45 0 45 90 100],'YTickLabel',{-90, -45, 0, 45, 90,'^'})
set(gca,'YTick',[-90 0 90 120],'YTickLabel',{-90 0 90 '^'})
set(gca,'GridAlpha',0.5,'MinorGridAlpha',0.8)
xl1 = xlabel('Frequency - Hz','FontSize',font,'FontName','calibri','Interpreter','latex')
yl2 = ylabel('Phase - deg ','FontSize',font,'FontName','calibri','Interpreter','latex')


% yl2.Position(1) = yl2.Position(1) - 0.03;
yl2.Position(1) = yl2.Position(1) + 0.035;
yl1.Position(1) = yl2.Position(1);

xl1.Position(2) = xl1.Position(2) +10;


% export_fig 'figs/artigo2/bode_Z_th_sl_dd' '-png' -transparent -painters -r400




%% Comparação de Zth_sl_dq com o resultado do  psim - Mudança de fonte


H = figure;
set(H,'Position',[50 100 1280 600]);

font = 28;

axes('Position',[0.09 0.58 0.89 0.4])
hold on
h1 = plot(wout_Zth_sl_dq./(2*pi),mag_Zth_sl_dq,'linewidth',2.0);
h2 = plot(Freq_Zth_sl_dq_psim,mag_Zth_sl_dq_psim,'or','linewidth',2.0);
hold off
xlim([1 1000])
ylim([-10 65])
grid
set(gca,'FontSize',font, 'XScale', 'log','FontName','calibri Italic','TickLabelInterpreter','latex');
set(gca,'YTick',[0 20 40 60 65],'YTickLabel',{0 20 40 60  '^' });


yl1 = ylabel('Magnitude - dB ','FontSize',font,'FontName','calibri Italic','Interpreter','latex')

set(gca,'XTickLabel',{})
set(gca,'GridAlpha',0.5,'MinorGridAlpha',0.8)
leg = legend('Linearized Model','Non-Linear Model','Location','northwest');
leg.FontSize = 0.8*font;
leg.Interpreter = 'latex';

axes('Position',[0.09 0.15 0.89 0.4])
hold on
h1 = plot(wout_Zth_sl_dq./(2*pi),wrapTo180(phase_Zth_sl_dq),'linewidth',2.0);
h2 = plot(Freq_Zth_sl_dq_psim,phase_Zth_sl_dq_psim,'or','linewidth',2.0);
hold off
xlim([1 1000])
grid
%ylim([-100 100])
%ylim([-100 10])
ylim([-200 200])

set(gca,'FontSize',font, 'XScale', 'log','FontName','calibri Italic','XTick',[1 10 100 1000],'TickLabelInterpreter','latex');
set(gca,'YTick',[-180 -90 0 90 180 200],'YTickLabel',{-180 -90 0 90 180 '^'})
%set(gca,'YTick',[-90 -45 0 45 90 100],'YTickLabel',{-90, -45, 0, 45, 90,'^'})
%set(gca,'YTick',[-90 0 90 120],'YTickLabel',{-90 0 90 '^'})
set(gca,'GridAlpha',0.5,'MinorGridAlpha',0.8)
xl1 = xlabel('Frequency - Hz','FontSize',font,'FontName','calibri','Interpreter','latex')
yl2 = ylabel('Phase - deg ','FontSize',font,'FontName','calibri','Interpreter','latex')


% yl2.Position(1) = yl2.Position(1) - 0.03;
yl2.Position(1) = yl2.Position(1) + 0.035;
yl1.Position(1) = yl2.Position(1);

xl1.Position(2) = xl1.Position(2) +10;


% export_fig 'figs/artigo2/bode_Z_th_sl_dq' '-png' -transparent -painters -r400




%% Comparação de Zth_sl_0 com o resultado do  psim - Mudança de fonte


H = figure;
set(H,'Position',[50 100 1280 600]);

font = 28;

axes('Position',[0.09 0.58 0.89 0.4])
hold on
h1 = plot(wout_Zth_sl_0./(2*pi),mag_Zth_sl_0,'linewidth',2.0);
h2 = plot(Freq_Zth_sl_0_psim,mag_Zth_sl_0_psim,'or','linewidth',2.0);
hold off
xlim([1 1000])
%ylim([-10 65])
grid
set(gca,'FontSize',font, 'XScale', 'log','FontName','calibri Italic','TickLabelInterpreter','latex');
set(gca,'YTick',[0 20 40 60 65],'YTickLabel',{0 20 40 60  '^' });


yl1 = ylabel('Magnitude - dB ','FontSize',font,'FontName','calibri Italic','Interpreter','latex')

set(gca,'XTickLabel',{})
set(gca,'GridAlpha',0.5,'MinorGridAlpha',0.8)
leg = legend('Linearized Model','Non-Linear Model','Location','northwest');
leg.FontSize = 0.8*font;
leg.Interpreter = 'latex';

axes('Position',[0.09 0.15 0.89 0.4])
hold on
h1 = plot(wout_Zth_sl_0./(2*pi),wrapTo180(phase_Zth_sl_0),'linewidth',2.0);
h2 = plot(Freq_Zth_sl_0_psim,phase_Zth_sl_0_psim,'or','linewidth',2.0);
hold off
xlim([1 1000])
grid
%ylim([-100 100])
%ylim([-100 10])
ylim([-200 200])

set(gca,'FontSize',font, 'XScale', 'log','FontName','calibri Italic','XTick',[1 10 100 1000],'TickLabelInterpreter','latex');
set(gca,'YTick',[-180 -90 0 90 180 200],'YTickLabel',{-180 -90 0 90 180 '^'})
%set(gca,'YTick',[-90 -45 0 45 90 100],'YTickLabel',{-90, -45, 0, 45, 90,'^'})
%set(gca,'YTick',[-90 0 90 120],'YTickLabel',{-90 0 90 '^'})
set(gca,'GridAlpha',0.5,'MinorGridAlpha',0.8)
xl1 = xlabel('Frequency - Hz','FontSize',font,'FontName','calibri','Interpreter','latex')
yl2 = ylabel('Phase - deg ','FontSize',font,'FontName','calibri','Interpreter','latex')


% yl2.Position(1) = yl2.Position(1) - 0.03;
yl2.Position(1) = yl2.Position(1) + 0.035;
yl1.Position(1) = yl2.Position(1);

xl1.Position(2) = xl1.Position(2) +10;


% export_fig 'figs/artigo2/bode_Z_th_sl_0' '-png' -transparent -painters -r400



%% Comparação de Gth_sl_dd com o resultado do  psim - Mudança de fonte


H = figure;
set(H,'Position',[50 100 1280 600]);

font = 28;

axes('Position',[0.09 0.58 0.89 0.4])
hold on
h1 = plot(wout_Gth_sl_dd./(2*pi),mag_Gth_sl_dd,'linewidth',2.0);
h2 = plot(Freq_Gth_sl_dq_psim,mag_Gth_sl_dd_psim,'or','linewidth',2.0);
hold off
xlim([1 1000])
ylim([-55 5])
grid
set(gca,'FontSize',font, 'XScale', 'log','FontName','calibri Italic','TickLabelInterpreter','latex');
set(gca,'YTick',[-40 -20 0 5],'YTickLabel',{-40 -20 0  '^' });


yl1 = ylabel('Magnitude - dB ','FontSize',font,'FontName','calibri Italic','Interpreter','latex')

set(gca,'XTickLabel',{})
set(gca,'GridAlpha',0.5,'MinorGridAlpha',0.8)
leg = legend('Linearized Model','Non-Linear Model','Location','southwest');
leg.FontSize = 0.8*font;
leg.Interpreter = 'latex';

axes('Position',[0.09 0.15 0.89 0.4])
hold on
h1 = plot(wout_Gth_sl_dd./(2*pi),wrapTo180(phase_Gth_sl_dd),'linewidth',2.0);
h2 = plot(Freq_Gth_sl_dq_psim,phase_Gth_sl_dd_psim,'or','linewidth',2.0);
hold off
xlim([1 1000])
grid
%ylim([-100 100])
%ylim([-100 10])
%ylim([-120 120])

set(gca,'FontSize',font, 'XScale', 'log','FontName','calibri Italic','XTick',[1 10 100 1000],'TickLabelInterpreter','latex');
%set(gca,'YTick',[-180 -90 0 90 180 200],'YTickLabel',{-180 -90 0 90 180 '^'})
%set(gca,'YTick',[-90 -45 0 45 90 100],'YTickLabel',{-90, -45, 0, 45, 90,'^'})
set(gca,'YTick',[-180 -90 0 90 180 200],'YTickLabel',{-180 -90 0 90 180 '^'})
set(gca,'GridAlpha',0.5,'MinorGridAlpha',0.8)
xl1 = xlabel('Frequency - Hz','FontSize',font,'FontName','calibri','Interpreter','latex')
yl2 = ylabel('Phase - deg ','FontSize',font,'FontName','calibri','Interpreter','latex')


% yl2.Position(1) = yl2.Position(1) - 0.03;
yl2.Position(1) = yl2.Position(1) + 0.035;
yl1.Position(1) = yl2.Position(1);

xl1.Position(2) = xl1.Position(2) +10;


%  export_fig 'figs/artigo2/bode_G_th_sl_dd' '-png' -transparent -painters -r400






%% Comparação de Gth_sl_dq com o resultado do  psim - Mudança de fonte


H = figure;
set(H,'Position',[50 100 1280 600]);

font = 28;

axes('Position',[0.09 0.58 0.89 0.4])
hold on
h1 = plot(wout_Gth_sl_dq./(2*pi),mag_Gth_sl_dq,'linewidth',2.0);
h2 = plot(Freq_Gth_sl_dq_psim,mag_Gth_sl_dq_psim,'or','linewidth',2.0);
hold off
xlim([1 1000])
ylim([-75 5])
grid
set(gca,'FontSize',font, 'XScale', 'log','FontName','calibri Italic','TickLabelInterpreter','latex');
set(gca,'YTick',[-60 -40 -20 0 5],'YTickLabel',{-60 -40 -20 0  '^' });


yl1 = ylabel('Magnitude - dB ','FontSize',font,'FontName','calibri Italic','Interpreter','latex')

set(gca,'XTickLabel',{})
set(gca,'GridAlpha',0.5,'MinorGridAlpha',0.8)
leg = legend('Linearized Model','Non-Linear Model','Location','northwest');
leg.FontSize = 0.8*font;
leg.Interpreter = 'latex';

axes('Position',[0.09 0.15 0.89 0.4])
hold on
h1 = plot(wout_Gth_sl_dq./(2*pi),wrapTo180(phase_Gth_sl_dq),'linewidth',2.0);
h2 = plot(Freq_Gth_sl_dq_psim,phase_Gth_sl_dq_psim,'or','linewidth',2.0);
hold off
xlim([1 1000])
grid
%ylim([-100 100])
%ylim([-100 10])
ylim([-200 200])

set(gca,'FontSize',font, 'XScale', 'log','FontName','calibri Italic','XTick',[1 10 100 1000],'TickLabelInterpreter','latex');
set(gca,'YTick',[-180 -90 0 90 180 200],'YTickLabel',{-180 -90 0 90 180 '^'})
%set(gca,'YTick',[-90 -45 0 45 90 100],'YTickLabel',{-90, -45, 0, 45, 90,'^'})
%set(gca,'YTick',[-90 0 90 120],'YTickLabel',{-90 0 90 '^'})
set(gca,'GridAlpha',0.5,'MinorGridAlpha',0.8)
xl1 = xlabel('Frequency - Hz','FontSize',font,'FontName','calibri','Interpreter','latex')
yl2 = ylabel('Phase - deg ','FontSize',font,'FontName','calibri','Interpreter','latex')


% yl2.Position(1) = yl2.Position(1) - 0.03;
yl2.Position(1) = yl2.Position(1) + 0.035;
yl1.Position(1) = yl2.Position(1);

xl1.Position(2) = xl1.Position(2) +10;


% export_fig 'figs/artigo2/bode_G_th_sl_dq' '-png' -transparent -painters -r400



