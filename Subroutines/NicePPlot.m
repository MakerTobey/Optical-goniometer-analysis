function NicePPlot(xAxis, yAxis, Data2D, cLims, xLabel, yLabel, zLabel, xTick, yTick, xTickLabel, Title, SaveName)
% make a publishable plot and save

%% Common variables

FontSize = 12;
FontName = 'MyriadPro-Regular'; % or choose any other font

doExportPlot = true;


%% start plot

% figure dimensions in cm. If figure is display in
% document much smaller increase the fontsize.

figure_width = 10;
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
  

%% plot
pcolor(xAxis, yAxis, Data2D)


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

set(gca,'Layer', 'top'); % bring axis on top again (fix matlab bug)


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

    
