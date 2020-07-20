%% Numerial tests
clear all
clc


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

%% COntrol Parameters

kpv_sl = 0.000001;
Tiv_sl = 0.01;
kiv_sl = kpv_sl/Tiv_sl;

s = tf('s');

Cv_sl = kpv_sl + kiv_sl/s;

%CTRL_VCSL = struct('kpv',kpv_sl,'kiv',kiv_sl);

%% Teste

M = MODEL_SRF_VC_SL(MMCstr,Cv_sl);