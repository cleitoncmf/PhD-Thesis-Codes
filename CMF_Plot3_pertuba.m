%% Função de plotagem exclusiva para o capítulo das técnicas de controle 
% São utilizadas 6 entradas:
% - vetor de tempo
% - fase a
% - fase b
% - fase c
% - valor base da variável
% - instante de tempo da perturbação
% - Nome da variável: Voltage ou Current
% Tudo é plotado em pu
function H = CMF_Plot3_pertuba(Time, a, b, c, base, Tperturb,NomeVar)


phase_a = [0, 0, 150]./256;
phase_b = [0, 180, 0]./256;
phase_c = [231, 13, 17]./256;


H = figure;
set(H,'Position',[50 100 1280 300]);

FS = 18;


axes('Position',[0.066 0.20 0.9 0.75])
hold on
h1 = plot(Time,a./base,'-','color',phase_a,'linewidth',2.0);
h2 = plot(Time,b./base,'--','color',phase_b,'linewidth',2.0);
h3 = plot(Time,c./base,'-.','color',phase_c,'linewidth',2.0);
h4 = plot([Tperturb Tperturb],[-1.4 1.4],'--k','linewidth',2.0);
hold off
grid
set(gca,'FontSize',FS,'FontName','calibri Italic','TickLabelInterpreter','latex');
ylabel(strcat(NomeVar,' - p.u.'),'FontSize',FS,'FontName','calibri Italic','interpreter','latex');
xlabel('Time - s','FontSize',FS,'FontName','calibri Italic','interpreter','latex');
%set(gca,'GridAlpha',0.5,'MinorGridAlpha',0.8)
set(gca,'YTick',[-1 -0.5 0 0.5 1 1.35],'YTickLabel',{-1 -0.5 0 0.5 1 '^'})
xlim([min(Time) max(Time)])
ylim([-1.35 1.35])


leg = legend('a','b','c','Location','northwest','Orientation', 'horizontal');
leg.FontSize = FS;
leg.Interpreter = 'latex';
