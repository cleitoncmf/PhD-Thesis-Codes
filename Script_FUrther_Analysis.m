%% resultados obtidos para impedância virtual 
clear all
clc




%% Funções para edição de figuras

addpath(genpath('altmany-export_fig-412662f/'));





%% Dados do MMC

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

MMCstr = struct('C',C,'N',N,'SN',SN,'Vdc0',Vdc0,'L',L,'R',R,'Lf',Lf,'Rf',Rf,'w0',w0,'Cf',Cf);



%% Definições

I = eye(3);

s = tf('s');

Ceq = C/N;

Z = L*s + R;
Zf = Lf*s + Rf;


W = [0 -w0 0;w0 0 0;0 0 0];
sdq = W + s.*I;

s2dq = 2.*W + s.*I;

Zdq = L*sdq + R*I;
Zfdq = Lf*sdq + Rf*I;


%% Funções 
% Todas as funções receberão como parametro o controllador utilizado
% Isso facilitara os testes de variação de ganhos 


% Controlador PI normal
GPI = @(kp,ki) (kp+ki/s);

% Matrix de controle em dq0
Gdq0 = @(G)[G 0 0;0 G 0;0 0 0];

% Controlador Ressonante normal
GR = @(kr,wr)(kr*s/(s^2 + wr^2));

% Controlador Proporciona Ressonante
GPR = @(kp,kr,wr) kp + GR(kr,wr);

% Controllador PIR
GPIR = @(kp,ki,kr,wr) GPI(kp,ki) + GR(kr,wr);

% Filtro passa altas de primeira ordem
Ghpf = @(wc) s/(s+wc);

% Filtro passa baixas de primeira ordem
Glpf = @(wc) wc/(s+wc);





% Admitancia dc em SRF
Gcharcir_srf = @(Gcir2dq) (I + 4*L*Ceq.*s2dq^2 + 4*R*Ceq.*s2dq + ((SN/(3*Vdc0))*I + 2*Vdc0*Ceq*s2dq)*Gcir2dq);
Ydc_srf = @(Gcir2dq) minreal(2*Ceq.*inv(Gcharcir_srf(Gcir2dq))*s2dq);



% MMC controllado por corrente em SRF
Didq_srf = ((L+2*Lf)/Vdc0).*W;
Gchar_srf =@(Gidq) I + (4*Vdc0*Ceq.*sdq + (2*SN/(3*Vdc0)).*I)*Gidq + 4*Ceq*(Z+2*Zf).*sdq -(2*SN/(3*Vdc0)).*Didq_srf;
Yac_srf = @(Gidq) 8*Ceq.*minreal(inv(Gchar_srf(Gidq)))*sdq;
Gnorton_srf = @(Gidq) minreal(inv(Gchar_srf(Gidq)))*(4*Vdc0*Ceq.*sdq + (2*SN/(3*Vdc0)).*I)*Gidq; % este é o Gicl

% Admitancia virtual do MMC controlado por corrente em SRF
Lambdai_srf = @(Gfiltro) (2*Gfiltro/Vdc0).*[1 0 0;0 1 0;0 0 0]; 
Yvir_srf=@(Gidq,Gfiltro)- minreal(inv(Gchar_srf(Gidq)))*(4*Vdc0*Ceq*sdq + (3*SN/(2*Vdc0))*I)*Lambdai_srf(Gfiltro);


% MMC controllado por malha simples de tensão em SRF
Gamma_vsl_in_srf = 4*Ceq*sdq*(Zdq+2*Zfdq) + I;
Z_vsl_in_srf = @(Gvdqsl) minreal(inv((4*Vdc0*Ceq*sdq + I*2*SN/(3*Vdc0))*Gvdqsl + 8*Ceq*sdq));
Gamma_vsl_out_srf = @(Gvdqsl) minreal(Cf*Z_vsl_in_srf(Gvdqsl)*Gamma_vsl_in_srf*sdq + I);
Gamma_vsl_out_inv_srf = @(Gvdqsl) minreal(inv(Gamma_vsl_out_srf(Gvdqsl)));
Z_sl_th_1_srf = @(Gvdqsl) minreal(Z_vsl_in_srf(Gvdqsl)*Gamma_vsl_in_srf);
Z_sl_th_srf = @(Gvdqsl) minreal(Gamma_vsl_out_inv_srf(Gvdqsl)*Z_sl_th_1_srf(Gvdqsl));
G_sl_th_1_srf = @(Gvdqsl) minreal((4*Vdc0*Ceq*sdq + I*2*SN/(3*Vdc0))*Gvdqsl);
G_sl_th_2_srf = @(Gvdqsl) minreal(Z_vsl_in_srf(Gvdqsl)*G_sl_th_1_srf(Gvdqsl));
G_sl_th_srf = @(Gvdqsl) minreal(Gamma_vsl_out_inv_srf(Gvdqsl)*G_sl_th_2_srf(Gvdqsl));


% Impedancia virtual do MMC controlado por malha simples de tensão em SRF
Lambda_vsl_srf = @(Gfiltro) (((R+2*Rf) + (L+2*Lf)*s*Gfiltro)*I + (L+2*Lf)*W)*(1/Vdc0);
%Zvir_sl = @(Gvdqsl,Gfiltro) minreal(minreal(Gamma_vsl_out_inv_srf(Gvdqsl)*Z_vsl_in_srf(Gvdqsl))*(4*Vdc0*Ceq*sdq + I*2*SN/(3*Vdc0))*Lambda_vsl_srf(Gfiltro));
% Zvir_sl = @(Gvdqsl,Gfiltro) ...
%    - minreal(minreal(Gamma_vsl_out_inv_srf(Gvdqsl)*Z_vsl_in_srf(Gvdqsl),0.04)*(4*Vdc0*Ceq*sdq + I*2*SN/(3*Vdc0))*Lambda_vsl_srf(Gfiltro),0.05);
Zvir_sl = @(Gvdqsl,Gfiltro) ...
   - minreal(minreal(Gamma_vsl_out_inv_srf(Gvdqsl)*Z_vsl_in_srf(Gvdqsl),0.04)*(4*Vdc0*Ceq*sdq + I*2*SN/(3*Vdc0))*Lambda_vsl_srf(Gfiltro),0.5);
Zvir_sl_teste = @(Gvdqsl,Gfiltro) ...
   - minreal(minreal(Gamma_vsl_out_inv_srf(Gvdqsl)*Z_vsl_in_srf(Gvdqsl),0.05)*(4*Vdc0*Ceq*sdq + I*2*SN/(3*Vdc0)),0.08)*Lambda_vsl_srf(Gfiltro);


    

% MMC controllado por malha dupla de tensão em SRF
Gcharv_srf = @(Gidq,Gvdq) minreal(Gnorton_srf(Gidq)*Gvdq + Yac_srf(Gidq));
Gcharv2_srf = @(Gidq,Gvdq) minreal(Gnorton_srf(Gidq)*Gvdq + Yac_srf(Gidq),0.1); % aproximação boa para o intervalo [1, 1000] Hz
Gcharvinv_srf = @(Gidq,Gvdq) minreal(inv(Gcharv_srf(Gidq,Gvdq)));
Gcharvinv2_srf = @(Gidq,Gvdq) minreal(inv(Gcharv2_srf(Gidq,Gvdq)),0.1);  % aproximação boa para o intervalo [1, 1000] Hz
Gcharvinv3_srf = @(Gidq,Gvdq) minreal(inv(Gcharv2_srf(Gidq,Gvdq)),0.03);
charV_srf = @(Gidq,Gvdq) I + Cf*Gcharvinv_srf(Gidq,Gvdq)*sdq; % matlab acusa erro (não consegue calcular coisas tão grandes)
charV2_srf = @(Gidq,Gvdq) I + Cf*Gcharvinv2_srf(Gidq,Gvdq)*sdq;
charVinv_srf = @(Gidq,Gvdq) inv(minreal(charV_srf(Gidq,Gvdq),0.2));
charVinv2_srf = @(Gidq,Gvdq) inv(charV2_srf(Gidq,Gvdq));
Zth2_srf = @(Gidq,Gvdq) charVinv2_srf(Gidq,Gvdq)*Gcharvinv2_srf(Gidq,Gvdq);
Zth3_srf = @(Gidq,Gvdq) charV2_srf(Gidq,Gvdq)\Gcharvinv3_srf(Gidq,Gvdq);
Gth2_srf = @(Gidq,Gvdq) (minreal(Zth3_srf(Gidq,Gvdq),0.0001)*minreal(minreal(Gnorton_srf(Gidq))*Gvdq,0.001)); % não tá com a a proximação usada no capítulo anterior

% Impedancia virtual do MMC controlado por malha dupla de tensão em SRF
Lambda_vdl_srf = @(Gidq,Gfiltro) ((R+2*Rf) + (L+2*Lf)*s*Gfiltro)*I*(1/Vdc0) + Gidq;
Gamma_vir_sl = @(Gidq,Gvdqdl,Gfiltro) -minreal(inv(Gchar_srf(Gidq)))*(4*Vdc0*Ceq.*sdq + (2*SN/(3*Vdc0)).*I)*Lambda_vdl_srf(Gidq,Gfiltro);
%Zvir_dl = @(Gidq,Gvdqdl,Gfiltro)minreal(charVinv2_srf(Gidq,Gvdqdl)*minreal(Gcharvinv2_srf(Gidq,Gvdqdl)*Gamma_vir_sl(Gidq,Gvdqdl,Gfiltro),0.0005),0.04);
Gcharvinv3_vir_srf = @(Gidq,Gvdq) minreal(inv(Gcharv2_srf(Gidq,Gvdq)),0.065); %mesma coisa do Gcharvinv3_srf, mas com uma precisão melhor  
Zvir_dl = @(Gidq,Gvdqdl,Gfiltro)minreal(charVinv2_srf(Gidq,Gvdqdl)*minreal(Gcharvinv3_vir_srf(Gidq,Gvdqdl)*Gamma_vir_sl(Gidq,Gvdqdl,Gfiltro)),0.0004);

% Admitancia dc em NRF
Y_dc_nrf = @(Gcir) 2*s*Ceq/(4*s*Ceq*Z+1 - (SN/(3*Vdc0)+ 2*s*Ceq* Vdc0)*Gcir );

% MMC controllado por corrente em NRF
DenI_nrf = @(Gi) 4*s*Ceq*(Z+2*Zf) + (4*s*Ceq*Vdc0 + (2*SN/(3*Vdc0)))*Gi + 1;
Yac_nrf = @(Gi) minreal(8*s*Ceq/DenI_nrf(Gi));
Gnorton_nrf = @(Gi) minreal( (4*s*Ceq*Vdc0 + 2*SN/(3*Vdc0))*Gi/DenI_nrf(Gi) );


% MMC controllado por malha simples de tensão em NRF
den_vsl_nrf = @(Gvsl) 8*s*Ceq + (4*s*Ceq*Vdc0 + 2*SN/(3*Vdc0))*Gvsl;
Zacsl_nrf = @(Gvsl) (4*s*Ceq*(Z+2*Zf)+1)/den_vsl_nrf(Gvsl);
Gvslcl_nrf = @(Gvsl) (4*s*Ceq*Vdc0 + 2*SN/(3*Vdc0))*Gvsl/den_vsl_nrf(Gvsl);
Zth_sl_nrf = @(Gvsl) Zacsl_nrf(Gvsl)/(s*Cf*Zacsl_nrf(Gvsl)+1);
Gth_sl_nrf = @(Gvsl) 1/(s*Cf*Zacsl_nrf(Gvsl)+1);

% MMC controllado por malha dupla de tensão em NRF
Zca_nrf = @(Gi,Gv) minreal(1/(Yac_nrf(Gi) + Gnorton_nrf(Gi)*Gv));
Gvcl_nrf = @(Gi,Gv) minreal(Gnorton_nrf(Gi)*Gv/(Yac_nrf(Gi) + Gnorton_nrf(Gi)*Gv));
Zth_nrf = @(Gi,Gv) minreal(Zca_nrf(Gi,Gv)/(s*Cf*Zca_nrf(Gi,Gv)+1));
Gth_nrf = @(Gi,Gv) minreal(Gvcl_nrf(Gi,Gv)/(s*Cf*Zca_nrf(Gi,Gv)+1));




%% Funções de transferência para as condições de referência

% Admitancia dc em NRF
krcir_nrf_0 = 0.1;
Gcir_nrf_0 = - GR(krcir_nrf_0,2*w0);
Y_dc_nrf_0 = Y_dc_nrf(Gcir_nrf_0);

% MMC controlado por corrent em NRF
kp_i_nrf_0 = 1e-4;
kr_i_nrf_0 = 1e-2;
G_i_nrf_0 = GPR(kp_i_nrf_0,kr_i_nrf_0,2*pi*60); 
Yca_i_nrf_0 = Yac_nrf(G_i_nrf_0); 
Gnorton_i_nrf_0 =Gnorton_nrf(G_i_nrf_0); 


% MMC controlado por corrente em SRF
kp_i_srf_0 = 0.001;
ki_i_srf_0 = 0.1;
G_i_srf_0 = Gdq0(GPI(kp_i_srf_0,ki_i_srf_0));
Gnorton_i_srf_0 = Gnorton_srf(G_i_srf_0);
Yca_i_srf_0 = Yac_srf(G_i_srf_0);

% MMC controlado por laço simples de tensão em NRF
kp_vsl_nrf_0 = 1e-4;
kr_vsl_nrf_0 = 1e-3;
G_vsl_nrf_0 = GPR(kp_vsl_nrf_0,kr_vsl_nrf_0,w0); 
Zth_vsl_nrf_0 = Zth_sl_nrf(G_vsl_nrf_0);
Gth_vsl_nrf_0 = Gth_sl_nrf(G_vsl_nrf_0);


% MMC controlado por laço simples de tensão em SRF
kp_vsl_srf_0 = 0.000001;
ki_vsl_srf_0 = 0.0001;
G_vsl_srf_0 = Gdq0(GPI(kp_vsl_srf_0,ki_vsl_srf_0));
Zth_vsl_srf_0 = Z_sl_th_srf(G_vsl_srf_0);
Gth_vsl_srf_0 = G_sl_th_srf(G_vsl_srf_0);

% MMC controlado por laço duplo de tensão em NRF
kp_vdl_nrf_0 = 0.1;
kr_vdl_nrf_0 = 1;
G_vdl_nrf_0 = GPR(kp_vdl_nrf_0,kr_vdl_nrf_0,w0); 
Zth_vdl_nrf_0 = Zth_nrf(G_i_nrf_0,G_vdl_nrf_0);
Gth_vdl_nrf_0 = Gth_nrf(G_i_nrf_0,G_vdl_nrf_0);



% MMC controlado por laço duplo de tensão em SRF
kp_idl_srf_0 = 0.001;
ki_idl_srf_0 = 0.1;
kp_vdl_srf_0 = 0.01;
ki_vdl_srf_0 = 1;
G_idl_srf_0 = Gdq0(GPI(kp_idl_srf_0,ki_idl_srf_0));
G_vdl_srf_0 = Gdq0(GPI(kp_vdl_srf_0,ki_vdl_srf_0));
Zth_vdl_srf_0 = Zth3_srf(G_idl_srf_0,G_vdl_srf_0);
Gth_vdl_srf_0 = Gth2_srf(G_idl_srf_0,G_vdl_srf_0);


%% Yca_srf: Avaliação da influencia dos ganhos proporcional e integral

kp_i_srf_1 = 0.0001;
kp_i_srf_2 = 0.005;

ki_i_srf_1 = 0.01;
ki_i_srf_2 = 1;


