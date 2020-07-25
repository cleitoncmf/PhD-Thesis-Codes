%% Validation of the NRF models
% This script read the data obtained from the non-linear model and compares
% their results with the lineared transfer functions (models developed in the Thesis)
% It is also generated all the graphs used in the article: 
% A linearized small-signal Thévenin-equivalent model of a
% voltage-controlled modular multilevel converter
% https://doi.org/10.1016/j.epsr.2020.106231
clear all
clc


%% Figure edition API
% Copyright (c) 2014, Oliver J. Woodford, Yair M. Altman, All rights reserved.
addpath(genpath('altmany-export_fig-412662f/'));



%% MMC Parameters

C = 9000e-6;
N = 20;

SN = 100e6;
Vdc0 = 150e3;

L = 19e-3;
R = 1;

Lf = 20e-3;
Rf = 1;


f0 = 60;
w0 = 2*pi*60;

Cf = 20e-6;


%% Definitions


s = tf('s');

Ceq = C/N;

Zs = L*s + R;
Zfs = Lf*s + Rf;


%% Controllers

krcir = 0.1;


Gcir = -krcir*s/(s^2 + (2*w0)^2);

%% Transfer function of the circulating current loop

Y_cc_icir_s = 2*s*Ceq/(4*s*Ceq*Zs+1 - (SN/(3*Vdc0)+ 2*s*Ceq* Vdc0)*Gcir );



%% Frequency Response for Y_cc_icir_s 

[mag_Y_cc_icir_s,phase_Y_cc_icir_s,wout_Y_cc_icir_s] = bode(Y_cc_icir_s,{1*2*pi,1000*2*pi});
mag_Y_cc_icir_s = 20*log10(squeeze(mag_Y_cc_icir_s));
phase_Y_cc_icir_s = squeeze(phase_Y_cc_icir_s);



%% Frequence Response for Y_cc_icir_s considering the non-linear model data 

psim_Y_cc_icir_s =  csvread('Dados/psim_primeiro_teste/resp_vdc_para_icir.csv',1,0);

psim_vdc = 1000;
psim_f = psim_Y_cc_icir_s(:,1);
psim_AmpdB = 20.*log10(psim_Y_cc_icir_s(:,2)/psim_vdc);
psim_Ang = psim_Y_cc_icir_s(:,3);


%% Comparação de Y_cc_icir_s com o resultado do psim psim - mudanças de fontes


H = figure;
set(H,'Position',[50 100 1280 600]);

anot1 = annotation('textarrow',[0.65 0.7],[0.65 0.65],'String','120Hz', 'FontSize',18)

font = 28;

axes('Position',[0.09 0.58 0.89 0.4])
hold on
h1 = plot(wout_Y_cc_icir_s./(2*pi),mag_Y_cc_icir_s,'linewidth',2.0);
h2 = plot(psim_f,psim_AmpdB,'or','linewidth',2.0);
plot([120 120],[-50000 50000],'-.k','linewidth',1.2) % linha tracejuada
hold off
xlim([1 1000])
ylim([-200 10])
grid
set(gca,'FontSize',font, 'XScale', 'log','FontName','calibri Italic','TickLabelInterpreter','latex');
set(gca,'YTick',[-180 -120 -60 0 10],'YTickLabel',{-180 -120 -60 0  '^'});

yl1 = ylabel('Magnitude - dB ','FontSize',font,'FontName','calibri Italic','Interpreter','latex')

set(gca,'XTickLabel',{})
set(gca,'GridAlpha',0.5,'MinorGridAlpha',0.8)
leg = legend('Linearized Model','Non-Linear Model','Location','southeast');
leg.FontSize = 0.8*font;
leg.Interpreter = 'latex';

axes('Position',[0.09 0.15 0.89 0.4])
hold on
h1 = plot(wout_Y_cc_icir_s./(2*pi),(phase_Y_cc_icir_s),'linewidth',2.0);
h2 = plot(psim_f,psim_Ang,'or','linewidth',2.0);
plot([120 120],[-50000 50000],'-.k','linewidth',1.2) % linha tracejuada
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


%export_fig 'figs/artigo1/bode_Y_cc_icir_2' '-png' -transparent -painters -r200
set(H,'PaperUnits','points','PaperSize',[960 450])
%saveas(H, 'figs/Tese/Artigo1/bode_Y_cc_icir_2', 'pdf') %Save figure
%saveas(H, 'figs/Tese/Artigo1/bode_Y_cc_icir_2', 'svg') %Save figure
%saveas(H, 'figs/Tese/Artigo1/bode_Y_cc_icir_2', 'png') %Save figure


%% Zoom Comparação de Y_cc_icir_s com o resultado do psim psim - mudanças de fontes


H = figure;
set(H,'Position',[50 100 1280 300]);

font = 28;

axes('Position',[0.02 0.15 0.95 0.9])
hold on
h1 = plot(wout_Y_cc_icir_s./(2*pi),mag_Y_cc_icir_s,'linewidth',2.0);
h2 = plot(psim_f,psim_AmpdB,'or','linewidth',2.0);
plot([120 120],[-50000 50000],'-.k','linewidth',1.2) % linha tracejuada
hold off
xlim([100 140])
ylim([-200 10])
grid
set(gca,'FontSize',font, 'XScale', 'log','FontName','calibri Italic','TickLabelInterpreter','latex');
set(gca,'YTick',[-180 -120 -60 0 10],'YTickLabel',{-180 -120 -60 0  '^'});


set(gca,'GridAlpha',0.5,'MinorGridAlpha',0.8)

yl2.Position(1) = yl2.Position(1) - 0.03;
yl1.Position(1) = yl2.Position(1);

xl1.Position(2) = xl1.Position(2) +10;


%export_fig 'figs/artigo1/bode_Y_cc_icir_zoom' '-png' -transparent -painters -r400





%% Teste de deferentes ganhos para Y_cc_icir_s 


krcir1 = 0.01;
%krcir2 = 0.1;
krcir3 = 1;


Gcir1 = -krcir1*s/(s^2 + (2*w0)^2);
%Gcir2 = -krcir2*s/(s^2 + (2*w0)^2);
Gcir3 = -krcir3*s/(s^2 + (2*w0)^2);

Y_cc_icir_s1 = 2*s*Ceq/(4*s*Ceq*Zs+1 - (SN/(3*Vdc0)+ 2*s*Ceq* Vdc0)*Gcir1 );
%Y_cc_icir_s2 = 2*s*Ceq/(4*s*Ceq*Zs+1 - (SN/(3*Vdc0)+ 2*s*Ceq* Vdc0)*Gcir2 );
Y_cc_icir_s3 = 2*s*Ceq/(4*s*Ceq*Zs+1 - (SN/(3*Vdc0)+ 2*s*Ceq* Vdc0)*Gcir3 );




%% Bode com Variação dos ganhos de Gcir 


[mag_Y_cc_icir_s1,phase_Y_cc_icir_s1,wout_Y_cc_icir_s1] = bode(Y_cc_icir_s1,{1*2*pi,1000*2*pi});
mag_Y_cc_icir_s1 = 20*log10(squeeze(mag_Y_cc_icir_s1));
phase_Y_cc_icir_s1 = squeeze(phase_Y_cc_icir_s1);

