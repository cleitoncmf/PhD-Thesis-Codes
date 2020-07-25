%
% É uma função para somar as colunas de duas ou mais tabelas
% É bem simple, ou seja, as tabelas já devem possuir os mesmos comprimetos
function Y = CMF_SUM_TABLE_RF_1(varargin)

for n=1:nargin
    if(~any(strcmp('Mag_cplx', varargin{n}.Properties.VariableNames)) |...
       ~any(strcmp('w', varargin{n}.Properties.VariableNames)) | ...
       ~any(strcmp('f', varargin{n}.Properties.VariableNames)))
        error('As tabelas não contem os campos desejados');
    else
        if(n==1)
            Mag_cplx = varargin{1}.Mag_cplx;
            
            w = varargin{1}.w;
            f = varargin{1}.f;
        else
            Mag_cplx = Mag_cplx +  varargin{n}.Mag_cplx;
        end
    end    
end


Mag = 20.*log10(abs(Mag_cplx));




Phi = wrapTo180(rad2deg(angle(Mag_cplx)));



Y = table(f,w,Mag,Phi,Mag_cplx);


end