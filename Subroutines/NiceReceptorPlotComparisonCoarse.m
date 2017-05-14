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
% % set(hsp,'Position',[0.15 0.17 0.75 0.80]);


%% plot
% set(0,'defaultAxesColorOrder','remove')
DefaultColours = get(groot,'DefaultAxesColorOrder'); %does not equal: Colours = parula(6);!
DarkBlue = DefaultColours(1,:);
% LightBlue = DefaultColours(6,:);
% LightGreen = DefaultColours(5,:);
Purple = DefaultColours(4,:);

% import additional colours: @cmu.colors;
% colors('dark green')
% colors('android green')

%,'m' 'm--'%,'g''g:'%,'k-.'
%'MarkerEdgeColor','b',
%'--s','--o','--^'
MSize = 3;
MSizesmall = 2.5;
LineWidth = 2;

plot(xAxis,IntRef.u,':o','color',colors('light pastel purple'),'Linewidth',LineWidth,...
    'MarkerSize',MSizesmall,'MarkerFaceColor',[1 1 1]); hold on
plot(xAxis,IntRef.b,':o','color',colors('light sky blue'),'Linewidth',LineWidth,...
    'MarkerSize',MSizesmall,'MarkerFaceColor',[1 1 1]);
plot(xAxis,IntRef.g,':o','color',colors('light green'),'Linewidth',LineWidth,...
    'MarkerSize',MSizesmall,'MarkerFaceColor',[1 1 1]);

plot(xAxis,IntSpec.u,'-o','color',Purple,'Linewidth',LineWidth,...
    'MarkerSize',MSize,'MarkerFaceColor',Purple );
plot(xAxis,IntSpec.b,'-o','color',DarkBlue,'Linewidth',LineWidth,...
    'MarkerSize',MSize,'MarkerFaceColor',DarkBlue );
plot(xAxis,IntSpec.g,'-o','color',colors('dark pastel green'),'Linewidth',LineWidth,...
    'MarkerSize',MSize,'MarkerFaceColor',colors('dark pastel green') );



% %default colours:
% plot(xAxis,IntRef.u,'Linewidth',2); hold on %,'m' 'm--'%,'g''g:'%,'k-.'
% plot(xAxis,IntRef.b,'Linewidth',2);
% plot(xAxis,IntRef.g,'Linewidth',2);
% plot(xAxis,IntSpec.u,'Linewidth',2);
% plot(xAxis,IntSpec.b,'Linewidth',2);
% plot(xAxis,IntSpec.g,'Linewidth',2);


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
%     print(hfig, ['-r' num2str(400)], [IMAGENAME '.svg' ], ['-d' 'svg']);  
%     crop([IMAGENAME '.png']);
    display('finished plot export')
end

% close(hfig);
