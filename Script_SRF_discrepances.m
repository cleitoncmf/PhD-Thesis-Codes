%% Testes do novo modelo com SRF 18/02/2019
clear all
clc




%% Funções para edição de figuras

addpath(genpath('altmany-export_fig-412662f/'));

addpath(genpath('breakxaxis/breakxaxis'));



%% Algumas definições

VLL_rated = 69e3;
S_rated = 100e6;

I_rated = S_rated/(sqrt(3)*VLL_rated);



Ip_rated = I_rated*sqrt(2);
Vp_rated = sqrt(2)*VLL_rated/sqrt(3);

Vdc_rated = 150e3;



%% Reading the data

DATA_50Hz = readtable('Dados/nonlinearities/DADOS_50HZ.csv');
DATA_60Hz = readtable('Dados/nonlinearities/DADOS_60HZ.csv');
DATA_70Hz = readtable('Dados/nonlinearities/DADOS_70HZ.csv');



%% Time response: circulating current for 50Hz

H = TIME_PLOT(DATA_50Hz.Time,DATA_50Hz.icira./Ip_rated,'',...
              DATA_50Hz.Time,DATA_50Hz.icirb./Ip_rated,'--',...
              DATA_50Hz.Time,DATA_50Hz.icirb./Ip_rated,':'...
                              );
hold on
plot([3 3],[-2 2],'--k','linewidth',2.5);
hold off
ylabel('Current - p.u.');
ylim([-0.35 -0.05])
xlim([2.9 4.5])
Hgca = get(gca);
Hgca.Children(2).Color = [0.47 0.25 0.80]

% export_fig 'figs/Tese/Disc/perturb_icir_50' '-png' -transparent -painters -r200



%% Time response: circulating current for 60Hz

H = TIME_PLOT(DATA_50Hz.Time,DATA_60Hz.icira./Ip_rated,'',...
              DATA_50Hz.Time,DATA_60Hz.icirb./Ip_rated,'--',...
              DATA_50Hz.Time,DATA_60Hz.icirb./Ip_rated,':'...
                              );
hold on
plot([3 3],[-2 2],'--k','linewidth',2.5);
hold off
ylabel('Current - p.u.');
ylim([-0.35 -0.05])
xlim([2.9 4.5])
Hgca = get(gca);
Hgca.Children(2).Color = [0.47 0.25 0.80]

% export_fig 'figs/Tese/Disc/perturb_icir_60' '-png' -transparent -painters -r200


%% Time response: circulating current for 70Hz


H = TIME_PLOT(DATA_50Hz.Time,DATA_70Hz.icira./Ip_rated,'',...
              DATA_50Hz.Time,DATA_70Hz.icirb./Ip_rated,'--',...
              DATA_50Hz.Time,DATA_70Hz.icirb./Ip_rated,':'...
                              );
hold on
plot([3 3],[-2 2],'--k','linewidth',2.5);
hold off
ylabel('Current - p.u.');
ylim([-0.35 -0.05])
xlim([2.9 4.5])
Hgca = get(gca);
Hgca.Children(2).Color = [0.47 0.25 0.80]

%export_fig 'figs/Tese/Disc/perturb_icir_70' '-png' -transparent -painters -r300

%% Time response: vdc 50Hz

H = TIME_PLOT(DATA_50Hz.Time,DATA_50Hz.vdc./Vdc_rated,'');
hold on
plot([3 3],[-2 2],'--k','linewidth',2.5);
hold off
ylim([0.99 1.01])
xlim([2.98 3.1])
ylabel('DC Voltage - p.u')

%export_fig 'figs/Tese/Disc/perturb_vdc_50' '-png' -transparent -painters -r200

[H,h]=BROKEN_X_TIME_PLOT(DATA_50Hz.Time,DATA_50Hz.vdc./Vdc_rated,'',[3.02 4.45])

%export_fig 'figs/Tese/Disc/perturb_vdc_50_BA' '-png' -transparent -painters -r200

%% Time response: vdc 60Hz

H = TIME_PLOT(DATA_50Hz.Time,DATA_60Hz.vdc./Vdc_rated,'');
hold on
plot([3 3],[-2 2],'--k','linewidth',2.5);
hold off
ylim([0.99 1.01])
xlim([2.98 3.1])
ylabel('DC Voltage - p.u')

