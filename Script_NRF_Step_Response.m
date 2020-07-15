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

%% Definições


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



%% Dados Simulação PSCAD - Oscilação no lado CA


data = csvread('Dados/Dados_PSCAD_EPSR_2019/oscilacao_300HZ_carga_variaveis_io.txt',1,0);
oscilacao_300HZ_carga_variaveis_t = data(:,1); 
oscilacao_300HZ_carga_variaveis_io_a = -data(:,2)/1.183;

data = csvread('Dados/Dados_PSCAD_EPSR_2019/oscilacao_300HZ_carga_variaveis_vo_voref.txt',1,0);
oscilacao_300HZ_carga_variaveis_vo_a = data(:,2)./56.338;

clearvars data 

data = csvread('Dados/Dados_PSCAD_EPSR_2019/oscilacao_420HZ_carga_variaveis_io.txt',1,0);
oscilacao_420HZ_carga_variaveis_t = data(:,1); 
oscilacao_420HZ_carga_variaveis_io_a = -data(:,2)/1.183;

data = csvread('Dados/Dados_PSCAD_EPSR_2019/oscilacao_420HZ_carga_variaveis_vo_voref.txt',1,0);
oscilacao_420HZ_carga_variaveis_vo_a = data(:,2)./56.338;

clearvars data 

data = csvread('Dados/Dados_PSCAD_EPSR_2019/oscilacao_60HZ_carga_variaveis_io.txt',1,0);
oscilacao_60HZ_carga_variaveis_t = data(:,1); 
oscilacao_60HZ_carga_variaveis_io_a = -data(:,2)/1.183;

data = csvread('Dados/Dados_PSCAD_EPSR_2019/oscilacao_60HZ_carga_variaveis_vo_voref.txt',1,0);
oscilacao_60HZ_carga_variaveis_vo_a = data(:,2)./56.338;

clearvars data 




%% Resposta oscilação io - 60Hz

