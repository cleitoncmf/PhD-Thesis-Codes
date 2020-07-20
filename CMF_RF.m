%% Função para obter as respostas em frequência de uma matriz de transferencia
% Seja
%     | Mdd  Mdq  0  |
% M = | Mqd  Mqq  0  |
%     |  0    0   M0 |
%
% Sera retornado uma tabela Y
%
% se opt = 1, retornará a tabela completa:
% 
% Y = [ w_dd w_dq w_qd w_qq w_0 Mag_dd Mag_dq Mag_qd Mag_qq Mag_0 Phi_dd Phi_dq Phi_qd Phi_qq Phi_0 ]
%
% Se opt ~=1. retronará a tbela reduzida  
% 
% Y = [ w_dd w_dq w_0 Mag_dd Mag_dq Mag_0 Phi_dd Phi_dq Phi_0 ]
%
% As magnitudes estão em dB e as fases em graus
%
% As colunas das tabelas poderão ser acessades com a notação ponto
%
function Y = CMF_RF(H,fmin,fmax,opt,varargin)

if (size(H,1)~=3 || size(H,2)~=3)
    error('A matriz não é 3 x 3.');
else
    
    if(nargin == 5)
        [Mag_dd,Phi_dd,w_dd] = bode(H(1,1),varargin{1});
        [Mag_dq,Phi_dq,w_dq] = bode(H(1,2),varargin{1});
        [Mag_0,Phi_0,w_0] = bode(H(3,3),varargin{1});
    else
        % É meio idiota o que vou fazer, mas para garantir a melhor precisão
        % vou obter as frequencias utilizadas em todos, formar um vetor com a
        % união destas frequecias e rodar o bode de novo. Assim, um mesmo vetor
        % de frequências será utilizado para todas as respostas
        [Mag_dd,Phi_dd,w_dd] = bode(H(1,1),{fmin*2*pi,fmax*2*pi});
        [Mag_dq,Phi_dq,w_dq] = bode(H(1,2),{fmin*2*pi,fmax*2*pi});
        [Mag_0,Phi_0,w_0] = bode(H(3,3),{fmin*2*pi,fmax*2*pi});
    end
    
   
    
    if(opt~=1)
        % isso daqui dava para ser evitado, mas a falta de paciencia
        % impediu isso
        w = union(union(w_dd,w_dq),w_0);
        
        f = w./(2*pi);
        
        [Mag_dd,Phi_dd] = bode(H(1,1),w); 
        Mag_dd_cplx = squeeze(Mag_dd).*exp(1j.*deg2rad(squeeze(Phi_dd)));
        Mag_dd = 20.*log10(squeeze(Mag_dd));
        Phi_dd = wrapTo180(squeeze(Phi_dd));
        
        
    
        [Mag_dq,Phi_dq] = bode(H(1,2),w);
        Mag_dq_cplx = squeeze(Mag_dq).*exp(1j.*deg2rad(squeeze(Phi_dq)));
        Mag_dq = 20.*log10(squeeze(Mag_dq));
        Phi_dq = wrapTo180(squeeze(Phi_dq));
    
        [Mag_0,Phi_0] = bode(H(3,3),w);
        Mag_0_cplx = squeeze(Mag_0).*exp(1j.*deg2rad(squeeze(Phi_0)));
        Mag_0 = 20.*log10(squeeze(Mag_0));
        Phi_0 = wrapTo180(squeeze(Phi_0));
        
        Y = table(f,w,Mag_dd,Phi_dd,Mag_dd_cplx,Mag_dq,Phi_dq,Mag_dq_cplx,Mag_0,Phi_0,Mag_0_cplx);
    else
        
        [Mag_qq,Phi_qq,w_qq] = bode(H(2,2),{fmin*2*pi,fmax*2*pi});
        
        [Mag_qd,Phi_qd,w_qd] = bode(H(2,1),{fmin*2*pi,fmax*2*pi});
        
        w = union(union(union(w_dd,w_dq),union(w_0, w_qq)), w_qd);
        
        [Mag_dd,Phi_dd] = bode(H(1,1),w);
        Mag_dd = 20.*log10(squeeze(Mag_dd));
        Phi_dd = wrapTo180(squeeze(Phi_dd));
    
        [Mag_dq,Phi_dq] = bode(H(1,2),w);
        Mag_dq = 20.*log10(squeeze(Mag_dq));
        Phi_dq = wrapTo180(squeeze(Phi_dq));
    
        [Mag_0,Phi_0] = bode(H(3,3),w);
        Mag_0 = 20.*log10(squeeze(Mag_0));
        Phi_0 = wrapTo180(squeeze(Phi_0));
        
        [Mag_qq,Phi_qq,w_qq] = bode(H(2,2),w);
        Mag_qq = 20.*log10(squeeze(Mag_qq));
        Phi_qq = wrapTo180(squeeze(Phi_qq));
        
        [Mag_qd,Phi_qd,w_qd] = bode(H(2,1),w);
        Mag_qd = 20.*log10(squeeze(Mag_qd));
        Phi_qd = wrapTo180(squeeze(Phi_qd));
        
        
        f = w./(2*pi);
        
        Y = table(f,w,Mag_dd,Phi_dd,Mag_dq,Phi_dq,Mag_qd,Phi_qd,Mag_qq,Phi_qq,Mag_0,Phi_0);
        
    end
    
   
    
end
