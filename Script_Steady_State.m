%% Gráficos e testes de regime permanente
clear all
clc



%% Funções para edição de figuras

addpath(genpath('altmany-export_fig-412662f/'));


%% Definitions

phase_a = [0, 0, 150]./256;
phase_b = [0, 180, 0]./256;
phase_c = [231, 13, 17]./256;


%% Variáveis

C = 9000e-6;
N = 20;

Ceq = C/N;

R = 1;
Rf = 1;

L = 19e-3;
Lf = 20e-3;


f = 60;

w = 2*pi*f;



%% Definições extras
Vdc0 = 150e3;


P0 = 100e6;
Q0 = 0;




V0 = 69e3/sqrt(3);
Vdc0 = 150e3;




Snominal = 100e6;
VcaNominal = 69e3;
VdcNominal = 150e3;
IcaNominal = Snominal/(sqrt(3)*VcaNominal);
IccNominal = Snominal/VdcNominal;


IcaNominalPico = IcaNominal*sqrt(2); 

%% Algumas funções

F_I0 = @(P0m,Q0m,V0m) sqrt(P0m.^2 + Q0m.^2)./(3.*V0m);

F_I0s = @(P0m,Q0m,V0m)cos(-atan2(Q0m,P0m)).*F_I0(P0m,Q0m,V0m);
F_I0c = @(P0m,Q0m,V0m)sin(-atan2(Q0m,P0m)).*F_I0(P0m,Q0m,V0m);


F_Icir0 = @(Vdc0m,P0m,I0m,Rm,Rfm) (3.*Vdc0m - sqrt(9.*Vdc0m^2 - 12.*R.*(P0m + 3.*Rfm.*I0m.^2)) )./ (6.*Rm);


F_E0s = @(Vdc0m,V0m,I0m,wm,Lm,Lfm,Rm,Rfm,P0m,Q0m) (sqrt(2)./Vdc0m).*(2*V0m - I0m.*wm.*(2.*Lfm+Lm).*sin(-atan2(Q0m,P0m)) + I0m.*(2.*Rfm+Rm).*cos(-atan2(Q0m,P0m)));
F_E0c = @(Vdc0m,V0m,I0m,wm,Lm,Lfm,Rm,Rfm,P0m,Q0m) (sqrt(2)./Vdc0m).*(I0m.*wm.*(2.*Lfm+Lm).*cos(-atan2(Q0m,P0m)) + I0m.*(2.*Rfm+Rm).*sin(-atan2(Q0m,P0m)));


%% calaculos considerando condição nominal

I0s = F_I0s(P0,Q0,V0)*sqrt(2);
I0c = F_I0c(P0,Q0,V0)*sqrt(2);

I0 =  F_I0(P0,Q0,V0);

E0s = F_E0s(Vdc0,V0,I0,w,L,Lf,R,Rf,P0,Q0);
E0c = F_E0c(Vdc0,V0,I0,w,L,Lf,R,Rf,P0,Q0);

Icir0 = F_Icir0(Vdc0,P0,I0,R,Rf);

%% testes

f_Icir2s(Ceq,R,Rf,L,Lf,w,E0s,E0c,I0s,I0c,Icir0,Vdc0)
f_Icir2c(Ceq,R,Rf,L,Lf,w,E0s,E0c,I0s,I0c,Icir0,Vdc0)

f_Icir4s(Ceq,R,Rf,L,Lf,w,E0s,E0c,I0s,I0c,Icir0,Vdc0)
f_Icir4c(Ceq,R,Rf,L,Lf,w,E0s,E0c,I0s,I0c,Icir0,Vdc0)



f_Vdcn1s(Ceq,R,Rf,L,Lf,w,E0s,E0c,I0s,I0c,Icir0,Vdc0)
f_Vdcn1c(Ceq,R,Rf,L,Lf,w,E0s,E0c,I0s,I0c,Icir0,Vdc0)

f_Vdcn2s(Ceq,R,Rf,L,Lf,w,E0s,E0c,I0s,I0c,Icir0,Vdc0)
f_Vdcn2c(Ceq,R,Rf,L,Lf,w,E0s,E0c,I0s,I0c,Icir0,Vdc0)

f_Vdcn3s(Ceq,R,Rf,L,Lf,w,E0s,E0c,I0s,I0c,Icir0,Vdc0)
f_Vdcn3c(Ceq,R,Rf,L,Lf,w,E0s,E0c,I0s,I0c,Icir0,Vdc0)

f_Vdcn4s(Ceq,R,Rf,L,Lf,w,E0s,E0c,I0s,I0c,Icir0,Vdc0)
f_Vdcn4c(Ceq,R,Rf,L,Lf,w,E0s,E0c,I0s,I0c,Icir0,Vdc0)




