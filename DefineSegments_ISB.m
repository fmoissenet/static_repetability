% Author       : Florent Moissenet
% License      : Creative Commons Attribution-NonCommercial 4.0 International License 
%                https://creativecommons.org/licenses/by-nc/4.0/legalcode
% Source code  : https://github.com/fmoissenet/static_repetability
% Reference    : Not applicable
% Date         : October 2021
% -------------------------------------------------------------------------
% Description  : Define body segments coordinate systems and parameters
%                following ISB recommendations (adapted from Dumas and 
%                Wojtusch (2018): doi://10.1007/978-3-319-30808-1_147-1)
% -------------------------------------------------------------------------
% Dependencies : - 3D Kinematics and Inverse Dynamics toolbox by Raphaël Dumas: https://fr.mathworks.com/matlabcentral/fileexchange/58021-3d-kinematics-and-inverse-dynamics?s_tid=prof_contriblnk
% -------------------------------------------------------------------------
% This work is licensed under the Creative Commons Attribution - 
% NonCommercial 4.0 International License. To view a copy of this license, 
% visit http://creativecommons.org/licenses/by-nc/4.0/ or send a letter to 
% Creative Commons, PO Box 1866, Mountain View, CA 94042, USA.
% -------------------------------------------------------------------------

function Trial = DefineSegments_ISB(Marker,Trial)

% -------------------------------------------------------------------------
% Kinematic chain used:
% Right foot > Right tibia > Right femur > Pelvis > Left femur > Left tibia
% > Left foot
% -------------------------------------------------------------------------

% -------------------------------------------------------------------------
% Right foot parameters
% -------------------------------------------------------------------------
% Marker trajectories
RHEE    = permute(Marker.RHEE,[2,3,1]);
RFMH    = permute(Marker.RFMH,[2,3,1]);
RVMH    = permute(Marker.RVMH,[2,3,1]);
RAJC    = permute(Marker.RAJC,[2,3,1]);
RMJC    = permute(Marker.RMJC,[2,3,1]);
RFOOT_X = permute(Marker.RFOOT_X,[2,3,1]);
RFOOT_Y = permute(Marker.RFOOT_Y,[2,3,1]);
RFOOT_Z = permute(Marker.RFOOT_Z,[2,3,1]);
% Foot axes
X2 = Vnorm_array3(RFOOT_X-RAJC);
Y2 = Vnorm_array3(RFOOT_Y-RAJC);
Z2 = Vnorm_array3(RFOOT_Z-RAJC); 
% Foot parameters (Dumas and Chèze 2007)
rP2                  = RAJC;
rD2                  = RMJC;
w2                   = Z2;
u2                   = X2;
Trial.Segment(2).Q   = [u2;rP2;rD2;w2];
Trial.Segment(2).rM  = [RHEE,RFMH,RVMH];
Trial.Segment(2).rMl = {'RHEE','RFMH','RVMH'};
Trial.Segment(2).wM  = [1,1,1,... % Optimisation weights, along X-Y-Z directions for each marker
                        1,1,1,...
                        1,1,1];

% -------------------------------------------------------------------------
% Right Tibia/fibula parameters
% -------------------------------------------------------------------------
% Marker trajectories
RFAX     = permute(Marker.RFAX,[2,3,1]);
RTTA     = permute(Marker.RTTA,[2,3,1]);
RANK     = permute(Marker.RANK,[2,3,1]);
RMED     = permute(Marker.RMED,[2,3,1]);
RKJC     = permute(Marker.RKJC,[2,3,1]);
RTIBIA_X = permute(Marker.RTIBIA_X,[2,3,1]);
RTIBIA_Y = permute(Marker.RTIBIA_Y,[2,3,1]);
RTIBIA_Z = permute(Marker.RTIBIA_Z,[2,3,1]);
% Tibia/fibula axes
X3 = Vnorm_array3(RTIBIA_X-RKJC);
Y3 = Vnorm_array3(RTIBIA_Y-RKJC);
Z3 = Vnorm_array3(RTIBIA_Z-RKJC); 
% Tibia/fibula parameters (Dumas and Chèze 2007)
rP3                  = RKJC;
rD3                  = RAJC;
w3                   = Z3;
u3                   = X3;
Trial.Segment(3).Q   = [u3;rP3;rD3;w3];
Trial.Segment(3).rM  = [RFAX,RTTA,RANK,RMED];
Trial.Segment(3).rMl = {'RFAX','RTTA','RANK','RMED'};
Trial.Segment(3).wM  = [1,1,1,... % Optimisation weights, along X-Y-Z directions for each marker
                        1,1,1,...
                        1,1,1,...
                        1,1,1]*1e4;

% -------------------------------------------------------------------------
% Right femur parameters
% -------------------------------------------------------------------------
% Marker trajectories
RGTR     = permute(Marker.RGTR,[2,3,1]);
RKNE     = permute(Marker.RKNE,[2,3,1]);
RKNM     = permute(Marker.RKNM,[2,3,1]);
RHJC     = permute(Marker.RHJC,[2,3,1]);
RFEMUR_X = permute(Marker.RFEMUR_X,[2,3,1]);
RFEMUR_Y = permute(Marker.RFEMUR_Y,[2,3,1]);
RFEMUR_Z = permute(Marker.RFEMUR_Z,[2,3,1]);
% Femur axes
X4 = Vnorm_array3(RFEMUR_X-RHJC);
Y4 = Vnorm_array3(RFEMUR_Y-RHJC);
Z4 = Vnorm_array3(RFEMUR_Z-RHJC);
% Femur parameters (Dumas and Chèze 2007)
rP4                  = RHJC;
rD4                  = RKJC;
w4                   = Z4;
u4                   = X4;
Trial.Segment(4).Q   = [u4;rP4;rD4;w4];
Trial.Segment(4).rM  = [RGTR,RKNE,RKNM];
Trial.Segment(4).rMl = {'RGTR','RKNE','RKNM'};
Trial.Segment(4).wM  = [1,1,1,... % Optimisation weights, along X-Y-Z directions for each marker
                        1,1,1,...
                        1,1,1];

% -------------------------------------------------------------------------
% Pelvis parameters
% -------------------------------------------------------------------------
% Marker trajectories
RASI     = permute(Marker.RASI,[2,3,1]);
LASI     = permute(Marker.LASI,[2,3,1]);
RPSI     = permute(Marker.RPSI,[2,3,1]);
LPSI     = permute(Marker.LPSI,[2,3,1]);
LJC      = permute(Marker.LJC,[2,3,1]);
LHJC     = permute(Marker.LHJC,[2,3,1]);
midASIS  = permute(Marker.midASIS,[2,3,1]);
PELVIC_X = permute(Marker.PELVIC_X,[2,3,1]);
PELVIC_Y = permute(Marker.PELVIC_Y,[2,3,1]);
PELVIC_Z = permute(Marker.PELVIC_Z,[2,3,1]);
% Pelvis axes
X5 = Vnorm_array3(PELVIC_X-midASIS);
Y5 = Vnorm_array3(PELVIC_Y-midASIS);
Z5 = Vnorm_array3(PELVIC_Z-midASIS);
% Pelvis parameters (Dumas and Chèze 2007)
rP5                  = LJC;
rD5                  = (RHJC+LHJC)/2;
w5                   = Z5;
u5                   = X5;
Trial.Segment(5).Q   = [u5;rP5;rD5;w5];
Trial.Segment(5).rM  = [RASI,LASI,RPSI,LPSI];
Trial.Segment(5).rMl = {'RASI','LASI','RPSI','LPSI'};
Trial.Segment(5).wM  = [1,1,1,... % Optimisation weights, along X-Y-Z directions for each marker
                        1,1,1,...
                        1,1,1,...
                        1,1,1];

% -------------------------------------------------------------------------
% Left femur parameters
% -------------------------------------------------------------------------
% Marker trajectories
LGTR     = permute(Marker.LGTR,[2,3,1]);
LKNE     = permute(Marker.LKNE,[2,3,1]);
LKNM     = permute(Marker.LKNM,[2,3,1]);
LKJC     = permute(Marker.LKJC,[2,3,1]);
LFEMUR_X = permute(Marker.LFEMUR_X,[2,3,1]);
LFEMUR_Y = permute(Marker.LFEMUR_Y,[2,3,1]);
LFEMUR_Z = permute(Marker.LFEMUR_Z,[2,3,1]);
% Femur axes
X6 = Vnorm_array3(LFEMUR_X-LHJC);
Y6 = Vnorm_array3(LFEMUR_Y-LHJC);
Z6 = Vnorm_array3(LFEMUR_Z-LHJC);
% Femur parameters (Dumas and Chèze 2007)
rP6                  = LKJC; % Continuity of the right leg kinematic chain
rD6                  = LHJC; % Continuity of the right leg kinematic chain
w6                   = Z6;
u6                   = X6;
Trial.Segment(6).Q   = [u6;rP6;rD6;w6];
Trial.Segment(6).rM  = [LGTR,LKNE,LKNM];
Trial.Segment(6).rMl = {'LGTR','LKNE','LKNM'};
Trial.Segment(6).wM  = [1,1,1,... % Optimisation weights, along X-Y-Z directions for each marker
                        1,1,1,...
                        1,1,1];

% -------------------------------------------------------------------------
% Left Tibia/fibula parameters
% -------------------------------------------------------------------------
% Marker trajectories
LFAX     = permute(Marker.LFAX,[2,3,1]);
LTTA     = permute(Marker.LTTA,[2,3,1]);
LANK     = permute(Marker.LANK,[2,3,1]);
LMED     = permute(Marker.LMED,[2,3,1]);
LAJC     = permute(Marker.LAJC,[2,3,1]);
LTIBIA_X = permute(Marker.LTIBIA_X,[2,3,1]);
LTIBIA_Y = permute(Marker.LTIBIA_Y,[2,3,1]);
LTIBIA_Z = permute(Marker.LTIBIA_Z,[2,3,1]);
% Tibia/fibula axes
X7 = Vnorm_array3(LTIBIA_X-LKJC);
Y7 = Vnorm_array3(LTIBIA_Y-LKJC);
Z7 = Vnorm_array3(LTIBIA_Z-LKJC); 
% Tibia/fibula parameters (Dumas and Chèze 2007)
rP7                  = LAJC; % Continuity of the right leg kinematic chain
rD7                  = LKJC; % Continuity of the right leg kinematic chain
w7                   = Z7;
u7                   = X7;
Trial.Segment(7).Q   = [u7;rP7;rD7;w7];
Trial.Segment(7).rM  = [LFAX,LTTA,LANK,LMED];
Trial.Segment(7).rMl = {'LFAX','LTTA','LANK','LMED'};
Trial.Segment(7).wM  = [1,1,1,... % Optimisation weights, along X-Y-Z directions for each marker
                        1,1,1,...
                        1,1,1,...
                        1,1,1];

% -------------------------------------------------------------------------
% Left foot parameters
% -------------------------------------------------------------------------
% Marker trajectories
LHEE    = permute(Marker.LHEE,[2,3,1]);
LFMH    = permute(Marker.LFMH,[2,3,1]);
LVMH    = permute(Marker.LVMH,[2,3,1]);
LMJC    = permute(Marker.LMJC,[2,3,1]);
LFOOT_X = permute(Marker.LFOOT_X,[2,3,1]);
LFOOT_Y = permute(Marker.LFOOT_Y,[2,3,1]);
LFOOT_Z = permute(Marker.LFOOT_Z,[2,3,1]);
% Foot axes
X8 = Vnorm_array3(LFOOT_X-LAJC);
Y8 = Vnorm_array3(LFOOT_Y-LAJC);
Z8 = Vnorm_array3(LFOOT_Z-LAJC); 
% Foot parameters (Dumas and Chèze 2007)
rP8                  = LMJC; % Continuity of the right leg kinematic chain
rD8                  = LAJC; % Continuity of the right leg kinematic chain
w8                   = Z8;
u8                   = X8;
Trial.Segment(8).Q   = [u8;rP8;rD8;w8];
Trial.Segment(8).rM  = [LHEE,LFMH,LVMH];
Trial.Segment(8).rMl = {'LHEE','LFMH','LVMH'};
Trial.Segment(8).wM  = [1,1,1,... % Optimisation weights, along X-Y-Z directions for each marker
                        1,1,1,...
                        1,1,1];