G_i_srf_01 = Gdq0(GPI(kp_i_srf_0,ki_i_srf_1));
Yca_i_srf_01 = Yac_srf(G_i_srf_01);

G_i_srf_02 = Gdq0(GPI(kp_i_srf_0,ki_i_srf_2));
Yca_i_srf_02 = Yac_srf(G_i_srf_02);

G_i_srf_10 = Gdq0(GPI(kp_i_srf_1,ki_i_srf_0));
Yca_i_srf_10 = Yac_srf(G_i_srf_10);

G_i_srf_20 = Gdq0(GPI(kp_i_srf_2,ki_i_srf_0));
Yca_i_srf_20 = Yac_srf(G_i_srf_20);



RF_Yca_i_srf_0 = CMF_RF(Yca_i_srf_0,1,1000,0);


RF_Yca_i_srf_01 = CMF_RF(Yca_i_srf_01,1,1000,0);
RF_Yca_i_srf_02 = CMF_RF(Yca_i_srf_02,1,1000,0);
RF_Yca_i_srf_10 = CMF_RF(Yca_i_srf_10,1,1000,0);
RF_Yca_i_srf_20 = CMF_RF(Yca_i_srf_20,1,1000,0);

%% Gráficos Yca_srf dd: variação do ganho proporcional

[H,gcaMag,gcaPhi,yT,xB,yB] =...
CMF_plot_RF(RF_Yca_i_srf_20.f,RF_Yca_i_srf_20.Mag_dd,RF_Yca_i_srf_20.Phi_dd,'--', ...
            RF_Yca_i_srf_0.f,RF_Yca_i_srf_0.Mag_dd,RF_Yca_i_srf_0.Phi_dd,'', ...
            RF_Yca_i_srf_10.f,RF_Yca_i_srf_10.Mag_dd,RF_Yca_i_srf_10.Phi_dd,'k-.');
        
set(gcaMag,'YLim',[-62 -15],'YTick',[-60 -40 -20 -15],'YTickLabel',{-60 -40 -20 '^'});
leg = legend(gcaMag,'$k_p^i = 0.0050 A^{-1}$','$k_p^i = 0.0010 A^{-1}$','$k_p^i = 0.0001 A^{-1}$','Location', 'northwest','FontName','calibri');
leg.FontSize = 24;
leg.Interpreter = 'latex';


% export_fig 'figs/Tese/var_gains/bode_Yca_i_srf_dd_var_kpi' '-png' -transparent -painters -r200


        
%% Gráficos Yca_srf dq: variação do ganho proporcional

[H,gcaMag,gcaPhi,yT,xB,yB] =...
CMF_plot_RF(RF_Yca_i_srf_20.f,RF_Yca_i_srf_20.Mag_dq,RF_Yca_i_srf_20.Phi_dq,'--', ...
            RF_Yca_i_srf_0.f,RF_Yca_i_srf_0.Mag_dq,RF_Yca_i_srf_0.Phi_dq,'', ...
            RF_Yca_i_srf_10.f,RF_Yca_i_srf_10.Mag_dq,RF_Yca_i_srf_10.Phi_dq,'k-.');
        
set(gcaMag,'YLim',[-150 -10],'YTick',[-120 -90 -60 -30 -10],'YTickLabel',{-120 -90 -60 -30 '^'});
leg = legend(gcaMag,'$k_p^i = 0.0050 A^{-1}$','$k_p^i = 0.0010 A^{-1}$','$k_p^i = 0.0001 A^{-1}$','Location', 'northwest','FontName','calibri');
leg.FontSize = 24;
leg.Interpreter = 'latex';

%% Gráficos Yca_srf dd: variação do ganho integral

[H,gcaMag,gcaPhi,yT,xB,yB] =...
CMF_plot_RF(RF_Yca_i_srf_02.f,RF_Yca_i_srf_02.Mag_dd,RF_Yca_i_srf_02.Phi_dd,'--', ...
            RF_Yca_i_srf_0.f,RF_Yca_i_srf_0.Mag_dd,RF_Yca_i_srf_0.Phi_dd,'', ...
            RF_Yca_i_srf_01.f,RF_Yca_i_srf_01.Mag_dd,RF_Yca_i_srf_01.Phi_dd,'k-.');
        
set(gcaMag,'YLim',[-55 -35],'YTick',[-50 -40 -35],'YTickLabel',{-50 -40 '^'});
leg = legend(gcaMag,'$k_i^i = 1.00 A^{-1}rad/s$','$k_i^i = 0.10 A^{-1}rad/s$','$k_i^i = 0.01 A^{-1}rad/s$','Location', 'southeast','FontName','calibri');
leg.FontSize = 24;
leg.Interpreter = 'latex';

%export_fig 'figs/Tese/var_gains/bode_Yca_i_srf_dd_var_kii' '-png' -transparent -painters -r200


%% Gráficos Yca_srf dq: variação do ganho integral

[H,gcaMag,gcaPhi,yT,xB,yB] =...
CMF_plot_RF(RF_Yca_i_srf_02.f,RF_Yca_i_srf_02.Mag_dq,RF_Yca_i_srf_02.Phi_dq,'--', ...
            RF_Yca_i_srf_0.f,RF_Yca_i_srf_0.Mag_dq,RF_Yca_i_srf_0.Phi_dq,'', ...
            RF_Yca_i_srf_01.f,RF_Yca_i_srf_01.Mag_dq,RF_Yca_i_srf_01.Phi_dq,'k-.');
        
set(gcaMag,'YLim',[-140 -40],'YTick',[-120 -90 -60 -40],'YTickLabel',{-120 -90 -60 '^'});
leg = legend(gcaPhi,'$k_i^i = 1.00 A^{-1}rad/s$','$k_i^i = 0.10 A^{-1}rad/s$','$k_i^i = 0.01 A^{-1}rad/s$','Location', 'northwest','FontName','calibri');
leg.FontSize = 24;
leg.Interpreter = 'latex';


%% Zth_vsl_srf: Avaliação da influencia dos ganhos proporcional e integral

% kp_vsl_srf_0 = 0.000001;
% ki_vsl_srf_0 = 0.0001;
% G_vsl_srf_0 = Gdq0(GPI(kp_vsl_srf_0,ki_vsl_srf_0));
% Zth_vsl_srf_0 = Z_sl_th_srf(G_vsl_srf_0);

kp_vsl_srf_1 = 0.0000001;
kp_vsl_srf_2 = 0.00001;
 
ki_vsl_srf_1 = 0.00001;
ki_vsl_srf_2 = 0.001;


G_vsl_srf_01 = Gdq0(GPI(kp_vsl_srf_0,ki_vsl_srf_1));
Zth_vsl_srf_01 = Z_sl_th_srf(G_vsl_srf_01);

G_vsl_srf_02 = Gdq0(GPI(kp_vsl_srf_0,ki_vsl_srf_2));
Zth_vsl_srf_02 = Z_sl_th_srf(G_vsl_srf_02);

G_vsl_srf_10 = Gdq0(GPI(kp_vsl_srf_1,ki_vsl_srf_0));
Zth_vsl_srf_10 = Z_sl_th_srf(G_vsl_srf_10);

G_vsl_srf_20 = Gdq0(GPI(kp_vsl_srf_2,ki_vsl_srf_0));
Zth_vsl_srf_20 = Z_sl_th_srf(G_vsl_srf_20);


RF_Zth_vsl_srf_0 = CMF_RF(Zth_vsl_srf_0,1,1000,0);


RF_Zth_vsl_srf_01 = CMF_RF(Zth_vsl_srf_01,1,1000,0);
RF_Zth_vsl_srf_02 = CMF_RF(Zth_vsl_srf_02,1,1000,0);
RF_Zth_vsl_srf_10 = CMF_RF(Zth_vsl_srf_10,1,1000,0);
RF_Zth_vsl_srf_20 = CMF_RF(Zth_vsl_srf_20,1,1000,0);


%% Gráficos Zth_vsl_srf dd: variação do ganho proporcional

[H,gcaMag,gcaPhi,yT,xB,yB] =...
CMF_plot_RF(RF_Zth_vsl_srf_20.f,RF_Zth_vsl_srf_20.Mag_dd,RF_Zth_vsl_srf_20.Phi_dd,'--', ...
            RF_Zth_vsl_srf_0.f,RF_Zth_vsl_srf_0.Mag_dd,RF_Zth_vsl_srf_0.Phi_dd,'', ...
            RF_Zth_vsl_srf_10.f,RF_Zth_vsl_srf_10.Mag_dd,RF_Zth_vsl_srf_10.Phi_dd,'k-.');
        
set(gcaMag,'YLim',[-15 70],'YTick',[0 20 40 60 70],'YTickLabel',{0 20 40 60 '^'});


CMF_plot_TR(gcaMag,[155.3 70],[214.7 70],[334.5 70], [275.3 70]);
CMF_plot_TR(gcaPhi,[155.3 200],[214.7 200],[334.5 200], [275.3 200]);


hp = patch(gcaMag,[45 45 85 85],[-70 70 70 -70],'k',...
    'facecolor','r','edgecolor','r','FaceAlpha',0.1,'EdgeAlpha',0.1) ;


hp = patch(gcaPhi,[45 45 85 85],[-200 200 200 -200],'k',...
    'facecolor','r','edgecolor','r','FaceAlpha',0.1,'EdgeAlpha',0.1) ;

leg = legend(gcaMag.Children([end end-1 end-2]),...
                                               '$k_p^{v,sl} = 0.0000100 V^{-1}$',...
                                               '$k_p^{v,sl} = 0.0000010 V^{-1}$',...
                                               '$k_p^{v,sl} = 0.0000001 V^{-1}$',...
                                               'Location', 'northwest','FontName','calibri');
leg.FontSize = 24;
leg.Interpreter = 'latex';

CMF_Anota_Plot90(gcaMag,[155.3 -14],[214.7 -14],[334.5 -14],[275.3 -14]);




% export_fig 'figs/Tese/var_gains/bode_Zth_vsl_srf_dd_var_kpv' '-png' -transparent -painters -r200



%% Gráficos Zth_vsl_srf dq: variação do ganho proporcional

[H,gcaMag,gcaPhi,yT,xB,yB] =...
CMF_plot_RF(RF_Zth_vsl_srf_20.f,RF_Zth_vsl_srf_20.Mag_dq,RF_Zth_vsl_srf_20.Phi_dq,'--', ...
            RF_Zth_vsl_srf_0.f,RF_Zth_vsl_srf_0.Mag_dq,RF_Zth_vsl_srf_0.Phi_dq,'', ...
            RF_Zth_vsl_srf_10.f,RF_Zth_vsl_srf_10.Mag_dq,RF_Zth_vsl_srf_10.Phi_dq,'k-.');
        
set(gcaMag,'YLim',[-15 70],'YTick',[0 20 40 60 70],'YTickLabel',{0 20 40 60 '^'});

CMF_plot_TR(gcaMag,[155.3 70],[214.7 70],[334.5 70], [275.3 70]);
CMF_plot_TR(gcaPhi,[155.3 200],[214.7 200],[334.5 200], [275.3 200]);

hp = patch(gcaMag,[45 45 85 85],[-70 70 70 -70],'k',...
    'facecolor','r','edgecolor','r','FaceAlpha',0.1,'EdgeAlpha',0.1) ;


hp = patch(gcaPhi,[45 45 85 85],[-200 200 200 -200],'k',...
    'facecolor','r','edgecolor','r','FaceAlpha',0.1,'EdgeAlpha',0.1) ;


leg = legend(gcaMag.Children([end end-1 end-2]),'$k_p^{v,sl} = 0.0000100 V^{-1}$','$k_p^{v,sl} = 0.0000010 V^{-1}$','$k_p^{v,sl} = 0.0000001 V^{-1}$','Location', 'northwest','FontName','calibri');
leg.FontSize = 24;
leg.Interpreter = 'latex';

CMF_Anota_Plot90(gcaMag,[155.3 -14],[214.7 -14],[334.5 -14],[275.3 -14]);

% export_fig 'figs/Tese/var_gains/bode_Zth_vsl_srf_dq_var_kpv' '-png' -transparent -painters -r200


%% Gráficos Zth_vsl_srf dd: variação do ganho integral

[H,gcaMag,gcaPhi,yT,xB,yB] =...
CMF_plot_RF(RF_Zth_vsl_srf_02.f,RF_Zth_vsl_srf_02.Mag_dd,RF_Zth_vsl_srf_02.Phi_dd,'--', ...
            RF_Zth_vsl_srf_0.f,RF_Zth_vsl_srf_0.Mag_dd,RF_Zth_vsl_srf_0.Phi_dd,'', ...
            RF_Zth_vsl_srf_01.f,RF_Zth_vsl_srf_01.Mag_dd,RF_Zth_vsl_srf_01.Phi_dd,'k-.');
        
set(gcaMag,'YLim',[-10 75],'YTick',[0 20 40 60 75],'YTickLabel',{0 20 40 60 '^'});
%yT.Position(2) = 33;% para o ylabel caber na figura


CMF_plot_TR(gcaMag,[155.3 90], [275.3 90]);
CMF_plot_TR(gcaPhi,[155.3 200], [275.3 200]);

hp = patch(gcaMag,[38 38 85 85],[-70 80 80 -70],'k',...
    'facecolor','r','edgecolor','r','FaceAlpha',0.1,'EdgeAlpha',0.1) ;


hp = patch(gcaPhi,[38 38 85 85],[-200 200 200 -200],'k',...
    'facecolor','r','edgecolor','r','FaceAlpha',0.1,'EdgeAlpha',0.1) ;


leg = legend(gcaMag.Children([end end-1 end-2]),...
    '$k_i^{v,sl} = 0.00100 V^{-1}rad/s$',...
    '$k_i^{v,sl} = 0.00010 V^{-1}rad/s$',...
    '$k_i^{v,sl} = 0.00001 V^{-1}rad/s$',...
    'Location', 'northwest','FontName','calibri');
leg.FontSize = 24;
leg.Interpreter = 'latex';

CMF_Anota_Plot90(gcaMag,[155.3 -9],[275.3 -9]);

%  export_fig 'figs/Tese/var_gains/bode_Zth_vsl_srf_dd_var_kiv' '-png' -transparent -painters -r200


%% Gráficos Zth_vsl_srf dq: variação do ganho integral

[H,gcaMag,gcaPhi,yT,xB,yB] =...
CMF_plot_RF(RF_Zth_vsl_srf_02.f,RF_Zth_vsl_srf_02.Mag_dq,RF_Zth_vsl_srf_02.Phi_dq,'--', ...
            RF_Zth_vsl_srf_0.f,RF_Zth_vsl_srf_0.Mag_dq,RF_Zth_vsl_srf_0.Phi_dq,'', ...
            RF_Zth_vsl_srf_01.f,RF_Zth_vsl_srf_01.Mag_dq,RF_Zth_vsl_srf_01.Phi_dq,'k-.');
        
set(gcaMag,'YLim',[-15 70],'YTick',[0 20 40 60 70],'YTickLabel',{0 20 40 60 '^'});


CMF_plot_TR(gcaMag,[155.3 80], [275.3 80]);
CMF_plot_TR(gcaPhi,[155.3 200], [275.3 200]);


hp = patch(gcaMag,[38 38 95 95],[-70 70 70 -70],'k',...
    'facecolor','r','edgecolor','r','FaceAlpha',0.1,'EdgeAlpha',0.1) ;


hp = patch(gcaPhi,[38 38 95 95],[-200 200 200 -200],'k',...
    'facecolor','r','edgecolor','r','FaceAlpha',0.1,'EdgeAlpha',0.1) ;


