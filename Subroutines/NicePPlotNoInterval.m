function NicePPlotNoInterval(xAxis, yAxis, Data2D, cLims, xLabel, yLabel, zLabel, xTick, yTick, xTickLabel, Title, SaveName)
% make a publishable plot and save

%% Common variables

FontSize = 12;
FontName = 'MyriadPro-Regular'; % or choose any other font

doExportPlot = true;

% % Data2D = Data2D - min(min(Data2D)); % normalize to 0-1
% % Data2D = Data2D / max(max(Data2D)); 


%% start plot

% figure dimensions in cm. I choose 1.5 or 2 times 
% the target size typically. If figure is display in
% document much smaller increase the fontsize.

figure_width = 10;  %14
figure_height = 10;

% --- setup plot windows
figuresVisible = 'on'; % 'off' for non displayed plots (will still be exported)
hfig = figure(1); clf;
    set(hfig,'Visible', figuresVisible)

    set(hfig, 'units', 'centimeters', 'pos', [5 5 figure_width figure_height])   
    set(hfig, 'PaperPositionMode', 'auto');    
    set(hfig, 'Renderer','opengl'); %'painters'
    set(hfig, 'Color', [1 1 1]); % Sets figure background
    set(gca, 'Color', [1 1 1]); % Sets axes background

% --- dimensions and position of plot 
hsp = subplot(1,1,1, 'Parent', hfig);
% % set(hsp,'Position',[0.15 0.17 0.75 0.80]);
    
%% plot
% colorDepth = 1000;
% colormap(jet(colorDepth));%jet  %%%% MAKE PLOT COLORFUL OR INTENSITY SCALED
pcolor(xAxis, yAxis, Data2D)

%% Add vertical lines to the plot to mark change in intensities and label them
% line('XData',[0, 0],'YData',[700, 700], ...
% 	'linestyle', 'none', 'Color','r', ...
%     'marker', 'p', 'markeredgecolor', 'none', 'markerfacecolor', 'w','MarkerSize', 12);%make marker
%     %'Tag', '/4'
% line('XData',[cosd(-2.5+270), cosd(-2.5+270)],'YData',[min(yAxis), max(yAxis)], ...
%    'LineStyle', '--', 'LineWidth', 2, 'Color','w');
% line('XData',[cosd(2.5+270), cosd(2.5+270)],'YData',[min(yAxis), max(yAxis)], ...
%     'LineStyle', '--', 'LineWidth', 2, 'Color','w');%'k'


%%  setup axis plot properties
shading interp; % interpolate pixels
% shading flat; % do not interpolate pixels
axis on;      % display axis
axis tight;   % no white borders
% % axis image;   % real x,y scaling

set(gca, ...
    'CLim'        , cLims, ...
    'Box'         , 'on'      , ...
    'TickDir'     , 'in'      , ...
    'TickLength'  , [.015 .015] , ...
    'XMinorTick'  , 'off'      , ...
    'YMinorTick'  , 'off'     , ...
    'XGrid'       , 'off'     , ...
    'YGrid'       , 'off'     , ...
    'XColor'      , [.0 .0 .0], ...
    'YColor'      , [.0 .0 .0], ...
    'LineWidth'   , 0.6        );


%% axis scales
if isempty(xTick)
else
    if isempty(xTickLabel)
        set(gca,'XTick',xTick)
    else
        set(gca,'XTick',xTick,'XTickLabel',xTickLabel)
    end
end

if isempty(yTick)
else
    set(gca,'YTick',yTick)
end

%% label texts
% xLabelText = %'x / µm';  % greek letters in LaTeX Syntax

% save handles to set up label properties
hTitle = title(Title);
hXLabel = xlabel(xLabel);
hYLabel = ylabel(yLabel);


%% colorbar
caxis(cLims);
hcb = colorbar('location','EastOutside');
hcLabel = ylabel(hcb,zLabel);
set(hcb,'Ytick', [0,cLims(2)])
% % set(hcb,'YTickLabel',0:0.2*cLims(2):cLims(2), 'Ytick', 0:0.2*cLims(2):cLims(2))
set(hcb,'YTickMode','manual')
set(hcb, ...
  'Box'         , 'on'     , ...
  'TickDir'     , 'in'     , ...
  'TickLength'  , 0.015 , ...
  'LineWidth'   , 0.6);


%% set properties for all handles
set([gca, hcb, hTitle, hXLabel, hYLabel, hcLabel], ...
    'FontSize'   , FontSize    , ...
    'FontName'   , FontName);


%% last 'bug' fixes

% bring axis on top again (fix matlab bug)
set(gca,'Layer', 'top');

%% export
drawnow

SaveDir = '';

if (doExportPlot)
    IMAGENAME = [SaveDir SaveName]; 
    print(hfig, ['-r' num2str(400)], [IMAGENAME '.jpg' ], ['-d' 'jpeg']);
%     print(hfig, ['-r' num2str(400)], [IMAGENAME '.svg' ], ['-d' 'svg']);  
%     crop([IMAGENAME '.png']);
%     display('finished plot export')
end

% close(hfig);

    