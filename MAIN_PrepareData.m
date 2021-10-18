% Author       : Florent Moissenet
% License      : Creative Commons Attribution-NonCommercial 4.0 International License 
%                https://creativecommons.org/licenses/by-nc/4.0/legalcode
% Source code  : https://github.com/fmoissenet/static_repetability
% Reference    : Not applicable
% Date         : October 2021
% -------------------------------------------------------------------------
% Description  : Main routine used to prepare the dataset
% -------------------------------------------------------------------------
% Dependencies : - Biomechanical Toolkit: https://github.com/Biomechanical-ToolKit
% -------------------------------------------------------------------------
% This work is licensed under the Creative Commons Attribution - 
% NonCommercial 4.0 International License. To view a copy of this license, 
% visit http://creativecommons.org/licenses/by-nc/4.0/ or send a letter to 
% Creative Commons, PO Box 1866, Mountain View, CA 94042, USA.
% -------------------------------------------------------------------------

% -------------------------------------------------------------------------
% INIT THE WORKSPACE
% -------------------------------------------------------------------------
clearvars;
close all;
clc;

% -------------------------------------------------------------------------
% SET FOLDERS
% -------------------------------------------------------------------------
disp('Set folders');
Folder.toolbox      = 'C:\Users\moissene\OneDrive - unige.ch\2021 - SOFAMEA - Static marker variability\Static_Repetability_Toolbox\';
Folder.data         = 'C:\Users\moissene\OneDrive - unige.ch\2019 - NSCLBP - Biomarkers\Data\NSLBP-BIO\Data\NSLBP-BIO-029\20210707 - FWP_session\';
Folder.dependencies = [Folder.toolbox,'dependencies\'];
addpath(Folder.toolbox);
addpath(genpath(Folder.dependencies));

% -------------------------------------------------------------------------
% DEFINE PARTICIPANT
% -------------------------------------------------------------------------
disp('Set participant parameters');
Participant.id     = 'P29';
Participant.gender = 'Male'; % Female / Male
Participant.age    = 22; % yrs
Participant.height = 174.00; % cm
Participant.weight = 55.00; % kg

% -------------------------------------------------------------------------
% DEFINE SESSION
% -------------------------------------------------------------------------
disp('Set session parameters');
Session.markerHeight = 0.014; % m

% -------------------------------------------------------------------------
% LOAD C3D FILES
% -------------------------------------------------------------------------
disp('Extract data from C3D files');

% List all trial types
trialTypes = {'Static'};

% Extract data from C3D files
cd(Folder.data);
c3dFiles = dir('*.c3d');
k1       = 1;
for i = 1:size(c3dFiles,1)
    disp(['  - ',c3dFiles(i).name]);
    for j = 1:size(trialTypes,2)
        if ~isempty(strfind(c3dFiles(i).name,trialTypes{j}))
            Static(k1).type    = trialTypes{j};
            Static(k1).file    = c3dFiles(i).name;
            Static(k1).btk     = btkReadAcquisition(c3dFiles(i).name);
            Static(k1).n0      = btkGetFirstFrame(Static(k1).btk);
            Static(k1).n1      = btkGetLastFrame(Static(k1).btk)-Static(k1).n0+1;
            Static(k1).fmarker = btkGetPointFrequency(Static(k1).btk);
            Static(k1).fanalog = btkGetAnalogFrequency(Static(k1).btk);
            k1 = k1+1;
        end
    end
end
clear k1 c3dFiles trialTypes;

% -------------------------------------------------------------------------
% PRE-PROCESS DATA
% -------------------------------------------------------------------------

% Static data
disp('Pre-process static data');
for i = 1:size(Static,2)
    disp(['  - ',Static(i).file]);
        
    % Process marker trajectories
    Marker            = btkGetMarkers(Static(i).btk);
    Static(i).Marker  = [];
    Static(i).Vmarker = [];
    Static(i).Segment = [];
    Static(i).Joint   = [];
    Static(i)         = InitialiseMarkerTrajectories(Static(i),Marker);
    Static(i)         = InitialiseVmarkerTrajectories(Static(i));
    Static(i)         = ProcessMarkerTrajectories([],Static(i));
    Static(i)         = DefineVirtualMarkers(Participant,Static(i));
    clear Marker;
    
    % Store processed static data in a new C3D file
    mkdir('output');
    ExportC3D(Static(i),Participant,Session,Folder);
end