leg = legend(gcaMag.Children([end end-1 end-2]),...
    '$k_i^{v,sl} = 0.00100 V^{-1}rad/s$','$k_i^{v,sl} = 0.00010 V^{-1}rad/s$','$k_i^{v,sl} = 0.00001 V^{-1}rad/s$','Location', 'northwest','FontName','calibri');
leg.FontSize = 24;
leg.Interpreter = 'latex';

CMF_Anota_Plot90(gcaMag,[155.3 -14],[275.3 -14]);

%export_fig 'figs/Tese/var_gains/bode_Zth_vsl_srf_dq_var_kiv' '-png' -transparent -painters -r200






%% Zth_vdl_srf: Avaliação da influencia dos ganhos proporcional e integral

% kp_idl_srf_0 = 0.001;
% ki_idl_srf_0 = 0.1;
% kp_vdl_srf_0 = 0.01;
% ki_vdl_srf_0 = 1;
% G_idl_srf_0 = Gdq0(GPI(kp_idl_srf_0,ki_idl_srf_0));
% G_vdl_srf_0 = Gdq0(GPI(kp_vdl_srf_0,ki_vdl_srf_0));
% Zth_vdl_srf_0 = Zth3_srf(G_idl_srf_0,G_vdl_srf_0);
% Gth_vdl_srf_0 = Gth2_srf(G_idl_srf_0,G_vdl_srf_0);



kp_idl_srf_1 = 0.0001;
kp_idl_srf_2 = 0.01;
  
ki_idl_srf_1 = 0.01;
ki_idl_srf_2 = 1;


kp_vdl_srf_1 = 0.001;
kp_vdl_srf_2 = 0.1;

ki_vdl_srf_1 = 0.1;
ki_vdl_srf_2 = 10;


G_idl_srf_10 = Gdq0(GPI(kp_idl_srf_1,ki_idl_srf_0));
G_idl_srf_20 = Gdq0(GPI(kp_idl_srf_2,ki_idl_srf_0));

G_idl_srf_01 = Gdq0(GPI(kp_idl_srf_0,ki_idl_srf_1));
G_idl_srf_02 = Gdq0(GPI(kp_idl_srf_0,ki_idl_srf_2));


G_vdl_srf_10 = Gdq0(GPI(kp_vdl_srf_1,ki_vdl_srf_0));
G_vdl_srf_20 = Gdq0(GPI(kp_vdl_srf_2,ki_vdl_srf_0));

G_vdl_srf_01 = Gdq0(GPI(kp_vdl_srf_0,ki_vdl_srf_1));
G_vdl_srf_02 = Gdq0(GPI(kp_vdl_srf_0,ki_vdl_srf_2));


Zth_vdl_srf_1000 = Zth3_srf(G_idl_srf_10,G_vdl_srf_0);
Zth_vdl_srf_2000 = Zth3_srf(G_idl_srf_20,G_vdl_srf_0);

Zth_vdl_srf_0100 = Zth3_srf(G_idl_srf_01,G_vdl_srf_0);
Zth_vdl_srf_0200 = Zth3_srf(G_idl_srf_02,G_vdl_srf_0);


Zth_vdl_srf_0010 = Zth3_srf(G_idl_srf_0,G_vdl_srf_10);
Zth_vdl_srf_0020 = Zth3_srf(G_idl_srf_0,G_vdl_srf_20);

Zth_vdl_srf_0001 = Zth3_srf(G_idl_srf_0,G_vdl_srf_01);
Zth_vdl_srf_0002 = Zth3_srf(G_idl_srf_0,G_vdl_srf_02);




RF_Zth_vdl_srf_0 = CMF_RF(Zth_vdl_srf_0,1,1000,0);


RF_Zth_vdl_srf_1000 = CMF_RF(Zth_vdl_srf_1000,1,1000,0);
RF_Zth_vdl_srf_2000 = CMF_RF(Zth_vdl_srf_2000,1,1000,0);
RF_Zth_vdl_srf_0100 = CMF_RF(Zth_vdl_srf_0100,1,1000,0);
RF_Zth_vdl_srf_0200 = CMF_RF(Zth_vdl_srf_0200,1,1000,0);
RF_Zth_vdl_srf_0010 = CMF_RF(Zth_vdl_srf_0010,1,1000,0);
RF_Zth_vdl_srf_0020 = CMF_RF(Zth_vdl_srf_0020,1,1000,0);
RF_Zth_vdl_srf_0001 = CMF_RF(Zth_vdl_srf_0001,1,1000,0);
RF_Zth_vdl_srf_0002 = CMF_RF(Zth_vdl_srf_0002,1,1000,0);






%% Gráficos Zth_vdl_srf dd: variação do ganho proporcional do controle de corrente

[H,gcaMag,gcaPhi,yT,xB,yB] =...
CMF_plot_RF(RF_Zth_vdl_srf_2000.f,RF_Zth_vdl_srf_2000.Mag_dd,RF_Zth_vdl_srf_2000.Phi_dd,'--', ...
            RF_Zth_vdl_srf_0.f,RF_Zth_vdl_srf_0.Mag_dd,RF_Zth_vdl_srf_0.Phi_dd,'', ...
            RF_Zth_vdl_srf_1000.f,RF_Zth_vdl_srf_1000.Mag_dd,RF_Zth_vdl_srf_1000.Phi_dd,'k-.');
        
set(gcaMag,'YLim',[15 45],'YTick',[20 30 40 45],'YTickLabel',{20 30 40 '^'});


CMF_plot_TR(gcaMag,[201 70],[260 70]);
CMF_plot_TR(gcaPhi,[201 200],[260 200]);


leg = legend(gcaPhi.Children([end end-1 end-2]),...
    '$k_p^{i,dl} = 0.0100 A^{-1}$','$k_p^{i,dl} = 0.0010 A^{-1}$','$k_p^{i,dl} = 0.0001 A^{-1}$','Location', 'southwest','FontName','calibri');
leg.FontSize = 24;
leg.Interpreter = 'latex';

CMF_Anota_Plot90(gcaMag,[201 18],[260 18]);

% export_fig 'figs/Tese/var_gains/bode_Zth_vdl_srf_dd_var_kpi' '-png' -transparent -painters -r200



%% Gráficos Zth_vdl_srf dq: variação do ganho proporcional do controle de corrente

[H,gcaMag,gcaPhi,yT,xB,yB] =...
CMF_plot_RF(RF_Zth_vdl_srf_2000.f,RF_Zth_vdl_srf_2000.Mag_dq,RF_Zth_vdl_srf_2000.Phi_dq,'--', ...
            RF_Zth_vdl_srf_0.f,RF_Zth_vdl_srf_0.Mag_dq,RF_Zth_vdl_srf_0.Phi_dq,'', ...
            RF_Zth_vdl_srf_1000.f,RF_Zth_vdl_srf_1000.Mag_dq,RF_Zth_vdl_srf_1000.Phi_dq,'k-.');
        
set(gcaMag,'YLim',[-25 50],'YTick',[-20 0 20 40 50],'YTickLabel',{-20 0 20 40 '^'});


CMF_plot_TR(gcaMag,[256 70]);
CMF_plot_TR(gcaPhi,[256 200]);


leg = legend(gcaPhi.Children([end end-1 end-2]),...
    '$k_p^{i,dl} = 0.0100 A^{-1}$','$k_p^{i,dl} = 0.0010 A^{-1}$','$k_p^{i,dl} = 0.0001 A^{-1}$','Location', 'southwest','FontName','calibri');
leg.FontSize = 24;
leg.Interpreter = 'latex';

CMF_Anota_Plot90(gcaMag,[256 -20]);

% export_fig 'figs/Tese/var_gains/bode_Zth_vdl_srf_dq_var_kpi' '-png' -transparent -painters -r200




%% Gráficos Zth_vdl_srf dd: variação do ganho integral do controle de corrente

[H,gcaMag,gcaPhi,yT,xB,yB] =...
CMF_plot_RF(RF_Zth_vdl_srf_0200.f,RF_Zth_vdl_srf_0200.Mag_dd,RF_Zth_vdl_srf_0200.Phi_dd,'--', ...
            RF_Zth_vdl_srf_0.f,RF_Zth_vdl_srf_0.Mag_dd,RF_Zth_vdl_srf_0.Phi_dd,'', ...
            RF_Zth_vdl_srf_0100.f,RF_Zth_vdl_srf_0100.Mag_dd,RF_Zth_vdl_srf_0100.Phi_dd,'k-.');
        
set(gcaMag,'YLim',[15 42],'YTick',[20 30 40 42],'YTickLabel',{20 30 40 '^'});


% CMF_plot_TR(gcaMag,[201 70],[260 70]);
% CMF_plot_TR(gcaPhi,[201 200],[260 200]);


leg = legend(gcaPhi.Children([end end-1 end-2]),...
    '$k_i^{i,dl} = 1.00 A^{-1}rad/s$','$k_i^{i,dl} = 0.10 A^{-1}rad/s$','$k_i^{i,dl} = 0.01 A^{-1}rad/s$','Location', 'southwest','FontName','calibri');
leg.FontSize = 24;
leg.Interpreter = 'latex';

%CMF_Anota_Plot90(gcaMag,[201 18],[260 18]);

%export_fig 'figs/Tese/var_gains/bode_Zth_vdl_srf_dd_var_kii' '-png' -transparent -painters -r200





%% Gráficos Zth_vdl_srf dq: variação do ganho integral do controle de corrente

[H,gcaMag,gcaPhi,yT,xB,yB] =...
CMF_plot_RF(RF_Zth_vdl_srf_0200.f,RF_Zth_vdl_srf_0200.Mag_dq,RF_Zth_vdl_srf_0200.Phi_dq,'--', ...
            RF_Zth_vdl_srf_0.f,RF_Zth_vdl_srf_0.Mag_dq,RF_Zth_vdl_srf_0.Phi_dq,'', ...
            RF_Zth_vdl_srf_0100.f,RF_Zth_vdl_srf_0100.Mag_dq,RF_Zth_vdl_srf_0100.Phi_dq,'k-.');
        
set(gcaMag,'YLim',[-25 45],'YTick',[-20 0 20 40 45],'YTickLabel',{-20 0 20 40 '^'});


% CMF_plot_TR(gcaMag,[201 70],[260 70]);
% CMF_plot_TR(gcaPhi,[201 200],[260 200]);


leg = legend(gcaPhi.Children([end end-1 end-2]),...
    '$k_i^{i,dl} = 1.00 A^{-1}rad/s$','$k_i^{i,dl} = 0.10 A^{-1}rad/s$','$k_i^{i,dl} = 0.01 A^{-1}rad/s$','Location', 'southwest','FontName','calibri');
leg.FontSize = 24;
leg.Interpreter = 'latex';

%CMF_Anota_Plot90(gcaMag,[201 18],[260 18]);

%export_fig 'figs/Tese/var_gains/bode_Zth_vdl_srf_dq_var_kii' '-png' -transparent -painters -r200




%% Gráficos Zth_vdl_srf dd: variação do ganho proporcional do controle de tensão

[H,gcaMag,gcaPhi,yT,xB,yB] =...
CMF_plot_RF(RF_Zth_vdl_srf_0020.f,RF_Zth_vdl_srf_0020.Mag_dd,RF_Zth_vdl_srf_0020.Phi_dd,'--', ...
            RF_Zth_vdl_srf_0.f,RF_Zth_vdl_srf_0.Mag_dd,RF_Zth_vdl_srf_0.Phi_dd,'', ...
            RF_Zth_vdl_srf_0010.f,RF_Zth_vdl_srf_0010.Mag_dd,RF_Zth_vdl_srf_0010.Phi_dd,'k-.');
        
set(gcaMag,'YLim',[12 45],'YTick',[20 30 40 45],'YTickLabel',{20 30 40 '^'});
% 
% 
CMF_plot_TR(gcaMag,[606 70]);
CMF_plot_TR(gcaPhi,[606 200]);


leg = legend(gcaPhi.Children([end end-1 end-2]),...
    '$k_p^{v,dl} = 0.100 S$','$k_p^{v,dl} = 0.010 S$','$k_p^{v,dl} = 0.001 S$','Location', 'southwest','FontName','calibri');
leg.FontSize = 24;
leg.Interpreter = 'latex';

CMF_Anota_Plot90(gcaMag,[606 13]);

%export_fig 'figs/Tese/var_gains/bode_Zth_vdl_srf_dd_var_kpv' '-png' -transparent -painters -r200


%% Gráficos Zth_vdl_srf dq: variação do ganho proporcional do controle de tensão

[H,gcaMag,gcaPhi,yT,xB,yB] =...
CMF_plot_RF(RF_Zth_vdl_srf_0020.f,RF_Zth_vdl_srf_0020.Mag_dq,RF_Zth_vdl_srf_0020.Phi_dq,'--', ...
            RF_Zth_vdl_srf_0.f,RF_Zth_vdl_srf_0.Mag_dd,RF_Zth_vdl_srf_0.Phi_dd,'', ...
            RF_Zth_vdl_srf_0010.f,RF_Zth_vdl_srf_0010.Mag_dq,RF_Zth_vdl_srf_0010.Phi_dq,'k-.');
        
%set(gcaMag,'YLim',[12 45],'YTick',[20 30 40 45],'YTickLabel',{20 30 40 '^'});
% 
% 
% CMF_plot_TR(gcaMag,[606 70]);
% CMF_plot_TR(gcaPhi,[606 200]);


leg = legend(gcaPhi.Children([end end-1 end-2]),...
    '$k_p^{v,dl} = 0.100 S$','$k_p^{v,dl} = 0.010 S$','$k_p^{v,dl} = 0.001 S$','Location', 'southwest','FontName','calibri');
leg.FontSize = 24;
leg.Interpreter = 'latex';

% CMF_Anota_Plot90(gcaMag,[606 13]);

%export_fig 'figs/Tese/var_gains/bode_Zth_vdl_srf_dq_var_kpv' '-png' -transparent -painters -r200



%% Gráficos Zth_vdl_srf dd: variação do ganho integral do controle de tensão

[H,gcaMag,gcaPhi,yT,xB,yB] =...
CMF_plot_RF(RF_Zth_vdl_srf_0002.f,RF_Zth_vdl_srf_0002.Mag_dd,RF_Zth_vdl_srf_0002.Phi_dd,'--', ...
            RF_Zth_vdl_srf_0.f,RF_Zth_vdl_srf_0.Mag_dd,RF_Zth_vdl_srf_0.Phi_dd,'', ...
            RF_Zth_vdl_srf_0001.f,RF_Zth_vdl_srf_0001.Mag_dd,RF_Zth_vdl_srf_0001.Phi_dd,'k-.');
        
set(gcaMag,'YLim',[-5 45],'YTick',[0 20 40 45],'YTickLabel',{0 20 40 '^'});
% 
% % 
% CMF_plot_TR(gcaMag,[606 70]);
% CMF_plot_TR(gcaPhi,[606 200]);


leg = legend(gcaPhi.Children([end end-1 end-2]),...
    '$k_i^{v,dl} = 10 Srad/s$','$k_i^{v,dl} = 1.0 Srad/s$','$k_i^{v,dl} = 0.1 Srad/s$','Location', 'southwest','FontName','calibri');
leg.FontSize = 24;
leg.Interpreter = 'latex';

% CMF_Anota_Plot90(gcaMag,[606 13]);

%export_fig 'figs/Tese/var_gains/bode_Zth_vdl_srf_dd_var_kiv' '-png' -transparent -painters -r200


%% Gráficos Zth_vdl_srf dq: variação do ganho integral do controle de tensão

