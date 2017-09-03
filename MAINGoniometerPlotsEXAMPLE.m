%% Tobey's script to plot optical goniometer data

%%%%%%% load data %%%%%%%
% addpath('C:\Users\tw347\ownCloud\FLOWERS'); % repository of the data file, if not identical with folder of this script
load('scan170503PeonQOTN.mat'); % load matlab data file

%%%%%%% data type %%%%%%%
FlowerName = 'Peonia'; % used for plots
pairs = [[44 49];[54 59];[35 50];[55 60];[43 48];[53 58];[46 51];[56 61];[47 52];[57 62]]; % data selection to be processed.
% Choose two (each) specific datasets which to compare scans (perpendicular
%(Spec) vs  parallel (Ref) to striations). Perpendicular (Spec) needs to be
% the FIRST, and parallel (Ref) the SECOND number!
% Both datasets must have the same angular range.

%%% settings
plottedAnglularRange = [-60 60]; % graph plotted between the angles if the data is available
plottedWLRange = [299 702]; % range of wavelengths plotted
addpath(Subroutines); % include the folder "Subroutines" with custom functions and scripts


%% Make "Goniometer" plot (for each measurement)

% prepare data for use and disply pairs
Selection = sort(reshape(pairs,[numel(pairs) 1]));
disp('selected pairs - order and scan numbers:')
disp([(1:size(pairs,1))' pairs]);

%%% set initial colour scale maximum for all measurements
CLimsManual = ones(length(Selection)) * 0.22;

%%%%%%% set maximum of colour scale manually where needed
CLimsManual(pairs(1,:)) = 0.18;
% CLimsManual(pairs(2,:)) = 0.14;
% CLimsManual(pairs(3,:)) = 0.14;
% CLimsManual(pairs(4,:)) = 0.3;
% CLimsManual(pairs(5,:)) = 0.14;
% CLimsManual(pairs(6,:)) = 0.35;
CLimsManual(pairs(7,:)) = 0.30;
CLimsManual(pairs(8,:)) = 0.30;
% CLimsManual(pairs(9,:)) = 0.35;
% CLimsManual(pairs(10,:)) = 0.35;
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% plot for each selected measurement
for i = Selection';
    [PairNr,~] = find(pairs==i); % determine which pair is currently run (for file name)
    GoniometerPlots(scan(i),i, FlowerName, 1, plottedAnglularRange, plottedWLRange, CLimsManual, PairNr);
end

       
%% Make angular bee-sensitivity plot, integrating over weighted wavelength intervals

%%% settings
plottedAnglularRange = [-57.5 57.5]; % graph plotted between the angles, if the data is available
thetastep = 5; % angular step size in degree

for n = 1:length(pairs) % selection, pair by pair
    PairN = pairs(n,:);

    % load, adjust and read out settings
    dataRef = scan(PairN(2)).spec' *CLimsManual(PairN(1));
    dataSpec = scan(PairN(1)).spec' *CLimsManual(PairN(1));
    lambda = scan(PairN(1)).wl(:,1);
    theta = scan(PairN(1)).detectorangle -(scan(PairN(1)).sampleangle(1) *2); % set direct surface reflection angle to zero
    
    plotname = strcat('pair',num2str(n),'_scan_',num2str(PairN(1)),'_angle_',num2str(scan(PairN(1)).sampleangle(1))); % include dataset characteristics into filename
    
    %plot
    AllSpectralPlotsReceptors(dataRef, dataSpec, theta, lambda, plotname, thetastep, scan(PairN(1)).sampleangle(1), plottedAnglularRange);
end
