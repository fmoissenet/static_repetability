% Author       : Florent Moissenet
% License      : Creative Commons Attribution-NonCommercial 4.0 International License 
%                https://creativecommons.org/licenses/by-nc/4.0/legalcode
% Source code  : https://github.com/fmoissenet/static_repetability
% Reference    : Not applicable
% Date         : October 2021
% -------------------------------------------------------------------------
% Description  : Main routine used to compute inverse kinematics
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
Folder.data         = 'C:\Users\moissene\OneDrive - unige.ch\2021 - SOFAMEA - Static marker variability\Static_Repetability_Toolbox\data\';
Folder.dependencies = [Folder.toolbox,'dependencies\'];
addpath(Folder.toolbox);
addpath(genpath(Folder.dependencies));

% -------------------------------------------------------------------------
% LOAD C3D FILES
% -------------------------------------------------------------------------
disp('Extract data from C3D files');

% Extract data from C3D files
cd(Folder.data);
c3dFiles = dir('*.c3d');
for i = 1:size(c3dFiles,1)
    disp(['  - ',c3dFiles(i).name]);
    Static(i).file    = c3dFiles(i).name;
    Static(i).btk     = btkReadAcquisition(c3dFiles(i).name);
    Static(i).n0      = btkGetFirstFrame(Static(i).btk);
    Static(i).n1      = btkGetLastFrame(Static(i).btk)-Static(i).n0+1;
    Static(i).fmarker = btkGetPointFrequency(Static(i).btk);
    if i == 1 % Same information in all statics of a same participant
        temp               = btkGetMetaData(Static(i).btk);    
        Participant.id     = temp.children.PARTICIPANT.children.VALUES.info.values{1};
        Participant.gender = temp.children.PARTICIPANT.children.VALUES.info.values{2};
        Participant.age    = str2num(temp.children.PARTICIPANT.children.VALUES.info.values{3});
        Participant.height = str2num(temp.children.PARTICIPANT.children.VALUES.info.values{4});
        Participant.weight = str2num(temp.children.PARTICIPANT.children.VALUES.info.values{5});
        clear temp;
    end
end
clear i c3dFiles;

% -------------------------------------------------------------------------
% BUILD MODEL
% -------------------------------------------------------------------------
disp('Compute inverse kinematics');

% Define the Static to be used as measured marker position
iStatic = 1;

% Define body segments
Marker                  = btkGetMarkers(Static(iStatic).btk);
Static(iStatic).Segment = [];
Static(iStatic)         = InitialiseSegments(Static(iStatic));
Static(iStatic)         = DefineSegments_ISB(Marker,Static(iStatic));
clear Marker;

% Prepare the Segment structure used to define the local marker position
% based on Static 1
for i = 1:9
    Segment(i).Q   = Static(iStatic).Segment(i).Q;
    Segment(i).rM  = Static(iStatic).Segment(i).rM;
    Segment(i).wM  = Static(iStatic).Segment(i).wM;
    Segment(i).rM0 = Static(iStatic).Segment(i).rM; % Store as initial posture before correction
end

% Compute local marker position in each segment (nM)
Segment = Multibody_Optimisation_SSS_Static(Segment);

% -------------------------------------------------------------------------
% PROCESS INVERSE KINEMATICS
% -------------------------------------------------------------------------

% Define the Static to be used as measured marker position
iStatic = 2;

% Define body segments
Marker                  = btkGetMarkers(Static(iStatic).btk);
Static(iStatic).Segment = [];
Static(iStatic)         = InitialiseSegments(Static(iStatic));
Static(iStatic)         = DefineSegments_ISB(Marker,Static(iStatic));
clear Marker;

% Prepare the Segment structure used to define the global marker position
% based on Static 2
for i = 1:9
    Segment(i).Q   = Static(iStatic).Segment(i).Q;
    Segment(i).rM  = Static(iStatic).Segment(i).rM;
    Segment(i).rMl = Static(iStatic).Segment(i).rMl;
    Segment(i).wM  = Static(iStatic).Segment(i).wM;
end
n = size(Segment(2).rM,3);

% Inverse kinematics
Segment = Multibody_Optimisation_SSS_Static(Segment);

% -------------------------------------------------------------------------
% PLOT RESULTS
% -------------------------------------------------------------------------
figure;
clc;
for i = 2:8
    for j = 1:size(Segment(i).rM,2)
        NMij = [Segment(i).nM(1,j)*eye(3),...
            (1 + Segment(i).nM(2,j))*eye(3), ...
            - Segment(i).nM(2,j)*eye(3), ...
            Segment(i).nM(3,j)*eye(3)];
        Segment(i).rM2(:,j,:) = Mprod_array3(repmat(NMij,[1,1,n]),Segment(i).Q);
        plot3(Segment(i).rM0(1,j),Segment(i).rM0(2,j),Segment(i).rM0(3,j),...
              'Marker','o','Color','black');
        hold on;
        axis equal;  
        plot3(Segment(i).rM(1,j),Segment(i).rM(2,j),Segment(i).rM(3,j),...
              'Marker','o','Color','red');
        plot3(Segment(i).rM2(1,j),Segment(i).rM2(2,j),Segment(i).rM2(3,j),...
              'Marker','x','Color','blue');        
        [Segment(i).rMl{j},' error (mm)']
        sqrt((Segment(i).rM2(1,j)-Segment(i).rM(1,j))^2+...
             (Segment(i).rM2(2,j)-Segment(i).rM(2,j))^2+...
             (Segment(i).rM2(3,j)-Segment(i).rM(3,j))^2)*1e3
        error(:,j,i) = Segment(i).rM2(:,j)-Segment(i).rM(:,j);
    end
end
disp(['Mean error (mm): ',num2str(1e3*mean(abs(error(:))))]);
disp(['Std  error (mm): ',num2str(1e3*std(abs(error(:))))]);
disp(['Max  error (mm): ',num2str(1e3*max(abs(error(:))))]);