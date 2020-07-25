%% PSCAD results for the thesis chapter MMC
clear all
clc

%% Funções para edição de figuras

addpath(genpath('altmany-export_fig-412662f/'));


%% Dados

%PSCAD_DATA =  csvread('Dados/Dados_PSCAD_MMC_TESE/Dados_PSCAD_MMC_TESE_OPENLOOP.csv',1,0);

PSCAD_DATA =  readtable('Dados/Dados_PSCAD_MMC_TESE/Dados_PSCAD_MMC_TESE_OPENLOOP.csv');

PSCAD_DATA_FOURIER =  readtable('Dados/Dados_PSCAD_MMC_TESE/Dados_PSCAD_MMC_TESE_OPENLOOP_FOURIER.csv');



%% Rated values

S0 = 100e6;
VL0rms = 69e3;
I0rms = S0/(sqrt(3)*VL0rms);
V0rms = VL0rms/sqrt(3);
VL0 = sqrt(2)*VL0rms;
I0 = sqrt(2)*I0rms;
V0 = sqrt(2)*V0rms;
Vdc0 = 150e3;
N = 20;
Idc0 = S0/Vdc0;

%% Definitions

phase_a = [0, 0, 150]./256;
phase_b = [0, 180, 0]./256;
phase_c = [231, 13, 17]./256;

%% Circulating current: full simulation



H = figure;
%set(H,'Position',[50 100 1280 600]);
set(H,'Position',[50 100 1280 300]);

FS = 16;


axes('Position',[0.066 0.20 0.9 0.75])
hold on
h1 = plot(PSCAD_DATA.Time,1000.*PSCAD_DATA.icira./Idc0,'-','color',phase_a,'linewidth',2.0);
h2 = plot(PSCAD_DATA.Time,1000.*PSCAD_DATA.icirb./Idc0,'--','color',phase_b,'linewidth',2.0);
h3 = plot(PSCAD_DATA.Time,1000.*PSCAD_DATA.icirc./Idc0,'-.','color',phase_c,'linewidth',2.0);
h4 = plot([0.1 0.1],[-10 10],'--k','linewidth',2.0);
%h2 = plot(psim_f2,psim_AmpdB2,'or','linewidth',2.0);
hold off
%xlim([1 1000])
grid
set(gca,'FontSize',FS,'FontName','calibri Italic','TickLabelInterpreter','latex');
ylabel('Current - p.u. ','FontSize',FS,'FontName','calibri Italic','interpreter','latex');
xlabel('Time - s','FontSize',FS,'FontName','calibri Italic','interpreter','latex');
%set(gca,'GridAlpha',0.5,'MinorGridAlpha',0.8)
xlim([0.09 0.4])
ylim([-2.5 5])


leg = legend('Phase a','Phase b','Phase c','Location','northeast','Orientation', 'horizontal');
leg.FontSize = FS;
leg.Interpreter = 'latex';


%export_fig 'figs/Tese/MMC_PSCAD/icir' '-png' -transparent -painters -r200





%% Circulating current: zoom



H = figure;
%set(H,'Position',[50 100 1280 600]);
set(H,'Position',[50 100 1280 300]);

FS = 16;


axes('Position',[0.066 0.20 0.9 0.75])
hold on
h1 = plot(PSCAD_DATA.Time,1000.*PSCAD_DATA.icira./Idc0,'-','color',phase_a,'linewidth',2.0);
h2 = plot(PSCAD_DATA.Time,1000.*PSCAD_DATA.icirb./Idc0,'--','color',phase_b,'linewidth',2.0);
h3 = plot(PSCAD_DATA.Time,1000.*PSCAD_DATA.icirc./Idc0,'-.','color',phase_c,'linewidth',2.0);
h4 = plot([0.1 0.1],[-10 10],'--k','linewidth',2.0);
%h2 = plot(psim_f2,psim_AmpdB2,'or','linewidth',2.0);
hold off
%xlim([1 1000])
grid
set(gca,'FontSize',FS,'FontName','calibri Italic','TickLabelInterpreter','latex');
ylabel('Current - p.u. ','FontSize',FS,'FontName','calibri Italic','interpreter','latex');
xlabel('Time - s','FontSize',FS,'FontName','calibri Italic','interpreter','latex');
%set(gca,'GridAlpha',0.5,'MinorGridAlpha',0.8)
xlim([0.35 0.4])
ylim([0.22 0.42])