[mag_Y_cc_icir_s3,phase_Y_cc_icir_s3,wout_Y_cc_icir_s3] = bode(Y_cc_icir_s3,{1*2*pi,1000*2*pi});
mag_Y_cc_icir_s3 = 20*log10(squeeze(mag_Y_cc_icir_s3));
phase_Y_cc_icir_s3 = squeeze(phase_Y_cc_icir_s3);







%% Bode com Variação dos ganhos de Gcir -  mudanças de fontes

H = figure;
set(H,'Position',[50 100 1280 600]);
%
annotation('textarrow',[0.65 0.7],[0.65 0.65],'String','120Hz', 'FontSize',18,'Color','r')
annotation('textarrow',[0.33 0.38],[0.65 0.65],'String','9.8Hz', 'FontSize',18,'Color','r')
annotation('textarrow',[0.46 0.51],[0.80 0.80],'String','26.8Hz', 'FontSize',18,'Color','r')
annotation('textarrow',[0.46 0.48],[0.65 0.65],'String','20.5Hz', 'FontSize',18,'Color','r')
annotation('textarrow',[0.89 0.84],[0.82 0.82],'String','339.1Hz', 'FontSize',18,'Color','r')
annotation('textarrow',[0.89 0.84],[0.82 0.82],'String','339.1Hz', 'FontSize',18,'Color','r')
annotation('textarrow',[0.65 0.74],[0.80 0.80],'String','157.1Hz', 'FontSize',18,'Color','r')

%plot([120 120],[-50000 50000],'-.k','linewidth',1.5) % linha tracejuada
font = 28;

axes('Position',[0.09 0.58 0.89 0.4])
hold on
h2 = plot(wout_Y_cc_icir_s1./(2*pi),mag_Y_cc_icir_s1,'--','linewidth',2.0);
h1 = plot(wout_Y_cc_icir_s./(2*pi),mag_Y_cc_icir_s,'linewidth',2.0);
h3 = plot(wout_Y_cc_icir_s3./(2*pi),mag_Y_cc_icir_s3,'k-.','linewidth',2.0);
plot([120 120],[-50000 50000],'-.r','linewidth',1.2) % linha tracejuada
plot([9.8 9.8],[-50000 50000],'-.r','linewidth',1.2) % linha tracejuada
plot([20.5 20.5],[-50000 50000],'-.r','linewidth',1.2) % linha tracejuada
plot([26.8 26.8],[-50000 50000],'-.r','linewidth',1.2) % linha tracejuada
%plot([124.3 124.3],[-50000 50000],'-.r','linewidth',1.2) % linha tracejuada
plot([157.1 157.1],[-50000 50000],'-.r','linewidth',1.2) % linha tracejuada
plot([339.1 339.1],[-50000 50000],'-.r','linewidth',1.2) % linha tracejuada
hold off
xlim([1 1000])
ylim([-200 10])
grid
set(gca,'FontSize',font, 'XScale', 'log','FontName','calibri Italic','TickLabelInterpreter','latex');
set(gca,'YTick',[-180 -120 -60 0 10],'YTickLabel',{-180 -120 -60 0  '^'});

yl1 = ylabel('Magnitude - dB ','FontSize',font,'FontName','calibri Italic','Interpreter','latex')

set(gca,'XTickLabel',{})
set(gca,'GridAlpha',0.5,'MinorGridAlpha',0.8)
leg = legend('$k_r^{cir}=0.01 A^{-1}rad/s$','$k_r^{cir}=0.10 A^{-1}rad/s$','$k_r^{cir}=1.00 A^{-1}rad/s$','Location','southeast');
leg.FontSize = 0.8*font;
leg.Interpreter = 'latex';

axes('Position',[0.09 0.15 0.89 0.4])
hold on
h2 = plot(wout_Y_cc_icir_s1./(2*pi),(phase_Y_cc_icir_s1),'--','linewidth',2.0);
h1 = plot(wout_Y_cc_icir_s./(2*pi),(phase_Y_cc_icir_s),'linewidth',2.0);
h2 = plot(wout_Y_cc_icir_s3./(2*pi),(phase_Y_cc_icir_s3),'k-.','linewidth',2.0);
plot([120 120],[-50000 50000],'-.r','linewidth',1.2) % linha tracejuada
plot([9.8 9.8],[-50000 50000],'-.r','linewidth',1.2) % linha tracejuada
plot([20.5 20.5],[-50000 50000],'-.r','linewidth',1.2) % linha tracejuada
plot([26.8 26.8],[-50000 50000],'-.r','linewidth',1.2) % linha tracejuada
%plot([124.3 124.3],[-50000 50000],'-.r','linewidth',1.2) % linha tracejuada
plot([157.1 157.1],[-50000 50000],'-.r','linewidth',1.2) % linha tracejuada
plot([339.1 339.1],[-50000 50000],'-.r','linewidth',1.2) % linha tracejuada
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

%export_fig 'figs/artigo1/bode_Y_cc_icir_var' '-png' -transparent -painters -r200
set(H,'PaperUnits','points','PaperSize',[960 450])
%saveas(H, 'figs/Tese/Artigo1/bode_Y_cc_icir_var', 'pdf') %Save figure
%saveas(H, 'figs/Tese/Artigo1/bode_Y_cc_icir_var', 'png') %Save figure

%% Funções da admitância de saída

kpi = 1e-4;
kri = 1e-2;

Gi = kpi + kri*s/(s^2+w0^2);

DenI = 4*s*Ceq*(Zs+2*Zfs) + (4*s*Ceq*Vdc0 + (2*SN/(3*Vdc0)))*Gi + 1;

Ycas = 8*s*Ceq/DenI;




%% Resposta em frequencia para Y_cc_icir_s 

[mag_Y_ca_i_s,phase_Y_ca_i_s,wout_Y_ca_i_s] = bode(Ycas,{1*2*pi,1000*2*pi});
mag_Y_ca_i_s = 20*log10(squeeze(mag_Y_ca_i_s));
phase_Y_ca_i_s = squeeze(phase_Y_ca_i_s);



%% Resultados do psim para  Y_ac_i_s 

psim_Y_ca_i_s =  csvread('Dados/psim_primeiro_teste/resp_vk_para_ik.csv',1,0);

psim_vca = 1000;
psim_f2 = psim_Y_ca_i_s(:,1);
psim_AmpdB2 = 20.*log10(psim_Y_ca_i_s(:,2)/psim_vca);
psim_Ang2 = psim_Y_ca_i_s(:,3);





%% Comparação de Y_ac_i_s com o resultado do psim - Mudanças nas fontes

H = figure;
set(H,'Position',[50 100 1280 600]);


font = 28;

%axes('Position',[0.08 0.55 0.9 0.4])
ha = axes('Position',[0.09 0.58 0.89 0.4]);
hold on
h1 = plot(wout_Y_ca_i_s./(2*pi),mag_Y_ca_i_s,'linewidth',2.0);
h2 = plot(psim_f2,psim_AmpdB2,'or','linewidth',2.0);
hold off
xlim([1 1000])
ylim([-170 20])
grid
set(gca,'FontSize',font, 'XScale', 'log','FontName','calibri Italic','TickLabelInterpreter','latex');
yl1 = ylabel('Magnitude - dB ','FontSize',font,'FontName','calibri Italic','Interpreter','latex')
set(gca,'YTick',[-150 -100 -50 0 20],'YTickLabel',{-150 -100 -50 0  '^'});
set(gca,'XTickLabel',{})
set(gca,'GridAlpha',0.5,'MinorGridAlpha',0.8)
leg = legend('Linearized Model','Non-Linear Model','Location','southeast');
leg.FontSize = 0.8*font;
leg.Interpreter = 'latex';

