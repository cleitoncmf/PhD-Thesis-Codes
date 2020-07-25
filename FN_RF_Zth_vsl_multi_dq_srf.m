function Y = FN_RF_Zth_vsl_multi_dq_srf(MMC_structure,Gvdqsl,G5,G7)

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
% w = [60:60:1000];
% w = (union(union(w,1:1:100),100:5:1000).*2*pi)';
% 
w = ([1:0.1:1000]').*2*pi;

%PHI: já incluindo a seq. zero
PHI = tf([1,1j,0;-1j,1,0;0,0,0]);
PHIT = PHI.';

%Psi
psi5 = (1/2)*CMF_Shift_TF(G5,-6j*w0)*PHI + (1/2)*CMF_Shift_TF(G5,+6j*w0)*PHIT;
psi7 = (1/2)*CMF_Shift_TF(G7,-6j*w0)*PHIT + (1/2)*CMF_Shift_TF(G7,+6j*w0)*PHI;
psi57 = (psi5+psi7);




% Gamma_vsl_in_srf
Gamma_vsl_in_srf = 4*Ceq*sdq*(Zdq+2*Zfdq) + I;
H_Gamma_vsl_in_srf = freqresp(Gamma_vsl_in_srf,w);


% Z_vsl_in_srf
Z_vsl_in_srf = inv((4*Vdc0*Ceq*sdq + I*2*SN/(3*Vdc0))*(Gvdqsl+psi57) + 8*Ceq*sdq);
H_Z_vsl_in_srf = freqresp(Z_vsl_in_srf,w);

%Gamma_vsl_out_srf
Gamma_vsl_out_srf = minreal(Cf*Z_vsl_in_srf*Gamma_vsl_in_srf*sdq + I);
H_Gamma_vsl_out_srf = freqresp(Gamma_vsl_out_srf,w);

%Gamma_vsl_out_inv_srf
%Gamma_vsl_out_inv_srf = [inv(Gamma_vsl_out_srf(1:2,1:2)),[0;0];[0,0,1/Gamma_vsl_out_srf(3,3)]];
% Gamma_vsl_out_inv_srf = inv(Gamma_vsl_out_srf);
% H_Gamma_vsl_out_inv_srf = freqresp(Gamma_vsl_out_inv_srf,w);
H_Gamma_vsl_out_inv_srf = [H_Gamma_vsl_out_srf(1:2,1:2,:).^(-1),zeros(2,1,size(w,1));[zeros(1,2,size(w,1)),1./H_Gamma_vsl_out_srf(3,3,:)]];


%Z_sl_th_1_srf
Z_sl_th_1_srf = Z_vsl_in_srf*Gamma_vsl_in_srf;
H_Z_sl_th_1_srf = freqresp(Z_sl_th_1_srf,w);
%H_Z_sl_th_1_srf = H_Z_vsl_in_srf.*H_Gamma_vsl_in_srf;

%Z_sl_th_srf
H_Z_sl_th_srf = H_Gamma_vsl_out_inv_srf.*H_Z_sl_th_1_srf;
Z_sl_th_srf = Gamma_vsl_out_srf\Z_sl_th_1_srf; 
%H_Z_sl_th_srf = freqresp(Z_sl_th_srf,w);

% função analisada
H = H_Z_sl_th_srf;%freqresp(minreal(Gamma_vsl_out_srf)\Z_sl_th_1_srf);


% pós processamento
f = w./(2*pi);

Mag_dd_cplx = zeros(size(f));
Mag_dq_cplx = zeros(size(f));
Mag_qd_cplx = zeros(size(f));
Mag_qq_cplx = zeros(size(f));
Mag_0_cplx = zeros(size(f));

for k=1:length(w)
    Mag_dd_cplx(k) = H(1,1,k);
    Mag_dq_cplx(k) = H(1,2,k);
    Mag_qd_cplx(k) = H(2,1,k);
    Mag_qq_cplx(k) = H(2,2,k);
    Mag_0_cplx(k) = H(3,3,k);
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









