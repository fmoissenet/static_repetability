% Author       : Florent Moissenet
% License      : Creative Commons Attribution-NonCommercial 4.0 International License 
%                https://creativecommons.org/licenses/by-nc/4.0/legalcode
% Source code  : https://github.com/fmoissenet/static_repetability
% Reference    : Not applicable
% Date         : October 2021
% -------------------------------------------------------------------------
% Description  : Export new C3D files
% -------------------------------------------------------------------------
% Dependencies : None
% -------------------------------------------------------------------------
% This work is licensed under the Creative Commons Attribution - 
% NonCommercial 4.0 International License. To view a copy of this license, 
% visit http://creativecommons.org/licenses/by-nc/4.0/ or send a letter to 
% Creative Commons, PO Box 1866, Mountain View, CA 94042, USA.
% -------------------------------------------------------------------------

function ExportC3D(Trial,Participant,Session,Folder)

% Set new C3D file
nframe  = 20; % Number of frames in the new c3d files
btkFile = btkNewAcquisition();
btkSetFrequency(btkFile,Trial.fmarker);
btkSetFrameNumber(btkFile,nframe);
btkSetPointsUnit(btkFile,'marker','m');
btkSetAnalogSampleNumberPerFrame(btkFile,10);

% Append marker trajectories
if ~isempty(Trial.Marker)
    for i = 1:size(Trial.Marker,2)
        if ~isempty(Trial.Marker(i).Trajectory.smooth)
            btkAppendPoint(btkFile,'marker',Trial.Marker(i).label,repmat(Trial.Marker(i).Trajectory.smooth,[nframe,1]));
        else
            btkAppendPoint(btkFile,'marker',Trial.Marker(i).label,zeros(nframe,3));
        end
    end
end

% Append virtual marker trajectories
if ~isempty(Trial.Vmarker)
    for i = 1:size(Trial.Vmarker,2)
        if ~isempty(Trial.Vmarker(i).Trajectory.smooth)
            btkAppendPoint(btkFile,'marker',Trial.Vmarker(i).label,repmat(Trial.Vmarker(i).Trajectory.smooth,[nframe,1]));
        else
            btkAppendPoint(btkFile,'marker',Trial.Vmarker(i).label,zeros(nframe,3));
        end
    end
end

% Append participant metadata
nData = 5;
info.format = 'Integer';
info.values = nData;
btkAppendMetaData(btkFile,'PARTICIPANT','USED',info);
clear info;
info.format = 'Char';
info.dimensions = ['1x',nData];
info.values(1:nData) = {'id' 'gender' 'age' 'height' 'weight'};
btkAppendMetaData(btkFile,'PARTICIPANT','LABELS',info);
clear info;
info.format = 'Char';
info.dimensions = ['1x',nData];
info.values(1:nData) = {'adimensioned' 'adimensioned (1: male, 2: female)' 'years' 'cm' 'kg'};
btkAppendMetaData(btkFile,'PARTICIPANT','UNITS',info);
clear info;
info.format          = 'Char';
info.dimensions      = ['1x',nData];
info.values(1:nData) = {Participant.id Participant.gender num2str(Participant.age) num2str(Participant.height) num2str(Participant.weight)};
btkAppendMetaData(btkFile,'PARTICIPANT','VALUES',info);

% Append session metadata
nData                = 1;
info.format          = 'Integer';
info.values          = nData;
btkAppendMetaData(btkFile,'SESSION','USED',info);
clear info;
info.format          = 'Char';
info.dimensions      = ['1x',nData];
info.values(1:nData) = {'markerHeight'};
btkAppendMetaData(btkFile,'SESSION','LABELS',info);
clear info;
info.format          = 'Char';
info.dimensions      = ['1x',nData];
info.values(1:nData) = {'m'};
btkAppendMetaData(btkFile,'SESSION','UNITS',info);
clear info;
info.format          = 'Char';
info.dimensions      = ['1x',nData];
info.values(1:nData) = {num2str(Session.markerHeight)};
btkAppendMetaData(btkFile,'SESSION','VALUES',info);

% Export C3D file
cd([Folder.data,'output\']);
btkWriteAcquisition(btkFile,[regexprep(Trial.file,'.c3d',''),'_processed.c3d']);