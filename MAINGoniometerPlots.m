%% Tobey's script to plot optical goniometer data

%%%%%%% load data %%%%%%%
% addpath('C:\Users\...(path)'); % repository of the data file, if not identical with folder of this script
load('flowerscans2.mat'); % load matlab data file

%%%%%%% data type %%%%%%%
% Choose two (each) specific datasets which to compare scans (perpendicular
%(Spec) vs  parallel (Ref) to striations). Perpendicular (Spec) needs to be
% the FIRST, and parallel (Ref) the SECOND number!
% Both datasets must have the same angular range.
pairs = [[2 1];[3 4];[6 5];[7 8];[9 12];[10 13];[11 14];[15 16];...
    [17 18];[19 20];[21 22];[23 24];[25 26];[27 28];[29 30];...
    [31 32];[33 34];[35 36];[37 38]];

%%% settings
plottedAnglularRange = [-60 60]; % graph plotted between the angles if the data is available
plottedWLRange = [280 720]; % range of wavelengths plotted
addpath('Subroutines'); % include the folder "Subroutines" with custom functions and scripts


%% Make "Goniometer" plot (for each measurement)

% disply pair numbers
Selection = sort(reshape(pairs,[numel(pairs) 1]));
disp('selected pairs - order and scan numbers:')
disp([(1:size(pairs,1))' pairs]);

%%% set initial colour scale maximum for all measurements
CLimsManual = zeros(length(flowerscans2),1); %initiatlise
    for i = 1:length(flowerscans2);
        CLimsManual(i)= flowerscans2(i).clim;
    end
%%%%%%% set maximum of colour scale manually where needed
%     CLimsManual(pairs(1,:)) = 0.32;
%     CLimsManual(pairs(2,:)) = 0.35;
%     CLimsManual(pairs(3,:)) = 0.45;
%     CLimsManual(pairs(4,:)) = 0.52;
%     CLimsManual(pairs(5,:)) = 1.6;
%     CLimsManual(pairs(6,:)) = 2;
%     CLimsManual(pairs(7,:)) = 2;
%     CLimsManual(pairs(8,:)) = 0.6;
%     CLimsManual(pairs(9,:)) = 0.6;
%     CLimsManual(pairs(10,:)) = 0.8;
%     CLimsManual(pairs(11,:)) = 1.3;
%     CLimsManual(pairs(12,:)) = 1.5;
%     CLimsManual(pairs(13,:)) = 0.35;
%     CLimsManual(pairs(14,:)) = 0.40;
%     CLimsManual(pairs(15,:)) = 0.55;
%     CLimsManual(pairs(16,:)) = 1.8;
%     CLimsManual(pairs(17,:)) = 0.68;
%     CLimsManual(pairs(18,:)) = 0.8;
%     CLimsManual(pairs(19,:)) = 1.2;
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% plot data as heatmap for each selected measurement
for i = Selection';
    [PairNr,~] = find(pairs==i); % determine which pair is currently run (for file name)
    GoniometerPlots(flowerscans2(i),i,plottedAnglularRange, plottedWLRange, CLimsManual, PairNr);
end

       
%% Make angular bee-sensitivity plot, integrating over weighted wavelength intervals

%%% settings
plottedAnglularRange = [-57.5 57.5]; % graph plotted between the angles, if the data is available
thetastep = 5; % angular step size in degree, as plotted in final graphs

for n = 1:length(pairs) % selection, pair by pair
    PairN = pairs(n,:);

    % load, adjust and read out settings
    dataRef = flowerscans2(PairN(2)).thedata.spec' *CLimsManual(PairN(1));
    dataSpec = flowerscans2(PairN(1)).thedata.spec' *CLimsManual(PairN(1));
    lambda = flowerscans2(PairN(1)).thedata.wl(:,1);
    theta = flowerscans2(PairN(1)).thedata.detectorangle -(flowerscans2(PairN(1)).thedata.sampleangle(1) *2); % set direct surface reflection angle to zero

    % include dataset characteristics into filename
    plotname = strcat('pair',num2str(n),'_',flowerscans2(PairN(1)).name,'_angle_',num2str(flowerscans2(PairN(1)).thedata.sampleangle(1)));
    
    %plot
    AllSpectralPlotsReceptors(dataRef, dataSpec, theta, lambda, plotname, thetastep, flowerscans2(PairN(1)).thedata.sampleangle(1), plottedAnglularRange);
end
