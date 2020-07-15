%% Resultados complementares artigo Electric Power System Research
% It is also generated all the graphs used in the article: 
% A linearized small-signal Thévenin-equivalent model of a
% voltage-controlled modular multilevel converter
% https://doi.org/10.1016/j.epsr.2020.106231
clear all
clc

format long

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
w0 = 2*pi*60;

Cf = 20e-6;


t = 0:1e-5:4;


%% Definições


s = tf('s');

Ceq = C/N;

Zs = L*s + R;
Zfs = Lf*s + Rf;


%% Controladores

krcir = 0.1;


Gcir = -krcir*s/(s^2 + (2*w0)^2);

%% Funções de transferência da malha de corrente circulante

Y_cc_icir_s = 2*s*Ceq/(4*s*Ceq*Zs+1 - (SN/(3*Vdc0)+ 2*s*Ceq* Vdc0)*Gcir );


%% Funções da admitância de saída

kpi = 1e-4;
kri = 1e-2;

Gi = kpi + kri*s/(s^2+w0^2);

DenI = 4*s*Ceq*(Zs+2*Zfs) + (4*s*Ceq*Vdc0 + (2*SN/(3*Vdc0)))*Gi + 1;

Ycas = minreal(8*s*Ceq/DenI);


%% Funções de transferência de malha fechada da corrente

Gicl = minreal((4*s*Ceq*Vdc0 + 2*SN/(3*Vdc0))*Gi/DenI);


%% Funções de transferência para o modelo de Thevenin

kpv = 0.1;
krv = 1;

Gv = kpv + krv*s/(s^2+w0^2);

Zca = minreal(1/(Ycas + Gicl*Gv));

Gvcl = minreal(Gicl*Gv/(Ycas + Gicl*Gv));


Zth = minreal(Zca/(s*Cf*Zca+1));

Gth = minreal(Gvcl/(s*Cf*Zca+1));




%% conversor controlador por corrente

% Sistema estável
kpi_ci = 1e-4;
kri_ci = 1e-2;

Gi_ci = kpi_ci + kri_ci*s/(s^2+w0^2);

DenI_ci = 4*s*Ceq*(Zs+2*Zfs) + (4*s*Ceq*Vdc0 + (2*SN/(3*Vdc0)))*Gi_ci + 1;

Ycas_ci = 8*s*Ceq/DenI_ci;


% Sistema instável
kpi_ci2 = -1e-4;
kri_ci2 = 1e-2;

Gi_ci2 = kpi_ci2 + kri_ci2*s/(s^2+w0^2);

DenI_ci2 = 4*s*Ceq*(Zs+2*Zfs) + (4*s*Ceq*Vdc0 + (2*SN/(3*Vdc0)))*Gi_ci2 + 1;

Ycas_ci2 = 8*s*Ceq/DenI_ci2;


%% outro sistema instável


% Conversor conrolador por corrente
kpi_ci3 = 1e-4/10;
kri_ci3 = 1e-2/10;

Gi_ci3 = kpi_ci3 + kri_ci3*s/(s^2+w0^2);

DenI_ci3 = 4*s*Ceq*(Zs+2*Zfs) + (4*s*Ceq*Vdc0 + (2*SN/(3*Vdc0)))*Gi_ci3 + 1;

Ycas_ci3 = 8*s*Ceq/DenI_ci3;


% conversor controlado por tensão


kpi3 = 1e-4/10;
kri3 = 1e-2/10;

Gi3 = kpi3 + kri3*s/(s^2+w0^2);

DenI3 = 4*s*Ceq*(Zs+2*Zfs) + (4*s*Ceq*Vdc0 + (2*SN/(3*Vdc0)))*Gi3 + 1;

Ycas3 = minreal(8*s*Ceq/DenI3);

Gicl3 = minreal((4*s*Ceq*Vdc0 + 2*SN/(3*Vdc0))*Gi3/DenI3);


kpv3 = 0.1/10;
krv3 = 1/10;

Gv3 = kpv3 + krv3*s/(s^2+w0^2);

Zca3 = minreal(1/(Ycas3 + Gicl3*Gv3));

