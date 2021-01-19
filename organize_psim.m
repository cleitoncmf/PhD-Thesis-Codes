%% Organize the psim results
clear all
clc



%% bode Yac_dd


psim_Y_ac =  csvread('Dados/psim_teste_dq/resp_freq_Yac_dd.csv',0,0);

Freq_Yac_psim = psim_Y_ac(:,4);

phase_Yac_psim = rad2deg(atan(psim_Y_ac(:,3)./psim_Y_ac(:,2))); 
phase_Yac_psim(1) = 74.13;

mag_Yac_psim = 20.*log10(2.*sqrt((psim_Y_ac(:,2)./0.7).^2+(psim_Y_ac(:,3)./0.7).^2)./1000);



%% bode Gi_dd


psim_Gi_dd =  csvread('Dados/psim_teste_dq/resp_freq_Gi_dd.csv',0,0);

Freq_Gi_dd_psim = psim_Gi_dd(:,4);

phase_Gi_dd_psim = rad2deg(atan(psim_Gi_dd(:,3)./psim_Gi_dd(:,2))); 
phase_Gi_dd_psim(1) = -0.9;

mag_Gi_dd_psim = 20.*log10(2.*sqrt((psim_Gi_dd(:,2)./0.7).^2+(psim_Gi_dd(:,3)./0.7).^2)./100);
mag_Gi_dd_psim(1) = -0.05;


%% bode Gi_dq


psim_Gi_dq =  csvread('Dados/psim_teste_dq/resp_freq_Gi_dq.csv',0,0);

Freq_Gi_dq_psim = psim_Gi_dq(:,4);

phase_Gi_dq_psim = rad2deg(atan(psim_Gi_dq(:,3)./psim_Gi_dq(:,2))); 
phase_Gi_dq_psim(1) = -0.9;

mag_Gi_dq_psim = 20.*log10(2.*sqrt((psim_Gi_dq(:,2)./0.7).^2+(psim_Gi_dq(:,3)./0.7).^2)./100);
mag_Gi_dq_psim(1) = -0.05;


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



%% Results

T_Results_psim_Y_ac = table(Freq_Yac_psim,...
                            Freq_Yac_psim.*2*pi,...
                            mag_Yac_psim,...
                            phase_Yac_psim);
T_Results_psim_Y_ac.Properties.VariableNames = {'f','w','Mag_dd','Phi_dd'};


T_Results_psim_Gi_cl = table(Freq_Gi_dd_psim,...
                             Freq_Gi_dd_psim.*2*pi,...
                             mag_Gi_dd_psim,...
                             phase_Gi_dd_psim,...
                             mag_Gi_dq_psim,...
                             phase_Gi_dq_psim);
T_Results_psim_Gi_cl.Properties.VariableNames = {'f','w','Mag_dd','Phi_dd','Mag_dq','Phi_dq'};


T_Results_psim_Z_th = table(Freq_Zth_dq_psim,...
                            Freq_Zth_dq_psim.*2*pi,...
                            mag_Zth_dd_psim,...
                            phase_Zth_dd_psim,...
                            mag_Zth_dq_psim,...
                            phase_Zth_dq_psim);
T_Results_psim_Z_th.Properties.VariableNames = {'f','w','Mag_dd','Phi_dd','Mag_dq','Phi_dq'};


T_Results_psim_G_th = table(Freq_Gth_dq_psim,...
                            Freq_Gth_dq_psim.*2*pi,...
                            mag_Gth_dd_psim,...
                            phase_Gth_dd_psim,...
                            mag_Gth_dq_psim,...
                            phase_Gth_dq_psim);
T_Results_psim_G_th.Properties.VariableNames = {'f','w','Mag_dd','Phi_dd','Mag_dq','Phi_dq'};





%% converting into csv files

writetable(T_Results_psim_Y_ac,'Dados/psim_teste_dq/PSIM_SRF_Yac_0.csv')
writetable(T_Results_psim_Gi_cl,'Dados/psim_teste_dq/PSIM_SRF_Gicl_0.csv')
writetable(T_Results_psim_Z_th,'Dados/psim_teste_dq/PSIM_SRF_Zth_0.csv')
writetable(T_Results_psim_Z_th,'Dados/psim_teste_dq/PSIM_SRF_Gth_0.csv')