leg = legend('Phase a','Phase b','Phase c','Location','northeast','Orientation', 'horizontal');
leg.FontSize = FS;
leg.Interpreter = 'latex';


%export_fig 'figs/Tese/MMC_PSCAD/icir_zoom' '-png' -transparent -painters -r300


%% Output current: full simulation



H = figure;
%set(H,'Position',[50 100 1280 600]);
set(H,'Position',[50 100 1280 300]);

FS = 16;


axes('Position',[0.066 0.20 0.9 0.75])
hold on
h1 = plot(PSCAD_DATA.Time,1000.*PSCAD_DATA.ica./I0,'-','color',phase_a,'linewidth',2.0);
h2 = plot(PSCAD_DATA.Time,1000.*PSCAD_DATA.icb./I0,'--','color',phase_b,'linewidth',2.0);
h3 = plot(PSCAD_DATA.Time,1000.*PSCAD_DATA.icc./I0,'-.','color',phase_c,'linewidth',2.0);
h4 = plot([0.1 0.1],[-10 10],'--k','linewidth',2.0);
%h2 = plot(psim_f2,psim_AmpdB2,'or','linewidth',2.0);
hold off
%xlim([1 1000])
grid
set(gca,'FontSize',FS,'FontName','calibri Italic','TickLabelInterpreter','latex');
ylabel('Current - p.u. ','FontSize',FS,'FontName','calibri Italic','interpreter','latex');
xlabel('Time - s','FontSize',FS,'FontName','calibri Italic','interpreter','latex');
%set(gca,'GridAlpha',0.5,'MinorGridAlpha',0.8)
xlim([0.09 0.4])
ylim([-1.6 1.6])


leg = legend('Phase a','Phase b','Phase c','Location','northeast','Orientation', 'horizontal');
leg.FontSize = FS;
leg.Interpreter = 'latex';


%export_fig 'figs/Tese/MMC_PSCAD/ic' '-png' -transparent -painters -r200


%% Output voltage: full simulation



H = figure;
%set(H,'Position',[50 100 1280 600]);
set(H,'Position',[50 100 1280 300]);

FS = 16;


axes('Position',[0.066 0.20 0.9 0.75])
hold on
h1 = plot(PSCAD_DATA.Time,1000.*PSCAD_DATA.eca./V0,'-','color',phase_a,'linewidth',2.0);
h2 = plot(PSCAD_DATA.Time,1000.*PSCAD_DATA.ecb./V0,'--','color',phase_b,'linewidth',2.0);
h3 = plot(PSCAD_DATA.Time,1000.*PSCAD_DATA.ecc./V0,'-.','color',phase_c,'linewidth',2.0);
h4 = plot([0.1 0.1],[-10 10],'--k','linewidth',2.0);
%h2 = plot(psim_f2,psim_AmpdB2,'or','linewidth',2.0);
hold off
%xlim([1 1000])
grid
set(gca,'FontSize',FS,'FontName','calibri Italic','TickLabelInterpreter','latex');
ylabel('Voltage - p.u. ','FontSize',FS,'FontName','calibri Italic','interpreter','latex');
xlabel('Time - s','FontSize',FS,'FontName','calibri Italic','interpreter','latex');
%set(gca,'GridAlpha',0.5,'MinorGridAlpha',0.8)
xlim([0.09 0.4])
ylim([-1.6 1.6])


leg = legend('Phase a','Phase b','Phase c','Location','northeast','Orientation', 'horizontal');
leg.FontSize = FS;
leg.Interpreter = 'latex';