[H,gcaMag,gcaPhi,yT,xB,yB] =...
CMF_plot_RF(RF_Zth_vdl_srf_0002.f,RF_Zth_vdl_srf_0002.Mag_dq,RF_Zth_vdl_srf_0002.Phi_dq,'--', ...
            RF_Zth_vdl_srf_0.f,RF_Zth_vdl_srf_0.Mag_dq,RF_Zth_vdl_srf_0.Phi_dq,'', ...
            RF_Zth_vdl_srf_0001.f,RF_Zth_vdl_srf_0001.Mag_dq,RF_Zth_vdl_srf_0001.Phi_dq,'k-.');
        
set(gcaMag,'YLim',[-45 45],'YTick',[-40 -20 0 20 40 45],'YTickLabel',{-40 -20 0 20 40 '^'});
% 
% % 
% CMF_plot_TR(gcaMag,[606 70]);
% CMF_plot_TR(gcaPhi,[606 200]);


leg = legend(gcaPhi.Children([end end-1 end-2]),...
    '$k_i^{v,dl} = 10 Srad/s$','$k_i^{v,dl} = 1.0 Srad/s$','$k_i^{v,dl} = 0.1 Srad/s$','Location', 'southwest','FontName','calibri');
leg.FontSize = 24;
leg.Interpreter = 'latex';

% CMF_Anota_Plot90(gcaMag,[606 13]);

%export_fig 'figs/Tese/var_gains/bode_Zth_vdl_srf_dq_var_kiv' '-png' -transparent -painters -r200




%% Yca_nrf: Avaliação da influencia dos ganhos proporcional e ressonante


kp_i_nrf_1 = 1e-5;
kp_i_nrf_2 = 1e-3;

kr_i_nrf_1 = 1e-3;
kr_i_nrf_2 = 1e-1;



G_i_nrf_10 = GPR(kp_i_nrf_1,kr_i_nrf_0,2*pi*60);
G_i_nrf_20 = GPR(kp_i_nrf_2,kr_i_nrf_0,2*pi*60);
G_i_nrf_01 = GPR(kp_i_nrf_0,kr_i_nrf_1,2*pi*60);
G_i_nrf_02 = GPR(kp_i_nrf_0,kr_i_nrf_2,2*pi*60);

Yca_i_nrf_10 = Yac_nrf(G_i_nrf_10);
Yca_i_nrf_20 = Yac_nrf(G_i_nrf_20);
Yca_i_nrf_01 = Yac_nrf(G_i_nrf_01);
Yca_i_nrf_02 = Yac_nrf(G_i_nrf_02);
 

% Estou fazendo uma gambiarra para não ter que programar outra função
RF_Yca_i_nrf_0 = CMF_RF_1(Yca_i_nrf_0,1,1000);

RF_Yca_i_nrf_10 = CMF_RF_1(Yca_i_nrf_10,1,1000);
RF_Yca_i_nrf_20 = CMF_RF_1(Yca_i_nrf_20,1,1000);
RF_Yca_i_nrf_01 = CMF_RF_1(Yca_i_nrf_01,1,1000);
RF_Yca_i_nrf_02 = CMF_RF_1(Yca_i_nrf_02,1,1000);



%% Gráfico de Yca_nrf - variação do ganho proporcional


[H,gcaMag,gcaPhi,yT,xB,yB] =...
CMF_plot_RF(RF_Yca_i_nrf_20.f,RF_Yca_i_nrf_20.Mag,RF_Yca_i_nrf_20.Phi,'--', ...
            RF_Yca_i_nrf_0.f,RF_Yca_i_nrf_0.Mag,RF_Yca_i_nrf_0.Phi,'', ...
            RF_Yca_i_nrf_10.f,RF_Yca_i_nrf_10.Mag,RF_Yca_i_nrf_10.Phi,'k-.');
        
set(gcaMag,'YLim',[-180 10],'YTick',[-150 -100 -50 0 10],'YTickLabel',{-150 -100 -50 0 '^'});

CMF_plot_TR(gcaMag,[14.06 200]);
CMF_plot_TR(gcaPhi,[14.06 200]);

leg = legend(gcaPhi.Children([end end-1 end-2]),'$k_p^i = 0.00100 A^{-1}$',...
                    '$k_p^i = 0.00010 A^{-1}$',...
                    '$k_p^i = 0.00001 A^{-1}$',...
                    'Location', 'southwest','FontName','calibri');
leg.FontSize = 24;
leg.Interpreter = 'latex';

CMF_Anota_Plot90(gcaMag,[14.06 -150]);

% export_fig 'figs/Tese/var_gains/bode_Yca_i_nrf_var_kpi' '-png' -transparent -painters -r200



%% Gráfico de Yca_nrf - variação do ganho ressonante


[H,gcaMag,gcaPhi,yT,xB,yB] =...
CMF_plot_RF(RF_Yca_i_nrf_02.f,RF_Yca_i_nrf_02.Mag,RF_Yca_i_nrf_02.Phi,'--', ...
            RF_Yca_i_nrf_0.f,RF_Yca_i_nrf_0.Mag,RF_Yca_i_nrf_0.Phi,'', ...
            RF_Yca_i_nrf_01.f,RF_Yca_i_nrf_01.Mag,RF_Yca_i_nrf_01.Phi,'k-.');
        
set(gcaMag,'YLim',[-180 10],'YTick',[-150 -100 -50 0 10],'YTickLabel',{-150 -100 -50 0 '^'});

% CMF_plot_TR(gcaMag,[14.06 200]);
% CMF_plot_TR(gcaPhi,[14.06 200]);

leg = legend(gcaPhi.Children([end end-1 end-2]),'$k_r^i = 0.100 A^{-1}rad/s$',...
                    '$k_r^i = 0.010 A^{-1}rad/s$',...
                    '$k_r^i = 0.001 A^{-1}rad/s$',...
                    'Location', 'southwest','FontName','calibri');
leg.FontSize = 24;
leg.Interpreter = 'latex';

% CMF_Anota_Plot90(gcaMag,[14.06 -150]);

% export_fig 'figs/Tese/var_gains/bode_Yca_i_nrf_var_kri' '-png' -transparent -painters -r200








%% Zth_sl_nrf: Avaliação da influencia dos ganhos proporcional e ressonante


kp_vsl_nrf_1 = 1e-5;
kp_vsl_nrf_2 = 1e-3;

kr_vsl_nrf_1 = 1e-4;
kr_vsl_nrf_2 = 1e-2;



G_vsl_nrf_10 = GPR(kp_vsl_nrf_1,kr_vsl_nrf_0,2*pi*60);
G_vsl_nrf_20 = GPR(kp_vsl_nrf_2,kr_vsl_nrf_0,2*pi*60);
G_vsl_nrf_01 = GPR(kp_vsl_nrf_0,kr_vsl_nrf_1,2*pi*60);
G_vsl_nrf_02 = GPR(kp_vsl_nrf_0,kr_vsl_nrf_2,2*pi*60);

Zth_vsl_nrf_10 = Zth_sl_nrf(G_vsl_nrf_10);
Zth_vsl_nrf_20 = Zth_sl_nrf(G_vsl_nrf_20);
Zth_vsl_nrf_01 = Zth_sl_nrf(G_vsl_nrf_01);
Zth_vsl_nrf_02 = Zth_sl_nrf(G_vsl_nrf_02);
 

% Estou fazendo uma gambiarra para não ter que programar outra função
RF_Zth_vsl_nrf_0 = CMF_RF_1(Zth_vsl_nrf_0,1,1000);

RF_Zth_vsl_nrf_10 = CMF_RF_1(Zth_vsl_nrf_10,1,1000);
RF_Zth_vsl_nrf_20 = CMF_RF_1(Zth_vsl_nrf_20,1,1000);
RF_Zth_vsl_nrf_01 = CMF_RF_1(Zth_vsl_nrf_01,1,1000);
RF_Zth_vsl_nrf_02 = CMF_RF_1(Zth_vsl_nrf_02,1,1000);




%% Gráfico de Zth_sl_nrf - variação do ganho proporcional


[H,gcaMag,gcaPhi,yT,xB,yB] =...
CMF_plot_RF(RF_Zth_vsl_nrf_20.f,RF_Zth_vsl_nrf_20.Mag,RF_Zth_vsl_nrf_20.Phi,'--', ...
            RF_Zth_vsl_nrf_0.f,RF_Zth_vsl_nrf_0.Mag,RF_Zth_vsl_nrf_0.Phi,'', ...
            RF_Zth_vsl_nrf_10.f,RF_Zth_vsl_nrf_10.Mag,RF_Zth_vsl_nrf_10.Phi,'k-.');
        
set(gcaMag,'YLim',[-80 85],'YTick',[-60 -30 0 30 60 85],'YTickLabel',{-60 -30 0 30 60 '^'});

CMF_plot_TR(gcaMag,[604.3 200],[274.5 200]);
CMF_plot_TR(gcaPhi,[604.3 200],[274.5 200]);

leg = legend(gcaPhi.Children([end end-1 end-2]),'$k_p^{v,sl} = 0.00100 V^{-1}$',...
                    '$k_p^{v,sl} = 0.00010 V^{-1}$',...
                    '$k_p^{v,sl} = 0.00001 V^{-1}$',...
                    'Location', 'northwest','FontName','calibri');
leg.FontSize = 24;
leg.Interpreter = 'latex';

CMF_Anota_Plot90(gcaMag,[604.3 -60],[274.5 -60]);

% export_fig 'figs/Tese/var_gains/bode_Zth_sl_nrf_var_kpv' '-png' -transparent -painters -r200




%% Gráfico de Zth_sl_nrf - variação do ganho ressonante


[H,gcaMag,gcaPhi,yT,xB,yB] =...
CMF_plot_RF(RF_Zth_vsl_nrf_02.f,RF_Zth_vsl_nrf_02.Mag,RF_Zth_vsl_nrf_02.Phi,'--', ...
            RF_Zth_vsl_nrf_0.f,RF_Zth_vsl_nrf_0.Mag,RF_Zth_vsl_nrf_0.Phi,'', ...
            RF_Zth_vsl_nrf_01.f,RF_Zth_vsl_nrf_01.Mag,RF_Zth_vsl_nrf_01.Phi,'k-.');
        
set(gcaMag,'YLim',[-50 70],'YTick',[-60 -30 0 30 60 70],'YTickLabel',{-60 -30 0 30 60 '^'});
% 
CMF_plot_TR(gcaMag,[604.3 200]);
CMF_plot_TR(gcaPhi,[604.3 200]);

leg = legend(gcaPhi.Children([end end-1 end-2]),'$k_r^{v,sl} = 0.0100 V^{-1}rad/s$',...
                    '$k_r^{v,sl} = 0.0010 V^{-1}rad/s$',...
                    '$k_r^{v,sl} = 0.0001 V^{-1}rad/s$',...
                    'Location', 'northwest','FontName','calibri');
leg.FontSize = 24;
leg.Interpreter = 'latex';

CMF_Anota_Plot90(gcaMag,[604.3 -20]);

%export_fig 'figs/Tese/var_gains/bode_Zth_sl_nrf_var_krv' '-png' -transparent -painters -r200


















%% Zth_vdl_nrf: Avaliação da influencia dos ganhos proporcional e integral


% kp_i_nrf_0 = 1e-4;
% kr_i_nrf_0 = 1e-2;

% kp_vdl_nrf_0 = 0.1;
% kr_vdl_nrf_0 = 1;
% G_vdl_nrf_0 = GPR(kp_vdl_nrf_0,kr_vdl_nrf_0,w0); 
% Zth_vdl_nrf_0 = Zth_nrf(G_i_nrf_0,G_vdl_nrf_0);
% Gth_vdl_nrf_0 = Gth_nrf(G_i_nrf_0,G_vdl_nrf_0);
%Zth_nrf = @(Gi,Gv)

% kpi = 1e-4;
% kri = 1e-2;
% kpv = 0.1;
% krv = 1;

kp_idl_nrf_1 = kp_i_nrf_0/10;
kp_idl_nrf_2 = kp_i_nrf_0*10;
  
kr_idl_nrf_1 = kr_i_nrf_0/10;
kr_idl_nrf_2 = kr_i_nrf_0*5;


kp_vdl_nrf_1 = kp_vdl_nrf_0/10;
kp_vdl_nrf_2 = kp_vdl_nrf_0*5;

kr_vdl_nrf_1 = 0.09;
kr_vdl_nrf_2 = 9;


G_idl_nrf_10 =GPR(kp_idl_nrf_1,kr_i_nrf_0,w0);
G_idl_nrf_20 = GPR(kp_idl_nrf_2,kr_i_nrf_0,w0);

G_idl_nrf_01 = GPR(kp_i_nrf_0,kr_idl_nrf_1,w0);
G_idl_nrf_02 = GPR(kp_i_nrf_0,kr_idl_nrf_2,w0);


G_vdl_nrf_10 = GPR(kp_vdl_nrf_1,kr_vdl_nrf_0,w0);
G_vdl_nrf_20 = GPR(kp_vdl_nrf_2,kr_vdl_nrf_0,w0);

G_vdl_nrf_01 = GPR(kp_vdl_nrf_0,kr_vdl_nrf_1,w0);
G_vdl_nrf_02 = GPR(kp_vdl_nrf_0,kr_vdl_nrf_2,w0);


Zth_vdl_nrf_1000 = Zth_nrf(G_idl_nrf_10,G_vdl_nrf_0);
Zth_vdl_nrf_2000 = Zth_nrf(G_idl_nrf_20,G_vdl_nrf_0);

Zth_vdl_nrf_0100 = Zth_nrf(G_idl_nrf_01,G_vdl_nrf_0);
Zth_vdl_nrf_0200 = Zth_nrf(G_idl_nrf_02,G_vdl_nrf_0);


Zth_vdl_nrf_0010 = Zth_nrf(G_i_nrf_0,G_vdl_nrf_10);
Zth_vdl_nrf_0020 = Zth_nrf(G_i_nrf_0,G_vdl_nrf_20);

Zth_vdl_nrf_0001 = Zth_nrf(G_i_nrf_0,G_vdl_nrf_01);
Zth_vdl_nrf_0002 = Zth_nrf(G_i_nrf_0,G_vdl_nrf_02);




RF_Zth_vdl_nrf_0 = CMF_RF_1(Zth_vdl_nrf_0,1,1000);


RF_Zth_vdl_nrf_1000 = CMF_RF_1(Zth_vdl_nrf_1000,1,1000);
RF_Zth_vdl_nrf_2000 = CMF_RF_1(Zth_vdl_nrf_2000,1,1000);
RF_Zth_vdl_nrf_0100 = CMF_RF_1(Zth_vdl_nrf_0100,1,1000);
RF_Zth_vdl_nrf_0200 = CMF_RF_1(Zth_vdl_nrf_0200,1,1000);
RF_Zth_vdl_nrf_0010 = CMF_RF_1(Zth_vdl_nrf_0010,1,1000);
RF_Zth_vdl_nrf_0020 = CMF_RF_1(Zth_vdl_nrf_0020,1,1000);
RF_Zth_vdl_nrf_0001 = CMF_RF_1(Zth_vdl_nrf_0001,1,1000);
RF_Zth_vdl_nrf_0002 = CMF_RF_1(Zth_vdl_nrf_0002,1,1000);


















%% Gráfico de Zth_dl_nrf - variação do ganho proporcional da corrente


[H,gcaMag,gcaPhi,yT,xB,yB] =...
CMF_plot_RF(RF_Zth_vdl_nrf_2000.f,RF_Zth_vdl_nrf_2000.Mag,RF_Zth_vdl_nrf_2000.Phi,'--', ...
            RF_Zth_vdl_nrf_0.f,RF_Zth_vdl_nrf_0.Mag,RF_Zth_vdl_nrf_0.Phi,'', ...
            RF_Zth_vdl_nrf_1000.f,RF_Zth_vdl_nrf_1000.Mag,RF_Zth_vdl_nrf_1000.Phi,'k-.');
        
