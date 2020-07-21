%% Numerial tests
clear all
clc

%% Figure edition API
% Copyright (c) 2014, Oliver J. Woodford, Yair M. Altman, All rights reserved.
addpath(genpath('altmany-export_fig-412662f/'));


%% MMC definition

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

% structure representing the MMC
MMCstr = struct('C',C,'N',N,'SN',SN,'Vdc0',Vdc0,'L',L,'R',R,'Lf',Lf,'Rf',Rf,'w0',w0,'Cf',Cf);

s = tf('s');

%% Control Parameters: Current-controlled

kpi = 0.001;
Tii = 0.01;
kii = kpi/Tii;

Ci = kpi + kii/s;


%% Control Parameters: Single-loop voltage-controlled

kpv_sl = 0.000001;
Tiv_sl = 0.01;
kiv_sl = kpv_sl/Tiv_sl;



Cv_sl = kpv_sl + kiv_sl/s;


%% Control Parameters: Double-loop voltage-controlled 

kpi_dl = 0.001;
Tii_dl = 0.01;
kii_dl = kpi_dl/Tii_dl;

Ci_dl = kpi_dl + kii_dl/s;


kpv_dl = 0.01;
Tiv_dl = 0.01;
kiv_dl = kpv_dl/Tiv_dl;

Cv_dl = kpv_dl + kiv_dl/s;

%% Tests

M_i = MODEL_SRF_IC(MMCstr,Ci);
M_vsl = MODEL_SRF_VC_SL(MMCstr,Cv_sl);
M_vdl = MODEL_SRF_VC_DL(MMCstr,Cv_dl,Ci_dl);



%% Single-loop, voltage controlled - Thevenin impedance for different implementations

% 
% 
% Z_sl_th_ns_2 = minreal(Z_sl_th_ns,0.01);
% 
% 
% Table_SL_V_RF = CMF_RF(Z_sl_th,1,1000,0);
% %Table_SL_V_RF_ns = CMF_RF(Z_sl_th_ns,1,1000,0);
% wteste = 2*pi.*union([40:0.001:99],union([1:0.1:40],[100:1:1000]));
% Table_SL_V_RF_ns = CMF_RF(Z_sl_th_ns,1,1000,0,wteste);
% Table_SL_V_RF_ns_2 = CMF_RF(Z_sl_th_ns_2,1,1000,0);
% 
% Table_SL_V_RF_2 = CMF_RF(Z_sl_thteste2,1,1000,0);
% Table_SL_V_RF_3 = CMF_RF(Z_sl_thteste3,1,1000,0);


Table_Zth_SL_RF = CMF_RF(M_vsl.Z_th,1,1000,0);
Table_Zth_2_SL_RF = CMF_RF(M_vsl.Z_th_2,1,1000,0);
Table_Zth_3_SL_RF = CMF_RF(M_vsl.Z_th_3,1,1000,0);
Table_Zth_4_SL_RF = CMF_RF(M_vsl.Z_th_4,1,1000,0);
Table_Zth_5_SL_RF = CMF_RF(M_vsl.Z_th_5,1,1000,0);





%function [H,gcaMag,gcaPhi,yT,xB,yB] = CMF_plot_RF(varargin)%
[H,gcaMag,gcaPhi,yT,xB,yB] = CMF_plot_RF(...
            Table_Zth_SL_RF.f,Table_Zth_SL_RF.Mag_dd,Table_Zth_SL_RF.Phi_dd,'.', ...
            Table_Zth_2_SL_RF.f,Table_Zth_2_SL_RF.Mag_dd,Table_Zth_2_SL_RF.Phi_dd,'-.',...
            Table_Zth_3_SL_RF.f,Table_Zth_3_SL_RF.Mag_dd,Table_Zth_3_SL_RF.Phi_dd,'--',...
            Table_Zth_4_SL_RF.f,Table_Zth_4_SL_RF.Mag_dd,Table_Zth_4_SL_RF.Phi_dd,':',...
            Table_Zth_5_SL_RF.f,Table_Zth_5_SL_RF.Mag_dd,Table_Zth_5_SL_RF.Phi_dd,''...
            ); 