%export_fig 'figs/Tese/MMC_PSCAD/ec' '-png' -transparent -painters -r200


%% Output voltage: zoom


H = figure;
%set(H,'Position',[50 100 1280 600]);
set(H,'Position',[50 100 1280 300]);

FS = 16;


axes('Position',[0.066 0.20 0.9 0.75])
hold on
h1 = plot(PSCAD_DATA.Time,1000.*PSCAD_DATA.eca./V0,'-','color',phase_a,'linewidth',2.0);
h2 = plot(PSCAD_DATA.Time,1000.*PSCAD_DATA.ecb./V0,'--','color',phase_b,'linewidth',2.0);
h3 = plot(PSCAD_DATA.Time,1000.*PSCAD_DATA.ecc./V0,'-.','color',phase_c,'linewidth',2.0);
h4 = plot([0.1 0.1],[-10 10],'--k','linewidth',2.0);
%h2 = plot(psim_f2,psim_AmpdB2,'or','linewidth',2.0);
hold off
%xlim([1 1000])
grid
set(gca,'FontSize',FS,'FontName','calibri Italic','TickLabelInterpreter','latex');
ylabel('Voltage - p.u. ','FontSize',FS,'FontName','calibri Italic','interpreter','latex');
xlabel('Time - s','FontSize',FS,'FontName','calibri Italic','interpreter','latex');
%set(gca,'GridAlpha',0.5,'MinorGridAlpha',0.8)
%xlim([0.09 0.4])
xlim([0.382 0.392])
ylim([0 1])


leg = legend('Phase a','Phase b','Phase c','Location','northeast','Orientation', 'horizontal');
leg.FontSize = FS;
leg.Interpreter = 'latex';


%export_fig 'figs/Tese/MMC_PSCAD/ec_zoom' '-png' -transparent -painters -r200



%% Upper arm dc voltages of phase a: full simulation



H = figure;
%set(H,'Position',[50 100 1280 600]);
set(H,'Position',[50 100 1280 300]);

FS = 16;


axes('Position',[0.066 0.20 0.9 0.75])
hold on
h1 = plot(PSCAD_DATA.Time,1000.*PSCAD_DATA.vdcap1./Vdc0,'linewidth',2.0);
h2 = plot(PSCAD_DATA.Time,1000.*PSCAD_DATA.vdcap2./Vdc0,'linewidth',2.0);
h3 = plot(PSCAD_DATA.Time,1000.*PSCAD_DATA.vdcap3./Vdc0,'linewidth',2.0);
h4 = plot(PSCAD_DATA.Time,1000.*PSCAD_DATA.vdcap4./Vdc0,'linewidth',2.0);
h5 = plot(PSCAD_DATA.Time,1000.*PSCAD_DATA.vdcap5./Vdc0,'linewidth',2.0);
h6 = plot(PSCAD_DATA.Time,1000.*PSCAD_DATA.vdcap6./Vdc0,'linewidth',2.0);
h7 = plot(PSCAD_DATA.Time,1000.*PSCAD_DATA.vdcap7./Vdc0,'linewidth',2.0);
h8 = plot(PSCAD_DATA.Time,1000.*PSCAD_DATA.vdcap8./Vdc0,'linewidth',2.0);
h9 = plot(PSCAD_DATA.Time,1000.*PSCAD_DATA.vdcap9./Vdc0,'linewidth',2.0);
h10 = plot(PSCAD_DATA.Time,1000.*PSCAD_DATA.vdcap10./Vdc0,'linewidth',2.0);
h11 = plot(PSCAD_DATA.Time,1000.*PSCAD_DATA.vdcap11./Vdc0,'linewidth',2.0);
h12 = plot(PSCAD_DATA.Time,1000.*PSCAD_DATA.vdcap12./Vdc0,'linewidth',2.0);
h13 = plot(PSCAD_DATA.Time,1000.*PSCAD_DATA.vdcap13./Vdc0,'linewidth',2.0);
h14 = plot(PSCAD_DATA.Time,1000.*PSCAD_DATA.vdcap14./Vdc0,'linewidth',2.0);
h15 = plot(PSCAD_DATA.Time,1000.*PSCAD_DATA.vdcap15./Vdc0,'linewidth',2.0);
h16 = plot(PSCAD_DATA.Time,1000.*PSCAD_DATA.vdcap16./Vdc0,'linewidth',2.0);
h17 = plot(PSCAD_DATA.Time,1000.*PSCAD_DATA.vdcap17./Vdc0,'linewidth',2.0);
h18 = plot(PSCAD_DATA.Time,1000.*PSCAD_DATA.vdcap18./Vdc0,'linewidth',2.0);
h19 = plot(PSCAD_DATA.Time,1000.*PSCAD_DATA.vdcap19./Vdc0,'linewidth',2.0);
h20 = plot(PSCAD_DATA.Time,1000.*PSCAD_DATA.vdcap20./Vdc0,'linewidth',2.0);

