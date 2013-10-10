% loads a struct containing the frame description with all possible frames
% and all their possible target values.

% frametags NOT described in the masterframe will be ignored during loading
% of descriptive/oracle frames, depending on the
% conf.settingconf.ignoremissingfield flag

function [masterframes] =load_masterframes(varargin)
masterframes.framenames = {'commando_triplets','aan_uit','open_dicht','verwarmingHoger','voeteinde'}; % this list will correspond to the 'thisframe' selfdescription to distuinguish between (no-slots) frames

% Frame 1
frameid=1;
masterframes.frame(frameid).data.object={'hoofdeindeStand', 'staandeLampStand'};
masterframes.frame(frameid).data.stand={'1','2','3'};	
% Frame 2 
frameid=2;
masterframes.frame(frameid).data.object={'badkamerlicht','slaapkamerlicht','keukenEnWoonkamerLicht','keukenlicht','keukenlichtFornuis', 'keukenlichtTafel','leeslamp','woonkamerlicht','alleLichten'};				

masterframes.frame(frameid).data.action={'Aan','Uit'};

% Frame 3
frameid=3;
masterframes.frame(frameid).data.object={'badkamerdeur','rolluikWoonkamerDeur','rolluikSlaapkamer','rolluikWoonkamerRaam','slaapkamerdeur','woonkamerDeur','voordeur','deurEnRolluikSlaapkamer' }; 		

masterframes.frame(frameid).data.action={'Open','Dicht'};	

% Frame 4
frameid=4;
 masterframes.frame(frameid).data={}; % this frame has no slots
  
 % Frame 5
 frameid=5;
 masterframes.frame(frameid).data.Stand={'1','2'}; % this frame has no slots



 


