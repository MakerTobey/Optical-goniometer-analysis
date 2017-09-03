function NiceReceptorPlotComparisonCoarse(IntRef, IntSpec, xAxis, xLabel, yLabel, xTick, xTickLabel, xLim, Title, Legend, SaveName);
%(xAxis, Data1D1, Data1D2, Data1D3, Data1D4, xLim, yLim, xLabel, yLabel, Legend, SaveName)
% make a publishable plot and save


%% Common variables

FontSize = 12;
FontName = 'MyriadPro-Regular'; % or choose any other font

doExportPlot = true;


%% start plot
% figure dimensions 

figure_width = 10;%16;
figure_height = 9;%10;

% --- setup plot windows
figuresVisible = 'on'; % 'off' for non displayed plots (will still be exported)
hfig = figure(1); clf;
    set(hfig,'Visible', figuresVisible)

    set(hfig, 'units', 'centimeters', 'pos', [5 5 figure_width figure_height])   
    set(hfig, 'PaperPositionMode', 'auto');    
    set(hfig, 'Renderer','painters'); %'painters' 'Zbuffer' 'opengl'
    set(hfig, 'Color', [1 1 1]); % Sets figure background
    set(gca, 'Color', [1 1 1]); % Sets axes background

% --- dimensions and position of plot 
hsp = subplot(1,1,1, 'Parent', hfig);

%% plot

% define colours for plot tracks:
DefaultColours = get(groot,'DefaultAxesColorOrder'); % Get from default (parula) colours. Note: this notation does not equal Colours = parula(6);!
DarkBlue = DefaultColours(1,:);
Purple = DefaultColours(4,:);
LightPastelPurple = [0.690000 0.610000 0.850000];
LightSkyBlue = [0.530000 0.810000 0.980000];
LightGreen = [0.560000 0.930000 0.560000];
DarkPastelGreen = [0.010000 0.750000 0.240000];

% define markers and lines
MSize = 3;
MSizesmall = 2.5;
LineWidth = 2;

plot(xAxis,IntRef.u,':o','color',LightPastelPurple,'Linewidth',LineWidth,...
    'MarkerSize',MSizesmall,'MarkerFaceColor',[1 1 1]); hold on
plot(xAxis,IntRef.b,':o','color',LightSkyBlue,'Linewidth',LineWidth,...
    'MarkerSize',MSizesmall,'MarkerFaceColor',[1 1 1]);
plot(xAxis,IntRef.g,':o','color',LightGreen,'Linewidth',LineWidth,...
    'MarkerSize',MSizesmall,'MarkerFaceColor',[1 1 1]);

plot(xAxis,IntSpec.u,'-o','color',Purple,'Linewidth',LineWidth,...
    'MarkerSize',MSize,'MarkerFaceColor',Purple );
plot(xAxis,IntSpec.b,'-o','color',DarkBlue,'Linewidth',LineWidth,...
    'MarkerSize',MSize,'MarkerFaceColor',DarkBlue );
plot(xAxis,IntSpec.g,'-o','color',colors('dark pastel green'),'Linewidth',LineWidth,...
    'MarkerSize',MSize,'MarkerFaceColor',DarkPastelGreen );


%% axis scales
if isempty(xTick)
else
    if isempty(xTickLabel)
        set(gca,'XTick',xTick)
    else
        set(gca,'XTick',xTick,'XTickLabel',xTickLabel)
    end
end

% set(gca,'YTick',[]) %%%%%%% toggled out to display y-axsis
% % if isempty(yTick)
% % else
% %     set(gca,'YTick',yTick)
% % end

%%  setup axis plot properties
set(gca, ...
    'Box'         , 'on'      , ...
    'TickDir'     , 'in'      , ...
    'TickLength'  , [.015 .015] , ...
    'XMinorTick'  , 'off'      , ...
    'YMinorTick'  , 'off'     , ...
    'XGrid'       , 'off'     , ...
    'YGrid'       , 'off'     , ...
    'LineWidth'   , 0.6        );


%% label texts and limits
hTitle = title(Title);
hXLabel = xlabel(xLabel);
hYLabel = ylabel(yLabel);
xlim(xLim)
%%% ADAPTED to start from zero
yl = ylim;
ylim([0 yl(2)])

hleg = legend((Legend),'Location','SouthEastOutside');%,'NorthEast');
set(hleg, 'FontSize', 8, 'FontName', FontName)%,  'Box', 'off', %%%'FitBoxToText', 'on');


%% set properties for all handles
set([gca, hTitle, hXLabel, hYLabel], ...
    'FontSize'   , FontSize    , ...
    'FontName'   , FontName);

% bring axis on top again (fix matlab bug)
set(gca,'Layer', 'top');

hold off


%% export
drawnow
SaveDir = '';
if (doExportPlot)
    IMAGENAME = [SaveDir SaveName]; 
    print(hfig, ['-r' num2str(400)], [IMAGENAME '.jpg' ], ['-d' 'jpeg']);
    print(hfig, ['-r' num2str(400)], [IMAGENAME '.svg' ], ['-d' 'svg']);  
    display('finished plot export')
end

% close(hfig);
