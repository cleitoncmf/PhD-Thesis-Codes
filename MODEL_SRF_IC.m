function Model = MODEL_SRF_IC(MMC,Ci)
    % Model for the Voltage-COntrolled, Single-loop MMC
    % MMC -> Structure with the MMC's parameters
    % CTRL -> Structure with the control parameters

    % Definitions
    I = eye(3);                         % Identity matrix
    s = tf('s');                        % Complex frequency
    Ceq = MMC.C/MMC.N;                  % Equivalent capacitance
       
    Z = MMC.L*s + MMC.R;                % Inner Impedance
    Zf = MMC.Lf*s + MMC.Rf;             % Outer Impedance
    W = [0 -MMC.w0 0;MMC.w0 0 0;0 0 0]; % Coupling Matrix
    sdq = W + s.*I;                     % Matrix frequency
    Zdq = MMC.R*I + MMC.L*sdq; % Inner Impedance
    Zfdq = MMC.Rf*I + MMC.Lf*sdq; % Outer Impedance
       
    % Some ajustments to fit in the screem
    Vdc0 = MMC.Vdc0;   
    SN = MMC.SN;  
    Cf = MMC.Cf;
    
    Ci_dq = [Ci 0 0;0 Ci 0;0 0 0];% Current Controller
    Di_dq = ((MMC.L+2*MMC.Lf)/Vdc0).*W;
    
    % Model:
    % It is computed in different ways to show the numeric
    % effects of different implementations
    Gamma_mid = (4*Vdc0*Ceq.*sdq + (2*SN/(3*Vdc0)).*I)*Ci_dq;
    
    Gamma_i = I + Gamma_mid + 4*Ceq*(Z+2*Zf).*sdq -(2*SN/(3*Vdc0)).*Di_dq;
       
    Y_norton = 8*Ceq.*inv(Gamma_i)*sdq;
    Y_norton_2 = 8*Ceq.*(Gamma_i\sdq);
      
    Gi_cl = inv(Gamma_i)*Gamma_mid; 
    Gi_cl_2 = Gamma_i\Gamma_mid; 
    
    % Output structure
    Model = struct('Di_dq',Di_dq,...
                   'Gamma_i',Gamma_i,...
                   'Gamma_mid',Gamma_mid,...
                   'Y_norton',Y_norton,...
                   'Y_norton_2',Y_norton_2,...
                   'Gi_cl',Gi_cl,...
                   'Gi_cl_2',Gi_cl_2...
                   );

end