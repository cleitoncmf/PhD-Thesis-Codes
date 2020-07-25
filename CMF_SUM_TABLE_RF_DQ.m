%
% É uma função para somar as colunas de duas ou mais tabelas
% É bem simple, ou seja, as tabelas já devem possuir os mesmos comprimetos
function Y = CMF_SUM_TABLE_RF_DQ(varargin)

for n=1:nargin
    if(~any(strcmp('Mag_dd_cplx', varargin{n}.Properties.VariableNames)) |...
       ~any(strcmp('Mag_dq_cplx', varargin{n}.Properties.VariableNames)) |...
       ~any(strcmp('Mag_0_cplx', varargin{n}.Properties.VariableNames)) | ...
       ~any(strcmp('w', varargin{n}.Properties.VariableNames)) | ...
       ~any(strcmp('f', varargin{n}.Properties.VariableNames)))
        error('As tabelas não contem os campos desejados');
    else
        if(n==1)
            Mag_dd_cplx = varargin{1}.Mag_dd_cplx;
            Mag_dq_cplx = varargin{1}.Mag_dq_cplx;
            Mag_0_cplx = varargin{1}.Mag_0_cplx;
            
            w = varargin{1}.w;
            f = varargin{1}.f;
        else
            Mag_dd_cplx = Mag_dd_cplx +  varargin{n}.Mag_dd_cplx;
            Mag_dq_cplx = Mag_dq_cplx +  varargin{n}.Mag_dq_cplx;
            Mag_0_cplx = Mag_0_cplx +  varargin{n}.Mag_0_cplx;
        end
    end    
end


Mag_dd = 20.*log10(abs(Mag_dd_cplx));
Mag_dq = 20.*log10(abs(Mag_dq_cplx));
Mag_0 = 20.*log10(abs(Mag_0_cplx));



Phi_dd = wrapTo180(rad2deg(angle(Mag_dd_cplx)));
Phi_dq = wrapTo180(rad2deg(angle(Mag_dq_cplx)));
Phi_0 = wrapTo180(rad2deg(angle(Mag_0_cplx)));


Y = table(f,w,Mag_dd,Phi_dd,Mag_dd_cplx,Mag_dq,Phi_dq,Mag_dq_cplx,Mag_0,Phi_0,Mag_0_cplx);


end