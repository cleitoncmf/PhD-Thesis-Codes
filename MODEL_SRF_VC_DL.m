function Model = MODEL_SRF_VC_DL(MMC,Cv_dl,Ci_dl)
    % Model for the Voltage-COntrolled, Single-loop MMC
    % MMC -> Structure with the MMC's parameters
    % CTRL -> Structure with the control parameters

    % Definitions
    I = eye(3);                         % Identity matrix
    s = tf('s');                        % Complex frequency
    Ceq = MMC.C/MMC.N;                  % Equivalent capacitance
    
    
    %Z = MMC.L*s + MMC.R;                % Inner Impedance
    %Zf = MMC.Lf*s + MMC.Rf;             % Outer Impedance
    W = [0 -MMC.w0 0;MMC.w0 0 0;0 0 0]; % Coupling Matrix
    sdq = W + s.*I;                     % Matrix frequency
    Zdq = MMC.R*I + MMC.L*sdq; % Inner Impedance
    Zfdq = MMC.Rf*I + MMC.Lf*sdq; % Outer Impedance
        
    Cv_dq = [Cv_dl 0 0;0 Cv_dl 0;0 0 0];% Voltage Controller
    Ci_dq = [Ci_dl 0 0;0 Ci_dl 0;0 0 0];% Current Controller
    
    % Some ajustments to fit in the screem
    Vdc0 = MMC.Vdc0;   
    SN = MMC.SN;  
    Cf = MMC.Cf;
    
    % Model:
    % It is computed in different ways to show the numeric
    % effects of different implementations
    
    InnerCurrent = MODEL_SRF_IC(MMC,Ci_dl);    
    Y_N = InnerCurrent.Y_norton_2; % Norton admitance (inner loop)
    Gi_cl = InnerCurrent.Gi_cl_2; % Closed-loop TF (inner loop) 
    
    
    
    % Gcharv = minreal(Gnorton*Gvdq + Yac);
    Y_in = Gi_cl*Cv_dq + Y_N;
    Z_in = Y_in\I;
    
    
    
    
    % %charV = I + Cf*Gcharvinv*sdq; % matlab acusa erro (não consegue calcular coisas tão grandes)
% charV2 = I + Cf*Gcharvinv2*sdq;
    Gamma_out = I + (Cf*Z_in)*sdq;
    Gamma_out_2 = minreal(Gamma_out);
    Gamma_out_3 = I + Cf*(Y_in\sdq);
    Gamma_out_4 = minreal(Gamma_out_3);
    
    %sys_Gamma_out = ss(Gamma_out);
    %sys_Gamma_out_2 = prescale(sys_Gamma_out,{2*pi,2*pi*1000});
    
    Gamma_out_inv = Gamma_out\I;
    Gamma_out_inv_2 = Gamma_out_2\I;
    Gamma_out_inv_3 = Gamma_out_3\I;
    
    Z_th = Gamma_out_4\Z_in;


% 
% 
% Gcharv = minreal(Gnorton*Gvdq + Yac);
% Gcharv2 = minreal(Gnorton*Gvdq + Yac,0.1); % aproximação boa para o intervalo [1, 1000] Hz
% 
% Gcharvinv = minreal(inv(Gcharv));
% Gcharvinv2 = minreal(inv(Gcharv2),0.1);  % aproximação boa para o intervalo [1, 1000] Hz
% Gcharvinv3 = minreal(inv(Gcharv2),0.03);
% 
% 
% %charV = I + Cf*Gcharvinv*sdq; % matlab acusa erro (não consegue calcular coisas tão grandes)
% charV2 = I + Cf*Gcharvinv2*sdq;
% 
% %charVinv = inv(minreal(charV,0.2));
% charVinv2 = inv(charV2);
% 
% 
% 
% Zth2 = charVinv2*Gcharvinv2;
% Zth3 = charV2\Gcharvinv3;
% 
% 
% Gth2 = (Zth3*Gnorton*Gvdq);
    
    
    % Output structure
    Model = struct('Y_norton',Y_N,...
                   'Gi_cl',Gi_cl,...
                   'Y_in',Y_in,...
                   'Z_in',Z_in,...
                   'Gamma_out',Gamma_out,...
                   'Gamma_out_2',Gamma_out_2,...
                   'Gamma_out_3',Gamma_out_3,...
                   'Gamma_out_4',Gamma_out_4,...
                   'Gamma_out_inv',Gamma_out_inv,...
                   'Gamma_out_inv_2',Gamma_out_inv_2,...
                   'Gamma_out_inv_3',Gamma_out_inv_3,...
                   'Z_th',Z_th...
                   );

end