%export_fig 'figs/Tese/Disc/perturb_vdc_60' '-png' -transparent -painters -r300


[H,h]=BROKEN_X_TIME_PLOT(DATA_60Hz.Time,DATA_60Hz.vdc./Vdc_rated,'',[3.02 4.45])

%export_fig 'figs/Tese/Disc/perturb_vdc_60_BA' '-png' -transparent -painters -r200

%% Time response: vdc 70Hz

H = TIME_PLOT(DATA_50Hz.Time,DATA_70Hz.vdc./Vdc_rated,'');
hold on
plot([3 3],[-2 2],'--k','linewidth',2.5);
hold off
ylim([0.99 1.01])
xlim([2.9 4.5])
ylabel('DC Voltage - p.u')

%export_fig 'figs/Tese/Disc/perturb_vdc_70' '-png' -transparent -painters -r300


[H,h]=BROKEN_X_TIME_PLOT(DATA_70Hz.Time,DATA_70Hz.vdc./Vdc_rated,'',[3.02 4.45])

%export_fig 'figs/Tese/Disc/perturb_vdc_70_BA' '-png' -transparent -painters -r200



%% Equivalend dc voltages  - 50Hz




H = TIME_PLOT(DATA_50Hz.Time,DATA_50Hz.vpa./Vdc_rated,'',...
              DATA_50Hz.Time,DATA_50Hz.vpb./Vdc_rated,'--',...
              DATA_50Hz.Time,DATA_50Hz.vpc./Vdc_rated,':'...
                              );
hold on
plot([3 3],[-2 2],'--k','linewidth',2.5);
hold off
ylabel('DC Voltage - p.u.');
ylim([0.96 1.04])
xlim([2.9 4.5])
lg = legend('a','b','c','Orientation','horizontal')
Hgca = get(gca);
Hgca.Children(2).Color = [0.47 0.25 0.80]

%export_fig 'figs/Tese/Disc/perturb_vdcp_50' '-png' -transparent -painters -r200

H = TIME_PLOT(DATA_50Hz.Time,DATA_50Hz.vna./Vdc_rated,'',...
              DATA_50Hz.Time,DATA_50Hz.vnb./Vdc_rated,'--',...
              DATA_50Hz.Time,DATA_50Hz.vnc./Vdc_rated,':'...
                              );
hold on
plot([3 3],[-2 2],'--k','linewidth',2.5);
hold off
ylabel('DC Voltage - p.u.');
ylim([0.96 1.04])
xlim([2.9 4.5])
lg = legend('a','b','c','Orientation','horizontal')
Hgca = get(gca);
Hgca.Children(2).Color = [0.47 0.25 0.80]

%export_fig 'figs/Tese/Disc/perturb_vdcn_50' '-png' -transparent -painters -r200


[H,h]=BROKEN_X_TIME_PLOT(DATA_50Hz.Time,DATA_50Hz.vpa./Vdc_rated,'',...
                         DATA_50Hz.Time,DATA_50Hz.vpb./Vdc_rated,'--',...
                         DATA_50Hz.Time,DATA_50Hz.vpc./Vdc_rated,':',[3.02 4.4])

h.leftAxes.XLim = [2.97 3]
h.leftAxes.YLim = [0.96 1.04]
h.rightAxes.YLim = [0.96 1.04]
set(gca,'YLim',[0.96 1.04])
h.annotationAxes.YLim = [0.96 1.04]
h.annotationAxes.XLabel.Position(2) = 0.94
h.rightAxes.XAxis.TickValues = [3 4.45 4.5]

Hgca = get(gca);
h.leftAxes.Children(1).Color = [0.47 0.25 0.80];
h.rightAxes.Children(1).Color = [0.47 0.25 0.80];

%export_fig 'figs/Tese/Disc/perturb_vdcp_50_zoom' '-png' -transparent -painters -r200



[H,h]=BROKEN_X_TIME_PLOT(DATA_50Hz.Time,DATA_50Hz.vna./Vdc_rated,'',...
                         DATA_50Hz.Time,DATA_50Hz.vnb./Vdc_rated,'--',...
                         DATA_50Hz.Time,DATA_50Hz.vnc./Vdc_rated,':',[3.02 4.4])