%% Efeito da potência

P0_pq = 0:1e6:100e6;
Q0_pq = 0:1e6:100e6;

[P0m_pq,Q0m_pq] = meshgrid(P0_pq,Q0_pq);

I0s_pq = F_I0s(P0m_pq,Q0m_pq,V0)*sqrt(2);
I0c_pq = F_I0c(P0m_pq,Q0m_pq,V0)*sqrt(2);


I0_pq =  F_I0(P0m_pq,Q0m_pq,V0);

E0s_pq = F_E0s(Vdc0,V0,I0_pq,w,L,Lf,R,Rf,P0m_pq,Q0m_pq);
E0c_pq = F_E0c(Vdc0,V0,I0_pq,w,L,Lf,R,Rf,P0m_pq,Q0m_pq);

Icir0_pq = F_Icir0(Vdc0,P0m_pq,I0_pq,R,Rf);

Icir2s_pq = f_Icir2s(Ceq,R,Rf,L,Lf,w,E0s_pq,E0c_pq,I0s_pq,I0c_pq,Icir0_pq,Vdc0);
Icir2c_pq = f_Icir2c(Ceq,R,Rf,L,Lf,w,E0s_pq,E0c_pq,I0s_pq,I0c_pq,Icir0_pq,Vdc0);

Icir2_pq = sqrt(Icir2s_pq.^2 + Icir2c_pq.^2); 


Icir4s_pq = f_Icir4s(Ceq,R,Rf,L,Lf,w,E0s_pq,E0c_pq,I0s_pq,I0c_pq,Icir0_pq,Vdc0);
Icir4c_pq = f_Icir4c(Ceq,R,Rf,L,Lf,w,E0s_pq,E0c_pq,I0s_pq,I0c_pq,Icir0_pq,Vdc0);

Icir4_pq = sqrt(Icir4s_pq.^2 + Icir4c_pq.^2); 



Vdcn1s_pq = f_Vdcn1s(Ceq,R,Rf,L,Lf,w,E0s_pq,E0c_pq,I0s_pq,I0c_pq,Icir0_pq,Vdc0);
Vdcn1c_pq = f_Vdcn1c(Ceq,R,Rf,L,Lf,w,E0s_pq,E0c_pq,I0s_pq,I0c_pq,Icir0_pq,Vdc0);
  
Vdcn_1 = sqrt(Vdcn1s_pq.^2 + Vdcn1c_pq.^2); 


Vdcn2s_pq = f_Vdcn2s(Ceq,R,Rf,L,Lf,w,E0s_pq,E0c_pq,I0s_pq,I0c_pq,Icir0_pq,Vdc0);
Vdcn2c_pq = f_Vdcn2c(Ceq,R,Rf,L,Lf,w,E0s_pq,E0c_pq,I0s_pq,I0c_pq,Icir0_pq,Vdc0);
  
Vdcn_2 = sqrt(Vdcn2s_pq.^2 + Vdcn2c_pq.^2); 



Vdcn3s_pq = f_Vdcn3s(Ceq,R,Rf,L,Lf,w,E0s_pq,E0c_pq,I0s_pq,I0c_pq,Icir0_pq,Vdc0);
Vdcn3c_pq = f_Vdcn3c(Ceq,R,Rf,L,Lf,w,E0s_pq,E0c_pq,I0s_pq,I0c_pq,Icir0_pq,Vdc0);
  
Vdcn_3 = sqrt(Vdcn3s_pq.^2 + Vdcn3c_pq.^2); 



Vdcn4s_pq = f_Vdcn4s(Ceq,R,Rf,L,Lf,w,E0s_pq,E0c_pq,I0s_pq,I0c_pq,Icir0_pq,Vdc0);
Vdcn4c_pq = f_Vdcn4c(Ceq,R,Rf,L,Lf,w,E0s_pq,E0c_pq,I0s_pq,I0c_pq,Icir0_pq,Vdc0);
  
Vdcn_4 = sqrt(Vdcn4s_pq.^2 + Vdcn4c_pq.^2); 









%% grafico:  Efeito da potência em icir0



H = figure;
set(H,'Position',[50 100 1280 600]);



font = 28;

axes('Position',[0.09 0.18 0.89 0.78])
hold on
[Con,h] = contourf(P0m_pq./100e6,Q0m_pq./100e6,Icir0_pq./IccNominal,'ShowText','on','linewidth',2);
%[Con2,h2] = contour(P0m_icir2./100e6,Q0m_icir2./100e6,I0_icir2./IcaNominal,[0.33,0.66],'--r','ShowText','on','linewidth',2);
hold off
colormap(summer)
clabel(Con,h,'FontSize',font,'Color','black')

