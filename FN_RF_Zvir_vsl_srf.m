
function Y = FN_RF_Zvir_vsl_srf(MMC_structure,Gvdqsl,Gfiltro)



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

% Vetor de frequencias
w = [60:60:1000];
w = (union(union(w,1:1:100),100:5:1000).*2*pi)';



% Gamma_vsl_in_srf
Gamma_vsl_in_srf = 4*Ceq*sdq*(Zdq+2*Zfdq) + I;
%H_Gamma_vsl_in_srf = freqresp(Gamma_vsl_in_srf,w);

% Z_vsl_in_srf
Z_vsl_in_srf = inv((4*Vdc0*Ceq*sdq + I*2*SN/(3*Vdc0))*Gvdqsl + 8*Ceq*sdq);
%H_Z_vsl_in_srf = freqresp(Z_vsl_in_srf,w);

%Gamma_vsl_out_srf
Gamma_vsl_out_srf = Cf*Z_vsl_in_srf*Gamma_vsl_in_srf*sdq + I;
%H_Gamma_vsl_out_srf = freqresp(Gamma_vsl_out_srf,w);

%Gamma_vsl_out_inv_srf
Gamma_vsl_out_inv_srf = inv(Gamma_vsl_out_srf);
H_Gamma_vsl_out_inv_srf = freqresp(Gamma_vsl_out_inv_srf,w);


%Lambda_vsl_srf
Lambda_vsl_srf =  (((R+2*Rf) + (L+2*Lf)*s*Gfiltro)*I + (L+2*Lf)*W)*(1/Vdc0);


%Zvir_sl_part1
Zvir_sl_part1 = Z_vsl_in_srf*(4*Vdc0*Ceq*sdq + I*2*SN/(3*Vdc0))*Lambda_vsl_srf;
H_Zvir_sl_part1 = freqresp(Zvir_sl_part1,w);


%Zvir_sl = @(Gvdqsl,Gfiltro) minreal(minreal(Gamma_vsl_out_inv_srf(Gvdqsl)*Z_vsl_in_srf(Gvdqsl))*(4*Vdc0*Ceq*sdq + I*2*SN/(3*Vdc0))*Lambda_vsl_srf(Gfiltro));
H_Zvir_sl = -H_Gamma_vsl_out_inv_srf.*H_Zvir_sl_part1;






% pós processamento
f = w./(2*pi);

Mag_dd_cplx = zeros(size(f));
Mag_dq_cplx = zeros(size(f));
Mag_qd_cplx = zeros(size(f));
Mag_qq_cplx = zeros(size(f));
Mag_0_cplx = zeros(size(f));

for k=1:length(w)
    Mag_dd_cplx(k) = H_Zvir_sl(1,1,k);
    Mag_dq_cplx(k) = H_Zvir_sl(1,2,k);
    Mag_qd_cplx(k) = H_Zvir_sl(2,1,k);
    Mag_qq_cplx(k) = H_Zvir_sl(2,2,k);
    Mag_0_cplx(k) = H_Zvir_sl(3,3,k);
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