Gvcl3 = minreal(Gicl3*Gv3/(Ycas3 + Gicl3*Gv3));


Zth3 = minreal(Zca3/(s*Cf*Zca3+1));

Gth3 = minreal(Gvcl3/(s*Cf*Zca3+1));


%% Stability ca

LFca = minreal(Ycas_ci*Zth);

LFca2 = minreal(Ycas_ci2*Zth);

LFca3 = minreal(Ycas_ci3*Zth3);





%% Estabilidade CA - Condição estável  - mudança de formatação




H = figure;
set(H,'Position',[50 100 720 600]);

font_ny = 18;

%axes('Position',[0.09 0.2 0.89 0.8])

%axes('Position',[0.09 0.58 0.89 0.4])
axes('Position',[0.14 0.11 0.83 0.84])

hold on
%h1 = plot(pole(LFca),'xr')
h1 = plot(real(pole(LFca)),imag(pole(LFca)),'*r','LineWidth',2)
h1b = area([0 20],[2000 2000],'EdgeColor',[0 0 0],'LineStyle',':','LineWidth',0.01,'FaceColor',[0.5,0.5,0.5],'FaceAlpha',0.4)
h1c = area([0 20],[-2000 -2000],'EdgeColor',[0 0 0],'LineStyle',':','LineWidth',0.01,'FaceColor',[0.5,0.5,0.5],'FaceAlpha',0.4)
an1 = annotation('arrow',[0.865 0.865],[0.11 0.95],'LineWidth',2);
an2 = annotation('arrow',[0.14 0.97],[0.53 0.53],'LineWidth',2);
hold off



set(h1,'MarkerSize',16)
%title('Poles of the loop function')
xlim([-140 20])
grid
set(gca,'GridAlpha',0.5,'MinorGridAlpha',0.8)
set(gca,'FontSize',font_ny, 'FontName','calibri Italic','TickLabelInterpreter','latex');
hxt = xlabel('Real Axis - rad/s','FontSize',font_ny,'FontName','calibri','Interpreter','latex')
hyt = ylabel('Imaginary Axis - rad/s','FontSize',font_ny,'FontName','calibri','Interpreter','latex')



% export_fig 'figs/artigo1/poles_ca_estavel' '-png' -transparent -painters -r400
% export_fig 'figs/artigo1/300dpi/poles_ca_estavel' '-png' -transparent -painters -r300

H = figure;
set(H,'Position',[50 100 720 600]);

font_ny = 18;

axes('Position',[0.14 0.11 0.83 0.84])


[RE_LFca,IM_LFca,W_LFca] = nyquist(LFca)

hold on
plot(-1,0,'r>');
ht_ny = plot(RE_LFca(:),IM_LFca(:),'b','linewidth',1.8)
hb_ny = plot(RE_LFca(:),-IM_LFca(:),'b','linewidth',1.8)
circle1 = viscircles([0 0],1)
hold off


circle1.Children(1).Color = [0.5 0.5 0.5];
circle1.Children(1).LineStyle = '--';

set(h1,'MarkerSize',16)
grid
set(gca,'GridAlpha',0.5,'MinorGridAlpha',0.8)
set(gca,'FontSize',font_ny, 'FontName','calibri Italic','TickLabelInterpreter','latex');
hxt = xlabel('Real Axis - rad/s','FontSize',font_ny,'FontName','calibri','Interpreter','latex')
hyt = ylabel('Imaginary Axis - rad/s','FontSize',font_ny,'FontName','calibri','Interpreter','latex')



% export_fig 'figs/artigo1/nyquist_ca_estavel' '-png' -transparent -painters -r400
% export_fig 'figs/artigo1/300dpi/nyquist_ca_estavel' '-png' -transparent -painters -r300


 
%% Estabilidade CA - Condição instavel  - mudança de formatação




H = figure;
set(H,'Position',[50 100 720 600]);

font_ny = 18;


axes('Position',[0.14 0.11 0.83 0.84])

