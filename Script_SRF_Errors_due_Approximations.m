%% Testes do novo modelo com SRF 
% This script aims at analyzing some of the problemas caused by the
% numerical implementation of matricial models.
clear all
clc




%% Fun��es para edi��o de figuras

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


%% Defini��es

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

Gnorton = inv(Gchar)*(4*Vdc0*Ceq.*sdq + (2*SN/(3*Vdc0)).*I)*Gidq; % este � o Gicl



%% Modelo de Thevenin


kpv = 0.01;
Tiv = 0.01;
kiv = kpv/Tiv;

Gv = kpv + kiv/s;

Gvdq = [Gv 0 0;0 Gv 0;0 0 0];

Gcharv = minreal(Gnorton*Gvdq + Yac);
Gcharv2 = minreal(Gnorton*Gvdq + Yac,0.1); % aproxima��o boa para o intervalo [1, 1000] Hz

Gcharvinv = minreal(inv(Gcharv));
Gcharvinv2 = minreal(inv(Gcharv2),0.1);  % aproxima��o boa para o intervalo [1, 1000] Hz
Gcharvinv3 = minreal(inv(Gcharv2),0.03);


%charV = I + Cf*Gcharvinv*sdq; % matlab acusa erro (n�o consegue calcular coisas t�o grandes)
charV2 = I + Cf*Gcharvinv2*sdq;

%charVinv = inv(minreal(charV,0.2));
charVinv2 = inv(charV2);



Zth2 = charVinv2*Gcharvinv2;
Zth3 = charV2\Gcharvinv3;


Gth2 = (Zth3*Gnorton*Gvdq);

%% Modelo thevenin - doubly-loop sem simplifica��o

Gcharv2_ns = Gnorton*Gvdq + Yac;
Gcharvinv2_ns = inv(Gcharv2_ns);
charV2_ns = I + Cf*Gcharvinv2_ns*sdq;
%charVinv2_ns = inv(charV2_ns);
%Zth2_ns = charVinv2_ns*Gcharvinv2_ns;


%% Modelo de Thevenin single loop


kpvsl = 0.000001;
Tivsl = 0.01;
kivsl = kpvsl/Tivsl;

Gvsl = kpvsl + kivsl/s;

Gvdqsl = [Gvsl 0 0;0 Gvsl 0;0 0 0];

% Impedancias in SRF
Zdq = R*I + L*sdq; 
Zfdq = Rf*I + Lf*sdq; 

%Defini�oes
Gamma_vsl_in = 4*Ceq*sdq*(Zdq+2*Zfdq) + I;
Z_vsl_in = minreal(inv((4*Vdc0*Ceq*sdq + I*2*SN/(3*Vdc0))*Gvdqsl + 8*Ceq*sdq));
Gamma_vsl_out = minreal(Cf*Z_vsl_in*Gamma_vsl_in*sdq + I);


Gamma_vsl_out_inv = minreal(inv(Gamma_vsl_out));

% impedancia de Thevenin
Z_sl_th_1 = minreal(Z_vsl_in*Gamma_vsl_in);

Z_sl_th = minreal(Gamma_vsl_out_inv*Z_sl_th_1);

Z_sl_thteste = (Gamma_vsl_out_inv*Z_sl_th_1);
Z_sl_thteste2 = minreal(Gamma_vsl_out_inv*Z_sl_th_1,0.01);
Z_sl_thteste3 = minreal(Gamma_vsl_out_inv*Z_sl_th_1,0.05);





% ganho de Thevenin
G_sl_th_1 = minreal((4*Vdc0*Ceq*sdq + I*2*SN/(3*Vdc0))*Gvdqsl);
G_sl_th_2 = minreal(Z_vsl_in*G_sl_th_1);
G_sl_th = minreal(Gamma_vsl_out_inv*G_sl_th_2);
% minreal(Gamma_vsl_out_inv*Z_vsl_in);
% G_sl_th_2 = minreal(G_sl_th_1*); 


%% Test without dimplifications (ns): single-loop voltage-controlled MMC

Z_vsl_in_ns = inv((4*Vdc0*Ceq*sdq + I*2*SN/(3*Vdc0))*Gvdqsl + 8*Ceq*sdq);
Gamma_vsl_out_ns = Cf*Z_vsl_in_ns*Gamma_vsl_in*sdq + I;
Gamma_vsl_out_inv_ns = (inv(Gamma_vsl_out_ns));
Z_sl_th_1_ns = (Z_vsl_in_ns*Gamma_vsl_in);
Z_sl_th_ns = (Gamma_vsl_out_inv_ns*Z_sl_th_1_ns);
G_sl_th_1_ns = ((4*Vdc0*Ceq*sdq + I*2*SN/(3*Vdc0))*Gvdqsl);
G_sl_th_2_ns = (Z_vsl_in_ns*G_sl_th_1_ns);
G_sl_th_ns = (Gamma_vsl_out_inv_ns*G_sl_th_2_ns);

Gamma_vsl_out_ns2 = Cf*Z_vsl_in_ns*(Gamma_vsl_in*sdq) + I;
Gamma_vsl_out_inv_ns2 = (inv(Gamma_vsl_out_ns2));
Z_sl_th_ns2 = Gamma_vsl_out_inv_ns2*Z_sl_th_1_ns;





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
% O MATLAB, �s vezes, coloca uma fase em -180, mas o bode do modelo teorico indica +180 (que � a mesme coisa)
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






