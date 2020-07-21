function Model = MODEL_SRF_VC_SL(MMC,Cv_sl)
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
        
    Cv_dq = [Cv_sl 0 0;0 Cv_sl 0;0 0 0];% Controller
    
    % Some ajustments to fit in the screem
    Vdc0 = MMC.Vdc0;   
    SN = MMC.SN;  
    Cf = MMC.Cf;
    
    % Model:
    % It is computed in different ways to show the numeric
    % effects of different implementations
    Gamma_in = 4*Ceq*sdq*(Zdq+2*Zfdq) + I;
    
    Gamma_mid = (4*Vdc0*Ceq*sdq + I*2*SN/(3*Vdc0))*Cv_dq;
    
    Y_in = Gamma_mid + 8*Ceq*sdq;
    Z_in = inv(Y_in); % Equation (2.69) of the thesis
    
    Gamma_out = Cf*Z_in*Gamma_in*sdq + I;
    Gamma_out_2 = Cf*Z_in*(Gamma_in*sdq) + I;
    Gamma_out_3 = Cf*(Y_in\(Gamma_in*sdq)) + I;
 
    Gamma_out_inv = inv(Gamma_out);
    Gamma_out_inv_2 = inv(Gamma_out_2);
    
    Z_th = Gamma_out_inv*Z_in*Gamma_in;
    Z_th_2 = Gamma_out_inv_2*Z_in*Gamma_in;
    Z_th_3 = Gamma_out_inv_2*(Z_in*Gamma_in);
    Z_th_4 = Gamma_out_2\(Z_in*Gamma_in);
    Z_th_5 = Gamma_out_3\(Y_in\Gamma_in);
  
    G_th = Gamma_out_inv_2*(Z_in*Gamma_mid);
    G_th_2 = Gamma_out_3\(Y_in\Gamma_mid);
    
    % Output structure
    Model = struct('Gamma_in',Gamma_in,...
                   'Gamma_mid',Gamma_mid,...
                   'Y_in',Y_in,...
                   'Z_in',Z_in,...
                   'Gamma_out',Gamma_out,...
                   'Gamma_out_2',Gamma_out_2,...
                   'Gamma_out_3',Gamma_out_3,...
                   'Gamma_out_inv',Gamma_out_inv,...
                   'Gamma_out_inv_2',Gamma_out_inv_2,...
                   'Z_th',Z_th,...
                   'Z_th_2',Z_th_2,...
                   'Z_th_3',Z_th_3,...
                   'Z_th_4',Z_th_4,...
                   'Z_th_5',Z_th_5,...
                   'G_th',G_th,...
                   'G_th_2',G_th_2);

end