% set(ha, 'Box', 'on')

%axes('Position',[0.08 0.12 0.9 0.4])
axes('Position',[0.09 0.15 0.89 0.4])
hold on
h1 = plot(wout_Y_ca_i_s./(2*pi),(phase_Y_ca_i_s),'linewidth',2.0);
h2 = plot(psim_f2,psim_Ang2,'or','linewidth',2.0);
hold off
xlim([1 1000])
grid
set(gca,'FontSize',font, 'XScale', 'log','FontName','calibri Italic','XTick',[1 10 100 1000],'TickLabelInterpreter','latex');
%set(gca,'YTick',[-90 -45 0 45 90 100],'YTickLabel',{-90, -45, 0, 45, 90,'^'})
set(gca,'GridAlpha',0.5,'MinorGridAlpha',0.8)
xl1 = xlabel('Frequency - Hz','FontSize',font,'FontName','calibri','Interpreter','latex')
yl2 = ylabel('Phase - deg ','FontSize',font,'FontName','calibri','Interpreter','latex')

 
yl2.Position(1) = yl2.Position(1) + 0.03;
yl1.Position(1) = yl2.Position(1);
% 
xl1.Position(2) = xl1.Position(2) +10;

%export_fig 'figs/artigo1/bode_Y_ca_i' '-png' -transparent -painters -r200

set(H,'PaperUnits','points','PaperSize',[960 450])
%saveas(H, 'figs/Tese/Artigo1/bode_Y_ca_i', 'pdf') %Save figure
%saveas(H, 'figs/Tese/Artigo1/bode_Y_ca_i', 'png') %Save figure

%% Comparação de Y_ac_i_s com o resultado do psim - -  mudanças de fontes
H = figure;
set(H,'Position',[50 100 1280 600]);
anot1 = annotation('textarrow',[0.56 0.61],[0.65 0.65],'String','60Hz', 'FontSize',18)
%plot([120 120],[-50000 50000],'-.k','linewidth',1.5) % linha tracejuada
font = 28;

axes('Position',[0.09 0.58 0.89 0.4])
hold on
h1 = plot(wout_Y_ca_i_s./(2*pi),mag_Y_ca_i_s,'linewidth',2.0);
h2 = plot(psim_f2,psim_AmpdB2,'or','linewidth',2.0);
plot([60 60],[-50000 50000],'-.k','linewidth',1.2) % linha tracejuada
hold off
xlim([1 1000])
ylim([-200 10])
grid
set(gca,'FontSize',font, 'XScale', 'log','FontName','calibri Italic','TickLabelInterpreter','latex');
set(gca,'YTick',[-180 -120 -60 0 10],'YTickLabel',{-180 -120 -60 0  '^'});

yl1 = ylabel('Magnitude - dB ','FontSize',font,'FontName','calibri Italic','Interpreter','latex')

set(gca,'XTickLabel',{})
set(gca,'GridAlpha',0.5,'MinorGridAlpha',0.8)
leg = legend('Linearized Model','Non-Linear Model','Location','southeast');
leg.FontSize = 0.8*font;
leg.Interpreter = 'latex';

axes('Position',[0.09 0.15 0.89 0.4])
hold on
h1 = plot(wout_Y_ca_i_s./(2*pi),(phase_Y_ca_i_s),'linewidth',2.0);
h2 = plot(psim_f2,psim_Ang2,'or','linewidth',2.0);
plot([60 60],[-50000 50000],'-.k','linewidth',1.2) % linha tracejuada
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

% export_fig 'figs/artigo1/bode_Y_ca_i' '-png' -transparent -painters -r200
set(H,'PaperUnits','points','PaperSize',[960 450])
%saveas(H, 'figs/Tese/Artigo1/bode_Y_ca_i', 'pdf') %Save figure
%saveas(H, 'figs/Tese/Artigo1/bode_Y_ca_i', 'png') %Save figure


%% Funções de transferência de malha fechada da corrente

Gicl = (4*s*Ceq*Vdc0 + 2*SN/(3*Vdc0))*Gi/DenI;



%% Resposta em frequencia para Gicl

[mag_G_i_cl_s,phase_G_i_cl_s,wout_G_i_cl_s] = bode(Gicl,{1*2*pi,1000*2*pi});
mag_G_i_cl_s = 20*log10(squeeze(mag_G_i_cl_s));
phase_G_i_cl_s = squeeze(phase_G_i_cl_s);



%% Resultados do psim para  Gicl 

psim_Y_eref_i_s =  csvread('Dados/psim_primeiro_teste/resp_eref_para_ik.csv',1,0);

psim_i = 100;
psim_f3 = psim_Y_eref_i_s(:,1);
psim_AmpdB3 = 20.*log10(psim_Y_eref_i_s(:,2)/psim_i);
psim_Ang3 = psim_Y_eref_i_s(:,3);





%% Comparação de G_i_cl_s com o resultado do psim  -  mudanças de fontes
H = figure;
set(H,'Position',[50 100 1280 600]);
anot1 = annotation('textarrow',[0.57 0.62],[0.65 0.65],'String','63.57Hz', 'FontSize',18)
%plot([120 120],[-50000 50000],'-.k','linewidth',1.5) % linha tracejuada
font = 28;

axes('Position',[0.09 0.58 0.89 0.4])
hold on
h1 = plot(wout_G_i_cl_s./(2*pi),mag_G_i_cl_s,'linewidth',2.0);
h2 = plot(psim_f3,psim_AmpdB3,'or','linewidth',2.0);
plot([63.57 63.57],[-50000 50000],'-.k','linewidth',1.2) % linha tracejuada
hold off
xlim([1 1000])
ylim([-35 5])
grid
set(gca,'FontSize',font, 'XScale', 'log','FontName','calibri Italic','TickLabelInterpreter','latex');
set(gca,'YTick',[-30 -20 -10 0 5],'YTickLabel',{-30 -20 -10 0  '^'});

yl1 = ylabel('Magnitude - dB ','FontSize',font,'FontName','calibri Italic','Interpreter','latex')

set(gca,'XTickLabel',{})
set(gca,'GridAlpha',0.5,'MinorGridAlpha',0.8)
leg = legend('Linearized Model','Non-Linear Model','Location','southwest');
leg.FontSize = 0.8*font;
leg.Interpreter = 'latex';

axes('Position',[0.09 0.15 0.89 0.4])
hold on
h1 = plot(wout_G_i_cl_s./(2*pi),(phase_G_i_cl_s),'linewidth',2.0);
h2 = plot(psim_f3,psim_Ang3,'or','linewidth',2.0);
plot([63.57 63.57],[-50000 50000],'-.k','linewidth',1.2) % linha tracejuada
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

% export_fig 'figs/artigo1/bode_G_i_cl' '-png' -transparent -painters -r200
set(H,'PaperUnits','points','PaperSize',[960 450])
%saveas(H, 'figs/Tese/Artigo1/bode_G_i_cl', 'pdf') %Save figure
%saveas(H, 'figs/Tese/Artigo1/bode_G_i_cl', 'png') %Save figure




%% Funções de transferência para o modelo de Thevenin

kpv = 0.1;
krv = 1;

Gv = kpv + krv*s/(s^2+w0^2);

