function [conf] = getconfigs_database(conf,speakerid)

% current database
database_name = 'patience';

    
% -------------- database ------------------
conf.database.speakerid = speakerid;

% -------------- settingconf ------------------


% %%%%%%%%%%%%%%% MODIFY THIS FOR YOUR SETUP %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
spchdatadir = fullfile('..','..','data','spchdatadir');
automatic_dir = fullfile('..','..','data','automatic_dir'); % automatic frame output
oracleaction_dir = fullfile('..','..','data','oracleaction_dir'); % oracle action frames - strictly a subset of the automatic annotation that corresponds to what was said
oraclecommand_dir = fullfile('..','..','data','oraclecommand_dir'); % oracle command frames - a frame description of what was said that accounts for ambiguity in the spoken command (e.g. "red" which can mean both harts and diamonds). Usefull for error measuring
transcriptiondir = fullfile('..','..','data','transcriptiondir');


conf.dirconf.speech_dir     = fullfile(spchdatadir,['pp' num2str(speakerid)]);

conf.dirconf.frames.oracleaction.frame_dir     = fullfile(oracleaction_dir,['pp' num2str(speakerid)]);
conf.dirconf.frames.oraclecommand.frame_dir    = fullfile(oraclecommand_dir,['pp' num2str(speakerid)]);
conf.dirconf.frames.automatic.frame_dir        = fullfile(automatic_dir,['pp' num2str(speakerid)]);

conf.dirconf.transcription_dir     = fullfile(transcriptiondir,['pp' num2str(speakerid)]);

conf.dirconf.flist_dir      = fullfile(conf.dirconf.baselocaldir,'databases',database_name, 'flists');
conf.dirconf.results        = fullfile(conf.dirconf.baselocaldir, 'experiments',database_name,'results');
conf.dirconf.datadir        = fullfile(conf.dirconf.basedatadir,database_name);

% -------------- fileconf ------------------

conf.fileconf.speech_suffix = '_audio.wav';

conf.fileconf.frames.automatic.frame_suffix     = '_framedescription.xml';
conf.fileconf.frames.oraclecommand.frame_suffix = '_oracleframe.xml';
conf.fileconf.frames.oracleaction.frame_suffix  = '_oracleframe.xml';

conf.fileconf.filelist = fullfile(conf.dirconf.flist_dir,['pp' num2str(speakerid) '.txt']); 


% -------------- experimental setup ------------------

conf.settingconf.expconf.all_slotsvalues_in_block=0; % flag telling if all slot-values should be in each block
conf.settingconf.expconf.max_num_blocks=8;
conf.settingconf.expconf.blockstep_array=[1 2 3 4 5 6 7];