%clabel(Con2,h2,'FontSize',18,'Color','red')


ylabel('Reactive Power - p.u. ','FontSize',font,'FontName','calibri Italic','Interpreter','latex');
xlabel('Active Power - p.u. ','FontSize',font,'FontName','calibri Italic','Interpreter','latex');

grid
set(gca,'FontSize',font, 'FontName','calibri Italic','TickLabelInterpreter','latex');



% export_fig 'figs/Tese/Regime_permanente/regime_permanente_P_Q_icir_dc' '-png' -transparent -painters -r300



%% grafico:  Efeito da potência em icir0 - Modified



H = figure;
set(H,'Position',[0 0 750 750]);



font = 28;

axes('Position',[0.15 0.15 0.82 0.82])
hold on
[Con,h] = contourf(P0m_pq./100e6,Q0m_pq./100e6,Icir0_pq./IccNominal,'ShowText','on','linewidth',2);
%[Con2,h2] = contour(P0m_icir2./100e6,Q0m_icir2./100e6,I0_icir2./IcaNominal,[0.33,0.66],'--r','ShowText','on','linewidth',2);
hold off
colormap(summer)
clabel(Con,h,'FontSize',font,'Color','black')

%clabel(Con2,h2,'FontSize',18,'Color','red')


ylabel('Reactive Power - p.u. ','FontSize',font,'FontName','calibri Italic','Interpreter','latex');
xlabel('Active Power - p.u. ','FontSize',font,'FontName','calibri Italic','Interpreter','latex');

grid
set(gca,'FontSize',font, 'FontName','calibri Italic','TickLabelInterpreter','latex');



%export_fig 'figs/Tese/Regime_permanente/regime_permanente_P_Q_icir_dc' '-png' -transparent -painters -r300




%% grafico:  Efeito da potência em icir2



H = figure;
set(H,'Position',[50 100 1280 600]);



font = 28;

axes('Position',[0.09 0.18 0.89 0.78])
hold on
[Con,h] = contourf(P0m_pq./100e6,Q0m_pq./100e6,Icir2_pq./IccNominal,'ShowText','on','linewidth',2);
%[Con2,h2] = contour(P0m_icir2./100e6,Q0m_icir2./100e6,I0_icir2./IcaNominal,[0.33,0.66],'--r','ShowText','on','linewidth',2);
hold off
colormap(summer)
clabel(Con,h,'FontSize',font,'Color','black')

%clabel(Con2,h2,'FontSize',18,'Color','red')


ylabel('Reactive Power - p.u. ','FontSize',font,'FontName','calibri Italic','Interpreter','latex');
xlabel('Active Power - p.u. ','FontSize',font,'FontName','calibri Italic','Interpreter','latex');

grid
set(gca,'FontSize',font, 'FontName','calibri Italic','TickLabelInterpreter','latex');



% export_fig 'figs/Tese/Regime_permanente/regime_permanente_P_Q_icir_2' '-png' -transparent -painters -r300



%% grafico:  Efeito da potência em icir2 - Modified



H = figure;
set(H,'Position',[0 0 750 750]);



font = 28;

axes('Position',[0.15 0.15 0.82 0.82])
hold on
[Con,h] = contourf(P0m_pq./100e6,Q0m_pq./100e6,Icir2_pq./IccNominal,'ShowText','on','linewidth',2);
%[Con2,h2] = contour(P0m_icir2./100e6,Q0m_icir2./100e6,I0_icir2./IcaNominal,[0.33,0.66],'--r','ShowText','on','linewidth',2);
hold off
colormap(summer)
clabel(Con,h,'FontSize',font,'Color','black')

%clabel(Con2,h2,'FontSize',18,'Color','red')


ylabel('Reactive Power - p.u. ','FontSize',font,'FontName','calibri Italic','Interpreter','latex');
xlabel('Active Power - p.u. ','FontSize',font,'FontName','calibri Italic','Interpreter','latex');

grid
set(gca,'FontSize',font, 'FontName','calibri Italic','TickLabelInterpreter','latex');



%export_fig 'figs/Tese/Regime_permanente/regime_permanente_P_Q_icir_2' '-png' -transparent -painters -r300


%% grafico:  Efeito da potência em icir4



H = figure;
set(H,'Position',[50 100 1280 600]);



font = 28;

