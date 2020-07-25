%% Função para plotar linhas tracejadas
% As entradas devem ser vetores contendo a posição x da linha
% [x, YMAX]
%

function CMF_plot_TR(handle,varargin)

for k=1:nargin-1
    line(handle,[varargin{k}(1) varargin{k}(1)],[-varargin{k}(2) varargin{k}(2)],'Color','r','LineStyle','--');
end


