
% % MMC controllado por malha dupla de tensão em SRF
% Gcharv_srf = @(Gidq,Gvdq) minreal(Gnorton_srf(Gidq)*Gvdq + Yac_srf(Gidq));
% Gcharv2_srf = @(Gidq,Gvdq) minreal(Gnorton_srf(Gidq)*Gvdq + Yac_srf(Gidq),0.1); % aproximação boa para o intervalo [1, 1000] Hz
% Gcharvinv_srf = @(Gidq,Gvdq) minreal(inv(Gcharv_srf(Gidq,Gvdq)));
% Gcharvinv2_srf = @(Gidq,Gvdq) minreal(inv(Gcharv2_srf(Gidq,Gvdq)),0.1);  % aproximação boa para o intervalo [1, 1000] Hz
% Gcharvinv3_srf = @(Gidq,Gvdq) minreal(inv(Gcharv2_srf(Gidq,Gvdq)),0.03);
% charV_srf = @(Gidq,Gvdq) I + Cf*Gcharvinv_srf(Gidq,Gvdq)*sdq; % matlab acusa erro (não consegue calcular coisas tão grandes)
% charV2_srf = @(Gidq,Gvdq) I + Cf*Gcharvinv2_srf(Gidq,Gvdq)*sdq;
% charVinv_srf = @(Gidq,Gvdq) inv(minreal(charV_srf(Gidq,Gvdq),0.2));
% charVinv2_srf = @(Gidq,Gvdq) inv(charV2_srf(Gidq,Gvdq));
% Zth2_srf = @(Gidq,Gvdq) charVinv2_srf(Gidq,Gvdq)*Gcharvinv2_srf(Gidq,Gvdq);
% Zth3_srf = @(Gidq,Gvdq) charV2_srf(Gidq,Gvdq)\Gcharvinv3_srf(Gidq,Gvdq);
% Gth2_srf = @(Gidq,Gvdq) (minreal(Zth3_srf(Gidq,Gvdq),0.0001)*minreal(minreal(Gnorton_srf(Gidq))*Gvdq,0.001)); % não tá com a a proximação usada no capítulo anterior
% 
% % Impedancia virtual do MMC controlado por malha dupla de tensão em SRF
% Lambda_vdl_srf = @(Gidq,Gfiltro) ((R+2*Rf) + (L+2*Lf)*s*Gfiltro)*I*(1/Vdc0) + Gidq;
% Gamma_vir_sl = @(Gidq,Gvdqdl,Gfiltro) -minreal(inv(Gchar_srf(Gidq)))*(4*Vdc0*Ceq.*sdq + (2*SN/(3*Vdc0)).*I)*Lambda_vdl_srf(Gidq,Gfiltro);
% %Zvir_dl = @(Gidq,Gvdqdl,Gfiltro)minreal(charVinv2_srf(Gidq,Gvdqdl)*minreal(Gcharvinv2_srf(Gidq,Gvdqdl)*Gamma_vir_sl(Gidq,Gvdqdl,Gfiltro),0.0005),0.04);
% Gcharvinv3_vir_srf = @(Gidq,Gvdq) minreal(inv(Gcharv2_srf(Gidq,Gvdq)),0.065); %mesma coisa do Gcharvinv3_srf, mas com uma precisão melhor  
% Zvir_dl = @(Gidq,Gvdqdl,Gfiltro)minreal(charVinv2_srf(Gidq,Gvdqdl)*minreal(Gcharvinv3_vir_srf(Gidq,Gvdqdl)*Gamma_vir_sl(Gidq,Gvdqdl,Gfiltro)),0.0004);

% % MMC controllado por corrente em SRF
% Didq_srf = ((L+2*Lf)/Vdc0).*W;
% Gchar_srf =@(Gidq) I + (4*Vdc0*Ceq.*sdq + (2*SN/(3*Vdc0)).*I)*Gidq + 4*Ceq*(Z+2*Zf).*sdq -(2*SN/(3*Vdc0)).*Didq_srf;
% Yac_srf = @(Gidq) 8*Ceq.*minreal(inv(Gchar_srf(Gidq)))*sdq;
% Gnorton_srf = @(Gidq) minreal(inv(Gchar_srf(Gidq)))*(4*Vdc0*Ceq.*sdq + (2*SN/(3*Vdc0)).*I)*Gidq; % este é o Gicl


function Y = FN_RF_Zvir_vdl_srf(MMC_structure,Gidq,Gvdqdl,Gfiltro)