axes('Position',[0.09 0.18 0.89 0.78])
hold on
[Con,h] = contourf(P0m_pq./100e6,Q0m_pq./100e6,Icir4_pq./IccNominal,'ShowText','on','linewidth',2);
%[Con2,h2] = contour(P0m_icir2./100e6,Q0m_icir2./100e6,I0_icir2./IcaNominal,[0.33,0.66],'--r','ShowText','on','linewidth',2);
hold off
colormap(summer)
clabel(Con,h,'FontSize',font,'Color','black')

%clabel(Con2,h2,'FontSize',18,'Color','red')


ylabel('Reactive Power - p.u. ','FontSize',font,'FontName','calibri Italic','Interpreter','latex');
xlabel('Active Power - p.u. ','FontSize',font,'FontName','calibri Italic','Interpreter','latex');

grid
set(gca,'FontSize',font, 'FontName','calibri Italic','TickLabelInterpreter','latex');



% export_fig 'figs/Tese/Regime_permanente/regime_permanente_P_Q_icir_4' '-png' -transparent -painters -r300



%% grafico:  Efeito da potência em icir4 - Modified



H = figure;
set(H,'Position',[0 0 750 750]);



font = 28;

axes('Position',[0.15 0.15 0.82 0.82])
hold on
[Con,h] = contourf(P0m_pq./100e6,Q0m_pq./100e6,Icir4_pq./IccNominal,'ShowText','on','linewidth',2);
%[Con2,h2] = contour(P0m_icir2./100e6,Q0m_icir2./100e6,I0_icir2./IcaNominal,[0.33,0.66],'--r','ShowText','on','linewidth',2);
hold off
colormap(summer)
clabel(Con,h,'FontSize',font,'Color','black')

%clabel(Con2,h2,'FontSize',18,'Color','red')


ylabel('Reactive Power - p.u. ','FontSize',font,'FontName','calibri Italic','Interpreter','latex');
xlabel('Active Power - p.u. ','FontSize',font,'FontName','calibri Italic','Interpreter','latex');

grid
set(gca,'FontSize',font, 'FontName','calibri Italic','TickLabelInterpreter','latex');



% export_fig 'figs/Tese/Regime_permanente/regime_permanente_P_Q_icir_4' '-png' -transparent -painters -r300


%% grafico:  Efeito da potência em vdcn1



H = figure;
set(H,'Position',[50 100 1280 600]);



font = 28;

axes('Position',[0.09 0.18 0.89 0.78])
hold on
[Con,h] = contourf(P0m_pq./100e6,Q0m_pq./100e6,Vdcn_1./VdcNominal,'ShowText','on','linewidth',2);
%[Con2,h2] = contour(P0m_icir2./100e6,Q0m_icir2./100e6,I0_icir2./IcaNominal,[0.33,0.66],'--r','ShowText','on','linewidth',2);
hold off
colormap(summer)
clabel(Con,h,'FontSize',font,'Color','black')

%clabel(Con2,h2,'FontSize',18,'Color','red')


ylabel('Reactive Power - p.u. ','FontSize',font,'FontName','calibri Italic','Interpreter','latex');
xlabel('Active Power - p.u. ','FontSize',font,'FontName','calibri Italic','Interpreter','latex');

grid
set(gca,'FontSize',font, 'FontName','calibri Italic','TickLabelInterpreter','latex');



% export_fig 'figs/Tese/Regime_permanente/regime_permanente_P_Q_vdcn_1' '-png' -transparent -painters -r300



%% grafico:  Efeito da potência em vdcn1 - Modified



H = figure;
set(H,'Position',[0 0 750 750]);



font = 28;

axes('Position',[0.15 0.15 0.82 0.82])
hold on
[Con,h] = contourf(P0m_pq./100e6,Q0m_pq./100e6,Vdcn_1./VdcNominal,'ShowText','on','linewidth',2);
%[Con2,h2] = contour(P0m_icir2./100e6,Q0m_icir2./100e6,I0_icir2./IcaNominal,[0.33,0.66],'--r','ShowText','on','linewidth',2);
hold off
colormap(summer)
clabel(Con,h,'FontSize',font,'Color','black')

%clabel(Con2,h2,'FontSize',18,'Color','red')


ylabel('Reactive Power - p.u. ','FontSize',font,'FontName','calibri Italic','Interpreter','latex');
xlabel('Active Power - p.u. ','FontSize',font,'FontName','calibri Italic','Interpreter','latex');

grid
set(gca,'FontSize',font, 'FontName','calibri Italic','TickLabelInterpreter','latex');



%export_fig 'figs/Tese/Regime_permanente/regime_permanente_P_Q_vdcn_1' '-png' -transparent -painters -r300




%% grafico:  Efeito da potência em vdcn2