set(gcaMag,'YLim',[-10 95],'YTick',[0 30 60 90 95],'YTickLabel',{0 30 60 90 '^'});
% 
CMF_plot_TR(gcaMag,[216.9 200],[273.6 200],[564.07 200]);
CMF_plot_TR(gcaPhi,[216.9 200],[273.6 200],[564.07 200]);

leg = legend(gcaPhi.Children([end end-1 end-2]),...
                    '$k_p^{i,dl} = 0.00100 A^{-1}$',...
                    '$k_p^{i,dl} = 0.00010 A^{-1}$',...
                    '$k_p^{i,dl} = 0.00001 A^{-1}$',...
                    'Location', 'northwest','FontName','calibri');
leg.FontSize = 24;
leg.Interpreter = 'latex';

CMF_Anota_Plot90(gcaMag,[216.9 -5],[273.6 55],[564.1 45]);

% export_fig 'figs/Tese/var_gains/bode_Zth_vdl_nrf_var_kpi' '-png' -transparent -painters -r200


%% Gráfico de Zth_dl_nrf - variação do ganho ressonante da corrente


[H,gcaMag,gcaPhi,yT,xB,yB] =...
CMF_plot_RF(RF_Zth_vdl_nrf_0200.f,RF_Zth_vdl_nrf_0200.Mag,RF_Zth_vdl_nrf_0200.Phi,'--', ...
            RF_Zth_vdl_nrf_0.f,RF_Zth_vdl_nrf_0.Mag,RF_Zth_vdl_nrf_0.Phi,'', ...
            RF_Zth_vdl_nrf_0100.f,RF_Zth_vdl_nrf_0100.Mag,RF_Zth_vdl_nrf_0100.Phi,'k-.');
        
set(gcaMag,'YLim',[-10 65],'YTick',[0 20 40 60 65],'YTickLabel',{0 20 40 60 '^'});
% 
CMF_plot_TR(gcaMag,[273.6 200]);
CMF_plot_TR(gcaPhi,[273.6 200]);

leg = legend(gcaPhi.Children([end end-1 end-2]),...
                    '$k_r^{i,dl} = 0.05 A^{-1}rad/s$',...
                    '$k_r^{i,dl} = 0.01 A^{-1}rad/s$',...
                    '$k_r^{i,dl} = 0.001 A^{-1}rad/s$',...
                    'Location', 'northwest','FontName','calibri');
leg.FontSize = 24;
leg.Interpreter = 'latex';

CMF_Anota_Plot90(gcaMag,[273.6 0]);

%export_fig 'figs/Tese/var_gains/bode_Zth_vdl_nrf_var_kri' '-png' -transparent -painters -r200




%% Gráfico de Zth_dl_nrf - variação do ganho proporcional da tensão


[H,gcaMag,gcaPhi,yT,xB,yB] =...
CMF_plot_RF(RF_Zth_vdl_nrf_0020.f,RF_Zth_vdl_nrf_0020.Mag,RF_Zth_vdl_nrf_0020.Phi,'--', ...
            RF_Zth_vdl_nrf_0.f,RF_Zth_vdl_nrf_0.Mag,RF_Zth_vdl_nrf_0.Phi,'', ...
            RF_Zth_vdl_nrf_0010.f,RF_Zth_vdl_nrf_0010.Mag,RF_Zth_vdl_nrf_0010.Phi,'k-.');
        
set(gcaMag,'YLim',[-10 55],'YTick',[0 30 60 90 95],'YTickLabel',{0 30 60 90 '^'});
% 
CMF_plot_TR(gcaMag,[214.3 200],[273.6 200],[451.4 200]);
CMF_plot_TR(gcaPhi,[214.3 200],[273.6 200],[451.4 200]);

leg = legend(gcaPhi.Children([end end-1 end-2]),...
                    '$k_p^{v,dl} = 0.50 V^{-1}$',...
                    '$k_p^{v,dl} = 0.10 V^{-1}$',...
                    '$k_p^{v,dl} = 0.01 V^{-1}$',...
                    'Location', 'northwest','FontName','calibri');
leg.FontSize = 24;
leg.Interpreter = 'latex';

CMF_Anota_Plot90(gcaMag,[214.3 -5],[273.6 -5],[451.4 -5]);

% export_fig 'figs/Tese/var_gains/bode_Zth_vdl_nrf_var_kpv' '-png' -transparent -painters -r200





%% Gráfico de Zth_dl_nrf - variação do ganho ressoante da tensão


[H,gcaMag,gcaPhi,yT,xB,yB] =...
CMF_plot_RF(RF_Zth_vdl_nrf_0002.f,RF_Zth_vdl_nrf_0002.Mag,RF_Zth_vdl_nrf_0002.Phi,'--', ...
            RF_Zth_vdl_nrf_0.f,RF_Zth_vdl_nrf_0.Mag,RF_Zth_vdl_nrf_0.Phi,'', ...
            RF_Zth_vdl_nrf_0001.f,RF_Zth_vdl_nrf_0001.Mag,RF_Zth_vdl_nrf_0001.Phi,'k-.');
        
set(gcaMag,'YLim',[-20 50],'YTick',[-15 0 15 30 45 50],'YTickLabel',{-15 0 15 30 45 '^'});
% 
CMF_plot_TR(gcaMag,[273.6 200]);
CMF_plot_TR(gcaPhi,[273.6 200]);

leg = legend(gcaPhi.Children([end end-1 end-2]),...
                    '$k_r^{v,dl} = 9.00 V^{-1}rad/s$',...
                    '$k_r^{v,dl} = 1.00 V^{-1}rad/s$',...
                    '$k_r^{v,dl} = 0.09 V^{-1}rad/s$',...
                    'Location', 'northwest','FontName','calibri');
leg.FontSize = 24;
leg.Interpreter = 'latex';

CMF_Anota_Plot90(gcaMag,[273.6 -5]);

%export_fig 'figs/Tese/var_gains/bode_Zth_vdl_nrf_var_krv' '-png' -transparent -painters -r200





%% Simulações com uso the multiploes loçoes resonantes

NRF_multires_CTRL_I_1 = readtable('Dados/psim_multres/NRF_CTRL_I_1.csv');
NRF_multires_CTRL_I_1_5_7 = readtable('Dados/psim_multres/NRF_CTRL_I_1_5_7.csv');

NRF_multires_CTRL_V_1 = readtable('Dados/psim_multres/NRF_CTRL_V_1.csv');
NRF_multires_CTRL_V_1_5_7 = readtable('Dados/psim_multres/NRF_CTRL_V_1_5_7.csv');

NRF_multires_CTRL_VI_1 = readtable('Dados/psim_multres/NRF_CTRL_VI_1.csv');
NRF_multires_CTRL_VI_1_5_7 = readtable('Dados/psim_multres/NRF_CTRL_VI_1_5_7.csv');


Sbase = 100e6;
Vacbase = sqrt(2)*69e3/sqrt(3);
Iaacbse = sqrt(2)*Sbase/(sqrt(3)*69e3);


%% Simulation results for the multres approach in NRF current-controller MMC

CMF_Plot3_pertuba(NRF_multires_CTRL_I_1.Time, ...
                  NRF_multires_CTRL_I_1.va, ...
                  NRF_multires_CTRL_I_1.vb, ...
                  NRF_multires_CTRL_I_1.vc, ...
                  Vacbase, 1.5, 'Voltage');
              te =text(1.465,-1.5,'(b)','FontSize',32)
% export_fig 'figs/Tese/NRF_multress/NRF_multires_CTRL_I_vabc' '-png' -transparent -painters -r200

CMF_Plot3_pertuba(NRF_multires_CTRL_I_1.Time, ...
                  NRF_multires_CTRL_I_1.ia, ...
                  NRF_multires_CTRL_I_1.ib, ...
                  NRF_multires_CTRL_I_1.ic, ...
                  Iaacbse, 1.5, 'Current');
              te =text(1.465,-1.5,'(c)','FontSize',32)
% export_fig 'figs/Tese/NRF_multress/NRF_multires_CTRL_I_1_iabc' '-png' -transparent -painters -r200              

CMF_Plot3_pertuba(NRF_multires_CTRL_I_1_5_7.Time, ...
                  NRF_multires_CTRL_I_1_5_7.ia, ...
                  NRF_multires_CTRL_I_1_5_7.ib, ...
                  NRF_multires_CTRL_I_1_5_7.ic, ...
                  Iaacbse, 1.5, 'Current');
                  te =text(1.465,-1.5,'(d)','FontSize',32)
% export_fig 'figs/Tese/NRF_multress/NRF_multires_CTRL_I_1_5_7_iabc' '-png' -transparent -painters -r200              



%% Frequency response for the NRF current controlled MMC with multi resonant loops



G_i_nrf_multres = G_i_nrf_0 + GR(0.6,5*w0) + GR(2,7*w0); 
Yca_i_nrf_multres = Yac_nrf(G_i_nrf_multres); 

RF_Yca_i_nrf_multres = CMF_RF_1(Yca_i_nrf_multres,1,1000);



[H,gcaMag,gcaPhi,yT,xB,yB] =...
CMF_plot_RF(RF_Yca_i_nrf_multres.f,RF_Yca_i_nrf_multres.Mag,RF_Yca_i_nrf_multres.Phi,':', ...
            RF_Yca_i_nrf_0.f,RF_Yca_i_nrf_0.Mag,RF_Yca_i_nrf_0.Phi,'');
        
set(gcaMag,'YLim',[-160 20],'YTick',[-150 -100 -50 0 20],'YTickLabel',{-150 -100 -50 0 '^'});
% 
CMF_plot_TR(gcaMag,[60 200],[300 200],[420 200]);
CMF_plot_TR(gcaPhi,[60 200],[300 200],[420 200]);

leg = legend(gcaPhi.Children([end end-1]),...
                    'Multi resonant',...
                    'Single resonant',...
                    'Location', 'southwest','FontName','calibri');
leg.FontSize = 24;
leg.Interpreter = 'latex';

CMF_Anota_Plot90(gcaMag,[60 -150],[300 -150],[420 -150]);
te =text(0.53,-170,'(a)','FontSize',32)

% export_fig 'figs/Tese/NRF_multress/NRF_multires_CTRL_I_RF' '-png' -transparent -painters -r200              









%% Simulation results for the multres approach in NRF single-loop voltage-controller MMC

CMF_Plot3_pertuba(NRF_multires_CTRL_V_1.Time, ...
                  NRF_multires_CTRL_V_1.ioa, ...
                  NRF_multires_CTRL_V_1.iob, ...
                  NRF_multires_CTRL_V_1.ioc, ...
                  Iaacbse, 1.5, 'Current');
              te =text(1.465,-1.5,'(b)','FontSize',32)
% export_fig 'figs/Tese/NRF_multress/NRF_multires_CTRL_V_iabc' '-png' -transparent -painters -r200

CMF_Plot3_pertuba(NRF_multires_CTRL_V_1.Time, ...
                  NRF_multires_CTRL_V_1.va, ...
                  NRF_multires_CTRL_V_1.vb, ...
                  NRF_multires_CTRL_V_1.vc, ...
                  Vacbase, 1.5, 'Voltage');
              te =text(1.465,-1.5,'(c)','FontSize',32)
% export_fig 'figs/Tese/NRF_multress/NRF_multires_CTRL_V_1_vabc' '-png' -transparent -painters -r200              

CMF_Plot3_pertuba(NRF_multires_CTRL_V_1_5_7.Time, ...
                  NRF_multires_CTRL_V_1_5_7.va, ...
                  NRF_multires_CTRL_V_1_5_7.vb, ...
                  NRF_multires_CTRL_V_1_5_7.vc, ...
                  Vacbase, 1.5, 'Voltage');
                  te =text(1.465,-1.5,'(d)','FontSize',32)
% export_fig 'figs/Tese/NRF_multress/NRF_multires_CTRL_V_1_5_7_vabc' '-png' -transparent -painters -r200     



%% Frequency response for the NRF single-loop voltage-controlled controlled MMC with multi resonant loops



% % % MMC controlado por laço simples de tensão em NRF
% kp_vsl_nrf_0 = 1e-4;
% kr_vsl_nrf_0 = 1e-3;
% G_vsl_nrf_0 = GPR(kp_vsl_nrf_0,kr_vsl_nrf_0,w0); 
% Zth_vsl_nrf_0 = Zth_sl_nrf(G_vsl_nrf_0);
% Gth_vsl_nrf_0 = Gth_sl_nrf(G_vsl_nrf_0);


G_vsl_nrf_multres =  G_vsl_nrf_0 + GR(1e-3,5*w0) + GR(4e-3,7*w0); 
Zth_vsl_nrf_multres = Zth_sl_nrf(G_vsl_nrf_multres);


RF_Zth_vsl_nrf_multres = CMF_RF_1(Zth_vsl_nrf_multres,1,1000);



[H,gcaMag,gcaPhi,yT,xB,yB] =...
CMF_plot_RF(RF_Zth_vsl_nrf_multres.f,RF_Zth_vsl_nrf_multres.Mag,RF_Zth_vsl_nrf_multres.Phi,':', ...
            RF_Zth_vsl_nrf_0.f,RF_Zth_vsl_nrf_0.Mag,RF_Zth_vsl_nrf_0.Phi,'');
        
set(gcaMag,'YLim',[-40 70],'YTick',[-30 0 30 60 70],'YTickLabel',{-30 0 30 60 '^'});
% 
CMF_plot_TR(gcaMag,[60 200],[300 200],[420 200]);
CMF_plot_TR(gcaPhi,[60 200],[300 200],[420 200]);

leg = legend(gcaPhi.Children([end end-1]),...
                    'Multi resonant',...
                    'Single resonant',...
                    'Location', 'northwest','FontName','calibri');
leg.FontSize = 24;
leg.Interpreter = 'latex';

CMF_Anota_Plot90(gcaPhi,[60 -180],[300 -180],[420 -180]);
te =text(0.53,-270,'(a)','FontSize',32)

% export_fig 'figs/Tese/NRF_multress/NRF_multires_CTRL_V_RF' '-png' -transparent -painters -r200       










%% Simulation results for the multres approach in NRF double-loop voltage-controller MMC

CMF_Plot3_pertuba(NRF_multires_CTRL_VI_1.Time, ...
                  NRF_multires_CTRL_VI_1.ioa, ...
                  NRF_multires_CTRL_VI_1.iob, ...
                  NRF_multires_CTRL_VI_1.ioc, ...
                  Iaacbse, 1.5, 'Current');
              te =text(1.465,-1.5,'(b)','FontSize',32)
% export_fig 'figs/Tese/NRF_multress/NRF_multires_CTRL_VI_iabc' '-png' -transparent -painters -r200

CMF_Plot3_pertuba(NRF_multires_CTRL_VI_1.Time, ...
                  NRF_multires_CTRL_VI_1.va, ...
                  NRF_multires_CTRL_VI_1.vb, ...
                  NRF_multires_CTRL_VI_1.vc, ...
                  Vacbase, 1.5, 'Voltage');
              te =text(1.465,-1.5,'(c)','FontSize',32)
% export_fig 'figs/Tese/NRF_multress/NRF_multires_CTRL_VI_1_vabc' '-png' -transparent -painters -r200              