Zca = 1/(Ycas + Gicl*Gv);

Gvcl = Gicl*Gv/(Ycas + Gicl*Gv);


Zth = Zca/(s*Cf*Zca+1);

Gth = Gvcl/(s*Cf*Zca+1);




%% Resposta em frequencia para Zth

[mag_Zth,phase_Zth,wout_Zth] = bode(Zth,{1*2*pi,1000*2*pi});
mag_Zth = 20*log10(squeeze(mag_Zth));
phase_Zth = squeeze(phase_Zth);


%% Resultados do psim para  Zth

psim_Zth =  csvread('Dados/psim_primeiro_teste/resp_Zth.csv',1,0);


psim_f4 = psim_Zth(:,1);
psim_AmpdB4 = 20.*log10(psim_Zth(:,2));
psim_Ang4 = psim_Zth(:,3);






%% Comparação de Zth com o resultado do psim -  mudanças de fontes
H = figure;
set(H,'Position',[50 100 1280 600]);
annotation('textarrow',[0.56 0.61],[0.65 0.65],'String','60Hz', 'FontSize',18)
annotation('textarrow',[0.87 0.82],[0.65 0.65],'String','273.6Hz', 'FontSize',18)
%plot([120 120],[-50000 50000],'-.k','linewidth',1.5) % linha tracejuada
font = 28;

axes('Position',[0.09 0.58 0.89 0.4])
hold on
h1 = plot(wout_Zth./(2*pi),mag_Zth,'linewidth',2.0);
h2 = plot(psim_f4,psim_AmpdB4,'or','linewidth',2.0);
plot([60 60],[-50000 50000],'-.k','linewidth',1.2) % linha tracejuada
plot([273.6 273.6],[-50000 50000],'-.k','linewidth',1.2) % linha tracejuada
hold off
xlim([1 1000])
ylim([-5 50])
grid
set(gca,'FontSize',font, 'XScale', 'log','FontName','calibri Italic','TickLabelInterpreter','latex');
set(gca,'YTick',[0 15 30 45 50],'YTickLabel',{0 15 30 45  '^'});

yl1 = ylabel('Magnitude - dB ','FontSize',font,'FontName','calibri Italic','Interpreter','latex')

set(gca,'XTickLabel',{})
set(gca,'GridAlpha',0.5,'MinorGridAlpha',0.8)
leg = legend('Linearized Model','Non-Linear Model','Location','southwest');
leg.FontSize = 0.8*font;
leg.Interpreter = 'latex';

axes('Position',[0.09 0.15 0.89 0.4])
hold on
h1 = plot(wout_Zth./(2*pi),(phase_Zth),'linewidth',2.0);
h2 = plot(psim_f4,psim_Ang4,'or','linewidth',2.0);
plot([60 60],[-50000 50000],'-.k','linewidth',1.2) % linha tracejuada
plot([273.6 273.6],[-50000 50000],'-.k','linewidth',1.2) % linha tracejuada
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


%export_fig 'figs/artigo1/bode_Zth' '-png' -transparent -painters -r200
set(H,'PaperUnits','points','PaperSize',[960 450])
%saveas(H, 'figs/Tese/Artigo1/bode_Zth', 'pdf') %Save figure
%saveas(H, 'figs/Tese/Artigo1/bode_Zth', 'png') %Save figure




%% Resposta em frequencia para Gth

[mag_Gth,phase_Gth,wout_Gth] = bode(Gth,{1*2*pi,1000*2*pi});
mag_Gth = 20*log10(squeeze(mag_Gth));
phase_Gth = squeeze(phase_Gth);



%% Resultados do psim para  Gth

psim_Gth =  csvread('Dados/psim_primeiro_teste/resp_Gth.csv',1,0);


vref = 1000;

psim_f5 = psim_Gth(:,1);
psim_AmpdB5 = 20.*log10(psim_Gth(:,2)/vref);
psim_Ang5 = psim_Gth(:,3);



%% Comparação de Gth com o resultado do psim  -  mudanças de fontes
H = figure;
set(H,'Position',[50 100 1280 600]);
annotation('textarrow',[0.56 0.61],[0.65 0.65],'String','60Hz', 'FontSize',18)
annotation('textarrow',[0.87 0.82],[0.65 0.65],'String','273.6Hz', 'FontSize',18)
%plot([120 120],[-50000 50000],'-.k','linewidth',1.5) % linha tracejuada
font = 28;

axes('Position',[0.09 0.58 0.89 0.4])
hold on
h1 = plot(wout_Gth./(2*pi),mag_Gth,'linewidth',2.0);
h2 = plot(psim_f5,psim_AmpdB5,'or','linewidth',2.0);
plot([60 60],[-50000 50000],'-.k','linewidth',1.2) % linha tracejuada
plot([273.6 273.6],[-50000 50000],'-.k','linewidth',1.2) % linha tracejuada
hold off
xlim([1 1000])
ylim([-35 15])
grid
set(gca,'FontSize',font, 'XScale', 'log','FontName','calibri Italic','TickLabelInterpreter','latex');
set(gca,'YTick',[-30 -20 -10 0 10 15],'YTickLabel',{-30 -20 -10 0 10 '^'});

yl1 = ylabel('Magnitude - dB ','FontSize',font,'FontName','calibri Italic','Interpreter','latex')

set(gca,'XTickLabel',{})
set(gca,'GridAlpha',0.5,'MinorGridAlpha',0.8)
leg = legend('Linearized Model','Non-Linear Model','Location','southwest');
leg.FontSize = 0.8*font;
leg.Interpreter = 'latex';

axes('Position',[0.09 0.15 0.89 0.4])
hold on
h1 = plot(wout_Gth./(2*pi),(phase_Gth),'linewidth',2.0);
h2 = plot(psim_f5,psim_Ang5,'or','linewidth',2.0);
plot([60 60],[-50000 50000],'-.k','linewidth',1.2) % linha tracejuada
plot([273.6 273.6],[-50000 50000],'-.k','linewidth',1.2) % linha tracejuada
hold off
xlim([1 1000])
grid
ylim([-200 100])

set(gca,'FontSize',font, 'XScale', 'log','FontName','calibri Italic','XTick',[1 10 100 1000],'TickLabelInterpreter','latex');
set(gca,'YTick',[-180 -90 0 90 100],'YTickLabel',{-180 -90 0 90,'^'})
set(gca,'GridAlpha',0.5,'MinorGridAlpha',0.8)
xl1 = xlabel('Frequency - Hz','FontSize',font,'FontName','calibri','Interpreter','latex')
yl2 = ylabel('Phase - deg ','FontSize',font,'FontName','calibri','Interpreter','latex')


yl2.Position(1) = yl2.Position(1) + 0.032;
yl1.Position(1) = yl2.Position(1);

xl1.Position(2) = xl1.Position(2) +10;

%export_fig 'figs/artigo1/bode_Gth' '-png' -transparent -painters -r200
set(H,'PaperUnits','points','PaperSize',[960 450],'Resize','off')
%saveas(H, 'figs/Tese/Artigo1/bode_Gth', 'pdf') %Save figure
%saveas(H, 'figs/Tese/Artigo1/bode_Gth', 'svg') %Save figure
%saveas(H, 'figs/Tese/Artigo1/bode_Gth', 'png') %Save figure



%% Variação do ganho proporcional do controle de corrente

kpi11 = 1e-3;
kpi12 = 1e-5;

