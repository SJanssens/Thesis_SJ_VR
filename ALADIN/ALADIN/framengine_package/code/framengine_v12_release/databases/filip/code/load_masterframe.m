% loads a struct containing the frame description with all possible frames
% and all their possible target values.

% frametags NOT described in the masterframe will be ignored during loading
% of descriptive/oracle frames, depending on the
% conf.settingconf.ignoremissingfield flag

function [masterframes] = load_masterframes(varargin)

% --- fields we will not be using ---
%actionframe.info.date=datestring; % date value
%actionframe.info.time=timestring; % time value
%actionframe.info.move=num2str(movecounter); % movecounter value

% -----------------------------------------------------------------------------
% -----------------------------------------------------------------------------
% -----------------------------------------------------------------------------

masterframes.framenames = {'move_abs','move_rel','turn_abs','turn_rel','grab','release','spin','drive',''}; % this list will correspond to the 'thisframe' selfdescription to distuinguish between (no-slots) frames

% -----------------------------------------------------------------------------
% -----------------------------------------------------------------------------
% -----------------------------------------------------------------------------

% FRAME 1 move_abs
frameid=1;

% -- slots ----
masterframes.frame(frameid).data.pos_x = vec2str(0:4); % x coord of target position
masterframes.frame(frameid).data.pos_y = vec2str(0:4); % y coord of target position

% FRAME 2 move_rel
frameid=2;

% -- slots ----
masterframes.frame(frameid).data.direction = {'f','b'}; % forward/backward
masterframes.frame(frameid).data.distance = vec2str(5:5:25); % distance to move (tenths of coordinate)

% FRAME 3 turn_abs
frameid=3;

% -- slots ----
masterframes.frame(frameid).data.angle = vec2str(0:45:360); % angle with the x axis

% FRAME 4 turn_rel
frameid=4;

% -- slots ----
masterframes.frame(frameid).data.direction = {'l','r'}; % left/right
masterframes.frame(frameid).data.angle = vec2str(45:45:180); % angle to turn

% FRAME 5 grab
frameid=5;

% -- slots ----
masterframes.frame(frameid).data = {}; % no slots

% FRAME 6 release
frameid=6;

% -- slots ----
masterframes.frame(frameid).data = {}; % no slots

% FRAME 7 spin
frameid=7;

% -- slots ----
masterframes.frame(frameid).data.direction = {'l','r'}; % left/right
masterframes.frame(frameid).data.duration = vec2str(1:3); % time to turn (seconds)

% FRAME 8 drive
frameid=8;

% -- slots ----
masterframes.frame(frameid).data.direction = {'f','b'}; % forward/backward
masterframes.frame(frameid).data.duration = vec2str(1:3); % time to drive

% FRAME 9 stop
frameid=9;

% -- slots ----
masterframes.frame(frameid).data = {}; % no slots