CMF_Plot3_pertuba(NRF_multires_CTRL_VI_1_5_7.Time, ...
                  NRF_multires_CTRL_VI_1_5_7.va, ...
                  NRF_multires_CTRL_VI_1_5_7.vb, ...
                  NRF_multires_CTRL_VI_1_5_7.vc, ...
                  Vacbase, 1.5, 'Voltage');
                  te =text(1.465,-1.5,'(d)','FontSize',32)
% export_fig 'figs/Tese/NRF_multress/NRF_multires_CTRL_VI_1_5_7_vabc' '-png' -transparent -painters -r200





%% Frequency response for the NRF double-loop voltage-controlled controlled MMC with multi resonant loops


% % MMC controlado por corrent em NRF
% kp_i_nrf_0 = 1e-4;
% kr_i_nrf_0 = 1e-2;
% G_i_nrf_0 = GPR(kp_i_nrf_0,kr_i_nrf_0,2*pi*60); 
% Yca_i_nrf_0 = Yac_nrf(G_i_nrf_0); 
% Gnorton_i_nrf_0 =Gnorton_nrf(G_i_nrf_0); 

% % MMC controlado por laço duplo de tensão em NRF
% kp_vdl_nrf_0 = 0.1;
% kr_vdl_nrf_0 = 1;
% G_vdl_nrf_0 = GPR(kp_vdl_nrf_0,kr_vdl_nrf_0,w0); 
% Zth_vdl_nrf_0 = Zth_nrf(G_i_nrf_0,G_vdl_nrf_0);
% Gth_vdl_nrf_0 = Gth_nrf(G_i_nrf_0,G_vdl_nrf_0);


G_i_nrf_00 = GPR(1e-3,1e-2,w0);
G_vdl_nrf_00 = GPR(0.1,1,w0);


G_i_nrf_multres = G_i_nrf_00 + GR(1e-2,5*w0)  + GR(0.003,7*w0);
G_vdl_nrf_multres = G_vdl_nrf_00 + GR(10,5*w0)  + GR(15,7*w0);

Zth_vdl_nrf_00 = Zth_nrf(G_i_nrf_00,G_vdl_nrf_00);
Zth_vdl_nrf_multres = Zth_nrf(G_i_nrf_multres,G_vdl_nrf_multres);


RF_Zth_vdl_nrf_00 = CMF_RF_1(Zth_vdl_nrf_00,1,1000);
RF_Zth_vdl_nrf_multres = CMF_RF_1(Zth_vdl_nrf_multres,1,1000);



[H,gcaMag,gcaPhi,yT,xB,yB] =...
CMF_plot_RF(RF_Zth_vdl_nrf_multres.f,RF_Zth_vdl_nrf_multres.Mag,RF_Zth_vdl_nrf_multres.Phi,':', ...
            RF_Zth_vdl_nrf_00.f,RF_Zth_vdl_nrf_00.Mag,RF_Zth_vdl_nrf_00.Phi,'');
        
set(gcaMag,'YLim',[-5 35],'YTick',[0 10 20 30 35],'YTickLabel',{0 10 20 30 '^'});

CMF_plot_TR(gcaMag,[60 200],[300 200],[420 200]);
CMF_plot_TR(gcaPhi,[60 200],[300 200],[420 200]);

leg = legend(gcaPhi.Children([end end-1]),...
                    'Multi resonant',...
                    'Single resonant',...
                    'Location', 'northwest','FontName','calibri');
leg.FontSize = 24;
leg.Interpreter = 'latex';

CMF_Anota_Plot90(gcaPhi,[60 -180],[300 -180],[420 -180]);
te =text(0.53,-270,'(a)','FontSize',32)

% export_fig 'figs/Tese/NRF_multress/NRF_multires_CTRL_VI_RF' '-png' -transparent -painters -r200      



%% Simulações com uso the laços resonants em SRF

SRF_res_CTRL_I_1 = readtable('Dados/psim_PIR/SRF_CTRL_I_1.csv');
SRF_res_CTRL_I_1_5_7 = readtable('Dados/psim_PIR/SRF_CTRL_I_1_5_7.csv');

SRF_res_CTRL_V_1 = readtable('Dados/psim_PIR/SRF_CTRL_V_1.csv');
SRF_res_CTRL_V_1_5_7 = readtable('Dados/psim_PIR/SRF_CTRL_V_1_5_7.csv');

SRF_res_CTRL_VI_1 = readtable('Dados/psim_PIR/SRF_CTRL_VI_1.csv');
SRF_res_CTRL_VI_1_5_7 = readtable('Dados/psim_PIR/SRF_CTRL_VI_1_5_7.csv');




%% Simulation results for the resonant approach in SRF current-controller MMC

CMF_Plot3_pertuba(SRF_res_CTRL_I_1.Time, ...
                  SRF_res_CTRL_I_1.va, ...
                  SRF_res_CTRL_I_1.vb, ...
                  SRF_res_CTRL_I_1.vc, ...
                  Vacbase, 1.5, 'Voltage');
              te =text(1.465,-1.5,'(b)','FontSize',32)
% export_fig 'figs/Tese/SRF_res/SRF_res_CTRL_I_vabc' '-png' -transparent -painters -r200

CMF_Plot3_pertuba(SRF_res_CTRL_I_1.Time, ...
                  SRF_res_CTRL_I_1.ia, ...
                  SRF_res_CTRL_I_1.ib, ...
                  SRF_res_CTRL_I_1.ic, ...
                  Iaacbse, 1.5, 'Current');
              te =text(1.465,-1.5,'(c)','FontSize',32)
% export_fig 'figs/Tese/SRF_res/SRF_res_CTRL_I_1_iabc' '-png' -transparent -painters -r200              

CMF_Plot3_pertuba(SRF_res_CTRL_I_1_5_7.Time, ...
                  SRF_res_CTRL_I_1_5_7.ia, ...
                  SRF_res_CTRL_I_1_5_7.ib, ...
                  SRF_res_CTRL_I_1_5_7.ic, ...
                  Iaacbse, 1.5, 'Current');
                  te =text(1.465,-1.5,'(d)','FontSize',32)
% export_fig 'figs/Tese/SRF_res/SRF_res_CTRL_I_1_5_7_iabc' '-png' -transparent -painters -r200 



%% Frequency response for the SRF current controlled MMC with resonant loop


% % MMC controlado por corrente em SRF
% kp_i_srf_0 = 0.001;
% ki_i_srf_0 = 0.1;
% G_i_srf_0 = Gdq0(GPI(kp_i_srf_0,ki_i_srf_0));
% Gnorton_i_srf_0 = Gnorton_srf(G_i_srf_0);
% Yca_i_srf_0 = Yac_srf(G_i_srf_0);

G_i_srf_res_0 = G_i_srf_0 + Gdq0(GR(0.5,2*pi*360));
Yca_i_srf_res_0 = Yac_srf(G_i_srf_res_0);



RF_Yca_i_srf_res_0 = CMF_RF(Yca_i_srf_res_0,1,1000,0);



[H,gcaMag,gcaPhi,yT,xB,yB] =...
CMF_plot_RF(RF_Yca_i_srf_res_0.f,RF_Yca_i_srf_res_0.Mag_dd,RF_Yca_i_srf_res_0.Phi_dd,':', ...
            RF_Yca_i_srf_0.f,RF_Yca_i_srf_0.Mag_dd,RF_Yca_i_srf_0.Phi_dd,'');
        
set(gcaMag,'YLim',[-105 -35],'YTick',[-100 -80 -60 -40 -35],'YTickLabel',{-100 -80 -60 -40 '^'});

CMF_plot_TR(gcaMag,[360 200]);
CMF_plot_TR(gcaPhi,[360 200]);

leg = legend(gcaPhi.Children([end end-1]),...
                    'With resonant loop',...
                    'Without resonant loop',...
                    'Location', 'southwest','FontName','calibri');
leg.FontSize = 24;
leg.Interpreter = 'latex';

CMF_Anota_Plot90(gcaMag,[360 -90]);
te =text(0.53,-170,'(a)','FontSize',32)
% 
% export_fig 'figs/Tese/SRF_res/SRF_res_CTRL_I_RF_dd' '-png' -transparent -painters -r200              


%% Simulation results for the resonant approach in SRF single-loop voltage-controller MMC

CMF_Plot3_pertuba(SRF_res_CTRL_V_1.Time, ...
                  SRF_res_CTRL_V_1.ioa, ...
                  SRF_res_CTRL_V_1.iob, ...
                  SRF_res_CTRL_V_1.ioc, ...
                  Iaacbse, 1.5, 'Current');
              te =text(1.465,-1.5,'(c)','FontSize',32)
% export_fig 'figs/Tese/SRF_res/SRF_res_CTRL_V_iabc' '-png' -transparent -painters -r200

CMF_Plot3_pertuba(SRF_res_CTRL_V_1.Time, ...
                  SRF_res_CTRL_V_1.va, ...
                  SRF_res_CTRL_V_1.vb, ...
                  SRF_res_CTRL_V_1.vc, ...
                  Vacbase, 1.5, 'Voltage');
              te =text(1.465,-1.5,'(d)','FontSize',32)
% export_fig 'figs/Tese/SRF_res/SRF_res_CTRL_V_1_vabc' '-png' -transparent -painters -r200              

CMF_Plot3_pertuba(SRF_res_CTRL_V_1_5_7.Time, ...
                  SRF_res_CTRL_V_1_5_7.va, ...
                  SRF_res_CTRL_V_1_5_7.vb, ...
                  SRF_res_CTRL_V_1_5_7.vc, ...
                  Vacbase, 1.5, 'Voltage');
                  te =text(1.465,-1.5,'(e)','FontSize',32)
% export_fig 'figs/Tese/SRF_res/SRF_res_CTRL_V_1_5_7_vabc' '-png' -transparent -painters -r200 



%% Frequency response for the SRF single-loop voltage-controlled MMC with resonant loop


 
G_vsl_srf_res_0 = Gdq0(GPI(0.000001*200,0.000001*200/0.01));

 
G_vsl_srf_res_1 = G_vsl_srf_res_0 + Gdq0(GR(0.01,360*2*pi));


RF_Zth_vsl_srf_res_0 = FN_RF_Zth_vsl_srf(MMCstr,G_vsl_srf_res_0);
RF_Zth_vsl_srf_res_1 = FN_RF_Zth_vsl_srf(MMCstr,G_vsl_srf_res_1);





%% Grafico dd: requency response for the SRF single-loop voltage-controlled MMC with resonant loop
[H,gcaMag,gcaPhi,yT,xB,yB] =...
CMF_plot_RF(RF_Zth_vsl_srf_res_1.f,RF_Zth_vsl_srf_res_1.Mag_dd,RF_Zth_vsl_srf_res_1.Phi_dd,':', ...
            RF_Zth_vsl_srf_res_0.f,RF_Zth_vsl_srf_res_0.Mag_dd,RF_Zth_vsl_srf_res_0.Phi_dd,'-');
        
set(gcaMag,'YLim',[-65 65],'YTick',[-60 -30 0 30 60 65],'YTickLabel',{-60 -30 0 30 60 '^'});

hp = patch(gcaMag,[50 50 70 70],[-65 65 65 -65],'k',...
    'facecolor','r','edgecolor','r','FaceAlpha',0.1,'EdgeAlpha',0.1) ;
hp = patch(gcaPhi,[50 50 70 70],[-200 200 200 -200],'k',...
    'facecolor','r','edgecolor','r','FaceAlpha',0.1,'EdgeAlpha',0.1) ;

CMF_plot_TR(gcaMag,[360 200]);
CMF_plot_TR(gcaPhi,[360 200]);

leg = legend(gcaPhi.Children([end end-1]),...
                    'With resonant loop',...
                    'Without resonant loop',...
                    'Location', 'southwest','FontName','calibri');
leg.FontSize = 24;
leg.Interpreter = 'latex';

CMF_Anota_Plot90(gcaMag,[360 25]);
te =text(0.53,-270,'(a)','FontSize',32)




% 
% export_fig 'figs/Tese/SRF_res/SRF_res_CTRL_V_RF_dd' '-png' -transparent -painters -r200    


%% Grafico dq: requency response for the SRF single-loop voltage-controlled MMC with resonant loop
[H,gcaMag,gcaPhi,yT,xB,yB] =...
CMF_plot_RF(RF_Zth_vsl_srf_res_1.f,RF_Zth_vsl_srf_res_1.Mag_dq,RF_Zth_vsl_srf_res_1.Phi_dq,':', ...
            RF_Zth_vsl_srf_res_0.f,RF_Zth_vsl_srf_res_0.Mag_dq,RF_Zth_vsl_srf_res_0.Phi_dq,'-');
        
set(gcaMag,'YLim',[-95 45],'YTick',[-80 -40 0 40 45],'YTickLabel',{-80 -40 0 40 '^'});

hp = patch(gcaMag,[50 50 70 70],[-95 65 65 -95],'k',...
    'facecolor','r','edgecolor','r','FaceAlpha',0.1,'EdgeAlpha',0.1) ;
hp = patch(gcaPhi,[50 50 70 70],[-200 200 200 -200],'k',...
    'facecolor','r','edgecolor','r','FaceAlpha',0.1,'EdgeAlpha',0.1) ;


CMF_plot_TR(gcaMag,[360 200]);
CMF_plot_TR(gcaPhi,[360 200]);

leg = legend(gcaPhi.Children([end end-1]),...
                    'With resonant loop',...
                    'Without resonant loop',...
                    'Location', 'southwest','FontName','calibri');
leg.FontSize = 24;
leg.Interpreter = 'latex';

CMF_Anota_Plot90(gcaMag,[360 -10]);
te =text(0.53,-270,'(b)','FontSize',32)
% 
%export_fig 'figs/Tese/SRF_res/SRF_res_CTRL_V_RF_dq' '-png' -transparent -painters -r200    



%% Simulation results for the resonant approach in SRF double-loop voltage-controller MMC

CMF_Plot3_pertuba(SRF_res_CTRL_VI_1.Time, ...
                  SRF_res_CTRL_VI_1.ioa, ...
                  SRF_res_CTRL_VI_1.iob, ...
                  SRF_res_CTRL_VI_1.ioc, ...
                  Iaacbse, 1.5, 'Current');
              te =text(1.465,-1.5,'(c)','FontSize',32)
% export_fig 'figs/Tese/SRF_res/SRF_res_CTRL_VI_iabc' '-png' -transparent -painters -r200

CMF_Plot3_pertuba(SRF_res_CTRL_VI_1.Time, ...
                  SRF_res_CTRL_VI_1.va, ...
                  SRF_res_CTRL_VI_1.vb, ...
                  SRF_res_CTRL_VI_1.vc, ...
                  Vacbase, 1.5, 'Voltage');
              te =text(1.465,-1.5,'(d)','FontSize',32)
% export_fig 'figs/Tese/SRF_res/SRF_res_CTRL_VI_1_vabc' '-png' -transparent -painters -r200              

CMF_Plot3_pertuba(SRF_res_CTRL_VI_1_5_7.Time, ...
                  SRF_res_CTRL_VI_1_5_7.va, ...
                  SRF_res_CTRL_VI_1_5_7.vb, ...
                  SRF_res_CTRL_VI_1_5_7.vc, ...
                  Vacbase, 1.5, 'Voltage');
                  te =text(1.465,-1.5,'(e)','FontSize',32)
% export_fig 'figs/Tese/SRF_res/SRF_res_CTRL_VI_1_5_7_vabc' '-png' -transparent -painters -r200 


%% Frequency response for the SRF double-loop voltage-controlled MMC with resonant loop