Gi11 = kpi11 + kri*s/(s^2+w0^2);
Gi12 = kpi12 + kri*s/(s^2+w0^2);


DenI11 = 4*s*Ceq*(Zs+2*Zfs) + (4*s*Ceq*Vdc0 + (2*SN/(3*Vdc0)))*Gi11 + 1;
DenI12 = 4*s*Ceq*(Zs+2*Zfs) + (4*s*Ceq*Vdc0 + (2*SN/(3*Vdc0)))*Gi12 + 1;

Ycas11 = 8*s*Ceq/DenI11;
Ycas12 = 8*s*Ceq/DenI12;

Gicl11 = (4*s*Ceq*Vdc0 + 2*SN/(3*Vdc0))*Gi11/DenI11;
Gicl12 = (4*s*Ceq*Vdc0 + 2*SN/(3*Vdc0))*Gi12/DenI12;


% Esta errado isso aqui: tem que colocar Ycas11 e Ycas12
%Gv1 = kpv1 + krv1*s/(s^2+w0^2);
Zca11 = 1/(Ycas + Gicl11*Gv);
Zca12 = 1/(Ycas + Gicl12*Gv);

Zth11 = Zca11/(s*Cf*Zca11+1);
Zth12 = Zca12/(s*Cf*Zca12+1);


%% resposta em frequencia variação de kpi

[mag_Zth11,phase_Zth11,wout_Zth11] = bode(Zth11,{1*2*pi,1000*2*pi});
mag_Zth11 = 20*log10(squeeze(mag_Zth11));
phase_Zth11 = squeeze(phase_Zth11);


[mag_Zth12,phase_Zth12,wout_Zth12] = bode(Zth12,{1*2*pi,1000*2*pi});
mag_Zth12 = 20*log10(squeeze(mag_Zth12));
phase_Zth12 = squeeze(phase_Zth12);



%% bode variação de kpi - mudanças de fontes
H = figure;
set(H,'Position',[50 100 1280 600]);
annotation('textarrow',[0.56 0.61],[0.65 0.65],'String','60Hz', 'FontSize',18,'Color','r')
annotation('textarrow',[0.83 0.81],[0.65 0.65],'String','273.6Hz', 'FontSize',18,'Color','r')
annotation('textarrow',[0.89 0.91],[0.75 0.75],'String','605.3Hz', 'FontSize',18,'Color','r')
annotation('textarrow',[0.73 0.78],[0.65 0.65],'String','213.5Hz', 'FontSize',18,'Color','r')
%plot([120 120],[-50000 50000],'-.k','linewidth',1.5) % linha tracejuada

font = 28;

axes('Position',[0.09 0.58 0.89 0.4])
hold on
h2 = plot(wout_Zth11./(2*pi),mag_Zth11,'--','linewidth',2.0);
h1 = plot(wout_Zth./(2*pi),mag_Zth,'linewidth',2.0);
h3 = plot(wout_Zth12./(2*pi),mag_Zth12,'k-.','linewidth',2.0);
plot([60 60],[-50000 50000],'-.r','linewidth',1.2) % linha tracejuada
plot([273.6 273.6],[-50000 50000],'-.r','linewidth',1.2) % linha tracejuada
plot([213.5 213.5],[-50000 50000],'-.r','linewidth',1.2) % linha tracejuada
plot([605.3 605.3],[-50000 50000],'-.r','linewidth',1.2) % linha tracejuada
hold off
xlim([1 1000])
ylim([-5 50])
grid
set(gca,'FontSize',font, 'XScale', 'log','FontName','calibri Italic','TickLabelInterpreter','latex');
set(gca,'YTick',[0 15 30 45 50],'YTickLabel',{0 15 30 45  '^'});

yl1 = ylabel('Magnitude - dB ','FontSize',font,'FontName','calibri Italic','Interpreter','latex')

set(gca,'XTickLabel',{})
set(gca,'GridAlpha',0.5,'MinorGridAlpha',0.8)
leg = legend('$k_p^{i}=0.00100 A^{-1}$','$k_p^{i}=0.00010 A^{-1}$','$k_p^{i}=0.00001 A^{-1}$','Location','southwest');
leg.FontSize = 0.8*font;
leg.Interpreter = 'latex';

axes('Position',[0.09 0.15 0.89 0.4])
hold on
h2 = plot(wout_Zth11./(2*pi),(phase_Zth11),'--','linewidth',2.0);
h1 = plot(wout_Zth./(2*pi),(phase_Zth),'linewidth',2.0);
h3 = plot(wout_Zth12./(2*pi),(phase_Zth12),'k-.','linewidth',2.0);
plot([60 60],[-50000 50000],'-.r','linewidth',1.2) % linha tracejuada
plot([273.6 273.6],[-50000 50000],'-.r','linewidth',1.2) % linha tracejuada
plot([213.5 213.5],[-50000 50000],'-.r','linewidth',1.2) % linha tracejuada
plot([605.3 605.3],[-50000 50000],'-.r','linewidth',1.2) % linha tracejuada
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

%export_fig 'figs/artigo1/bode_Zth_var1' '-png' -transparent -painters -r200
set(H,'PaperUnits','points','PaperSize',[960 450])
%saveas(H, 'figs/Tese/Artigo1/bode_Zth_var1', 'pdf') %Save figure
%saveas(H, 'figs/Tese/Artigo1/bode_Zth_var1', 'png') %Save figure



%% Variação do ganho ressonante do controle de corrente

kri21 = 0.00100;
kri22 = 0.050;

Gi21 = kpi + kri21*s/(s^2+w0^2);
Gi22 = kpi + kri22*s/(s^2+w0^2);


DenI21 = 4*s*Ceq*(Zs+2*Zfs) + (4*s*Ceq*Vdc0 + (2*SN/(3*Vdc0)))*Gi21 + 1;
DenI22 = 4*s*Ceq*(Zs+2*Zfs) + (4*s*Ceq*Vdc0 + (2*SN/(3*Vdc0)))*Gi22 + 1;

Ycas21 = 8*s*Ceq/DenI21;
Ycas22 = 8*s*Ceq/DenI22;

Gicl21 = (4*s*Ceq*Vdc0 + 2*SN/(3*Vdc0))*Gi21/DenI21;
Gicl22 = (4*s*Ceq*Vdc0 + 2*SN/(3*Vdc0))*Gi22/DenI22;

%errei isso aqui: tem que colocar Ycas21 e Ycas22
%Gv1 = kpv1 + krv1*s/(s^2+w0^2);
Zca21 = 1/(Ycas + Gicl21*Gv);
Zca22 = 1/(Ycas + Gicl22*Gv);

Zth21 = Zca21/(s*Cf*Zca21+1);
Zth22 = Zca22/(s*Cf*Zca22+1);


%% resposta em frequencia variação de kri

[mag_Zth21,phase_Zth21,wout_Zth21] = bode(Zth21,{1*2*pi,1000*2*pi});
mag_Zth21 = 20*log10(squeeze(mag_Zth21));
phase_Zth21 = squeeze(phase_Zth21);


[mag_Zth22,phase_Zth22,wout_Zth22] = bode(Zth22,{1*2*pi,1000*2*pi});
mag_Zth22 = 20*log10(squeeze(mag_Zth22));
phase_Zth22 = squeeze(phase_Zth22);