h21 = plot([0.1 0.1],[-10 10],'--k','linewidth',2.0);

hold off
%xlim([1 1000])
grid
set(gca,'FontSize',FS,'FontName','calibri Italic','TickLabelInterpreter','latex');
ylabel('Voltage - p.u. ','FontSize',FS,'FontName','calibri Italic','interpreter','latex');
xlabel('Time - s','FontSize',FS,'FontName','calibri Italic','interpreter','latex');
%set(gca,'GridAlpha',0.5,'MinorGridAlpha',0.8)
xlim([0.09 0.4])
ylim([0.03 0.06])



%export_fig 'figs/Tese/MMC_PSCAD/vdcpa' '-png' -transparent -painters -r200




%% Upper arm dc voltages of phase a: zoom



H = figure;
%set(H,'Position',[50 100 1280 600]);
set(H,'Position',[50 100 1280 300]);

FS = 16;


axes('Position',[0.066 0.20 0.9 0.75])
hold on
h1 = plot(PSCAD_DATA.Time,1000.*PSCAD_DATA.vdcap1./Vdc0,'linewidth',2.0);
h2 = plot(PSCAD_DATA.Time,1000.*PSCAD_DATA.vdcap2./Vdc0,'linewidth',2.0);
h3 = plot(PSCAD_DATA.Time,1000.*PSCAD_DATA.vdcap3./Vdc0,'linewidth',2.0);
h4 = plot(PSCAD_DATA.Time,1000.*PSCAD_DATA.vdcap4./Vdc0,'linewidth',2.0);
h5 = plot(PSCAD_DATA.Time,1000.*PSCAD_DATA.vdcap5./Vdc0,'linewidth',2.0);
h6 = plot(PSCAD_DATA.Time,1000.*PSCAD_DATA.vdcap6./Vdc0,'linewidth',2.0);
h7 = plot(PSCAD_DATA.Time,1000.*PSCAD_DATA.vdcap7./Vdc0,'linewidth',2.0);
h8 = plot(PSCAD_DATA.Time,1000.*PSCAD_DATA.vdcap8./Vdc0,'linewidth',2.0);
h9 = plot(PSCAD_DATA.Time,1000.*PSCAD_DATA.vdcap9./Vdc0,'linewidth',2.0);
h10 = plot(PSCAD_DATA.Time,1000.*PSCAD_DATA.vdcap10./Vdc0,'linewidth',2.0);
h11 = plot(PSCAD_DATA.Time,1000.*PSCAD_DATA.vdcap11./Vdc0,'linewidth',2.0);
h12 = plot(PSCAD_DATA.Time,1000.*PSCAD_DATA.vdcap12./Vdc0,'linewidth',2.0);
h13 = plot(PSCAD_DATA.Time,1000.*PSCAD_DATA.vdcap13./Vdc0,'linewidth',2.0);
h14 = plot(PSCAD_DATA.Time,1000.*PSCAD_DATA.vdcap14./Vdc0,'linewidth',2.0);
h15 = plot(PSCAD_DATA.Time,1000.*PSCAD_DATA.vdcap15./Vdc0,'linewidth',2.0);
h16 = plot(PSCAD_DATA.Time,1000.*PSCAD_DATA.vdcap16./Vdc0,'linewidth',2.0);
h17 = plot(PSCAD_DATA.Time,1000.*PSCAD_DATA.vdcap17./Vdc0,'linewidth',2.0);
h18 = plot(PSCAD_DATA.Time,1000.*PSCAD_DATA.vdcap18./Vdc0,'linewidth',2.0);
h19 = plot(PSCAD_DATA.Time,1000.*PSCAD_DATA.vdcap19./Vdc0,'linewidth',2.0);
h20 = plot(PSCAD_DATA.Time,1000.*PSCAD_DATA.vdcap20./Vdc0,'linewidth',2.0);