% % MMC controlado por laço duplo de tensão em SRF
% kp_idl_srf_0 = 0.001;
% ki_idl_srf_0 = 0.1;
% kp_vdl_srf_0 = 0.01;
% ki_vdl_srf_0 = 1;
% G_idl_srf_0 = Gdq0(GPI(kp_idl_srf_0,ki_idl_srf_0));
% G_vdl_srf_0 = Gdq0(GPI(kp_vdl_srf_0,ki_vdl_srf_0));
% Zth_vdl_srf_0 = Zth3_srf(G_idl_srf_0,G_vdl_srf_0);
% Gth_vdl_srf_0 = Gth2_srf(G_idl_srf_0,G_vdl_srf_0);


G_idl_srf_res_0 = G_idl_srf_0 + Gdq0(GR(2,2*pi*360));
G_vdl_srf_res_0 = G_vdl_srf_0 + Gdq0(GR(15,2*pi*360));

Zth_vdl_srf_res_0 = Zth3_srf(G_idl_srf_res_0,G_vdl_srf_res_0);




RF_Zth_vdl_srf_res_0 = CMF_RF(Zth_vdl_srf_res_0,1,1000,0);


%% Grafico dd: requency response for the SRF double-loop voltage-controlled MMC with resonant loop
[H,gcaMag,gcaPhi,yT,xB,yB] =...
CMF_plot_RF(RF_Zth_vdl_srf_res_0.f,RF_Zth_vdl_srf_res_0.Mag_dd,RF_Zth_vdl_srf_res_0.Phi_dd,'--', ...
            RF_Zth_vdl_srf_0.f,RF_Zth_vdl_srf_0.Mag_dd,RF_Zth_vdl_srf_0.Phi_dd,'');
        
set(gcaMag,'YLim',[-45 45],'YTick',[-40 -20 0 20 40 45],'YTickLabel',{-40 -20 0 20 40 '^'});

CMF_plot_TR(gcaMag,[360 200]);
CMF_plot_TR(gcaPhi,[360 200]);

leg = legend(gcaPhi.Children([end end-1]),...
                    'With resonant loop',...
                    'Without resonant loop',...
                    'Location', 'southwest','FontName','calibri');
leg.FontSize = 24;
leg.Interpreter = 'latex';

CMF_Anota_Plot90(gcaMag,[360 -35]);
te =text(0.53,-270,'(a)','FontSize',32)
% 
%export_fig 'figs/Tese/SRF_res/SRF_res_CTRL_VI_RF_dd' '-png' -transparent -painters -r200     

%% Grafico dq: requency response for the SRF double-loop voltage-controlled MMC with resonant loop


[H,gcaMag,gcaPhi,yT,xB,yB] =...
CMF_plot_RF(RF_Zth_vdl_srf_res_0.f,RF_Zth_vdl_srf_res_0.Mag_dq,RF_Zth_vdl_srf_res_0.Phi_dq,'--', ...
            RF_Zth_vdl_srf_0.f,RF_Zth_vdl_srf_0.Mag_dq,RF_Zth_vdl_srf_0.Phi_dq,'');
        
set(gcaMag,'YLim',[-45 55],'YTick',[-40 -20 0 20 40 55],'YTickLabel',{-40 -20 0 20 40 '^'});

CMF_plot_TR(gcaMag,[360 200]);
CMF_plot_TR(gcaPhi,[360 200]);

leg = legend(gcaPhi.Children([end end-1]),...
                    'With resonant loop',...
                    'Without resonant loop',...
                    'Location', 'southwest','FontName','calibri');
leg.FontSize = 24;
leg.Interpreter = 'latex';

CMF_Anota_Plot90(gcaMag,[360 25]);
te =text(0.53,-270,'(b)','FontSize',32)
% 
%export_fig 'figs/Tese/SRF_res/SRF_res_CTRL_VI_RF_dq' '-png' -transparent -painters -r200  













%% Frequency response of the SRF current-controlled MMC with vrtual admittance

Yvir_srf_0 = Yvir_srf(Gdq0(GPI(0.001,0.1)),1);
Yeq_vir_srf = Yvir_srf_0 + Yca_i_srf_0;

RF_Yeq_vir_srf = CMF_RF(Yeq_vir_srf,1,1000,0);



[H,gcaMag,gcaPhi,yT,xB,yB] =...
CMF_plot_RF(RF_Yeq_vir_srf.f,RF_Yeq_vir_srf.Mag_dd,RF_Yeq_vir_srf.Phi_dd,'--', ...
            RF_Yca_i_srf_0.f,RF_Yca_i_srf_0.Mag_dd,RF_Yca_i_srf_0.Phi_dd,'');
        
set(gcaMag,'YLim',[-100 -25],'YTick',[-90 -60 -30 -25],'YTickLabel',{-90 -60 -30 '^'});

CMF_plot_TR(gcaMag,[60 200]);
CMF_plot_TR(gcaPhi,[60 200]);

leg = legend(gcaPhi.Children([end end-1]),...
                    'With Virtual Admittance',...
                    'Without Virual admittance',...
                    'Location', 'southwest','FontName','calibri');
leg.FontSize = 24;
leg.Interpreter = 'latex';

CMF_Anota_Plot90(gcaMag,[60 -95]);
te =text(0.53,-270,'(a)','FontSize',32)

% export_fig 'figs/Tese/SRF_vir/SRF_vir_CTRL_I_RF_dd' '-png' -transparent -painters -r200      



%% Simulation results for the virtual admittance approach for the SRF current-controlled MMC

SRF_vir_CTRL_I_wv = readtable('Dados/psim_vir/SRF_CTRL_I_wv.csv');
SRF_vir_CTRL_I_vir = readtable('Dados/psim_vir/SRF_CTRL_I_vir.csv');



CMF_Plot3_pertuba(SRF_vir_CTRL_I_wv.Time, ...
                  SRF_vir_CTRL_I_wv.va, ...
                  SRF_vir_CTRL_I_wv.vb, ...
                  SRF_vir_CTRL_I_wv.vc, ...
                  Vacbase, 1.5, 'Voltage');
              te =text(1.465,-1.5,'(b)','FontSize',32)
% export_fig 'figs/Tese/SRF_vir/SRF_vir_CTRL_I_vabc' '-png' -transparent -painters -r200

CMF_Plot3_pertuba(SRF_vir_CTRL_I_wv.Time, ...
                  SRF_vir_CTRL_I_wv.ia, ...
                  SRF_vir_CTRL_I_wv.ib, ...
                  SRF_vir_CTRL_I_wv.ic, ...
                  Iaacbse, 1.5, 'Current');
              te =text(1.465,-1.5,'(c)','FontSize',32)
% export_fig 'figs/Tese/SRF_vir/SRF_vir_CTRL_I_iabc_wv' '-png' -transparent -painters -r200    

CMF_Plot3_pertuba(SRF_vir_CTRL_I_vir.Time, ...
                  SRF_vir_CTRL_I_vir.ia, ...
                  SRF_vir_CTRL_I_vir.ib, ...
                  SRF_vir_CTRL_I_vir.ic, ...
                  Iaacbse, 1.5, 'Current');
              te =text(1.465,-1.5,'(d)','FontSize',32)
% export_fig 'figs/Tese/SRF_vir/SRF_vir_CTRL_I_iabc_vir' '-png' -transparent -painters -r200   



%% Frequency response of the SRF single-loop voltage-controlled MMC with vrtual impedance



% Zvir_sl = @(Gvdqsl,Gfiltro)
% Zth_vsl_srf_0 = Z_sl_th_srf(G_vsl_srf_0);



G_vsl_srf_vir_0 = Gdq0(GPI(0.000001*200,0.000001*200/0.01));
Zth_vsl_srf_vir_0 = Z_sl_th_srf(G_vsl_srf_vir_0);

filtro_vsl_vir_srf_1 = Glpf(2*pi*100);
filtro_vsl_vir_srf_2 = Glpf(2*pi*500);
filtro_vsl_vir_srf_3 = Glpf(2*pi*1000);

% Zvir_vsl_srf_1 = Zvir_sl_teste(G_vsl_srf_vir_0,filtro_vsl_vir_srf_1);
% Zvir_vsl_srf_2 = Zvir_sl_teste(G_vsl_srf_vir_0,filtro_vsl_vir_srf_2);
% Zvir_vsl_srf_3 = Zvir_sl_teste(G_vsl_srf_vir_0,filtro_vsl_vir_srf_3);

% RF_Zth_vsl_srf_vir_0 = CMF_RF(Zth_vsl_srf_vir_0,1,1000,0);
% 
% RF_Zvir_vsl_srf_1 = CMF_RF(Zvir_vsl_srf_1,1,1000,0,RF_Zth_vsl_srf_vir_0.w);
% RF_Zvir_vsl_srf_2 = CMF_RF(Zvir_vsl_srf_2,1,1000,0,RF_Zth_vsl_srf_vir_0.w);
% RF_Zvir_vsl_srf_3 = CMF_RF(Zvir_vsl_srf_3,1,1000,0,RF_Zth_vsl_srf_vir_0.w);

RF_Zth_vsl_srf_vir_0 = FN_RF_Zth_vsl_srf(MMCstr,G_vsl_srf_vir_0);

RF_Zvir_vsl_srf_1 = FN_RF_Zvir_vsl_srf(MMCstr,G_vsl_srf_vir_0,filtro_vsl_vir_srf_1);
RF_Zvir_vsl_srf_2 = FN_RF_Zvir_vsl_srf(MMCstr,G_vsl_srf_vir_0,filtro_vsl_vir_srf_2);
RF_Zvir_vsl_srf_3 = FN_RF_Zvir_vsl_srf(MMCstr,G_vsl_srf_vir_0,filtro_vsl_vir_srf_3);

RF_Zeq_vsl_srf_1 = CMF_SUM_TABLE_RF_DQ(RF_Zvir_vsl_srf_1,RF_Zth_vsl_srf_vir_0);
RF_Zeq_vsl_srf_2 = CMF_SUM_TABLE_RF_DQ(RF_Zvir_vsl_srf_2,RF_Zth_vsl_srf_vir_0);
RF_Zeq_vsl_srf_3 = CMF_SUM_TABLE_RF_DQ(RF_Zvir_vsl_srf_3,RF_Zth_vsl_srf_vir_0);





%% Gráfico dd:  Frequency response of the SRF single-loop voltage-controlled MMC with vrtual impedance
[H,gcaMag,gcaPhi,yT,xB,yB] =...
CMF_plot_RF(RF_Zth_vsl_srf_vir_0.f,RF_Zth_vsl_srf_vir_0.Mag_dd,RF_Zth_vsl_srf_vir_0.Phi_dd,'', ...
            RF_Zeq_vsl_srf_1.f,RF_Zeq_vsl_srf_1.Mag_dd,RF_Zeq_vsl_srf_1.Phi_dd,'--', ...
            RF_Zeq_vsl_srf_2.f,RF_Zeq_vsl_srf_2.Mag_dd,RF_Zeq_vsl_srf_2.Phi_dd,':', ...
            RF_Zeq_vsl_srf_3.f,RF_Zeq_vsl_srf_3.Mag_dd,RF_Zeq_vsl_srf_3.Phi_dd,'k-.');
        
set(gcaMag,'YLim',[-35 55],'YTick',[-30 -15 0 15 30 45 55],'YTickLabel',{-30 -15 0 15 30 45 '^'});

hp = patch(gcaMag,[50 50 70 70],[-35 65 65 -35],'k',...
    'facecolor','r','edgecolor','r','FaceAlpha',0.1,'EdgeAlpha',0.1) ;
hp = patch(gcaPhi,[50 50 70 70],[-200 200 200 -200],'k',...
    'facecolor','r','edgecolor','r','FaceAlpha',0.1,'EdgeAlpha',0.1) ;

leg = legend(gcaMag.Children([end end-1 end-2 end-3]),...
                    '$Z_{sl,th}^{dq0}$',...
                    '$Z_{sl,th}^{dq0} + Z_{sl,vir}^{dq0}$: $f_c = 100Hz$',...
                    '$Z_{sl,th}^{dq0} + Z_{sl,vir}^{dq0}$: $f_c = 500Hz$',...
                    '$Z_{sl,th}^{dq0} + Z_{sl,vir}^{dq0}$: $f_c = 1000Hz$',...
                    'Location', 'northwest','FontName','calibri');
leg.FontSize = 20;
leg.Interpreter = 'latex';

%CMF_Anota_Plot90(gcaMag,[60 -95]);
te =text(0.53,-270,'(a)','FontSize',32)

% export_fig 'figs/Tese/SRF_vir/SRF_vir_CTRL_V_RF_dd' '-png' -transparent -painters -r200 


%% Gráfico dq:  Frequency response of the SRF single-loop voltage-controlled MMC with vrtual impedance
[H,gcaMag,gcaPhi,yT,xB,yB] =...
CMF_plot_RF(RF_Zth_vsl_srf_vir_0.f,RF_Zth_vsl_srf_vir_0.Mag_dq,RF_Zth_vsl_srf_vir_0.Phi_dq,'', ...
            RF_Zeq_vsl_srf_1.f,RF_Zeq_vsl_srf_1.Mag_dq,RF_Zeq_vsl_srf_1.Phi_dq,'--', ...
            RF_Zeq_vsl_srf_2.f,RF_Zeq_vsl_srf_2.Mag_dq,RF_Zeq_vsl_srf_2.Phi_dq,':', ...
            RF_Zeq_vsl_srf_3.f,RF_Zeq_vsl_srf_3.Mag_dq,RF_Zeq_vsl_srf_3.Phi_dq,'k-.');
        
set(gcaMag,'YLim',[-135 45],'YTick',[-120 -80 -40 0 40 45],'YTickLabel',{-120 -80 -40 0 40 '^'});

hp = patch(gcaMag,[50 50 70 70],[-135 65 65 -135],'k',...
    'facecolor','r','edgecolor','r','FaceAlpha',0.1,'EdgeAlpha',0.1) ;
hp = patch(gcaPhi,[50 50 70 70],[-200 200 200 -200],'k',...
    'facecolor','r','edgecolor','r','FaceAlpha',0.1,'EdgeAlpha',0.1) ;

leg = legend(gcaMag.Children([end end-1 end-2 end-3]),...
                    '$Z_{sl,th}^{dq0}$',...
                    '$Z_{sl,th}^{dq0} + Z_{sl,vir}^{dq0}$: $f_c = 100Hz$',...
                    '$Z_{sl,th}^{dq0} + Z_{sl,vir}^{dq0}$: $f_c = 500Hz$',...
                    '$Z_{sl,th}^{dq0} + Z_{sl,vir}^{dq0}$: $f_c = 1000Hz$',...
                    'Location', 'northwest','FontName','calibri');
leg.FontSize = 20;
leg.Interpreter = 'latex';

%CMF_Anota_Plot90(gcaMag,[60 -95]);
te =text(0.53,-270,'(b)','FontSize',32)

%export_fig 'figs/Tese/SRF_vir/SRF_vir_CTRL_V_RF_dq' '-png' -transparent -painters -r200 







%% Simulation results for the virtual impedance approach for the SRF single-loop voltage-controlled MMC with virtual impedance

SRF_vir_CTRL_V_wv = readtable('Dados/psim_vir/SRF_CTRL_V_wv.csv');
SRF_vir_CTRL_V_vir_100HZ = readtable('Dados/psim_vir/SRF_CTRL_V_vir_100Hz.csv');
SRF_vir_CTRL_V_vir_500HZ = readtable('Dados/psim_vir/SRF_CTRL_V_vir_500Hz.csv');
SRF_vir_CTRL_V_vir_1000HZ = readtable('Dados/psim_vir/SRF_CTRL_V_vir_1000Hz.csv');