%% bode variação de kri - mudanças de fontes
H = figure;
set(H,'Position',[50 100 1280 600]);
annotation('textarrow',[0.76 0.81],[0.65 0.65],'String','276.9Hz', 'FontSize',18,'Color','r')
annotation('textarrow',[0.56 0.61],[0.65 0.65],'String','60Hz', 'FontSize',18,'Color','r')
font = 28;

axes('Position',[0.09 0.58 0.89 0.4])
hold on
h2 = plot(wout_Zth21./(2*pi),mag_Zth21,'--','linewidth',2.0);
h1 = plot(wout_Zth./(2*pi),mag_Zth,'linewidth',2.0);
h3 = plot(wout_Zth22./(2*pi),mag_Zth22,'k-.','linewidth',2.0);
plot([60 60],[-50000 50000],'-.r','linewidth',1.2) % linha tracejuada
plot([276.9 276.9],[-50000 50000],'-.r','linewidth',1.2) % linha tracejuada
hold off
xlim([1 1000])
ylim([-20 65])
grid
set(gca,'FontSize',font, 'XScale', 'log','FontName','calibri Italic','TickLabelInterpreter','latex');
set(gca,'YTick',[-15 0 15 30 45 60 65],'YTickLabel',{-15 0 15 30 45 60  '^'});

yl1 = ylabel('Magnitude - dB ','FontSize',font,'FontName','calibri Italic','Interpreter','latex')

set(gca,'XTickLabel',{})
set(gca,'GridAlpha',0.5,'MinorGridAlpha',0.8)
leg = legend('$k_r^{i}=0.001 A^{-1}rad/s$','$k_r^{i}=0.010 A^{-1}rad/s$','$k_r^{i}=0.050 A^{-1}rad/s$','Location','southwest');
leg.FontSize = 0.8*font;
leg.Interpreter = 'latex';

axes('Position',[0.09 0.15 0.89 0.4])
hold on
h2 = plot(wout_Zth21./(2*pi),(phase_Zth21),'--','linewidth',2.0);
h1 = plot(wout_Zth./(2*pi),(phase_Zth),'linewidth',2.0);
h3 = plot(wout_Zth22./(2*pi),(phase_Zth22),'k-.','linewidth',2.0);
plot([60 60],[-50000 50000],'-.r','linewidth',1.2) % linha tracejuada
plot([276.9 276.9],[-50000 50000],'-.r','linewidth',1.2) % linha tracejuada

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

%export_fig 'figs/artigo1/bode_Zth_var2' '-png' -transparent -painters -r200
set(H,'PaperUnits','points','PaperSize',[960 450])
%saveas(H, 'figs/Tese/Artigo1/bode_Zth_var2', 'pdf') %Save figure
%saveas(H, 'figs/Tese/Artigo1/bode_Zth_var2', 'png') %Save figure


%% Variação do ganho proporcional do controle de tensão

kpv31 = 0.01000;
kpv32 = 0.5000;




Gv31 = kpv31 + krv*s/(s^2+w0^2);
Gv32 = kpv32 + krv*s/(s^2+w0^2);

Zca31 = 1/(Ycas + Gicl*Gv31);
Zca32 = 1/(Ycas + Gicl*Gv32);

Gvcl31 = Gicl*Gv31/(Ycas + Gicl*Gv31);
Gvcl32 = Gicl*Gv32/(Ycas + Gicl*Gv32);


Zth31 = Zca31/(s*Cf*Zca31+1);
Zth32 = Zca32/(s*Cf*Zca32+1);



%% resposta em frequencia variação de kpv

[mag_Zth31,phase_Zth31,wout_Zth31] = bode(Zth31,{1*2*pi,1000*2*pi});
mag_Zth31 = 20*log10(squeeze(mag_Zth31));
phase_Zth31 = squeeze(phase_Zth31);


[mag_Zth32,phase_Zth32,wout_Zth32] = bode(Zth32,{1*2*pi,1000*2*pi});
mag_Zth32 = 20*log10(squeeze(mag_Zth32));
phase_Zth32 = squeeze(phase_Zth32);




%% bode variação de kpv - mudanças de fontes
H = figure;
set(H,'Position',[50 100 1280 600]);
annotation('textarrow',[0.565 0.615],[0.65 0.65],'String','60Hz', 'FontSize',18,'Color','r')
annotation('textarrow',[0.73 0.78],[0.72 0.72],'String','214.3Hz', 'FontSize',18,'Color','r')
annotation('textarrow',[0.73 0.81],[0.67 0.67],'String','273.6Hz', 'FontSize',18,'Color','r')
annotation('textarrow',[0.73 0.875],[0.62 0.62],'String','451.4Hz', 'FontSize',18,'Color','r')
font = 28;

axes('Position',[0.09 0.58 0.89 0.4])
hold on
h2 = plot(wout_Zth31./(2*pi),mag_Zth31,'--','linewidth',2.0);
h1 = plot(wout_Zth./(2*pi),mag_Zth,'linewidth',2.0);
h3 = plot(wout_Zth32./(2*pi),mag_Zth32,'k-.','linewidth',2.0);
plot([60 60],[-50000 50000],'-.r','linewidth',1.2) % linha tracejuada
plot([273.6 273.6],[-50000 50000],'-.r','linewidth',1.2) % linha tracejuada
plot([451.4 451.4],[-50000 50000],'-.r','linewidth',1.2) % linha tracejuada
plot([214.3 214.3],[-50000 50000],'-.r','linewidth',1.2) % linha tracejuada
hold off
xlim([1 1000])
ylim([-20 50])
grid
set(gca,'FontSize',font, 'XScale', 'log','FontName','calibri Italic','TickLabelInterpreter','latex');
set(gca,'YTick',[-15 0 15 30 45 50],'YTickLabel',{-15 0 15 30 45 '^'});

yl1 = ylabel('Magnitude - dB ','FontSize',font,'FontName','calibri Italic','Interpreter','latex')

set(gca,'XTickLabel',{})
set(gca,'GridAlpha',0.5,'MinorGridAlpha',0.8)
leg = legend('$k_p^{v}=0.01 S$','$k_p^{v}=0.10 S$','$k_p^{v}=0.50 S$','Location','southwest');
leg.FontSize = 0.8*font;
leg.Interpreter = 'latex';

axes('Position',[0.09 0.15 0.89 0.4])
hold on
h2 = plot(wout_Zth31./(2*pi),(phase_Zth31),'--','linewidth',2.0);
h1 = plot(wout_Zth./(2*pi),(phase_Zth),'linewidth',2.0);
h3 = plot(wout_Zth32./(2*pi),(phase_Zth32),'k-.','linewidth',2.0);
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

%export_fig 'figs/artigo1/bode_Zth_var3' '-png' -transparent -painters -r200
set(H,'PaperUnits','points','PaperSize',[960 450])
% saveas(H, 'figs/Tese/Artigo1/bode_Zth_var3', 'pdf') %Save figure
%saveas(H, 'figs/Tese/Artigo1/bode_Zth_var3', 'png') %Save figure


%% Variação do ganho ressonante do controle de tensão

krv41 = 0.09;
krv42 = 9;




Gv41 = kpv + krv41*s/(s^2+w0^2);
Gv42 = kpv + krv42*s/(s^2+w0^2);

Zca41 = 1/(Ycas + Gicl*Gv41);
Zca42 = 1/(Ycas + Gicl*Gv42);