%h21 = plot([0.1 0.1],[-10 10],'--k','linewidth',2.0);

hold off
%xlim([1 1000])
grid
set(gca,'FontSize',FS,'FontName','calibri Italic','TickLabelInterpreter','latex');
ylabel('Voltage - p.u. ','FontSize',FS,'FontName','calibri Italic','interpreter','latex');
xlabel('Time - s','FontSize',FS,'FontName','calibri Italic','interpreter','latex');
%set(gca,'GridAlpha',0.5,'MinorGridAlpha',0.8)
xlim([0.3 0.4])
ylim([0.048 0.052])



%export_fig 'figs/Tese/MMC_PSCAD/vdcpa_zoom' '-png' -transparent -painters -r200






%% Lower arm dc voltages of phase a: full simulation



H = figure;
%set(H,'Position',[50 100 1280 600]);
set(H,'Position',[50 100 1280 300]);

FS = 16;


axes('Position',[0.066 0.20 0.9 0.75])
hold on
h1 = plot(PSCAD_DATA.Time,1000.*PSCAD_DATA.vdcan1./Vdc0,'linewidth',2.0);
h2 = plot(PSCAD_DATA.Time,1000.*PSCAD_DATA.vdcan2./Vdc0,'linewidth',2.0);
h3 = plot(PSCAD_DATA.Time,1000.*PSCAD_DATA.vdcan3./Vdc0,'linewidth',2.0);
h4 = plot(PSCAD_DATA.Time,1000.*PSCAD_DATA.vdcan4./Vdc0,'linewidth',2.0);
h5 = plot(PSCAD_DATA.Time,1000.*PSCAD_DATA.vdcan5./Vdc0,'linewidth',2.0);
h6 = plot(PSCAD_DATA.Time,1000.*PSCAD_DATA.vdcan6./Vdc0,'linewidth',2.0);
h7 = plot(PSCAD_DATA.Time,1000.*PSCAD_DATA.vdcan7./Vdc0,'linewidth',2.0);
h8 = plot(PSCAD_DATA.Time,1000.*PSCAD_DATA.vdcan8./Vdc0,'linewidth',2.0);
h9 = plot(PSCAD_DATA.Time,1000.*PSCAD_DATA.vdcan9./Vdc0,'linewidth',2.0);
h10 = plot(PSCAD_DATA.Time,1000.*PSCAD_DATA.vdcan10./Vdc0,'linewidth',2.0);
h11 = plot(PSCAD_DATA.Time,1000.*PSCAD_DATA.vdcan11./Vdc0,'linewidth',2.0);
h12 = plot(PSCAD_DATA.Time,1000.*PSCAD_DATA.vdcan12./Vdc0,'linewidth',2.0);
h13 = plot(PSCAD_DATA.Time,1000.*PSCAD_DATA.vdcan13./Vdc0,'linewidth',2.0);
h14 = plot(PSCAD_DATA.Time,1000.*PSCAD_DATA.vdcan14./Vdc0,'linewidth',2.0);
h15 = plot(PSCAD_DATA.Time,1000.*PSCAD_DATA.vdcan15./Vdc0,'linewidth',2.0);
h16 = plot(PSCAD_DATA.Time,1000.*PSCAD_DATA.vdcan16./Vdc0,'linewidth',2.0);
h17 = plot(PSCAD_DATA.Time,1000.*PSCAD_DATA.vdcan17./Vdc0,'linewidth',2.0);
h18 = plot(PSCAD_DATA.Time,1000.*PSCAD_DATA.vdcan18./Vdc0,'linewidth',2.0);
h19 = plot(PSCAD_DATA.Time,1000.*PSCAD_DATA.vdcan19./Vdc0,'linewidth',2.0);
h20 = plot(PSCAD_DATA.Time,1000.*PSCAD_DATA.vdcan20./Vdc0,'linewidth',2.0);

