function Model = MODEL_SRF_VC_DL(MMC,Cv_dl,Ci_dl)
    % Model for the Voltage-COntrolled, Single-loop MMC
    % MMC -> Structure with the MMC's parameters
    % Ci_dl -> s-domain transfer function (current controller)
    % Cv_dl -> s-domain transfer function (voltage controller)

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
    Y_ac = InnerCurrent.Y_norton_2; % Norton admitance (inner loop)
    Gi_cl = InnerCurrent.Gi_cl_2; % Closed-loop TF (inner loop)   
    
    % Inner Impedance
    Y_in = Gi_cl*Cv_dq + Y_ac;
    Z_in = Y_in\I;
    
    
    Gamma_out =  I + Cf*(Y_in\sdq);
    Gamma_out_2 =  I + minreal(Cf*(Y_in\sdq));
    Gamma_out_3 =  I + minreal(Cf*(Y_in\sdq),0.01);
    Gamma_out_4 =  I + minreal(Cf*(Y_in\sdq),0.025);
    Gamma_out_5 =  I + minreal(Cf*(Y_in\sdq),0.05);
    
    Z_th = Gamma_out\Z_in;
    Z_th_2 = Gamma_out_2\Z_in;
    Z_th_3 = Gamma_out_3\Z_in;
    Z_th_4 = Gamma_out_4\Z_in;
    Z_th_5 = Gamma_out_5\Z_in;
    

    
    % Output structure
    Model = struct('Y_ac',Y_ac,...
                   'Gi_cl',Gi_cl,...
                   'Y_in',Y_in,...
                   'Z_in',Z_in,...
                   'Gamma_out',Gamma_out,...
                   'Gamma_out_2',Gamma_out_2,...
                   'Gamma_out_3',Gamma_out_3,...
                   'Gamma_out_4',Gamma_out_4,...
                   'Gamma_out_5',Gamma_out_5,...
                   'Z_th',Z_th,...
                   'Z_th_2',Z_th_2,...
                   'Z_th_3',Z_th_3,...
                   'Z_th_4',Z_th_4,...
                   'Z_th_5',Z_th_5...
                   );

end