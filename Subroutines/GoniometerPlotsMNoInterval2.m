function GoniometerPlotsMNoInterval2(flowerscan,i, FlowerName, decreaseFact0Order, plottedAnglularRange, plottedWLRange,  CLimsManual)
% Make "Goniometer" plots
% crop, assign, plot

data = flowerscan.spec';
theta = flowerscan.detectorangle -(flowerscan.sampleangle(1) *2);
lambda = flowerscan.wl(:,1);


%% Smooth data with a span of 7% of the data points
% AA = mslowess(lambda*1E9,ReflAv','Order', 0, 'Span', 0.15, 'Kernel', 'linear');
%%%%CHANGED%%%%
% AA = %mslowess(theta,ReflAv,'Order', 2, 'Span', 0.05, 'Kernel', 'gaussian');


%% Reduce specular reflection intensity X-fold
thetaSpecular = ((theta<=3)&(theta>=-3));
data(thetaSpecular,:) = data(thetaSpecular,:)/decreaseFact0Order;


%% Reduce size of matrix to exclude sparsely sampled areas
thetaRegion = ((theta<=plottedAnglularRange(2))&(theta>=plottedAnglularRange(1)));%((theta<=91)&(theta>=-91));
lambdaRegion =  ((lambda<=plottedWLRange(2))&(lambda>=plottedWLRange(1)));

data(not(thetaRegion),:) = [];
theta(not(thetaRegion)) = [];

data(:,not(lambdaRegion)) = [];
lambda(not(lambdaRegion)) = [];


%% make "gonimeter" plots
xAxis = cosd(theta+270); % theta; %Decide on scaling of angular axsis: theta or cosd(thetaC+270) 
yAxis = lambda;
% data = data;
cLims = [0 CLimsManual(i)]; %flowerscan.clim %cLims = [0 1.5E-4]; % set colour scale limits  %[0 0.9E-4];
yLabel = 'wavelength (nm)';
xLabel = 'scattering angle (degree)'; %'cos of scattering angle';
zLabel = 'intensity';
xTick = cosd((-90:10:90)+270); % -60:30:60;
xTickLabel = {'' '' -70 '' '' -40 '' -20 -10 0 10 20 '' 40 '' '' 70 '' ''}; % or leave emty: []
yTick = 300:100:700;
Title = ''; % this is supposed to stay empty!! %[plotname ' far field propagation ' num2str(m)];
SaveName = strcat(num2str(i), '_', FlowerName,'_angle_',num2str(flowerscan.sampleangle(1)));

NicePPlotNoInterval(xAxis, yAxis, data', cLims, xLabel, yLabel, zLabel, xTick, yTick, xTickLabel, Title, SaveName)
% NicePPlotNoIntervalNoAxis

end