CMF_Plot3_pertuba(SRF_vir_CTRL_V_wv.Time, ...
                  SRF_vir_CTRL_V_wv.ioa, ...
                  SRF_vir_CTRL_V_wv.iob, ...
                  SRF_vir_CTRL_V_wv.ioc, ...
                  Iaacbse, 1.5, 'Current');
              te =text(1.465,-1.5,'(c)','FontSize',32)
% export_fig 'figs/Tese/SRF_vir/SRF_vir_CTRL_V_iabc' '-png' -transparent -painters -r200

CMF_Plot3_pertuba(SRF_vir_CTRL_V_wv.Time, ...
                  SRF_vir_CTRL_V_wv.va, ...
                  SRF_vir_CTRL_V_wv.vb, ...
                  SRF_vir_CTRL_V_wv.vc, ...
                  Vacbase, 1.5, 'Voltage');
              te =text(1.465,-1.5,'(d)','FontSize',32)
% export_fig 'figs/Tese/SRF_vir/SRF_vir_CTRL_V_vabc_wv' '-png' -transparent -painters -r200    

CMF_Plot3_pertuba(SRF_vir_CTRL_V_vir_100HZ.Time, ...
                  SRF_vir_CTRL_V_vir_100HZ.va, ...
                  SRF_vir_CTRL_V_vir_100HZ.vb, ...
                  SRF_vir_CTRL_V_vir_100HZ.vc, ...
                  Vacbase, 1.5, 'Voltage');
              te =text(1.465,-1.5,'(e)','FontSize',32)
% export_fig 'figs/Tese/SRF_vir/SRF_vir_CTRL_V_vabc_vir_100Hz' '-png' -transparent -painters -r200   

CMF_Plot3_pertuba(SRF_vir_CTRL_V_vir_500HZ.Time, ...
                  SRF_vir_CTRL_V_vir_500HZ.va, ...
                  SRF_vir_CTRL_V_vir_500HZ.vb, ...
                  SRF_vir_CTRL_V_vir_500HZ.vc, ...
                  Vacbase, 1.5, 'Voltage');
              te =text(1.465,-1.5,'(f)','FontSize',32)
% export_fig 'figs/Tese/SRF_vir/SRF_vir_CTRL_V_vabc_vir_500Hz' '-png' -transparent -painters -r200  

CMF_Plot3_pertuba(SRF_vir_CTRL_V_vir_1000HZ.Time, ...
                  SRF_vir_CTRL_V_vir_1000HZ.va, ...
                  SRF_vir_CTRL_V_vir_1000HZ.vb, ...
                  SRF_vir_CTRL_V_vir_1000HZ.vc, ...
                  Vacbase, 1.5, 'Voltage');
              te =text(1.465,-1.5,'(g)','FontSize',32)
% export_fig 'figs/Tese/SRF_vir/SRF_vir_CTRL_V_vabc_vir_1000Hz' '-png' -transparent -painters -r200   







%% Frequency response of the SRF double-loop voltage-controlled MMC with vrtual impedance

filtro_vdl_vir_srf_1 = Glpf(2*pi*100);
filtro_vdl_vir_srf_2 = Glpf(2*pi*500);
filtro_vdl_vir_srf_3 = Glpf(2*pi*1000);


Zvir_vdl_srf_1 = Zvir_dl(G_idl_srf_0,G_vdl_srf_0,filtro_vdl_vir_srf_1);
Zvir_vdl_srf_2 = Zvir_dl(G_idl_srf_0,G_vdl_srf_0,filtro_vdl_vir_srf_2);
Zvir_vdl_srf_3 = Zvir_dl(G_idl_srf_0,G_vdl_srf_0,filtro_vdl_vir_srf_3);


% Zeq_vdl_srf_1 = + Zvir_vdl_srf_1; % + Zth_vdl_srf_0; 
% Zeq_vdl_srf_2 = + Zvir_vdl_srf_2; % + Zth_vdl_srf_0;
% Zeq_vdl_srf_3 = + Zvir_vdl_srf_3; % + Zth_vdl_srf_0; 

% RF_Zvir_vdl_srf_1 = CMF_RF(Zvir_vdl_srf_1,1,1000,0,RF_Zth_vdl_srf_0.w);
% RF_Zvir_vdl_srf_2 = CMF_RF(Zvir_vdl_srf_2,1,1000,0,RF_Zth_vdl_srf_0.w);
% RF_Zvir_vdl_srf_3 = CMF_RF(Zvir_vdl_srf_3,1,1000,0,RF_Zth_vdl_srf_0.w);


RF_Zth_vdl_srf_vir_0 = FN_RF_Zth_vdl_srf(MMCstr,G_idl_srf_0,G_vdl_srf_0);

RF_Zvir_vdl_srf_1 = FN_RF_Zvir_vdl_srf(MMCstr,G_idl_srf_0,G_vdl_srf_0,filtro_vdl_vir_srf_1);
RF_Zvir_vdl_srf_2 = FN_RF_Zvir_vdl_srf(MMCstr,G_idl_srf_0,G_vdl_srf_0,filtro_vdl_vir_srf_2);
RF_Zvir_vdl_srf_3 = FN_RF_Zvir_vdl_srf(MMCstr,G_idl_srf_0,G_vdl_srf_0,filtro_vdl_vir_srf_3);


RF_Zeq_vdl_srf_1 = CMF_SUM_TABLE_RF_DQ(RF_Zvir_vdl_srf_1,RF_Zth_vdl_srf_vir_0);
RF_Zeq_vdl_srf_2 = CMF_SUM_TABLE_RF_DQ(RF_Zvir_vdl_srf_2,RF_Zth_vdl_srf_vir_0);
RF_Zeq_vdl_srf_3 = CMF_SUM_TABLE_RF_DQ(RF_Zvir_vdl_srf_3,RF_Zth_vdl_srf_vir_0);


% Zvir_dl = @(Gidq,Gvdqdl,Gfiltro)
% Zth_vdl_srf_0



%% gráfico dd:  Frequency response of the SRF double-loop voltage-controlled MMC with vrtual impedance
[H,gcaMag,gcaPhi,yT,xB,yB] =...
CMF_plot_RF(RF_Zth_vdl_srf_0.f,RF_Zth_vdl_srf_0.Mag_dd,RF_Zth_vdl_srf_0.Phi_dd,'', ...
            RF_Zeq_vdl_srf_1.f,RF_Zeq_vdl_srf_1.Mag_dd,RF_Zeq_vdl_srf_1.Phi_dd,'--', ...
            RF_Zeq_vdl_srf_2.f,RF_Zeq_vdl_srf_2.Mag_dd,RF_Zeq_vdl_srf_2.Phi_dd,':', ...
            RF_Zeq_vdl_srf_3.f,RF_Zeq_vdl_srf_3.Mag_dd,RF_Zeq_vdl_srf_3.Phi_dd,'k-.');

set(gcaMag,'YLim',[-50 50],'YTick',[-40 -20 0 20 40 50],'YTickLabel',{-40 -20 0 20 40 '^'});



hp = patch(gcaMag,[50 50 70 70],[-50 50 50 -50],'k',...
    'facecolor','r','edgecolor','r','FaceAlpha',0.1,'EdgeAlpha',0.1) ;


hp = patch(gcaPhi,[50 50 70 70],[-200 200 200 -200],'k',...
    'facecolor','r','edgecolor','r','FaceAlpha',0.1,'EdgeAlpha',0.1) ;


leg = legend(gcaPhi.Children([end end-1 end-2 end-3]),...
                    '$Z_{dl,th}^{dq0}$',...
                    '$Z_{dl,th}^{dq0} + Z_{dl,vir}^{dq0}$: $f_c = 100Hz$',...
                    '$Z_{dl,th}^{dq0} + Z_{dl,vir}^{dq0}$: $f_c = 500Hz$',...
                    '$Z_{dl,th}^{dq0} + Z_{dl,vir}^{dq0}$: $f_c = 1000Hz$',...
                    'Location', 'southwest','FontName','calibri');
leg.FontSize = 20;
leg.Interpreter = 'latex';

%CMF_Anota_Plot90(gcaMag,[60 -95]);
te =text(0.53,-270,'(a)','FontSize',32)

%export_fig 'figs/Tese/SRF_vir/SRF_vir_CTRL_VI_RF_dd' '-png' -transparent -painters -r200  


%% gráfico dq:  Frequency response of the SRF double-loop voltage-controlled MMC with virtual impedance
[H,gcaMag,gcaPhi,yT,xB,yB] =...
CMF_plot_RF(RF_Zth_vdl_srf_0.f,RF_Zth_vdl_srf_0.Mag_dq,RF_Zth_vdl_srf_0.Phi_dq,'', ...
            RF_Zeq_vdl_srf_1.f,RF_Zeq_vdl_srf_1.Mag_dq,RF_Zeq_vdl_srf_1.Phi_dq,'--', ...
            RF_Zeq_vdl_srf_2.f,RF_Zeq_vdl_srf_2.Mag_dq,RF_Zeq_vdl_srf_2.Phi_dq,':', ...
            RF_Zeq_vdl_srf_3.f,RF_Zeq_vdl_srf_3.Mag_dq,RF_Zeq_vdl_srf_3.Phi_dq,'k-.');

set(gcaMag,'YLim',[-70 35],'YTick',[-50 -25 0 25 35],'YTickLabel',{-50 -25 0 25 '^'});



hp = patch(gcaMag,[50 50 70 70],[-70 35 35 -70],'k',...
    'facecolor','r','edgecolor','r','FaceAlpha',0.1,'EdgeAlpha',0.1) ;


hp = patch(gcaPhi,[50 50 70 70],[-200 200 200 -200],'k',...
    'facecolor','r','edgecolor','r','FaceAlpha',0.1,'EdgeAlpha',0.1) ;


leg = legend(gcaPhi.Children([end end-1 end-2 end-3]),...
                    '$Z_{dl,th}^{dq0}$',...
                    '$Z_{dl,th}^{dq0} + Z_{dl,vir}^{dq0}$: $f_c = 100Hz$',...
                    '$Z_{dl,th}^{dq0} + Z_{dl,vir}^{dq0}$: $f_c = 500Hz$',...
                    '$Z_{dl,th}^{dq0} + Z_{dl,vir}^{dq0}$: $f_c = 1000Hz$',...
                    'Location', 'southwest','FontName','calibri');
leg.FontSize = 20;
leg.Interpreter = 'latex';

%CMF_Anota_Plot90(gcaMag,[60 -95]);
te =text(0.53,-270,'(b)','FontSize',32)

% export_fig 'figs/Tese/SRF_vir/SRF_vir_CTRL_VI_RF_dq' '-png' -transparent -painters -r200  



%% Simulation results for the virtual impedance approach for the SRF double-loop voltage-controlled MMC with virtual impedance

SRF_vir_CTRL_VI_wv = readtable('Dados/psim_vir/SRF_CTRL_VI_wv.csv');
SRF_vir_CTRL_VI_vir_100HZ = readtable('Dados/psim_vir/SRF_CTRL_VI_vir_100Hz.csv');
SRF_vir_CTRL_VI_vir_500HZ = readtable('Dados/psim_vir/SRF_CTRL_VI_vir_500Hz.csv');
SRF_vir_CTRL_VI_vir_1000HZ = readtable('Dados/psim_vir/SRF_CTRL_VI_vir_1000Hz.csv');



CMF_Plot3_pertuba(SRF_vir_CTRL_VI_wv.Time, ...
                  SRF_vir_CTRL_VI_wv.ioa, ...
                  SRF_vir_CTRL_VI_wv.iob, ...
                  SRF_vir_CTRL_VI_wv.ioc, ...
                  Iaacbse, 1.5, 'Current');
              te =text(1.465,-1.5,'(c)','FontSize',32)
% export_fig 'figs/Tese/SRF_vir/SRF_vir_CTRL_VI_iabc' '-png' -transparent -painters -r200

CMF_Plot3_pertuba(SRF_vir_CTRL_VI_wv.Time, ...
                  SRF_vir_CTRL_VI_wv.va, ...
                  SRF_vir_CTRL_VI_wv.vb, ...
                  SRF_vir_CTRL_VI_wv.vc, ...
                  Vacbase, 1.5, 'Voltage');
              te =text(1.465,-1.5,'(d)','FontSize',32)
% export_fig 'figs/Tese/SRF_vir/SRF_vir_CTRL_VI_vabc_wv' '-png' -transparent -painters -r200    

CMF_Plot3_pertuba(SRF_vir_CTRL_VI_vir_100HZ.Time, ...
                  SRF_vir_CTRL_VI_vir_100HZ.va, ...
                  SRF_vir_CTRL_VI_vir_100HZ.vb, ...
                  SRF_vir_CTRL_VI_vir_100HZ.vc, ...
                  Vacbase, 1.5, 'Voltage');
              te =text(1.465,-1.5,'(e)','FontSize',32)
% export_fig 'figs/Tese/SRF_vir/SRF_vir_CTRL_VI_vabc_vir_100Hz' '-png' -transparent -painters -r200   

CMF_Plot3_pertuba(SRF_vir_CTRL_VI_vir_500HZ.Time, ...
                  SRF_vir_CTRL_VI_vir_500HZ.va, ...
                  SRF_vir_CTRL_VI_vir_500HZ.vb, ...
                  SRF_vir_CTRL_VI_vir_500HZ.vc, ...
                  Vacbase, 1.5, 'Voltage');
              te =text(1.465,-1.5,'(f)','FontSize',32)
%  export_fig 'figs/Tese/SRF_vir/SRF_vir_CTRL_VI_vabc_vir_500Hz' '-png' -transparent -painters -r200  

CMF_Plot3_pertuba(SRF_vir_CTRL_VI_vir_1000HZ.Time, ...
                  SRF_vir_CTRL_VI_vir_1000HZ.va, ...
                  SRF_vir_CTRL_VI_vir_1000HZ.vb, ...
                  SRF_vir_CTRL_VI_vir_1000HZ.vc, ...
                  Vacbase, 1.5, 'Voltage');
              te =text(1.465,-1.5,'(g)','FontSize',32)
% export_fig 'figs/Tese/SRF_vir/SRF_vir_CTRL_VI_vabc_vir_1000Hz' '-png' -transparent -painters -r200   










%% Testes
Ycateste = (Yac_srf(Gdq0(GPI(0.001,0.1))));
Yvirteste = Yvir_srf(Gdq0(GPI(0.001,0.1)),Ghpf(0));
Yeqteste = Ycateste+Yvirteste;

teste = CMF_RF(Yeqteste,1,1000,0);
teste2 = CMF_RF(Ycateste,1,1000,0);


%CMF_plot_RF(teste.f,teste.Mag_dd,teste.Phi_dd,'',teste2.f,teste2.Mag_dd,teste2.Phi_dd,'r--')


Ydcteste_1 = (Ydc_srf(Gdq0(GPI(0.01,0.1))));
Ydcteste_2 = (Ydc_srf(Gdq0(GPI(0.1,0.1))));
testedc_1 = CMF_RF(Ydcteste_1,1,1000,0);
testedc_2 = CMF_RF(Ydcteste_2,1,1000,0);

%CMF_plot_RF(testedc_1.f,testedc_1.Mag_dd,testedc_1.Phi_dd,'',testedc_2.f,testedc_2.Mag_dd,testedc_2.Phi_dd,'')

%% teste tempo
t = 0:1e-5:0.1;
y1 = sin(2*pi*60.*t);
y2 = sin(2*pi*60.*t) + 0.1.*sin(-5*2*pi*60.*t);
y3 = sin(2*pi*60.*t) + 0.1.*sin(-5*2*pi*60.*t) + 0.05.*sin(7*2*pi*60.*t);

%CMF_plot_TIME3(t,y1,'',t,y2,'',t,y3,'');