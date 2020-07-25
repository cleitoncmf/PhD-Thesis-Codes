%% Função para plotar gráficos no domínio do tempo
% Em cada grupo de 3:
% - primeiro: vetor X
% - segundo: vetor Y
% - terceiro: strig com cor/tipo de traço do gráfico
function H = TIME_PLOT(varargin)


font = 22;

H = figure;
set(H,'Position',[50 100 1280 300]);
axes('Position',[0.09 0.25 0.89 0.7])

hold on
for k=1:3:nargin
    plot(varargin{k},varargin{k+1},varargin{k+2},'linewidth',2);    
end
hold off

xlabel('Time - s','FontSize',font,'FontName','calibri Italic','Interpreter','latex')
ylabel('Amplitude - p.u.','FontSize',font,'FontName','calibri Italic','Interpreter','latex')

ylim([-2 2])

set(gca,'GridAlpha',0.5,'MinorGridAlpha',0.8)
set(gca,'FontSize',font, 'FontName','calibri Italic','TickLabelInterpreter','latex','box','on');
set(gca,'GridLineStyle',':','GridAlpha',1.0)
grid





end