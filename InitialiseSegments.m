% Author       : Florent Moissenet
% License      : Creative Commons Attribution-NonCommercial 4.0 International License 
%                https://creativecommons.org/licenses/by-nc/4.0/legalcode
% Source code  : https://github.com/fmoissenet/static_repetability
% Reference    : Not applicable
% Date         : October 2021
% -------------------------------------------------------------------------
% Description  : Initialise Segment structure
% -------------------------------------------------------------------------
% Dependencies : None
% -------------------------------------------------------------------------
% This work is licensed under the Creative Commons Attribution - 
% NonCommercial 4.0 International License. To view a copy of this license, 
% visit http://creativecommons.org/licenses/by-nc/4.0/ or send a letter to 
% Creative Commons, PO Box 1866, Mountain View, CA 94042, USA.
% -------------------------------------------------------------------------

function Trial = InitialiseSegments(Trial)

segmentLabels = {'Right forceplate','Right foot','Right tibia','Right femur',...
                 'Pelvis',...
                 'Left femur','Left tibia','Left foot','Left forceplate'};
             
for i = 1:length(segmentLabels)
    Trial.Segment(i).Q   = [];
    Trial.Segment(i).rM  = [];
    Trial.Segment(i).rMl = {};
    Trial.Segment(i).wM  = [];
end