u_oscilacao_60HZ_carga_variaveis_io_a = 200.*sin(2*pi*60.*t).*heaviside(t-3);
dy_oscilacao_60HZ_carga_variaveis_vo_a = lsim(Zth,u_oscilacao_60HZ_carga_variaveis_io_a,t);
y_oscilacao_60HZ_carga_variaveis_vo_a = (dy_oscilacao_60HZ_carga_variaveis_vo_a' + 56338.*sin(2*pi*60.*t))./56338; 


H = figure;
set(H,'Position',[50 100 1280 600]);
font = 28;
intervalo_x = [2.95 3.05];
intervalo_y = [-2 2];

axes('Position',[0.09 0.58 0.89 0.4])
hold on
h1 = plot(oscilacao_60HZ_carga_variaveis_t,oscilacao_60HZ_carga_variaveis_io_a,'linewidth',2.0);
h3 = plot([3 3],intervalo_y.*10,'--k','linewidth',2)
box on;
hold off
xlim(intervalo_x)
ylim(intervalo_y*1.1)
grid
set(gca,'FontSize',font, 'FontName','calibri Italic','TickLabelInterpreter','latex');

yl1 = ylabel('Current - p.u.','FontSize',font,'FontName','calibri Italic','Interpreter','latex')

set(gca,'YTick',[-2,-1,0,1,2])
set(gca,'XTick',[2.96,2.98,3,3.02,3.04])
set(gca,'XTickLabel',{})
set(gca,'GridAlpha',0.5,'MinorGridAlpha',0.8)


texto = text(2.97,1.75,'$i_o^{a}$');
texto.FontSize = 33;
texto.FontName = 'calibri';
texto.Interpreter  = 'latex';

set(gca,'GridLineStyle',':','GridAlpha',1.0)

axes('Position',[0.09 0.15 0.89 0.4])
hold on
h1 = plot(oscilacao_60HZ_carga_variaveis_t(1:100:end),oscilacao_60HZ_carga_variaveis_vo_a(1:100:end),':or','linewidth',1.8);
h2 = plot(t,y_oscilacao_60HZ_carga_variaveis_vo_a,'linewidth',2)
h3 = plot([3 3],intervalo_y.*10,'--k','linewidth',2)
box on;
hold off
xlim(intervalo_x)
ylim(intervalo_y*1.1)
grid


set(gca,'FontSize',font, 'FontName','calibri Italic','TickLabelInterpreter','latex');
set(gca,'YTick',[-2,-1,0,1,2])
set(gca,'XTick',[2.96,2.98,3,3.02,3.04])
set(gca,'GridAlpha',0.5,'MinorGridAlpha',0.8)
xl1 = xlabel('Time - s','FontSize',font,'FontName','calibri','Interpreter','latex')
yl2 = ylabel('Voltage - p.u.','FontSize',font,'FontName','calibri','Interpreter','latex')
leg = legend('PSCAD','Proposed Model','Location','southwest');
leg.FontSize = 0.8*font;
leg.Interpreter = 'latex';
leg.Orientation = 'horizontal'

texto = text(2.97,1.75,'$v_o^{a}$');
texto.FontSize = 33;
texto.FontName = 'calibri';
texto.Interpreter  = 'latex';

set(gca,'GridLineStyle',':','GridAlpha',1.0)


%export_fig 'figs/artigo1/time_resp_ca_60Hz' '-png' -transparent -painters -r400
%export_fig 'figs/artigo1/300dpi/time_resp_ca_60Hz' '-png' -transparent -painters -r300




%% Resposta oscilação io - 300Hz

u_oscilacao_300HZ_carga_variaveis_io_a = 200.*sin(2*pi*300.*t).*heaviside(t-3);
dy_oscilacao_300HZ_carga_variaveis_vo_a = lsim(Zth,u_oscilacao_300HZ_carga_variaveis_io_a,t);
y_oscilacao_300HZ_carga_variaveis_vo_a = (-dy_oscilacao_300HZ_carga_variaveis_vo_a' + 56338.*sin(2*pi*60.*t))./56338; 


H = figure;
set(H,'Position',[50 100 1280 600]);
font = 28;
intervalo_x = [2.95 3.05];
intervalo_y = [-2 2];

axes('Position',[0.09 0.58 0.89 0.4])
hold on
h1 = plot(oscilacao_300HZ_carga_variaveis_t,oscilacao_300HZ_carga_variaveis_io_a,'linewidth',2.0);
h3 = plot([3 3],intervalo_y.*10,'--k','linewidth',2)
box on;
hold off
xlim(intervalo_x)
ylim(intervalo_y*1.1)
grid
set(gca,'FontSize',font, 'FontName','calibri Italic','TickLabelInterpreter','latex');

yl1 = ylabel('Current - p.u.','FontSize',font,'FontName','calibri Italic','Interpreter','latex')

set(gca,'YTick',[-2,-1,0,1,2])
set(gca,'XTick',[2.96,2.98,3,3.02,3.04])
set(gca,'XTickLabel',{})
set(gca,'GridAlpha',0.5,'MinorGridAlpha',0.8)


texto = text(2.97,1.75,'$i_o^{a}$');
texto.FontSize = 33;
texto.FontName = 'calibri';
texto.Interpreter  = 'latex';

set(gca,'GridLineStyle',':','GridAlpha',1.0)



axes('Position',[0.09 0.15 0.89 0.4])
hold on
h1 = plot(oscilacao_300HZ_carga_variaveis_t(1:100:end),oscilacao_300HZ_carga_variaveis_vo_a(1:100:end),':or','linewidth',1.8);
h2 = plot(t,y_oscilacao_300HZ_carga_variaveis_vo_a,'linewidth',2)
h3 = plot([3 3],intervalo_y.*10,'--k','linewidth',2)
box on;
hold off
xlim(intervalo_x)
ylim(intervalo_y*1.1)
grid


set(gca,'FontSize',font, 'FontName','calibri Italic','TickLabelInterpreter','latex');
set(gca,'YTick',[-2,-1,0,1,2])
set(gca,'XTick',[2.96,2.98,3,3.02,3.04])
set(gca,'GridAlpha',0.5,'MinorGridAlpha',0.8)
xl1 = xlabel('Time - s','FontSize',font,'FontName','calibri','Interpreter','latex')
yl2 = ylabel('Voltage - p.u.','FontSize',font,'FontName','calibri','Interpreter','latex')
leg = legend('PSCAD','Proposed Model','Location','southwest');
leg.FontSize = 0.8*font;
leg.Interpreter = 'latex';
leg.Orientation = 'horizontal'

texto = text(2.97,1.75,'$v_o^{a}$');
texto.FontSize = 33;
texto.FontName = 'calibri';
texto.Interpreter  = 'latex';

set(gca,'GridLineStyle',':','GridAlpha',1.0)



% export_fig 'figs/artigo1/time_resp_ca_300Hz' '-png' -transparent -painters -r400
%export_fig 'figs/artigo1/300dpi/time_resp_ca_300Hz' '-png' -transparent -painters -r300


%% Resposta oscilação io - 420Hz

u_oscilacao_420HZ_carga_variaveis_io_a = 200.*sin(2*pi*420.*t).*heaviside(t-3);
dy_oscilacao_420HZ_carga_variaveis_vo_a = lsim(Zth,u_oscilacao_420HZ_carga_variaveis_io_a,t);
y_oscilacao_420HZ_carga_variaveis_vo_a = (dy_oscilacao_420HZ_carga_variaveis_vo_a' + 56338.*sin(2*pi*60.*t))./56338; 


H = figure;
set(H,'Position',[50 100 1280 600]);
font = 28;
intervalo_x = [2.95 3.05];
intervalo_y = [-2 2];

axes('Position',[0.09 0.58 0.89 0.4])
hold on
h1 = plot(oscilacao_420HZ_carga_variaveis_t,oscilacao_420HZ_carga_variaveis_io_a,'linewidth',2.0);
h3 = plot([3 3],intervalo_y.*10,'--k','linewidth',2)
box on;
hold off
xlim(intervalo_x)
ylim(intervalo_y*1.1)
grid
set(gca,'FontSize',font, 'FontName','calibri Italic','TickLabelInterpreter','latex');

yl1 = ylabel('Current - p.u.','FontSize',font,'FontName','calibri Italic','Interpreter','latex')

set(gca,'YTick',[-2,-1,0,1,2])
set(gca,'XTick',[2.96,2.98,3,3.02,3.04])
set(gca,'XTickLabel',{})
set(gca,'GridAlpha',0.5,'MinorGridAlpha',0.8)


texto = text(2.97,1.75,'$i_o^{a}$');
texto.FontSize = 33;
texto.FontName = 'calibri';
texto.Interpreter  = 'latex';

set(gca,'GridLineStyle',':','GridAlpha',1.0)

axes('Position',[0.09 0.15 0.89 0.4])
hold on
h1 = plot(oscilacao_420HZ_carga_variaveis_t(1:100:end),oscilacao_420HZ_carga_variaveis_vo_a(1:100:end),':or','linewidth',1.8);
h2 = plot(t,y_oscilacao_420HZ_carga_variaveis_vo_a,'linewidth',2)
h3 = plot([3 3],intervalo_y.*10,'--k','linewidth',2)
box on;
hold off
xlim(intervalo_x)
ylim(intervalo_y*1.1)
grid


set(gca,'FontSize',font, 'FontName','calibri Italic','TickLabelInterpreter','latex');
set(gca,'YTick',[-2,-1,0,1,2])
set(gca,'XTick',[2.96,2.98,3,3.02,3.04])
set(gca,'GridAlpha',0.5,'MinorGridAlpha',0.8)
xl1 = xlabel('Time - s','FontSize',font,'FontName','calibri','Interpreter','latex')
yl2 = ylabel('Voltage - p.u.','FontSize',font,'FontName','calibri','Interpreter','latex')
leg = legend('PSCAD','Proposed Model','Location','southwest');
leg.FontSize = 0.8*font;
leg.Interpreter = 'latex';
leg.Orientation = 'horizontal'

texto = text(2.97,1.75,'$v_o^{a}$');
texto.FontSize = 33;
texto.FontName = 'calibri';
texto.Interpreter  = 'latex';

set(gca,'GridLineStyle',':','GridAlpha',1.0)


% export_fig 'figs/artigo1/time_resp_ca_420Hz' '-png' -transparent -painters -r400

%export_fig 'figs/artigo1/300dpi/time_resp_ca_420Hz' '-png' -transparent -painters -r300



%% Dados Simulação PSCAD - Oscilação no lado CC


data = csvread('Dados/Dados_PSCAD_EPSR_2019/oscilacao_0HZ_cc_variaveis_vcc.txt',1,0);
oscilacao_0HZ_cc_variaveis_t = data(:,1); 
oscilacao_0HZ_cc_variaveis_vcc = data(:,2)/150;

data = csvread('Dados/Dados_PSCAD_EPSR_2019/oscilacao_0HZ_cc_variaveis_icir.txt',1,0);
oscilacao_0HZ_cc_variaveis_icir_a = data(:,2)./1.183;

clearvars data 



data = csvread('Dados/Dados_PSCAD_EPSR_2019/oscilacao_120HZ_cc_variaveis_vcc.txt',1,0);
oscilacao_120HZ_cc_variaveis_t = data(:,1); 
oscilacao_120HZ_cc_variaveis_vcc = data(:,2)/150;

data = csvread('Dados/Dados_PSCAD_EPSR_2019/oscilacao_120HZ_cc_variaveis_icir.txt',1,0);
oscilacao_120HZ_cc_variaveis_icir_a = data(:,2)./1.183;

clearvars data 


data = csvread('Dados/Dados_PSCAD_EPSR_2019/oscilacao_240HZ_cc_variaveis_vcc.txt',1,0);
oscilacao_240HZ_cc_variaveis_t = data(:,1); 
oscilacao_240HZ_cc_variaveis_vcc = data(:,2)/150;

data = csvread('Dados/Dados_PSCAD_EPSR_2019/oscilacao_240HZ_cc_variaveis_icir.txt',1,0);
oscilacao_240HZ_cc_variaveis_icir_a = data(:,2)./1.183;

clearvars data 






%% Resposta oscilação vcc - 0Hz

u_oscilacao_0HZ_cc_variaveis_vcc = 10000.*heaviside(t-3);%2000.*sin(2*pi*420.*t).*heaviside(t-3);
dy_oscilacao_0HZ_cc_variaveis_icir_a = lsim(Y_cc_icir_s,u_oscilacao_0HZ_cc_variaveis_vcc,t);
y_oscilacao_0HZ_cc_variaveis_icir_a = (dy_oscilacao_0HZ_cc_variaveis_icir_a' - 220)./1183;%56338.*sin(2*pi*60.*t))./56338; 


H = figure;
set(H,'Position',[50 100 1280 600]);
font = 28;
intervalo_x = [2.98 3.22];
intervalo_yt = [0.85 1.15];
intervalo_yb = [-0.95 0.95];

axes('Position',[0.09 0.58 0.89 0.4])
hold on
h1 = plot(oscilacao_0HZ_cc_variaveis_t,oscilacao_0HZ_cc_variaveis_vcc,'linewidth',2.0);
h3 = plot([3 3],[-10 10],'--k','linewidth',2)
box on;
hold off
xlim(intervalo_x)
ylim(intervalo_yt)
grid
set(gca,'FontSize',font, 'FontName','calibri Italic','TickLabelInterpreter','latex');

yl1 = ylabel('Voltage - p.u.','FontSize',font,'FontName','calibri Italic','Interpreter','latex')

% set(gca,'YTick',[1,1.1])
set(gca,'XTick',[3,3.1,3.2,3.3])
set(gca,'XTickLabel',{})
set(gca,'GridAlpha',0.5,'MinorGridAlpha',0.8)


texto = text(2.985,1.05,'$v_{dc}$');
texto.FontSize = 33;
texto.FontName = 'calibri';
texto.Interpreter  = 'latex';

set(gca,'GridLineStyle',':','GridAlpha',1.0)

axes('Position',[0.09 0.15 0.89 0.4])
hold on
h1 = plot(oscilacao_0HZ_cc_variaveis_t(1:150:end),oscilacao_0HZ_cc_variaveis_icir_a(1:150:end),':or','linewidth',1.8);
h2 = plot(t,y_oscilacao_0HZ_cc_variaveis_icir_a,'linewidth',2)
h3 = plot([3 3],[-10 10],'--k','linewidth',2)
box on;
hold off
xlim(intervalo_x)
ylim(intervalo_yb)
grid


set(gca,'FontSize',font, 'FontName','calibri Italic','TickLabelInterpreter','latex');
set(gca,'YTick',[-1,-0.5,0,0.5,1])
set(gca,'XTick',[3,3.1,3.2,3.3])
set(gca,'GridAlpha',0.5,'MinorGridAlpha',0.8)

xl1 = xlabel('Time - s','FontSize',font,'FontName','calibri','Interpreter','latex')
yl2 = ylabel('Current - p.u.','FontSize',font,'FontName','calibri','Interpreter','latex')


leg = legend('PSCAD','Proposed Model','Location','northeast');
leg.FontSize = 0.8*font;
leg.Interpreter = 'latex';
leg.Orientation = 'horizontal'

texto = text(2.985,0.6,'$i_{cir}^{a}$');
texto.FontSize = 33;
texto.FontName = 'calibri';
texto.Interpreter  = 'latex';

set(gca,'GridLineStyle',':','GridAlpha',1.0)


% export_fig 'figs/artigo1/time_resp_cc_0Hz' '-png' -transparent -painters -r400

%export_fig 'figs/artigo1/300dpi/time_resp_cc_0Hz' '-png' -transparent -painters -r300




%% Resposta oscilação vcc - 120Hz

u_oscilacao_120HZ_cc_variaveis_vcc = 10000.*sin(2*pi*120.*t).*heaviside(t-3);
dy_oscilacao_120HZ_cc_variaveis_icir_a = lsim(Y_cc_icir_s,u_oscilacao_120HZ_cc_variaveis_vcc,t);
y_oscilacao_120HZ_cc_variaveis_icir_a = (dy_oscilacao_120HZ_cc_variaveis_icir_a' - 220)./1183;%56338.*sin(2*pi*60.*t))./56338; 


H = figure;
set(H,'Position',[50 100 1280 600]);
font = 28;
intervalo_x = [2.98 3.22];
intervalo_yt = [0.85 1.15];
intervalo_yb = [-0.45 0.15];

axes('Position',[0.09 0.58 0.89 0.4])
hold on
h1 = plot(oscilacao_120HZ_cc_variaveis_t,oscilacao_120HZ_cc_variaveis_vcc,'linewidth',2.0);
h3 = plot([3 3],[-10 10],'--k','linewidth',2)
box on;
hold off
xlim(intervalo_x)
ylim(intervalo_yt)
grid
set(gca,'FontSize',font, 'FontName','calibri Italic','TickLabelInterpreter','latex');

yl1 = ylabel('Voltage - p.u.','FontSize',font,'FontName','calibri Italic','Interpreter','latex')

% set(gca,'YTick',[1,1.1])
set(gca,'XTick',[3,3.1,3.2,3.3])
set(gca,'XTickLabel',{})
set(gca,'GridAlpha',0.5,'MinorGridAlpha',0.8)


texto = text(2.985,1.05,'$v_{dc}$');
texto.FontSize = 33;
texto.FontName = 'calibri';
texto.Interpreter  = 'latex';

set(gca,'GridLineStyle',':','GridAlpha',1.0)

axes('Position',[0.09 0.15 0.89 0.4])
hold on
h1 = plot(oscilacao_120HZ_cc_variaveis_t(1:50:end),oscilacao_120HZ_cc_variaveis_icir_a(1:50:end),':or','linewidth',1.8);
h2 = plot(t,y_oscilacao_120HZ_cc_variaveis_icir_a,'linewidth',2)
h3 = plot([3 3],[-10 10],'--k','linewidth',2)
box on;
hold off
xlim(intervalo_x)
ylim(intervalo_yb)
grid


set(gca,'FontSize',font, 'FontName','calibri Italic','TickLabelInterpreter','latex');
set(gca,'YTick',[-0.4,-0.2,0])
set(gca,'XTick',[3,3.1,3.2,3.3])
set(gca,'GridAlpha',0.5,'MinorGridAlpha',0.8)

xl1 = xlabel('Time - s','FontSize',font,'FontName','calibri','Interpreter','latex')
yl2 = ylabel('Current - p.u.','FontSize',font,'FontName','calibri','Interpreter','latex')


leg = legend('PSCAD','Proposed Model','Location','northeast');
leg.FontSize = 0.8*font;
leg.Interpreter = 'latex';
leg.Orientation = 'horizontal'

texto = text(2.985,-0.05,'$i_{cir}^{a}$');
texto.FontSize = 33;
texto.FontName = 'calibri';
texto.Interpreter  = 'latex';

set(gca,'GridLineStyle',':','GridAlpha',1.0)


% export_fig 'figs/artigo1/time_resp_cc_120Hz' '-png' -transparent -painters -r400

%export_fig 'figs/artigo1/300dpi/time_resp_cc_120Hz' '-png' -transparent -painters -r300







%% Resposta oscilação vcc - 240Hz

u_oscilacao_240HZ_cc_variaveis_vcc = 10000.*sin(2*pi*240.*t).*heaviside(t-3);
dy_oscilacao_240HZ_cc_variaveis_icir_a = lsim(Y_cc_icir_s,u_oscilacao_240HZ_cc_variaveis_vcc,t);
y_oscilacao_240HZ_cc_variaveis_icir_a = (dy_oscilacao_240HZ_cc_variaveis_icir_a' - 220)./1183;%56338.*sin(2*pi*60.*t))./56338; 


H = figure;
set(H,'Position',[50 100 1280 600]);
font = 28;
intervalo_x = [2.98 3.22];
intervalo_yt = [0.85 1.15];
intervalo_yb = [-0.45 0.15];

axes('Position',[0.09 0.58 0.89 0.4])
hold on
h1 = plot(oscilacao_240HZ_cc_variaveis_t,oscilacao_240HZ_cc_variaveis_vcc,'linewidth',2.0);
h3 = plot([3 3],[-10 10],'--k','linewidth',2)
box on;
hold off
xlim(intervalo_x)
ylim(intervalo_yt)
grid
set(gca,'FontSize',font, 'FontName','calibri Italic','TickLabelInterpreter','latex');

yl1 = ylabel('Voltage - p.u.','FontSize',font,'FontName','calibri Italic','Interpreter','latex')

% set(gca,'YTick',[1,1.1])
set(gca,'XTick',[3,3.1,3.2,3.3])
set(gca,'XTickLabel',{})
set(gca,'GridAlpha',0.5,'MinorGridAlpha',0.8)


texto = text(2.985,1.05,'$v_{dc}$');
texto.FontSize = 33;
texto.FontName = 'calibri';
texto.Interpreter  = 'latex';

set(gca,'GridLineStyle',':','GridAlpha',1.0)

axes('Position',[0.09 0.15 0.89 0.4])
hold on
h1 = plot(oscilacao_240HZ_cc_variaveis_t(1:50:end),oscilacao_240HZ_cc_variaveis_icir_a(1:50:end),':ro','linewidth',1.8);
h2 = plot(t,y_oscilacao_240HZ_cc_variaveis_icir_a,'linewidth',2)
h3 = plot([3 3],[-10 10],'--k','linewidth',2)
box on;
hold off
xlim(intervalo_x)
ylim(intervalo_yb)
grid


set(gca,'FontSize',font, 'FontName','calibri Italic','TickLabelInterpreter','latex');
set(gca,'YTick',[-0.4,-0.2,0])
set(gca,'XTick',[3,3.1,3.2,3.3])
set(gca,'GridAlpha',0.5,'MinorGridAlpha',0.8)

xl1 = xlabel('Time - s','FontSize',font,'FontName','calibri','Interpreter','latex')
yl2 = ylabel('Current - p.u.','FontSize',font,'FontName','calibri','Interpreter','latex')


leg = legend('PSCAD','Proposed Model','Location','northeast');
leg.FontSize = 0.8*font;
leg.Interpreter = 'latex';
leg.Orientation = 'horizontal'

texto = text(2.985,-0.05,'$i_{cir}^{a}$');
texto.FontSize = 33;
texto.FontName = 'calibri';
texto.Interpreter  = 'latex';

set(gca,'GridLineStyle',':','GridAlpha',1.0)


% export_fig 'figs/artigo1/time_resp_cc_240Hz' '-png' -transparent -painters -r400
%export_fig 'figs/artigo1/300dpi/time_resp_cc_240Hz' '-png' -transparent -painters -r300