H = figure;
set(H,'Position',[50 100 1280 600]);



font = 28;

axes('Position',[0.09 0.18 0.89 0.78])
hold on
[Con,h] = contourf(P0m_pq./100e6,Q0m_pq./100e6,Vdcn_2./VdcNominal,'ShowText','on','linewidth',2);
%[Con2,h2] = contour(P0m_icir2./100e6,Q0m_icir2./100e6,I0_icir2./IcaNominal,[0.33,0.66],'--r','ShowText','on','linewidth',2);
hold off
colormap(summer)
clabel(Con,h,'FontSize',font,'Color','black')

%clabel(Con2,h2,'FontSize',18,'Color','red')


ylabel('Reactive Power - p.u. ','FontSize',font,'FontName','calibri Italic','Interpreter','latex');
xlabel('Active Power - p.u. ','FontSize',font,'FontName','calibri Italic','Interpreter','latex');

grid
set(gca,'FontSize',font, 'FontName','calibri Italic','TickLabelInterpreter','latex');



% export_fig 'figs/Tese/Regime_permanente/regime_permanente_P_Q_vdcn_2' '-png' -transparent -painters -r300




%% grafico:  Efeito da potência em vdcn2 - Modified



H = figure;
set(H,'Position',[0 0 750 750]);



font = 28;

axes('Position',[0.15 0.15 0.82 0.82])
hold on
[Con,h] = contourf(P0m_pq./100e6,Q0m_pq./100e6,Vdcn_2./VdcNominal,'ShowText','on','linewidth',2);
%[Con2,h2] = contour(P0m_icir2./100e6,Q0m_icir2./100e6,I0_icir2./IcaNominal,[0.33,0.66],'--r','ShowText','on','linewidth',2);
hold off
colormap(summer)
clabel(Con,h,'FontSize',font,'Color','black')

%clabel(Con2,h2,'FontSize',18,'Color','red')


ylabel('Reactive Power - p.u. ','FontSize',font,'FontName','calibri Italic','Interpreter','latex');
xlabel('Active Power - p.u. ','FontSize',font,'FontName','calibri Italic','Interpreter','latex');

grid
set(gca,'FontSize',font, 'FontName','calibri Italic','TickLabelInterpreter','latex');



% export_fig 'figs/Tese/Regime_permanente/regime_permanente_P_Q_vdcn_2' '-png' -transparent -painters -r300


%% grafico:  Efeito da potência em vdcn3



H = figure;
set(H,'Position',[50 100 1280 600]);



font = 28;

axes('Position',[0.09 0.18 0.89 0.78])
hold on
[Con,h] = contourf(P0m_pq./100e6,Q0m_pq./100e6,Vdcn_3./VdcNominal,'ShowText','on','linewidth',2);
%[Con2,h2] = contour(P0m_icir2./100e6,Q0m_icir2./100e6,I0_icir2./IcaNominal,[0.33,0.66],'--r','ShowText','on','linewidth',2);
hold off
colormap(summer)
clabel(Con,h,'FontSize',font,'Color','black')

%clabel(Con2,h2,'FontSize',18,'Color','red')


ylabel('Reactive Power - p.u. ','FontSize',font,'FontName','calibri Italic','Interpreter','latex');
xlabel('Active Power - p.u. ','FontSize',font,'FontName','calibri Italic','Interpreter','latex');

grid
set(gca,'FontSize',font, 'FontName','calibri Italic','TickLabelInterpreter','latex');



% export_fig 'figs/Tese/Regime_permanente/regime_permanente_P_Q_vdcn_3' '-png' -transparent -painters -r300


%% grafico:  Efeito da potência em vdcn3 - Modified



H = figure;
set(H,'Position',[0 0 750 750]);



font = 28;

axes('Position',[0.15 0.15 0.82 0.82])
hold on
[Con,h] = contourf(P0m_pq./100e6,Q0m_pq./100e6,Vdcn_3./VdcNominal,'ShowText','on','linewidth',2);
%[Con2,h2] = contour(P0m_icir2./100e6,Q0m_icir2./100e6,I0_icir2./IcaNominal,[0.33,0.66],'--r','ShowText','on','linewidth',2);
hold off
colormap(summer)
clabel(Con,h,'FontSize',font,'Color','black')

%clabel(Con2,h2,'FontSize',18,'Color','red')


ylabel('Reactive Power - p.u. ','FontSize',font,'FontName','calibri Italic','Interpreter','latex');
xlabel('Active Power - p.u. ','FontSize',font,'FontName','calibri Italic','Interpreter','latex');

grid
set(gca,'FontSize',font, 'FontName','calibri Italic','TickLabelInterpreter','latex');