Gvcl41 = Gicl*Gv41/(Ycas + Gicl*Gv41);
Gvcl42 = Gicl*Gv42/(Ycas + Gicl*Gv42);


Zth41 = Zca41/(s*Cf*Zca41+1);
Zth42 = Zca42/(s*Cf*Zca42+1);






%% resposta em frequencia variação de krv

[mag_Zth41,phase_Zth41,wout_Zth41] = bode(Zth41,{1*2*pi,1000*2*pi});
mag_Zth41 = 20*log10(squeeze(mag_Zth41));
phase_Zth41 = squeeze(phase_Zth41);


[mag_Zth42,phase_Zth42,wout_Zth42] = bode(Zth42,{1*2*pi,1000*2*pi});
mag_Zth42 = 20*log10(squeeze(mag_Zth42));
phase_Zth42 = squeeze(phase_Zth42);





%% bode variação de kpv - mudanças de fontes
H = figure;
set(H,'Position',[50 100 1280 600]);
annotation('textarrow',[0.565 0.615],[0.65 0.65],'String','60Hz', 'FontSize',18,'Color','r')
annotation('textarrow',[0.73 0.81],[0.67 0.67],'String','273.6Hz', 'FontSize',18,'Color','r')
font = 28;

axes('Position',[0.09 0.58 0.89 0.4])
hold on
h2 = plot(wout_Zth41./(2*pi),mag_Zth41,'--','linewidth',2.0);
h1 = plot(wout_Zth./(2*pi),mag_Zth,'linewidth',2.0);
h3 = plot(wout_Zth42./(2*pi),mag_Zth42,'k-.','linewidth',2.0);
plot([60 60],[-50000 50000],'-.r','linewidth',1.2) % linha tracejuada
plot([273.6 273.6],[-50000 50000],'-.r','linewidth',1.2) % linha tracejuada
hold off
xlim([1 1000])
ylim([-20 50])
grid
set(gca,'FontSize',font, 'XScale', 'log','FontName','calibri Italic','TickLabelInterpreter','latex');
set(gca,'YTick',[-15 0 15 30 45 50],'YTickLabel',{-15 0 15 30 45 '^'});

yl1 = ylabel('Magnitude - dB ','FontSize',font,'FontName','calibri Italic','Interpreter','latex')

set(gca,'XTickLabel',{})
set(gca,'GridAlpha',0.5,'MinorGridAlpha',0.8)
leg = legend('$k_r^{v}=0.09 S rad/s$','$k_r^{v}=1.00 S rad/s$','$k_r^{v}=9.00 S rad/s$','Location','southwest');
leg.FontSize = 0.8*font;
leg.Interpreter = 'latex';

axes('Position',[0.09 0.15 0.89 0.4])
hold on
h2 = plot(wout_Zth41./(2*pi),(phase_Zth41),'--','linewidth',2.0);
h1 = plot(wout_Zth./(2*pi),(phase_Zth),'linewidth',2.0);
h3 = plot(wout_Zth42./(2*pi),(phase_Zth42),'k-.','linewidth',2.0);
plot([60 60],[-50000 50000],'-.r','linewidth',1.2) % linha tracejuada
plot([273.6 273.6],[-50000 50000],'-.r','linewidth',1.2) % linha tracejuada
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



%export_fig 'figs/artigo1/bode_Zth_var4' '-png' -transparent -painters -r200
set(H,'PaperUnits','points','PaperSize',[960 450])
% saveas(H, 'figs/Tese/Artigo1/bode_Zth_var4', 'pdf') %Save figure
%saveas(H, 'figs/Tese/Artigo1/bode_Zth_var4', 'png') %Save figure

%% Single Loop voltage control


kpvsl = 1e-4;
krvsl = 1e-3;

Gvsl = kpvsl + krvsl*s/(s^2+w0^2);

den_vsl = 8*s*Ceq + (4*s*Ceq*Vdc0 + 2*SN/(3*Vdc0))*Gvsl;

Zacsl = (4*s*Ceq*(Zs+2*Zfs)+1)/den_vsl;

Gvslcl = (4*s*Ceq*Vdc0 + 2*SN/(3*Vdc0))*Gvsl/den_vsl;


%% Resposta em frequencia de Zaccl e Gvslcl

[mag_Zacsl,phase_Zacsl,wout_Zacsl] = bode(Zacsl,{1*2*pi,1000*2*pi});
mag_Zacsl = 20*log10(squeeze(mag_Zacsl));
phase_Zacsl = squeeze(phase_Zacsl);


%% Resposta em frequencia para Zth single loop


Zth_sl = Zacsl/(s*Cf*Zacsl+1);



[mag_Zth_sl,phase_Zth_sl,wout_Zth_sl] = bode(Zth_sl,{1*2*pi,1000*2*pi});
mag_Zth_sl = 20*log10(squeeze(mag_Zth_sl));
phase_Zth_sl = squeeze(phase_Zth_sl);


%% Resultados do psim para  Zth single loop

psim_Zth_sl =  csvread('Dados/psim_primeiro_teste/resp_Zth_single_loop.csv',0,0);


psim_f4_sl = psim_Zth_sl(:,5);
psim_AmpdB4_sl = 20.*log10(sqrt(psim_Zth_sl(:,2).^2 + psim_Zth_sl(:,3).^2)./100 );
psim_Ang4_sl = (rad2deg(atan2(psim_Zth_sl(:,3),psim_Zth_sl(:,2))) +180 );


% em 60Hz tem que ser feita a diferença (step):
n60 = find(psim_f4_sl == 60);
psim_AmpdB4_sl(n60) = 20.*log10(  sqrt(  (psim_Zth_sl(n60,2) - 5.6338e+04).^2 + psim_Zth_sl(n60,3).^2)./100 );




%% Comparação de Zth_sl com o resultado do psim -  mudanças de fontes
H = figure;
set(H,'Position',[50 100 1280 600]);
annotation('textarrow',[0.56 0.61],[0.65 0.65],'String','60Hz', 'FontSize',18)
annotation('textarrow',[0.86 0.91],[0.65 0.65],'String','604.3Hz', 'FontSize',18)
%plot([120 120],[-50000 50000],'-.k','linewidth',1.5) % linha tracejuada
font = 28;

axes('Position',[0.09 0.58 0.89 0.4])
hold on
h1 = plot(wout_Zth_sl./(2*pi),mag_Zth_sl,'linewidth',2.0);
h2 = plot(psim_f4_sl,psim_AmpdB4_sl,'or','linewidth',2.0);
plot([60 60],[-50000 50000],'-.k','linewidth',1.2) % linha tracejuada
plot([604.3 604.3],[-50000 50000],'-.k','linewidth',1.2) % linha tracejuadahold off
xlim([1 1000])
ylim([-120 70])
grid
set(gca,'FontSize',font, 'XScale', 'log','FontName','calibri Italic','TickLabelInterpreter','latex');
set(gca,'YTick',[-100 -50 0 50 70],'YTickLabel',{-100 -50 0 50  '^'});

yl1 = ylabel('Magnitude - dB ','FontSize',font,'FontName','calibri Italic','Interpreter','latex')

set(gca,'XTickLabel',{})
set(gca,'GridAlpha',0.5,'MinorGridAlpha',0.8)
leg = legend('Linearized Model','Non-Linear Model','Location','southwest');
leg.FontSize = 0.8*font;
leg.Interpreter = 'latex';

