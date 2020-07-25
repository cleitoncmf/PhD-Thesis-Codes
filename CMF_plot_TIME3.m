%% Função para plotar 3 gráficos no domínio do tempo
% Haverá 3 gráficos em totem
% Usar número de entradas múltiplo de 3
% Em cada grupo de 3:
% - primeiro: vetor X
% - segundo: vetor Y
% - terceiro: strig com cor/tipo de traço do gráfico
function [H,gca1,gca2,gca3] = CMF_plot_TIME3(varargin)


if ~mod(nargin,3)
    
    H = figure;
    fator = 0.7/0.3;
    set(H,'Position',[50 100 1280 600*fator]);
    
    font = 28;
    
    
    % Gráfico superior
    axes('Position',[0.09 0.7 0.89 0.29]);
    
    
    
    % Gráfico do meio
    axes('Position',[0.09 0.4 0.89 0.29]);
    
    
    
    % Gráfico inferior
    axes('Position',[0.09 0.1 0.89 0.29]);
    
    
else
    error('Defina trios x, y, string ');
    
end
