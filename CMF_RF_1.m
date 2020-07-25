%% retorna a resposta em frequência de uma função de transferencia H
function Y = CMF_RF_1(H,fmin,fmax)






 [Mag,Phi,w] = bode(H,{fmin*2*pi,fmax*2*pi});
 
 f = w./(2*pi);
 
 Mag = 20.*log10(squeeze(Mag));
 Phi = wrapTo180(squeeze(Phi));
 
 
 Y = table(f,w,Mag,Phi);