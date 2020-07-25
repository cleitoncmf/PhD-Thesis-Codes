function Y = FN_RF_Yac_i_srf(MMC_structure,Gidq)



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
%Gnorton_srf = inv(Gchar_srf)*(4*Vdc0*Ceq.*sdq + (2*SN/(3*Vdc0)).*I)*Gidq; % este é o Gicl

%
H_Yac_srf = freqresp(Yac_srf,w);




% pós processamento
f = w./(2*pi);

Mag_dd_cplx = zeros(size(f));
Mag_dq_cplx = zeros(size(f));
Mag_qd_cplx = zeros(size(f));
Mag_qq_cplx = zeros(size(f));
Mag_0_cplx = zeros(size(f));

for k=1:length(w)
    Mag_dd_cplx(k) = H_Yac_srf(1,1,k);
    Mag_dq_cplx(k) = H_Yac_srf(1,2,k);
    Mag_qd_cplx(k) = H_Yac_srf(2,1,k);
    Mag_qq_cplx(k) = H_Yac_srf(2,2,k);
    Mag_0_cplx(k) = H_Yac_srf(3,3,k);
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