set(gcaMag,'Box','on')
set(gcaPhi,'Box','on')
hp = patch(gcaMag,[45 45 80 80],[-10 70 70 -10],'k',...
    'facecolor','r','edgecolor','r','FaceAlpha',0.15,'EdgeAlpha',0.1) ;

hp = patch(gcaMag,[35 35 100 100],[-10 70 70 -10],'k',...
    'facecolor','r','edgecolor','r','FaceAlpha',0.1,'EdgeAlpha',0.1) ;

hp = patch(gcaPhi,[45 45 80 80],[-200 200 200 -200],'k',...
    'facecolor','r','edgecolor','r','FaceAlpha',0.15,'EdgeAlpha',0.1) ;

hp = patch(gcaPhi,[35 35 100 100],[-200 200 200 -200],'k',...
    'facecolor','r','edgecolor','r','FaceAlpha',0.1,'EdgeAlpha',0.1) ;        
        
        
leg = legend(gcaMag.Children([end end-1 end-2 end-3 end-4]),...
                                               'Z\_th',...
                                               'Z\_th\_2',...
                                               'Z\_th\_3',...
                                               'Z\_th\_4',...
                                               'Z\_th\_5',...
                                               'Location', 'northwest',...
                                               'FontName','calibri',...
                                               'Interpreter','none'...
                                               );     
leg.FontSize = 18;

        

% export_fig 'figs/Tese/Numeric_errors/error_Zth' '-png' -transparent -painters -r300


%% Zoom na figura anterior


%function [H,gcaMag,gcaPhi,yT,xB,yB] = CMF_plot_RF(varargin)%
[H,gcaMag,gcaPhi,yT,xB,yB] = CMF_plot_RF(...
            Table_Zth_SL_RF.f,Table_Zth_SL_RF.Mag_dd,Table_Zth_SL_RF.Phi_dd,'.', ...
            Table_Zth_2_SL_RF.f,Table_Zth_2_SL_RF.Mag_dd,Table_Zth_2_SL_RF.Phi_dd,'-.',...
            Table_Zth_3_SL_RF.f,Table_Zth_3_SL_RF.Mag_dd,Table_Zth_3_SL_RF.Phi_dd,'--',...
            Table_Zth_4_SL_RF.f,Table_Zth_4_SL_RF.Mag_dd,Table_Zth_4_SL_RF.Phi_dd,':',...
            Table_Zth_5_SL_RF.f,Table_Zth_5_SL_RF.Mag_dd,Table_Zth_5_SL_RF.Phi_dd,''...
            ); 
set(gcaMag,'Box','on','XLim',[35 100])
set(gcaPhi,'Box','on','XLim',[35 100])
xB.Position(1) = 55;
yB.Position(1) = 32.7;
%gcaPhi.XTickLabel = {'$90$' '$10^{2}$'};
gcaPhi.XTick = [40 50 60 70 80 90 100];

hp = patch(gcaMag,[45 45 80 80],[-10 70 70 -10],'k',...
    'facecolor','r','edgecolor','r','FaceAlpha',0.15,'EdgeAlpha',0.1) ;

hp = patch(gcaMag,[35 35 100 100],[-10 70 70 -10],'k',...
    'facecolor','r','edgecolor','r','FaceAlpha',0.1,'EdgeAlpha',0.1) ;

hp = patch(gcaPhi,[45 45 80 80],[-200 200 200 -200],'k',...
    'facecolor','r','edgecolor','r','FaceAlpha',0.15,'EdgeAlpha',0.1) ;

hp = patch(gcaPhi,[35 35 100 100],[-200 200 200 -200],'k',...
    'facecolor','r','edgecolor','r','FaceAlpha',0.1,'EdgeAlpha',0.1) ;


leg = legend(gcaMag.Children([end end-1 end-2 end-3 end-4]),...
                                               'Z\_th',...
                                               'Z\_th\_2',...
                                               'Z\_th\_3',...
                                               'Z\_th\_4',...
                                               'Z\_th\_5',...
                                               'Location', 'northwest',...
                                               'FontName','calibri',...
                                               'Interpreter','none'...
                                               );     
leg.FontSize = 18;

% export_fig 'figs/Tese/Numeric_errors/error_Zth_zoom' '-png' -transparent -painters -r300