% Dados
L = MMC_structure.L;
Lf = MMC_structure.Lf;
R = MMC_structure.R;
Rf = MMC_structure.Rf;
Cf = MMC_structure.Cf;
Vdc0 = MMC_structure.Vdc0;
C = MMC_structure.C;
N = MMC_structure.N;
SN = MMC_structure.SN;
w0 = MMC_structure.w0;
Ceq = C/N;


% Definitions
s = tf('s');
I = eye(3);
W = [0 -w0 0;w0 0 0;0 0 0];
sdq = W + s.*I;
s2dq = 2.*W + s.*I;
Zdq = L*sdq + R*I;
Zfdq = Lf*sdq + Rf*I;
Z = R + L*s;
Zf = Rf + Lf*s;

% Vetor de frequencias
w = [60:60:1000];
w = (union(union(w,1:1:100),100:5:1000).*2*pi)';



%Didq_srf
Didq_srf = ((L+2*Lf)/Vdc0).*W;

%Gchar_srf
Gchar_srf =I + (4*Vdc0*Ceq.*sdq + (2*SN/(3*Vdc0)).*I)*Gidq + 4*Ceq*(Z+2*Zf).*sdq -(2*SN/(3*Vdc0)).*Didq_srf;

%Yac_srf
Yac_srf = 8*Ceq.*inv(Gchar_srf)*sdq;

%Gnorton_srf
Gnorton_srf = inv(Gchar_srf)*(4*Vdc0*Ceq.*sdq + (2*SN/(3*Vdc0)).*I)*Gidq; % este é o Gicl

%Gcharv_srf
Gcharv_srf = Gnorton_srf*Gvdqdl + Yac_srf;

%Gcharv_srf_inv
Gcharv_srf_inv = minreal(inv(Gcharv_srf),0.02);

%charV_srf
charV_srf = I + Cf*Gcharv_srf_inv*sdq;

%charV_srf_inv
charV_srf_inv = inv(charV_srf);
H_charV_srf_inv = freqresp(charV_srf_inv,w);

%Lambda_vdl_srf
Lambda_vdl_srf = ((R+2*Rf) + (L+2*Lf)*s*Gfiltro)*I*(1/Vdc0) + Gidq;

%Gamma_vir_sl
Gamma_vir_sl =  -inv(Gchar_srf)*(4*Vdc0*Ceq.*sdq + (2*SN/(3*Vdc0)).*I)*Lambda_vdl_srf;

%Zvir_dl charVinv2_srf*Gcharvinv2_srf*Gamma_vir_sl;
Zvir_dl_part1 = Gcharv_srf_inv*Gamma_vir_sl;
H_Zvir_dl_part1 = freqresp(Zvir_dl_part1,w);

%zvir
H_Zvir_dl = H_charV_srf_inv.*H_Zvir_dl_part1;







% pós processamento
f = w./(2*pi);

Mag_dd_cplx = zeros(size(f));
Mag_dq_cplx = zeros(size(f));
Mag_qd_cplx = zeros(size(f));
Mag_qq_cplx = zeros(size(f));
Mag_0_cplx = zeros(size(f));

for k=1:length(w)
    Mag_dd_cplx(k) = H_Zvir_dl(1,1,k);
    Mag_dq_cplx(k) = H_Zvir_dl(1,2,k);
    Mag_qd_cplx(k) = H_Zvir_dl(2,1,k);
    Mag_qq_cplx(k) = H_Zvir_dl(2,2,k);
    Mag_0_cplx(k) = H_Zvir_dl(3,3,k);
end


Mag_dd = 20.*log10(abs(Mag_dd_cplx));
Mag_dq = 20.*log10(abs(Mag_dq_cplx));
Mag_qd = 20.*log10(abs(Mag_qd_cplx));
Mag_qq = 20.*log10(abs(Mag_qq_cplx));
Mag_0 = 20.*log10(abs(Mag_0_cplx));

Phi_dd = wrapTo180(rad2deg(angle(Mag_dd_cplx)));
Phi_dq = wrapTo180(rad2deg(angle(Mag_dq_cplx)));
Phi_qd = wrapTo180(rad2deg(angle(Mag_qd_cplx)));
Phi_qq = wrapTo180(rad2deg(angle(Mag_qq_cplx)));
Phi_0 = wrapTo180(rad2deg(angle(Mag_0_cplx)));

Y = table(f,w,Mag_dd,Phi_dd,Mag_dd_cplx,Mag_dq,Phi_dq,Mag_dq_cplx,Mag_qd,Phi_qd,Mag_qq,Phi_qq,Mag_0,Phi_0,Mag_0_cplx);









end