function [conf] = getconfigs_database(conf,speakerid)

% current database
database_name = 'domotica_2';
    
% -------------- database ------------------
conf.database.speakerid = speakerid;

% -------------- settingconf ------------------


% -------------- dirconf ------------------
% %%%%%%%%%%%%%%% MODIFY THIS FOR YOUR SETUP %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
if ispc
    spchdatadir = 'E:\ALADIN\databases\domotica_2\DataCollection\Clean\Segments';
    automatic_dir = 'E:\ALADIN\databases\domotica_2\DataCollection\Clean\Transcriptions';
    oracleaction_dir = 'E:\ALADIN\databases\domotica_2\DataCollection\Clean\Transcriptions';
    oraclecommand_dir = 'E:\ALADIN\databases\domotica_2\DataCollection\Clean\Transcriptions';
    transcriptiondir = 'E:\ALADIN\databases\domotica_2\DataCollection\Clean\Transcriptions';
else
    spchdatadir = '/esat/spchtemp/scratch/jgemmeke/SVN/ALADIN/databases/domotica_2/DataCollection/Clean/Segments';
    automatic_dir = '/esat/spchtemp/scratch/jgemmeke/SVN/ALADIN/databases/domotica_2/DataCollection/Clean/Transcriptions';
    oracleaction_dir = '/esat/spchtemp/scratch/jgemmeke/SVN/ALADIN/databases/domotica_2/DataCollection/Clean/Transcriptions';
    oraclecommand_dir = '/esat/spchtemp/scratch/jgemmeke/SVN/ALADIN/databases/domotica_2/DataCollection/Clean/Transcriptions';
    transcriptiondir = '/esat/spchtemp/scratch/jgemmeke/SVN/ALADIN/databases/domotica_2/DataCollection/Clean/Transcriptions';
end
% -------------- dirconf ------------------
conf.dirconf.speech_dir     = fullfile(spchdatadir,['pp' num2str(speakerid)],'C1');

conf.dirconf.frames.oracleaction.frame_dir     = fullfile(oracleaction_dir,['pp' num2str(speakerid)]);
conf.dirconf.frames.oraclecommand.frame_dir    = fullfile(oraclecommand_dir,['pp' num2str(speakerid)]);
conf.dirconf.frames.automatic.frame_dir        = fullfile(automatic_dir,['pp' num2str(speakerid)]);

conf.dirconf.transcription_dir     = fullfile(transcriptiondir);

conf.dirconf.flist_dir      = fullfile(conf.dirconf.baselocaldir,'databases',database_name, 'flists');
conf.dirconf.results        = fullfile(conf.dirconf.baselocaldir, 'experiments',database_name,'results');
conf.dirconf.datadir        = fullfile(conf.dirconf.basedatadir,database_name);


% -------------- fileconf ------------------

conf.fileconf.speech_suffix = '.wav';

conf.fileconf.frames.automatic.frame_suffix     = '.csv';
conf.fileconf.frames.oraclecommand.frame_suffix = '.csv';
conf.fileconf.frames.oracleaction.frame_suffix  = '.csv';

conf.fileconf.filelist = fullfile(conf.dirconf.flist_dir,['pp' num2str(speakerid) '.txt']); 
% -------------- experimental setup ------------------

conf.settingconf.expconf.all_slotsvalues_in_block=0; % flag telling if all slot-values should be in a single block
conf.settingconf.expconf.max_num_blocks=6;
conf.settingconf.expconf.blockstep_array=[1 2 3 4 5];