%export_fig 'figs/Tese/Regime_permanente/regime_permanente_P_Q_vdcn_3' '-png' -transparent -painters -r300



%% grafico:  Efeito da potência em vdcn4



H = figure;
set(H,'Position',[50 100 1280 600]);



font = 28;

axes('Position',[0.09 0.18 0.89 0.78])
hold on
[Con,h] = contourf(P0m_pq./100e6,Q0m_pq./100e6,Vdcn_4./VdcNominal,'ShowText','on','linewidth',2);
%[Con2,h2] = contour(P0m_icir2./100e6,Q0m_icir2./100e6,I0_icir2./IcaNominal,[0.33,0.66],'--r','ShowText','on','linewidth',2);
hold off
colormap(summer)
clabel(Con,h,'FontSize',font,'Color','black')

%clabel(Con2,h2,'FontSize',18,'Color','red')


ylabel('Reactive Power - p.u. ','FontSize',font,'FontName','calibri Italic','Interpreter','latex');
xlabel('Active Power - p.u. ','FontSize',font,'FontName','calibri Italic','Interpreter','latex');

grid
set(gca,'FontSize',font, 'FontName','calibri Italic','TickLabelInterpreter','latex');



%export_fig 'figs/Tese/Regime_permanente/regime_permanente_P_Q_vdcn_4' '-png' -transparent -painters -r300



%% grafico:  Efeito da potência em vdcn4 - Modified



H = figure;
set(H,'Position',[0 0 750 750]);



font = 28;

axes('Position',[0.15 0.15 0.82 0.82])
hold on
[Con,h] = contourf(P0m_pq./100e6,Q0m_pq./100e6,Vdcn_4./VdcNominal,'ShowText','on','linewidth',2);
%[Con2,h2] = contour(P0m_icir2./100e6,Q0m_icir2./100e6,I0_icir2./IcaNominal,[0.33,0.66],'--r','ShowText','on','linewidth',2);
hold off
colormap(summer)
clabel(Con,h,'FontSize',font,'Color','black')

%clabel(Con2,h2,'FontSize',18,'Color','red')


ylabel('Reactive Power - p.u. ','FontSize',font,'FontName','calibri Italic','Interpreter','latex');
xlabel('Active Power - p.u. ','FontSize',font,'FontName','calibri Italic','Interpreter','latex');

grid
set(gca,'FontSize',font, 'FontName','calibri Italic','TickLabelInterpreter','latex');



%export_fig 'figs/Tese/Regime_permanente/regime_permanente_P_Q_vdcn_4' '-png' -transparent -painters -r300



%% Loading PSCAD results 

PSCAD_DATA =  readtable('Dados/Dados_PSCAD_MMC_TESE/Dados_PSCAD_MMC_TESE_OPENLOOP.csv');

%% PSCAD processing

PSCAD_DATA_sumvdcn = PSCAD_DATA.vdcan1 + PSCAD_DATA.vdcan2 + PSCAD_DATA.vdcan3 + PSCAD_DATA.vdcan4 + PSCAD_DATA.vdcan5 + ...
                     PSCAD_DATA.vdcan6 + PSCAD_DATA.vdcan7 + PSCAD_DATA.vdcan8 + PSCAD_DATA.vdcan9 + PSCAD_DATA.vdcan10 + ...
                     PSCAD_DATA.vdcan11 + PSCAD_DATA.vdcan12 + PSCAD_DATA.vdcan13 + PSCAD_DATA.vdcan14 + PSCAD_DATA.vdcan15 + ...
                     PSCAD_DATA.vdcan16 + PSCAD_DATA.vdcan17 + PSCAD_DATA.vdcan18 + PSCAD_DATA.vdcan19 + PSCAD_DATA.vdcan20;

%% Time domain simulation
t = 0:1e-5:0.5;
w_ts = 2*pi*60;

% defasagem entre a simulação e o modelo
delta = deg2rad(12);

% data
P0_ts = 89e6;
Q0_ts = 0;

V0_ts = 67e3/sqrt(3);

vo_ts = V0*sqrt(2).*sin(w_ts.*t);

I0s_ts = F_I0s(P0_ts,Q0_ts,V0_ts)*sqrt(2);
I0c_ts = F_I0c(P0_ts,Q0_ts,V0_ts)*sqrt(2);

ic_ts = I0s_ts.*sin(w_ts.*t-delta) + I0c_ts.*cos(w_ts.*t-delta); 


I0_ts =  F_I0(P0_ts,Q0_ts,V0_ts);
 