h.leftAxes.XLim = [2.97 3]
h.leftAxes.YLim = [0.96 1.04]
h.rightAxes.YLim = [0.96 1.04]
set(gca,'YLim',[0.96 1.04])
h.annotationAxes.YLim = [0.96 1.04]
h.annotationAxes.XLabel.Position(2) = 0.94
h.rightAxes.XAxis.TickValues = [3 4.45 4.5]

Hgca = get(gca);
h.leftAxes.Children(1).Color = [0.47 0.25 0.80];
h.rightAxes.Children(1).Color = [0.47 0.25 0.80];

%export_fig 'figs/Tese/Disc/perturb_vdcn_50_zoom' '-png' -transparent -painters -r200


%% Equivalend dc voltages  - 60Hz




H = TIME_PLOT(DATA_60Hz.Time,DATA_60Hz.vpa./Vdc_rated,'',...
              DATA_60Hz.Time,DATA_60Hz.vpb./Vdc_rated,'--',...
              DATA_60Hz.Time,DATA_60Hz.vpc./Vdc_rated,':'...
                              );
hold on
plot([3 3],[-2 2],'--k','linewidth',2.5);
hold off
ylabel('DC Voltage - p.u.');
ylim([0.96 1.04])
xlim([2.9 4.5])
lg = legend('a','b','c','Orientation','horizontal')
Hgca = get(gca);
Hgca.Children(2).Color = [0.47 0.25 0.80]

% export_fig 'figs/Tese/Disc/perturb_vdcp_60' '-png' -transparent -painters -r200


H = TIME_PLOT(DATA_60Hz.Time,DATA_60Hz.vna./Vdc_rated,'',...
              DATA_60Hz.Time,DATA_60Hz.vnb./Vdc_rated,'--',...
              DATA_60Hz.Time,DATA_60Hz.vnc./Vdc_rated,':'...
                              );
hold on
plot([3 3],[-2 2],'--k','linewidth',2.5);
hold off
ylabel('DC Voltage - p.u.');
ylim([0.96 1.04])
xlim([2.9 4.5])
lg = legend('a','b','c','Orientation','horizontal')
Hgca = get(gca);
Hgca.Children(2).Color = [0.47 0.25 0.80]

% export_fig 'figs/Tese/Disc/perturb_vdcn_60' '-png' -transparent -painters -r200


[H,h]=BROKEN_X_TIME_PLOT(DATA_60Hz.Time,DATA_60Hz.vpa./Vdc_rated,'',...
                         DATA_60Hz.Time,DATA_60Hz.vpb./Vdc_rated,'--',...
                         DATA_60Hz.Time,DATA_60Hz.vpc./Vdc_rated,':',[3.02 4.40])

h.leftAxes.XLim = [2.97 3]
h.leftAxes.YLim = [0.96 1.04]
h.rightAxes.YLim = [0.96 1.04]
set(gca,'YLim',[0.96 1.04])
h.annotationAxes.YLim = [0.96 1.04]
h.annotationAxes.XLabel.Position(2) = 0.94
h.rightAxes.XAxis.TickValues = [3 4.45 4.5]
h.leftAxes.Children(1).Color = [0.47 0.25 0.80];
h.rightAxes.Children(1).Color = [0.47 0.25 0.80];

% export_fig 'figs/Tese/Disc/perturb_vdcp_60_zoom' '-png' -transparent -painters -r200


[H,h]=BROKEN_X_TIME_PLOT(DATA_60Hz.Time,DATA_60Hz.vna./Vdc_rated,'',...
                         DATA_60Hz.Time,DATA_60Hz.vnb./Vdc_rated,'--',...
                         DATA_60Hz.Time,DATA_60Hz.vnc./Vdc_rated,':',[3.02 4.40])

