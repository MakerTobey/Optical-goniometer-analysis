function GoniometerPlots(flowerscan,i, plottedAnglularRange, plottedWLRange,  CLimsManual, PairNr)
% Make "Goniometer" plots
% crop, assign, plot

data = flowerscan.thedata.spec';
theta = flowerscan.thedata.detectorangle -(flowerscan.thedata.sampleangle(1) *2);
lambda = flowerscan.thedata.wl(:,1);


%% Reduce size of matrix to exclude sparsely sampled areas
thetaRegion = ((theta<=plottedAnglularRange(2))&(theta>=plottedAnglularRange(1)));%((theta<=91)&(theta>=-91));
lambdaRegion =  ((lambda<=plottedWLRange(2))&(lambda>=plottedWLRange(1)));

data(not(thetaRegion),:) = [];
theta(not(thetaRegion)) = [];

data(:,not(lambdaRegion)) = [];
lambda(not(lambdaRegion)) = [];


%% make "gonimeter" plots
xAxis = cosd(theta+270); %Decide on scaling of angular axsis: theta or cosd(thetaC+270) 
yAxis = lambda;
% data = data;
cLims = [0 CLimsManual(i)]; % set colour scale limits
yLabel = 'Wavelength (nm)';
xLabel = 'Scattering angle (degree)'; %'cos of scattering angle';
zLabel = 'Intensity';
xTick = cosd((-90:10:90)+270); % -60:30:60;
xTickLabel = {'' '' -70 '' '' -40 '' -20 -10 0 10 20 '' 40 '' '' 70 '' ''}; % or leave emty: []
yTick = 300:100:700;
Title = ''; % this is supposed to stay empty!
SaveName = strcat('pair',num2str(PairNr),'_scan_',num2str(i), '_', flowerscan.name,'_angle_',num2str(flowerscan.thedata.sampleangle(1)));

NicePPlot(xAxis, yAxis, data', cLims, xLabel, yLabel, zLabel, xTick, yTick, xTickLabel, Title, SaveName)

end