h21 = plot([0.1 0.1],[-10 10],'--k','linewidth',2.0);

hold off
%xlim([1 1000])
grid
set(gca,'FontSize',FS,'FontName','calibri Italic','TickLabelInterpreter','latex');
ylabel('Voltage - p.u. ','FontSize',FS,'FontName','calibri Italic','interpreter','latex');
xlabel('Time - s','FontSize',FS,'FontName','calibri Italic','interpreter','latex');
%set(gca,'GridAlpha',0.5,'MinorGridAlpha',0.8)
xlim([0.09 0.4])
ylim([0.03 0.06])



%export_fig 'figs/Tese/MMC_PSCAD/vdcna' '-png' -transparent -painters -r200



%% Lower arm dc voltages of phase a: zoom


H = figure;
%set(H,'Position',[50 100 1280 600]);
set(H,'Position',[50 100 1280 300]);

FS = 16;


axes('Position',[0.066 0.20 0.9 0.75])
hold on
h1 = plot(PSCAD_DATA.Time,1000.*PSCAD_DATA.vdcan1./Vdc0,'linewidth',2.0);
h2 = plot(PSCAD_DATA.Time,1000.*PSCAD_DATA.vdcan2./Vdc0,'linewidth',2.0);
h3 = plot(PSCAD_DATA.Time,1000.*PSCAD_DATA.vdcan3./Vdc0,'linewidth',2.0);
h4 = plot(PSCAD_DATA.Time,1000.*PSCAD_DATA.vdcan4./Vdc0,'linewidth',2.0);
h5 = plot(PSCAD_DATA.Time,1000.*PSCAD_DATA.vdcan5./Vdc0,'linewidth',2.0);
h6 = plot(PSCAD_DATA.Time,1000.*PSCAD_DATA.vdcan6./Vdc0,'linewidth',2.0);
h7 = plot(PSCAD_DATA.Time,1000.*PSCAD_DATA.vdcan7./Vdc0,'linewidth',2.0);
h8 = plot(PSCAD_DATA.Time,1000.*PSCAD_DATA.vdcan8./Vdc0,'linewidth',2.0);
h9 = plot(PSCAD_DATA.Time,1000.*PSCAD_DATA.vdcan9./Vdc0,'linewidth',2.0);
h10 = plot(PSCAD_DATA.Time,1000.*PSCAD_DATA.vdcan10./Vdc0,'linewidth',2.0);
h11 = plot(PSCAD_DATA.Time,1000.*PSCAD_DATA.vdcan11./Vdc0,'linewidth',2.0);
h12 = plot(PSCAD_DATA.Time,1000.*PSCAD_DATA.vdcan12./Vdc0,'linewidth',2.0);
h13 = plot(PSCAD_DATA.Time,1000.*PSCAD_DATA.vdcan13./Vdc0,'linewidth',2.0);
h14 = plot(PSCAD_DATA.Time,1000.*PSCAD_DATA.vdcan14./Vdc0,'linewidth',2.0);
h15 = plot(PSCAD_DATA.Time,1000.*PSCAD_DATA.vdcan15./Vdc0,'linewidth',2.0);
h16 = plot(PSCAD_DATA.Time,1000.*PSCAD_DATA.vdcan16./Vdc0,'linewidth',2.0);
h17 = plot(PSCAD_DATA.Time,1000.*PSCAD_DATA.vdcan17./Vdc0,'linewidth',2.0);
h18 = plot(PSCAD_DATA.Time,1000.*PSCAD_DATA.vdcan18./Vdc0,'linewidth',2.0);
h19 = plot(PSCAD_DATA.Time,1000.*PSCAD_DATA.vdcan19./Vdc0,'linewidth',2.0);
h20 = plot(PSCAD_DATA.Time,1000.*PSCAD_DATA.vdcan20./Vdc0,'linewidth',2.0);