E0s_ts = F_E0s(Vdc0,V0_ts,I0_ts,w,L,Lf,R,Rf,P0_ts,Q0_ts);
E0c_ts = F_E0c(Vdc0,V0_ts,I0_ts,w,L,Lf,R,Rf,P0_ts,Q0_ts);
 
Icir0_ts = F_Icir0(Vdc0,P0_ts,I0_ts,R,Rf);
 
Icir2s_ts = f_Icir2s(Ceq,R,Rf,L,Lf,w,E0s_ts,E0c_ts,I0s_ts,I0c_ts,Icir0_ts,Vdc0);
Icir2c_ts = f_Icir2c(Ceq,R,Rf,L,Lf,w,E0s_ts,E0c_ts,I0s_ts,I0c_ts,Icir0_ts,Vdc0);


Icir4s_ts = f_Icir4s(Ceq,R,Rf,L,Lf,w,E0s_ts,E0c_ts,I0s_ts,I0c_ts,Icir0_ts,Vdc0);
Icir4c_ts = f_Icir4c(Ceq,R,Rf,L,Lf,w,E0s_ts,E0c_ts,I0s_ts,I0c_ts,Icir0_ts,Vdc0);


Icir_ts = Icir0_ts + ...
          Icir2s_ts.*sin(2*(w_ts.*t-delta)) + Icir2c_ts.*cos(2*(w_ts.*t-delta)) + ...
          Icir4s_ts.*sin(4*(w_ts.*t-delta)) + Icir4c_ts.*cos(4*(w_ts.*t-delta)) ;


      
      
      
Vdcn1s_ts = f_Vdcn1s(Ceq,R,Rf,L,Lf,w,E0s_ts,E0c_ts,I0s_ts,I0c_ts,Icir0_ts,Vdc0);
Vdcn1c_ts = f_Vdcn1c(Ceq,R,Rf,L,Lf,w,E0s_ts,E0c_ts,I0s_ts,I0c_ts,Icir0_ts,Vdc0);


Vdcn2s_ts = f_Vdcn2s(Ceq,R,Rf,L,Lf,w,E0s_ts,E0c_ts,I0s_ts,I0c_ts,Icir0_ts,Vdc0);
Vdcn2c_ts = f_Vdcn2c(Ceq,R,Rf,L,Lf,w,E0s_ts,E0c_ts,I0s_ts,I0c_ts,Icir0_ts,Vdc0);


Vdcn3s_ts = f_Vdcn3s(Ceq,R,Rf,L,Lf,w,E0s_ts,E0c_ts,I0s_ts,I0c_ts,Icir0_ts,Vdc0);
Vdcn3c_ts = f_Vdcn3c(Ceq,R,Rf,L,Lf,w,E0s_ts,E0c_ts,I0s_ts,I0c_ts,Icir0_ts,Vdc0);

 
Vdcn4s_ts = f_Vdcn4s(Ceq,R,Rf,L,Lf,w,E0s_ts,E0c_ts,I0s_ts,I0c_ts,Icir0_ts,Vdc0);
Vdcn4c_ts = f_Vdcn4c(Ceq,R,Rf,L,Lf,w,E0s_ts,E0c_ts,I0s_ts,I0c_ts,Icir0_ts,Vdc0);
  
Vdcn = Vdc0 + ....
       Vdcn1s_ts.*sin(1*(w_ts.*t-delta)) + Vdcn1c_ts.*cos(1*(w_ts.*t-delta)) + ...
       Vdcn2s_ts.*sin(2*(w_ts.*t-delta)) + Vdcn2c_ts.*cos(2*(w_ts.*t-delta)) + ...
       Vdcn3s_ts.*sin(3*(w_ts.*t-delta)) + Vdcn3c_ts.*cos(3*(w_ts.*t-delta)) + ...
       Vdcn4s_ts.*sin(4*(w_ts.*t-delta)) + Vdcn4c_ts.*cos(4*(w_ts.*t-delta));





%% Output current



H = figure;
%set(H,'Position',[50 100 1280 600]);
set(H,'Position',[50 100 1280 300]);

FS = 16;