hold on
h1 = plot(real(pole(LFca3)),imag(pole(LFca3)),'*r','LineWidth',2)
h1b = area([0 20],[2000 2000],'EdgeColor',[0 0 0],'LineStyle',':','LineWidth',0.01,'FaceColor',[0.5,0.5,0.5],'FaceAlpha',0.4)
h1c = area([0 20],[-2000 -2000],'EdgeColor',[0 0 0],'LineStyle',':','LineWidth',0.01,'FaceColor',[0.5,0.5,0.5],'FaceAlpha',0.4)
an1 = annotation('arrow',[0.876 0.876],[0.11 0.95],'LineWidth',2);
an2 = annotation('arrow',[0.14 0.97],[0.53 0.53],'LineWidth',2);
hold off



set(h1,'MarkerSize',16)
xlim([-40 5])
grid
set(gca,'GridAlpha',0.5,'MinorGridAlpha',0.8)
set(gca,'FontSize',font_ny, 'FontName','calibri Italic','TickLabelInterpreter','latex');
hxt = xlabel('Real Axis - rad/s','FontSize',font_ny,'FontName','calibri','Interpreter','latex')
hyt = ylabel('Imaginary Axis - rad/s','FontSize',font_ny,'FontName','calibri','Interpreter','latex')

%export_fig 'figs/artigo1/poles_ca_instavel' '-png' -transparent -painters -r400
% export_fig 'figs/artigo1/300dpi/poles_ca_instavel' '-png' -transparent -painters -r300



H = figure;
set(H,'Position',[50 100 720 600]);

font_ny = 18;

axes('Position',[0.14 0.11 0.83 0.84])


[RE_LFca3,IM_LFca3,W_LFca3] = nyquist(LFca3)

hold on
plot(-1,0,'r>');
ht_ny = plot(RE_LFca3(:),IM_LFca3(:),'b','linewidth',1.8)
hb_ny = plot(RE_LFca3(:),-IM_LFca3(:),'b','linewidth',1.8)
circle1 = viscircles([0 0],1)
hold off


circle1.Children(1).Color = [0.5 0.5 0.5];
circle1.Children(1).LineStyle = '--';

set(h1,'MarkerSize',16)
grid
set(gca,'GridAlpha',0.5,'MinorGridAlpha',0.8)
set(gca,'FontSize',font_ny, 'FontName','calibri Italic','TickLabelInterpreter','latex');
hxt = xlabel('Real Axis - rad/s','FontSize',font_ny,'FontName','calibri','Interpreter','latex')
hyt = ylabel('Imaginary Axis - rad/s','FontSize',font_ny,'FontName','calibri','Interpreter','latex')


% Place second set of axes on same plot
handaxes2 = axes('Position', [0.45 0.6 0.25 0.25]);
hold on
plot(RE_LFca3(:),IM_LFca3(:),'b','linewidth',1.5)
plot(RE_LFca3(:),-IM_LFca3(:),'b','linewidth',1.5)
plot(-1,0,'r*');

hold off
set(handaxes2, 'Box', 'off')


xlim([-1.5 1])
ylim([-1 1])
grid


%export_fig 'figs/artigo1/nyquist_ca_instavel' '-png' -transparent -painters -r400
% export_fig 'figs/artigo1/300dpi/nyquist_ca_instavel' '-png' -transparent -painters -r300





%% Dados Simulação PSCAD - Estabilidade CA


data = csvread('Dados/Dados_PSCAD_EPSR_2019/estabilidade_ca_estavel_variaveis_vo_voref.txt',1,0);
estabilidade_ca_estavel_variaveis_t = data(:,1); 
estabilidade_ca_estavel_variaveis_vo_a = data(:,2)/56.338;
estabilidade_ca_estavel_variaveis_voref_a = heaviside(estabilidade_ca_estavel_variaveis_t-0.5).*data(:,5)/56.338;

data = csvread('Dados/Dados_PSCAD_EPSR_2019/estabilidade_ca_estavel_variaveis_ic_icref.txt',1,0);
estabilidade_ca_estavel_variaveis_ic_a = data(:,2)./1.183;
estabilidade_ca_estavel_variaveis_icref_a = heaviside(estabilidade_ca_estavel_variaveis_t-0.5).*data(:,5)./1.183;