axes('Position',[0.09 0.15 0.89 0.4])
hold on
h1 = plot(wout_Zth_sl./(2*pi), wrapTo180(phase_Zth_sl),'linewidth',2.0);
h2 = plot(psim_f4_sl,wrapTo180(psim_Ang4_sl),'or','linewidth',2.0);
plot([60 60],[-50000 50000],'-.k','linewidth',1.2) % linha tracejuada
plot([604.3 604.3],[-50000 50000],'-.k','linewidth',1.2) % linha tracejuada
%plot([273.6 273.6],[-50000 50000],'-.k','linewidth',1.2) % linha tracejuada
hold off
xlim([1 1000])
grid
ylim([-200 200])

set(gca,'FontSize',font, 'XScale', 'log','FontName','calibri Italic','XTick',[1 10 100 1000],'TickLabelInterpreter','latex');
set(gca,'YTick',[-180 -90 0 90 180 200],'YTickLabel',{-180 -90 0 90 180 '^'})
set(gca,'GridAlpha',0.5,'MinorGridAlpha',0.8)
xl1 = xlabel('Frequency - Hz','FontSize',font,'FontName','calibri','Interpreter','latex')
yl2 = ylabel('Phase - deg ','FontSize',font,'FontName','calibri','Interpreter','latex')


yl2.Position(1) = yl2.Position(1) + 0.03;
yl1.Position(1) = yl2.Position(1);

xl1.Position(2) = xl1.Position(2) +10;


%export_fig 'figs/artigo1/bode_Zth_sl' '-png' -transparent -painters -r200
set(H,'PaperUnits','points','PaperSize',[960 450])
%saveas(H, 'figs/Tese/Artigo1/bode_Zth_sl', 'pdf') %Save figure
%saveas(H, 'figs/Tese/Artigo1/bode_Zth_sl', 'png') %Save figure

%% Resposta em frequencia para Gth single loop


Gth_sl = 1/(s*Cf*Zacsl+1);



[mag_Gth_sl,phase_Gth_sl,wout_Gth_sl] = bode(Gth_sl,{1*2*pi,1000*2*pi});
mag_Gth_sl = 20*log10(squeeze(mag_Gth_sl));
phase_Gth_sl = squeeze(phase_Gth_sl);




%% Resultados do psim para  Gth single loop

psim_Gth_sl =  csvread('Dados/psim_primeiro_teste/resp_Gth_single_loop.csv',0,0);


psim_f4_Gsl = psim_Gth_sl(:,5);
psim_AmpdB4_Gsl = 20.*log10(sqrt(psim_Gth_sl(:,2).^2 + psim_Gth_sl(:,3).^2)./1000 );
psim_Ang4_Gsl = (rad2deg(atan2(psim_Gth_sl(:,3),psim_Gth_sl(:,2))) );


% em 60Hz tem que ser feita a diferença (step):
n60 = find(psim_f4_Gsl == 60);
psim_AmpdB4_Gsl(n60) = 20.*log10(  sqrt(  (psim_Gth_sl(n60,2) - 5.6338e+04).^2 + psim_Gth_sl(n60,3).^2)./1000 );


% Tem uns pontos iguais a -180, mas -180º = +180º, por isso vou fazer isso
% para deixar tudo em +180
psim_Ang4_Gsl(end) = psim_Ang4_Gsl(end)*(-1);
psim_Ang4_Gsl(end-1) = psim_Ang4_Gsl(end-1)*(-1);
psim_Ang4_Gsl(end-2) = psim_Ang4_Gsl(end-2)*(-1);

%% Comparação de Gth com o resultado do psim -  mudanças de fontes
H = figure;
set(H,'Position',[50 100 1280 600]);
%annotation('textarrow',[0.56 0.61],[0.65 0.65],'String','60Hz', 'FontSize',18)
annotation('textarrow',[0.86 0.91],[0.65 0.65],'String','604.3Hz', 'FontSize',18)
%annotation('textarrow',[0.87 0.82],[0.65 0.65],'String','273.6Hz', 'FontSize',18)
%plot([120 120],[-50000 50000],'-.k','linewidth',1.5) % linha tracejuada
font = 28;

axes('Position',[0.09 0.58 0.89 0.4])
hold on
h1 = plot(wout_Gth_sl./(2*pi),mag_Gth_sl,'linewidth',2.0);
h2 = plot(psim_f4_Gsl,psim_AmpdB4_Gsl,'or','linewidth',2.0);
plot([604.3 604.3],[-50000 50000],'-.k','linewidth',1.2) % linha tracejuada
%plot([273.6 273.6],[-50000 50000],'-.k','linewidth',1.2) % linha tracejuada
hold off
xlim([1 1000])
ylim([-120 70])
grid
set(gca,'FontSize',font, 'XScale', 'log','FontName','calibri Italic','TickLabelInterpreter','latex');
set(gca,'YTick',[-100 -50 0 50 70],'YTickLabel',{-100 -50 0 50  '^'});

yl1 = ylabel('Magnitude - dB ','FontSize',font,'FontName','calibri Italic','Interpreter','latex')

set(gca,'XTickLabel',{})
set(gca,'GridAlpha',0.5,'MinorGridAlpha',0.8)
leg = legend('Linearized Model','Non-Linear Model','Location','southwest');
leg.FontSize = 0.8*font;
leg.Interpreter = 'latex';

%set(gca,'color','none')
gcaT = get(gca);

axes('Position',[0.09 0.15 0.89 0.4])
hold on
h1 = plot(wout_Gth_sl./(2*pi), wrapTo180(phase_Gth_sl),'linewidth',2.0);
h2 = plot(psim_f4_Gsl,wrapTo180(psim_Ang4_Gsl),'or','linewidth',2.0);
%plot([60 60],[-50000 50000],'-.k','linewidth',1.2) % linha tracejuada
%plot([273.6 273.6],[-50000 50000],'-.k','linewidth',1.2) % linha tracejuada
hold off
xlim([1 1000])
grid
ylim([-200 50])

set(gca,'FontSize',font, 'XScale', 'log','FontName','calibri Italic','XTick',[1 10 100 1000],'TickLabelInterpreter','latex');
set(gca,'YTick',[-180 -90 0 50],'YTickLabel',{-180 -90 0 '^'})
set(gca,'GridAlpha',0.5,'MinorGridAlpha',0.8)
xl1 = xlabel('Frequency - Hz','FontSize',font,'FontName','calibri','Interpreter','latex')
yl2 = ylabel('Phase - deg ','FontSize',font,'FontName','calibri','Interpreter','latex')

gcaB = get(gca);
yl2.Position(1) = yl2.Position(1) + 0.03;
yl1.Position(1) = yl2.Position(1);

xl1.Position(2) = xl1.Position(2) +10;
%set(gca,'color','none')


% export_fig 'figs/artigo1/bode_Gth_sl' '-png' -transparent -painters -r200
export_fig 'figs/artigo1/bode_Gth_sl_wbg' '-png' -transparent -painters -r300
set(H,'PaperUnits','points','PaperSize',[960 450])
set(H,'Renderer','painters')
%set(H, 'PaperPositionMode', 'auto');

% export_fig 'figs/artigo1/bode_Gth_sl_gs' '-pdf' -transparent -painters 
%saveas(H, 'figs/Tese/Artigo1/bode_Gth_sl', 'pdf') %Save figure
% print(H,'figs/artigo1/bode_Gth_sl_mat','-dpdf','-painters')

