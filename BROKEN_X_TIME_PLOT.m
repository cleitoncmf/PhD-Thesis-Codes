%% Função para plotar gráficos com eixo quebrado no domínio do tempo
% O último argumento deve ser o intervalo [xmin xmax] onde o eixo deve ser
% quebrado
% Descontando a última entrada, usar 3 argumentos para cada curva
% Em cada grupo de 3:
% - primeiro: vetor X
% - segundo: vetor Y
% - terceiro: strig com cor/tipo de traço do gráfico
function [H, h] = BROKEN_X_TIME_PLOT(varargin)




font = 22;

H = figure;
set(H,'Position',[50 100 400 300]);
%axes('Position',[0.09 0.25 0.89 0.7])


mainAxes = axes;

hold on
for k=1:3:nargin-1
    plot(mainAxes,varargin{k},varargin{k+1},varargin{k+2},'linewidth',2);    
end
hold off

xlim([2.98 4.5])
ylim([0.99 1.01])


xlabel('Time - s','FontSize',font,'FontName','calibri Italic','Interpreter','latex')
ylabel('DC Voltage - p.u.','FontSize',font,'FontName','calibri Italic','Interpreter','latex')
set(gca,'GridAlpha',0.5,'MinorGridAlpha',0.8)
set(gca,'FontSize',font, 'FontName','calibri Italic','TickLabelInterpreter','latex','box','on');
set(gca,'GridLineStyle',':','GridAlpha',1.0)
set(gca,'XTick',[2.98 3 4.47 4.5])
grid



% xlabel 'This is an X Axis Label'
% ylabel 'This is a Y Axis Label'
% title('A Generic Title');
% legend('Red Line','Blue Line');
% set(gca,'Layer','Top')
% %Break The Axes


h = breakxaxis(varargin{end});





end