data = csvread('Dados/Dados_PSCAD_EPSR_2019/estabilidade_ca_estavel_variaveis_ic2_icref2.txt',1,0);
estabilidade_ca_estavel_variaveis_ic2_a = data(:,2)./1.183;
estabilidade_ca_estavel_variaveis_icref2_a = heaviside(estabilidade_ca_estavel_variaveis_t-0.5).*data(:,5)./1.183;

clearvars data 



data = csvread('Dados/Dados_PSCAD_EPSR_2019/estabilidade_ca_instavel_variaveis_vo_voref.txt',1,0);
estabilidade_ca_instavel_variaveis_t = data(:,1); 
estabilidade_ca_instavel_variaveis_vo_a = data(:,2)/56.338;
estabilidade_ca_instavel_variaveis_voref_a = heaviside(estabilidade_ca_instavel_variaveis_t-0.5).*data(:,5)/56.338;

data = csvread('Dados/Dados_PSCAD_EPSR_2019/estabilidade_ca_instavel_variaveis_ic_icref.txt',1,0);
estabilidade_ca_instavel_variaveis_ic_a = data(:,2)./1.183;
estabilidade_ca_instavel_variaveis_icref_a = heaviside(estabilidade_ca_instavel_variaveis_t-0.5).*data(:,5)./1.183;

data = csvread('Dados/Dados_PSCAD_EPSR_2019/estabilidade_ca_instavel_variaveis_ic2_icref2.txt',1,0);
estabilidade_ca_instavel_variaveis_ic2_a = data(:,2)./1.183;
estabilidade_ca_instavel_variaveis_icref2_a = heaviside(estabilidade_ca_instavel_variaveis_t-0.5).*data(:,5)./1.183;

clearvars data 


%% Estabilidade CA -  Caso estável


H = figure;
set(H,'Position',[50 100 1280 600]);
font = 28;
intervalo_x = [0.45 1.2];
intervalo_yt = [-1.75 1.75];
intervalo_yb = [-1.75 1.75];

axes('Position',[0.09 0.58 0.89 0.4])
hold on
h1 = plot(estabilidade_ca_estavel_variaveis_t,estabilidade_ca_estavel_variaveis_voref_a,':k','linewidth',2.0);
h1 = plot(estabilidade_ca_estavel_variaveis_t,estabilidade_ca_estavel_variaveis_vo_a,'linewidth',2.0);
h3 = plot([0.5 0.5],[-10 10],'--k','linewidth',2)
box on;
hold off
xlim(intervalo_x)
ylim(intervalo_yt)
grid
set(gca,'FontSize',font, 'FontName','calibri Italic','TickLabelInterpreter','latex');

yl1 = ylabel('Voltage - p.u.','FontSize',font,'FontName','calibri Italic','Interpreter','latex')


set(gca,'XTickLabel',{})
set(gca,'GridAlpha',0.5,'MinorGridAlpha',0.8)


leg = legend('$v_{o}^{a*}$','$v_{o}^{a}$','Location','northeast');
leg.FontSize = 0.8*font;
leg.Interpreter = 'latex';
leg.Orientation = 'horizontal'

texto = text(2.985,1.05,'$v_{dc}$');
texto.FontSize = 33;
texto.FontName = 'calibri';
texto.Interpreter  = 'latex';

set(gca,'GridLineStyle',':','GridAlpha',1.0)

axes('Position',[0.09 0.15 0.89 0.4])
hold on
h1 = plot(estabilidade_ca_estavel_variaveis_t,estabilidade_ca_estavel_variaveis_icref2_a,':k','linewidth',2.0);
h1 = plot(estabilidade_ca_estavel_variaveis_t,estabilidade_ca_estavel_variaveis_ic2_a,'linewidth',2.0);
h3 = plot([0.5 0.5],[-10 10],'--k','linewidth',2)
box on;

hold off
xlim(intervalo_x)
ylim(intervalo_yb)
grid


set(gca,'FontSize',font, 'FontName','calibri Italic','TickLabelInterpreter','latex');

