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

masterframes.framenames = {'dealcard','movecard'}; % this list will correspond to the 'thisframe' selfdescription to distuinguish between (no-slots) frames

% -----------------------------------------------------------------------------
% -----------------------------------------------------------------------------
% -----------------------------------------------------------------------------

% FRAME 1:
frameid=1;
masterframes.frame(frameid).data={}; % this frame has no slots

% FRAME 2:
frameid=2;

% ---- slots ------------

masterframes.frame(frameid).data.from_suit={'s','d','h','c'}; % the card to be moved, card suit (spades, diamonds, hearts, clubs)
masterframes.frame(frameid).data.from_value=vec2str(1:13); % the card to be moved, card value

masterframes.frame(frameid).data.target_suit={'s','d','h','c'}; % the target card, card suit (spades, diamonds, hearts, clubs)
masterframes.frame(frameid).data.target_value=vec2str(1:13); % the target card, card value

masterframes.frame(frameid).data.from_foundation=vec2str(1:4); % the card to be moved, foundation column  1-4
masterframes.frame(frameid).data.target_foundation=vec2str(1:4); % the target position, foundation column  1-4

masterframes.frame(frameid).data.from_fieldcol=vec2str(1:7); % the card to be moved, field column  1-7
masterframes.frame(frameid).data.target_fieldcol= vec2str(1:7); % the target position, field column 1-7


masterframes.frame(frameid).data.from_hand={'1'}; % the card to be moved comes from the hand (flag)
%masterframes.frame(frameid).data.target_foundationempty={'1'}; % the target foundation is empty (flag)
%masterframes.frame(frameid).data.target_fieldcolempty={'1'}; % the target field column is empty