h.leftAxes.XLim = [2.97 3]
h.leftAxes.YLim = [0.96 1.04]
h.rightAxes.YLim = [0.96 1.04]
set(gca,'YLim',[0.96 1.04])
h.annotationAxes.YLim = [0.96 1.04]
h.annotationAxes.XLabel.Position(2) = 0.94
h.rightAxes.XAxis.TickValues = [3 4.45 4.5]
h.leftAxes.Children(1).Color = [0.47 0.25 0.80];
h.rightAxes.Children(1).Color = [0.47 0.25 0.80];

% export_fig 'figs/Tese/Disc/perturb_vdcn_60_zoom' '-png' -transparent -painters -r200


%% Equivalend dc voltages  - 70Hz




H = TIME_PLOT(DATA_70Hz.Time,DATA_70Hz.vpa./Vdc_rated,'',...
              DATA_70Hz.Time,DATA_70Hz.vpb./Vdc_rated,'--',...
              DATA_70Hz.Time,DATA_70Hz.vpc./Vdc_rated,':'...
                              );
hold on
plot([3 3],[-2 2],'--k','linewidth',2.5);
hold off
ylabel('DC Voltage - p.u.');
ylim([0.96 1.04])
xlim([2.9 4.5])
lg = legend('a','b','c','Orientation','horizontal')
Hgca = get(gca);
Hgca.Children(2).Color = [0.47 0.25 0.80]

% export_fig 'figs/Tese/Disc/perturb_vdcp_70' '-png' -transparent -painters -r200

H = TIME_PLOT(DATA_70Hz.Time,DATA_70Hz.vna./Vdc_rated,'',...
              DATA_70Hz.Time,DATA_70Hz.vnb./Vdc_rated,'--',...
              DATA_70Hz.Time,DATA_70Hz.vnc./Vdc_rated,':'...
                              );
hold on
plot([3 3],[-2 2],'--k','linewidth',2.5);
hold off
ylabel('DC Voltage - p.u.');
ylim([0.96 1.04])
xlim([2.9 4.5])
lg = legend('a','b','c','Orientation','horizontal')
Hgca = get(gca);
Hgca.Children(2).Color = [0.47 0.25 0.80]


% export_fig 'figs/Tese/Disc/perturb_vdcn_70' '-png' -transparent -painters -r200


[H,h]=BROKEN_X_TIME_PLOT(DATA_70Hz.Time,DATA_70Hz.vpa./Vdc_rated,'',...
                         DATA_70Hz.Time,DATA_70Hz.vpb./Vdc_rated,'--',...
                         DATA_70Hz.Time,DATA_70Hz.vpc./Vdc_rated,':',[3.02 4.40])

h.leftAxes.XLim = [2.97 3]
h.leftAxes.YLim = [0.96 1.04]
h.rightAxes.YLim = [0.96 1.04]
set(gca,'YLim',[0.96 1.04])
h.annotationAxes.YLim = [0.96 1.04]
h.annotationAxes.XLabel.Position(2) = 0.94
h.rightAxes.XAxis.TickValues = [3 4.45 4.5]
h.leftAxes.Children(1).Color = [0.47 0.25 0.80];
h.rightAxes.Children(1).Color = [0.47 0.25 0.80];

% export_fig 'figs/Tese/Disc/perturb_vdcp_70_zoom' '-png' -transparent -painters -r200


[H,h]=BROKEN_X_TIME_PLOT(DATA_70Hz.Time,DATA_70Hz.vna./Vdc_rated,'',...
                         DATA_70Hz.Time,DATA_70Hz.vnb./Vdc_rated,'--',...
                         DATA_70Hz.Time,DATA_70Hz.vnc./Vdc_rated,':',[3.02 4.40])

h.leftAxes.XLim = [2.97 3]
h.leftAxes.YLim = [0.96 1.04]
h.rightAxes.YLim = [0.96 1.04]
set(gca,'YLim',[0.96 1.04])
h.annotationAxes.YLim = [0.96 1.04]
h.annotationAxes.XLabel.Position(2) = 0.94
h.rightAxes.XAxis.TickValues = [3 4.45 4.5]
h.leftAxes.Children(1).Color = [0.47 0.25 0.80];
h.rightAxes.Children(1).Color = [0.47 0.25 0.80];

% export_fig 'figs/Tese/Disc/perturb_vdcn_70_zoom' '-png' -transparent -painters -r200


%%