%h21 = plot([0.1 0.1],[-10 10],'--k','linewidth',2.0);

hold off
%xlim([1 1000])
grid
set(gca,'FontSize',FS,'FontName','calibri Italic','TickLabelInterpreter','latex');
ylabel('Voltage - p.u. ','FontSize',FS,'FontName','calibri Italic','interpreter','latex');
xlabel('Time - s','FontSize',FS,'FontName','calibri Italic','interpreter','latex');
%set(gca,'GridAlpha',0.5,'MinorGridAlpha',0.8)
xlim([0.3 0.4])
ylim([0.048 0.052])



%export_fig 'figs/Tese/MMC_PSCAD/vdcna_zoom' '-png' -transparent -painters -r200



%% Mask for highlighting the harmonic components

HM = dirac(PSCAD_DATA_FOURIER.Frequency) + ...
     dirac(PSCAD_DATA_FOURIER.Frequency - 060) + ...
     dirac(PSCAD_DATA_FOURIER.Frequency - 120) + ...
     dirac(PSCAD_DATA_FOURIER.Frequency - 180) + ...
     dirac(PSCAD_DATA_FOURIER.Frequency - 240) + ...
     dirac(PSCAD_DATA_FOURIER.Frequency - 300) + ...
     dirac(PSCAD_DATA_FOURIER.Frequency - 360) + ...
     dirac(PSCAD_DATA_FOURIER.Frequency - 420);
 
 idx = HM == Inf; % find Inf
 
 HM(idx) = 1;
 
 HM = HM +1e-8;
 stem(HM)


%% Circulating current: Fourier



H = figure;
%set(H,'Position',[50 100 1280 600]);
set(H,'Position',[50 100 1280 300]);

FS = 16;


axes('Position',[0.066 0.20 0.9 0.75])
hold on
%h1 = plot(PSCAD_DATA_FOURIER.Frequency,1000.*HM.*PSCAD_DATA_FOURIER.icira./I0,'-','color',phase_a,'linewidth',2.0);
%h0 = quiver(0,1e-5,0,0.1,0,'linewidth',3,'ShowArrowHead','on','MaxHeadSize',2000);
h1 = stem(PSCAD_DATA_FOURIER.Frequency,1000.*HM.*PSCAD_DATA_FOURIER.icira./I0,'-','color',phase_a,'linewidth',2.0,'Marker','^');

hold off
%xlim([1 1000])
grid
set(gca,'FontSize',FS,'FontName','calibri Italic','TickLabelInterpreter','latex','YScale','log');%,'YScale','log'
ylabel('Current - p.u. ','FontSize',FS,'FontName','calibri Italic','interpreter','latex');
xlabel('Frequency - Hz','FontSize',FS,'FontName','calibri Italic','interpreter','latex');
%set(gca,'GridAlpha',0.5,'MinorGridAlpha',0.8)
xlim([-10 300])
ylim([1e-4 1e0])


% leg = legend('Phase a','Phase b','Phase c','Location','northeast','Orientation', 'horizontal');
% leg.FontSize = FS;
% leg.Interpreter = 'latex';


%export_fig 'figs/Tese/MMC_PSCAD/icirFourier' '-png' -transparent -painters -r200


