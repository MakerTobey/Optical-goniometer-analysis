function AllSpectralPlotsReceptors(dataRef , dataSpec, theta, lambdaSpec, plotname, LIntv, sampleangle, plottedAnglularRange)
% Make one overall plot each (max. averaging)

load BeeEyeSpectra % load bee-eye receptor values

%% prepare data for use

% Reduce size of matrix to exclude sparsely sampled areas
plottedWLRange = [297 703]; %!% cut off for the interval of 300 and 700nm to match literature curves
thetaRegion = ((theta<=plottedAnglularRange(2))&(theta>=plottedAnglularRange(1)));%((theta<=91)&(theta>=-91));
lambdaRegion =  ((lambdaSpec<=plottedWLRange(2))&(lambdaSpec>=plottedWLRange(1)));

% size(theta)
% size(dataRef)
% size(dataSpec)
theta(not(thetaRegion)) = [];
lambdaSpec(not(lambdaRegion)) = [];
dataRef(not(thetaRegion),:) = [];
dataRef(:,not(lambdaRegion)) = [];
dataSpec(not(thetaRegion),:) = [];
dataSpec(:,not(lambdaRegion)) = [];

% downsamle spectrum by integrating over each wavelength interval
%e.g. 297.5 to 302.5nm and assign the values to the wavelength vector in 5nm stepps.
dataRefCoarse = zeros(length(theta),length(Lambda)); %initialise
dataSpecCoarse = zeros(length(theta),length(Lambda)); %initialise
for n=1:length(Lambda)
    LambdaInterval = ((lambdaSpec<(Lambda(n)+2.5))&(lambdaSpec>=(Lambda(n)-2.5)));
    dataRefCoarse(:,n) = trapz(lambdaSpec(LambdaInterval),dataRef(:,LambdaInterval),2);
    dataSpecCoarse(:,n) = trapz(lambdaSpec(LambdaInterval),dataSpec(:,LambdaInterval),2);
end

%% integrate (weighted!!) over bee eye receptor curves

% normalise sentivitiy curves by their integral (= overall sensitivity of receptor)
uIFact = 1/trapz(Lambda, beeUV);% integral over sensitivity curve
bIFact = 1/trapz(Lambda, beeBlue);
gIFact = 1/trapz(Lambda, beeGreen);

% spectra weighted by bee-sentitivity curves
uWeightedRef = bsxfun(@times, dataRefCoarse, beeUV' *uIFact);
bWeightedRef = bsxfun(@times, dataRefCoarse, beeBlue' *bIFact);
gWeightedRef = bsxfun(@times, dataRefCoarse, beeGreen' *gIFact);
uWeightedSpec = bsxfun(@times, dataSpecCoarse, beeUV' *uIFact);
bWeightedSpec = bsxfun(@times, dataSpecCoarse, beeBlue' *bIFact);
gWeightedSpec = bsxfun(@times, dataSpecCoarse, beeGreen' *gIFact);

% actual integration
IntRef.u = trapz(Lambda, uWeightedRef');
IntRef.b = trapz(Lambda, bWeightedRef');
IntRef.g = trapz(Lambda, gWeightedRef');
IntSpec.u = trapz(Lambda, uWeightedSpec');
IntSpec.b = trapz(Lambda, bWeightedSpec');
IntSpec.g = trapz(Lambda, gWeightedSpec');


%% integrate over angular intervals

% LIntv = 5; % interval length
% how many (uneven number to centre at 0!) intervals fit into the present angular range?
NrIntvLeft = -ceil( (theta(1)+(0.5*LIntv))/LIntv );
NrIntvRight = floor( (theta(end)-(0.5*LIntv))/LIntv );
NrIntv = NrIntvLeft + NrIntvRight +1;
ThetaCoarse = (-NrIntvLeft*LIntv):LIntv:(NrIntvRight*LIntv);

SNames = fieldnames(IntSpec); % load structure names into array
% initialise structures:
for i = 1:numel(SNames) % for each structure element in data
    IntRefCoarse.(SNames{i}) = zeros(1,NrIntv);
    IntSpecCoarse.(SNames{i}) = zeros(1,NrIntv);
end

if NrIntv>=3
    
    for n = 1:NrIntv; % for all angular intervals    
        for i = 1:numel(SNames) % for each structure element in data
            % integrate over values for included angles only:
            IndexIntv = ( (theta>=(ThetaCoarse(n)-(LIntv/2)))&...
                (theta<=(ThetaCoarse(n)+(LIntv/2))) );
            IntRefCoarse.(SNames{i})(n) = trapz(IntRef.(SNames{i})(IndexIntv),2); 
            IntSpecCoarse.(SNames{i})(n) = trapz(IntSpec.(SNames{i})(IndexIntv),2);
        end
    end
 
    %% make angular plots for the COARSE 6 integral curves

    xAxis = cosd(ThetaCoarse+270); % theta; %Decide on scaling of angular axsis: theta or cosd(thetaC+270) 
    % yAxis = Lambda; data = bWeightedRef; cLims = [0 CLimsManual*5];% zLabel = 'intensity';yTick = 300:100:700;
    yLabel = [];%'photo-stimmulation of receptor';
    xLabel = 'scattering angle (degree)'; %'cos of scattering angle';
    xTick = cosd((-60:10:60)+270); % -60:30:60;
    xTickLabel = {'' '' -40 '' -20 -10 0 10 20 '' 40 '' ''}; % or leave emty: []
    xLim = [cosd(ThetaCoarse(1) +270 -(LIntv/2)) cosd(ThetaCoarse(end) +270 +(LIntv/2))];

    Legend = [{'Parallel uv'} {'Parallel blue'} {'Parallel green'} {'Perpendicular uv'} {'Perp. blue'} {'Perp. green'}];
    SaveName = strcat(plotname, '_receptor_stimulation_coarse');
    Title = ''; % this is supposed to stay empty!! %[plotname ' far field propagation ' num2str(m)];
%Coarse
    NiceReceptorPlotComparisonCoarse(IntRefCoarse, IntSpecCoarse, xAxis, xLabel, yLabel, xTick, xTickLabel, xLim, Title, Legend, SaveName);

else
    disp('Angular interval is too large!')
end    
    