set(gca,'GridAlpha',0.5,'MinorGridAlpha',0.8)

xl1 = xlabel('Time - s','FontSize',font,'FontName','calibri','Interpreter','latex')
yl2 = ylabel('Current - p.u.','FontSize',font,'FontName','calibri','Interpreter','latex')


leg = legend('$i_{c2}^{a*}$','$i_{c2}^{a}$','Location','northeast');
leg.FontSize = 0.8*font;
leg.Interpreter = 'latex';
leg.Orientation = 'horizontal'

texto = text(2.985,-0.05,'$i_{cir}^{a}$');
texto.FontSize = 33;
texto.FontName = 'calibri';
texto.Interpreter  = 'latex';

set(gca,'GridLineStyle',':','GridAlpha',1.0)


%export_fig 'figs/artigo1/time_resp_ca_estavel' '-png' -transparent -painters -r400
% export_fig 'figs/artigo1/300dpi/time_resp_ca_estavel' '-png' -transparent -painters -r300





%% Estabilidade CA -  Caso instável


H = figure;
set(H,'Position',[50 100 1280 600]);
font = 28;
intervalo_x = [0.45 3.2];
intervalo_yt = [-1.75 1.75];
intervalo_yb = [-1.75 1.75];

axes('Position',[0.09 0.58 0.89 0.4])
hold on
h1 = plot(estabilidade_ca_instavel_variaveis_t,estabilidade_ca_instavel_variaveis_voref_a,':k','linewidth',2.0);
h1 = plot(estabilidade_ca_instavel_variaveis_t,estabilidade_ca_instavel_variaveis_vo_a,'linewidth',2.0);
h3 = plot([0.5 0.5],[-100 100],'--k','linewidth',2)
box on;
hold off
xlim(intervalo_x)
ylim(intervalo_yt)
grid
set(gca,'FontSize',font, 'FontName','calibri Italic','TickLabelInterpreter','latex');

yl1 = ylabel('Voltage - p.u.','FontSize',font,'FontName','calibri Italic','Interpreter','latex')

% set(gca,'YTick',[1,1.1])
%set(gca,'XTick',[3,3.1,3.2,3.3])
set(gca,'XTickLabel',{})
set(gca,'GridAlpha',0.5,'MinorGridAlpha',0.8)


leg = legend('$v_{o}^{a*}$','$v_{o}^{a}$','Location','northwest');
leg.FontSize = 0.8*font;
leg.Interpreter = 'latex';
leg.Orientation = 'horizontal'



set(gca,'GridLineStyle',':','GridAlpha',1.0)

axes('Position',[0.09 0.15 0.89 0.4])
hold on
h1 = plot(estabilidade_ca_instavel_variaveis_t,estabilidade_ca_instavel_variaveis_icref2_a,':k','linewidth',2.0);
h1 = plot(estabilidade_ca_instavel_variaveis_t,estabilidade_ca_instavel_variaveis_ic2_a,'linewidth',2.0);
h3 = plot([0.5 0.5],[-10 10],'--k','linewidth',2)
box on;

hold off
xlim(intervalo_x)
ylim(intervalo_yb)
grid


set(gca,'FontSize',font, 'FontName','calibri Italic','TickLabelInterpreter','latex');

set(gca,'GridAlpha',0.5,'MinorGridAlpha',0.8)

xl1 = xlabel('Time - s','FontSize',font,'FontName','calibri','Interpreter','latex')
yl2 = ylabel('Current - p.u.','FontSize',font,'FontName','calibri','Interpreter','latex')


leg = legend('$i_{c2}^{a*}$','$i_{c2}^{a}$','Location','northwest');
leg.FontSize = 0.8*font;
leg.Interpreter = 'latex';
leg.Orientation = 'horizontal'



set(gca,'GridLineStyle',':','GridAlpha',1.0)


% export_fig 'figs/artigo1/time_resp_ca_instavel' '-png' -transparent -painters -r400
% export_fig 'figs/artigo1/300dpi/time_resp_ca_instavel' '-png' -transparent -painters -r300