axes('Position',[0.066 0.20 0.9 0.75])
hold on
h1 = plot(PSCAD_DATA.Time,1000.*PSCAD_DATA.ica./IcaNominalPico,'-','color',phase_a,'linewidth',2.0);
h2 = plot(t,ic_ts./IcaNominalPico,'-.r','linewidth',2);
%h2 = plot(PSCAD_DATA.Time,1000.*PSCAD_DATA.icirb./Idc0,'--','color',phase_b,'linewidth',2.0);
%h3 = plot(PSCAD_DATA.Time,1000.*PSCAD_DATA.icirc./Idc0,'-.','color',phase_c,'linewidth',2.0);
h4 = plot([0.1 0.1],[-10 10],'--k','linewidth',2.0);
%h2 = plot(psim_f2,psim_AmpdB2,'or','linewidth',2.0);
hold off
%xlim([1 1000])
grid
set(gca,'FontSize',FS,'FontName','calibri Italic','TickLabelInterpreter','latex');
ylabel('Current - p.u. ','FontSize',FS,'FontName','calibri Italic','interpreter','latex');
xlabel('Time - s','FontSize',FS,'FontName','calibri Italic','interpreter','latex');
%set(gca,'GridAlpha',0.5,'MinorGridAlpha',0.8)
xlim([0.45 0.5])
ylim([-1.5 1.5])


leg = legend('Switching-level model','Analytical Model','Location','northeast','Orientation', 'horizontal');
leg.FontSize = FS;
leg.Interpreter = 'latex';


% export_fig 'figs/Tese/Regime_permanente/compara_ic_ss' '-png' -transparent -painters -r400


%% Circulating current



H = figure;
%set(H,'Position',[50 100 1280 600]);
set(H,'Position',[50 100 1280 300]);

FS = 16;


axes('Position',[0.066 0.20 0.9 0.75])
hold on
h1 = plot(PSCAD_DATA.Time,1000.*PSCAD_DATA.icira./IccNominal,'-','color',phase_a,'linewidth',2.0);
h2 = plot(t,Icir_ts./IccNominal,'-.r','linewidth',2);
%h2 = plot(PSCAD_DATA.Time,1000.*PSCAD_DATA.icirb./Idc0,'--','color',phase_b,'linewidth',2.0);
%h3 = plot(PSCAD_DATA.Time,1000.*PSCAD_DATA.icirc./Idc0,'-.','color',phase_c,'linewidth',2.0);
h4 = plot([0.1 0.1],[-10 10],'--k','linewidth',2.0);
%h2 = plot(psim_f2,psim_AmpdB2,'or','linewidth',2.0);
hold off
%xlim([1 1000])
grid
set(gca,'FontSize',FS,'FontName','calibri Italic','TickLabelInterpreter','latex');
ylabel('Current - p.u. ','FontSize',FS,'FontName','calibri Italic','interpreter','latex');
xlabel('Time - s','FontSize',FS,'FontName','calibri Italic','interpreter','latex');
%set(gca,'GridAlpha',0.5,'MinorGridAlpha',0.8)
xlim([0.45 0.5])
%ylim([-1.5 1.5])


leg = legend('Switching-level model','Analytical Model','Location','northeast','Orientation', 'horizontal');
leg.FontSize = FS;
leg.Interpreter = 'latex';


%export_fig 'figs/Tese/Regime_permanente/compara_icir_ss' '-png' -transparent -painters -r400




%% Equivalent dc voltage



H = figure;
%set(H,'Position',[50 100 1280 600]);
set(H,'Position',[50 100 1280 300]);

FS = 16;


axes('Position',[0.066 0.20 0.9 0.75])
hold on
h1 = plot(PSCAD_DATA.Time,1000.*PSCAD_DATA_sumvdcn./VdcNominal,'-','color',phase_a,'linewidth',2.0);
h2 = plot(t,Vdcn./VdcNominal,'-.r','linewidth',2);
%h2 = plot(PSCAD_DATA.Time,1000.*PSCAD_DATA.icirb./Idc0,'--','color',phase_b,'linewidth',2.0);
%h3 = plot(PSCAD_DATA.Time,1000.*PSCAD_DATA.icirc./Idc0,'-.','color',phase_c,'linewidth',2.0);
h4 = plot([0.1 0.1],[-10 10],'--k','linewidth',2.0);
%h2 = plot(psim_f2,psim_AmpdB2,'or','linewidth',2.0);
hold off
%xlim([1 1000])
grid
set(gca,'FontSize',FS,'FontName','calibri Italic','TickLabelInterpreter','latex');
ylabel('Voltage - p.u. ','FontSize',FS,'FontName','calibri Italic','interpreter','latex');
xlabel('Time - s','FontSize',FS,'FontName','calibri Italic','interpreter','latex');
%set(gca,'GridAlpha',0.5,'MinorGridAlpha',0.8)
xlim([0.45 0.5])
ylim([0.98 1.02])


leg = legend('Switching-level model','Analytical Model','Location','northeast','Orientation', 'horizontal');
leg.FontSize = FS;
leg.Interpreter = 'latex';


%export_fig 'figs/Tese/Regime_permanente/compara_vdcn_ss' '-png' -transparent -painters -r400
