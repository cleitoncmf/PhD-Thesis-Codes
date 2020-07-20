%% Função para plotar a RF já no padrão certinho
%
% Esta função tem que receber um número de entradas múltiplo de 4
% Em cada trio de entradas teremos as seguintes variávies
% Primeira: vetor w
% Segunda: Vetor Mag
% Terceira: Vetor Phi
% Quarta: vetor com cor/tipo de marcador e etc. Se não quiser coloque
% apenas ''.
%
%
function [H,gcaMag,gcaPhi,yT,xB,yB] = CMF_plot_RF(varargin)






if ~mod(nargin,4)
    H = figure;
    set(H,'Position',[50 100 1280 600]);
    
    font = 28;
    
    % Diagrama de Magnitude
    gcaMag = axes('Position',[0.09 0.58 0.89 0.4]);
    hold on
    for k=1:nargin/4
        plot(varargin{4*k-3},varargin{4*k-2},varargin{4*k},'linewidth',2.0);
    end
    hold off
    xlim([1 1000])
    grid
    %gcaMag = get(gca);
    set(gca,'FontSize',font, 'XScale', 'log','FontName','calibri Italic','XTick',[1 10 100 1000],'TickLabelInterpreter','latex');
    set(gca,'GridAlpha',0.5,'MinorGridAlpha',0.8);
    yT = ylabel('Magnitude - dB ','FontSize',font,'FontName','calibri Italic','Interpreter','latex');
    set(gca,'XTickLabel',{});
    
    
    % Diagrama de fase
    max_phi = 0;
    min_phi = 0;
    gcaPhi = axes('Position',[0.09 0.15 0.89 0.4]);
    hold on
    for k=1:nargin/4
        if(max(varargin{4*k-1}) > max_phi)
            max_phi = max(varargin{4*k-1});
        end
        if(min(varargin{4*k-1}) < min_phi)
            min_phi = min(varargin{4*k-1});
        end
        
        plot(varargin{4*k-3},varargin{4*k-1},varargin{4*k},'linewidth',2.0);
    end
    hold off
    xlim([1 1000])
    grid
    %gcaPhi = get(gca);
    set(gca,'FontSize',font, 'XScale', 'log','FontName','calibri Italic','XTick',[1 10 100 1000],'TickLabelInterpreter','latex');
    set(gca,'GridAlpha',0.5,'MinorGridAlpha',0.8);
    
    xB = xlabel('Frequency - Hz','FontSize',font,'FontName','calibri','Interpreter','latex');
    yB = ylabel('Phase - deg ','FontSize',font,'FontName','calibri','Interpreter','latex');
    
    
    
    if(max_phi<100 & min_phi > -100)
        set(gca,'YLim',[-120 120],'YTick',[-90 0 90 120], 'YTickLabel',{-90,  0, 90,'^'});
        xB.Position(2) = -170;
    else
        set(gca,'YLim',[-200 200],'YTick',[-180 -90 0 90 180 200], 'YTickLabel',{-180 -90 0 90 180 '^'});
        xB.Position(2) = -284;
    end
    
    
    %yB.Position(1) = yB.Position(1) - 0.03;
    %yB.Position(1) = yB.Position(1) + 0.035;
    %yB.Position(1) = yB.Position(1) + 0.01
    yB.Position(1) = 0.64;
    yT.Position(1) = yB.Position(1);
    
    yT.Units = 'normalized';
    yT.Position(2) = 0.54;
    
    %xB.Position(2) = -284;
     
    %xB.Position(2) = xB.Position(2) -17;


    
    
    
    
    
else
    error('Defina quartetos w, Mag, phi, string ');
    
end