%% Plot com diferentes minimiza��es

%bode(Z_sl_th(1,1),Z_sl_thteste(1,1),Z_sl_thteste2(1,1),Z_sl_thteste3(1,1))


Z_sl_th_ns_2 = minreal(Z_sl_th_ns,0.01);


Table_SL_V_RF = CMF_RF(Z_sl_th,1,1000,0);
%Table_SL_V_RF_ns = CMF_RF(Z_sl_th_ns,1,1000,0);
wteste = 2*pi.*union([40:0.001:99],union([1:0.1:40],[100:1:1000]));
Table_SL_V_RF_ns = CMF_RF(Z_sl_th_ns,1,1000,0,wteste);
Table_SL_V_RF_ns_2 = CMF_RF(Z_sl_th_ns_2,1,1000,0);

Table_SL_V_RF_2 = CMF_RF(Z_sl_thteste2,1,1000,0);
Table_SL_V_RF_3 = CMF_RF(Z_sl_thteste3,1,1000,0);





%function [H,gcaMag,gcaPhi,yT,xB,yB] = CMF_plot_RF(varargin)%
[H,gcaMag,gcaPhi,yT,xB,yB] = CMF_plot_RF(...
            Freq_Zth_sl_dq_psim,mag_Zth_sl_dd_psim,phase_Zth_sl_dd_psim,'or',...
            Table_SL_V_RF.f,Table_SL_V_RF.Mag_dd,Table_SL_V_RF.Phi_dd,'--', ...
            Table_SL_V_RF_ns.f,Table_SL_V_RF_ns.Mag_dd,Table_SL_V_RF_ns.Phi_dd,'-.',...
            Table_SL_V_RF_2.f,Table_SL_V_RF_2.Mag_dd,Table_SL_V_RF_2.Phi_dd,'-' ...
            );
hp = patch(gcaMag,[45 45 80 80],[0 60 60 0],'k',...
    'facecolor','r','edgecolor','r','FaceAlpha',0.2,'EdgeAlpha',0.1) ;

hp = patch(gcaPhi,[45 45 80 80],[-200 200 200 -200],'k',...
    'facecolor','r','edgecolor','r','FaceAlpha',0.2,'EdgeAlpha',0.1) ;




%% Convers�es para obter o Latex

digits(4)

Gchar_num = Gchar.Numerator;
Gchar_den = Gchar.denominator;

syms S

%Gchar_dd_sym = vpa(poly2sym(Gchar_num{1,1},S)/poly2sym(Gchar_den{1,1},S))
Gchar_dd_sym_1000 = vpa(poly2sym(1000.*Gchar_num{1,1},S)/poly2sym(Gchar_den{1,1},S));


%Gchar_dq_sym = vpa(poly2sym(Gchar_num{1,2},S)/poly2sym(Gchar_den{1,2},S))
Gchar_dq_sym_1000 = vpa(poly2sym(1000.*Gchar_num{1,2},S)/poly2sym(Gchar_den{1,2},S));


%Gchar_qd_sym = vpa(poly2sym(Gchar_num{2,1},S)/poly2sym(Gchar_den{2,1},S))
Gchar_qd_sym_1000 = vpa(poly2sym(1000.*Gchar_num{2,1},S)/poly2sym(Gchar_den{2,1},S));


%Gchar_qq_sym = vpa(poly2sym(Gchar_num{2,2},S)/poly2sym(Gchar_den{2,2},S))
Gchar_qq_sym_1000 = vpa(poly2sym(1000.*Gchar_num{2,2},S)/poly2sym(Gchar_den{2,2},S));


%Gchar_0_sym = vpa(poly2sym(Gchar_num{3,3},S)/poly2sym(Gchar_den{3,3},S))
Gchar_0_sym_1000 = vpa(poly2sym(1000.*Gchar_num{3,3},S)/poly2sym(Gchar_den{3,3},S));


Gchar_inv = inv(Gchar);
Gchar_inv_num = Gchar_inv.Numerator;
Gchar_inv_den = Gchar_inv.denominator;

Gchar_inv_dd_sym = vpa(poly2sym(Gchar_inv_num{1,1},S)/poly2sym(Gchar_inv_den{1,1},S));

Gchar_inv_dq_sym = vpa(poly2sym(Gchar_inv_num{1,2},S)/poly2sym(Gchar_inv_den{1,2},S));

Gchar_inv_qd_sym = vpa(poly2sym(Gchar_inv_num{2,1},S)/poly2sym(Gchar_inv_den{2,1},S));

Gchar_inv_qq_sym = vpa(poly2sym(Gchar_inv_num{2,2},S)/poly2sym(Gchar_inv_den{2,2},S));

Gchar_inv_0_sym = vpa(poly2sym(Gchar_inv_num{3,3},S)/poly2sym(Gchar_inv_den{3,3},S));




Yac_num = Yac.Numerator;
Yac_den = Yac.denominator;


Yac_dd_sym = vpa(poly2sym(Yac_num{1,1},S)/poly2sym(Yac_den{1,1},S));

Yac_qd_sym = vpa(poly2sym(Yac_num{2,1},S)/poly2sym(Yac_den{2,1},S));





























