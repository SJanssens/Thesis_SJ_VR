function [conf] = getconfigs(varargin)

if nargin>0
    conf = varargin{1};
end

% -------------- dirconf ------------------
% %%%%%%%%%%%%%%% MODIFY THIS FOR YOUR SETUP %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
if ispc
    conf.dirconf.baselocaldir = 'C:\Dropbox\ALADIN_shared2\framengine_package\release\framengine_v12_release';
    conf.dirconf.basedatadir = 'C:\temp';
else
    conf.dirconf.baselocaldir = '/users/start2010/s0215391/Documents/Thesis/ALADIN_shared2/framengine_package/code/framengine_v12_release';    
    conf.dirconf.basedatadir = '/users/start2010/s0215391/Documents/Thesis/ALADIN_shared2/temp';
end

% ---------------------- add paths ---------------------

addpath( ...
    'include/framengine/convert', ...       % functions to convert between acoustic or semantic representations
    'include/framengine/decode', ...        % functions to decde utterances
    'include/framengine/frames', ...        % functions to manipulate frame descriptions
    'include/framengine/hmm', ...           % functions to construct a HMM for frames
    'include/framengine/train', ...         % high-level functions to train representations, NMF, HMM
    'include/framengine/files', ...         % high-level functions to load files
    'include/NMF', ...                      % functions to do non-negative matrix factorisation (NMF)
    'include/xmltree', ...                  % functions to read, write and manipulate xml files
    'include/eucdist', ...                  % fast Euclidean distance calculation
    'include/kmeans', ...                   % functions for K-means clustering
    'include/util', ...                     % various utility functions
    'include/hmm', ...                      % functions for HMM learning and decoding
    'include/methodology', ...              % functions for determining CV folds
    'include/collect_stats_v8', ...         % functions for output scoring
    'include/fe_funcs');                    % functions for feature extraction and VAD

% -------------- audioconf -----------------
conf.audioconf.channels = 1;         % input channels (supports also multiple channels)
conf.audioconf.featchannels = 1;     % feature level channels
conf.audioconf.fs = 16000;           % sampling rate for internal processing
conf.audioconf.maxf = 8000;          % maximum frequency to be considered
conf.audioconf.minf = 64;            % maximum frequency to be considered
conf.audioconf.melbands = 26;        % mel band count (0 to disable)
conf.audioconf.framelen_ms = 25;     % millisecond length of each frame
conf.audioconf.framestep_ms = 10;    % millisecond step between frames
conf.audioconf.windowfunc = 'hamming';  % window function name
conf.audioconf.preemphasis = 0.97;   % 0 to disable
conf.audioconf.dcremoval = true;     % DC removal in the feature extractor
conf.audioconf.Nfft = 0;             % Number of FFT bands (0 to calculate from framelength)
conf.audioconf.CepOrder = 13;        % number of Cepstral bands    

% -------------- settingconf ------------------

% general
conf.settingconf.computetype = 0; % 0=CPU, 1=GPU 2=mex
conf.settingconf.verbose = true; % output detailed information on program run
conf.settingconf.savedata = true; % save (large) intermediate datasets to speed up re-execution

% frames
conf.settingconf.frame.ignoremissingfield=1; % if set to one, no error is thrown when a field from a frame does not match any master frame field (usefull for testing different frame-layouts)
conf.settingconf.frame.supervision_type='oracleaction'; % options are "automatic","oracleaction","oraclecommand"
conf.settingconf.frame.evaluation_type='oracleaction'; % options are "oracleaction","oraclecommand"


% specfeat
conf.settingconf.specfeat.method = 'mfccdd'; %'mfcc','mfccdd','melmag'
conf.settingconf.specfeat.usevad = 1; % whether or not to drop silence frames
conf.settingconf.specfeat.min_vadfraction = 0.1; % at least this fraction should be speech when using VAD
conf.settingconf.specfeat.usemapstd_perutt = 0; % do mean/variance normalisation per file


% acfeat_params
conf.settingconf.acfeat_params.acmethod = 'softVQ';% this can be a list of methods {'VQ','gmm','sr','softVQ'}
conf.settingconf.acfeat_params.acmethod_usemapstd = 1; % whether or not to do mean/variance normalisation over all data

conf.settingconf.acfeat_params.VQ_numclusters = 100; % codebook size in case of kmeans/VQ
conf.settingconf.acfeat_params.gmm_nummixtures = 300; % number of mixtures in case of GMM
conf.settingconf.acfeat_params.gmm_numiters = 300; % number of mixtures in case of GMM
conf.settingconf.acfeat_params.softVQ_numclusters = 100;
conf.settingconf.acfeat_params.numframes=200000;
conf.settingconf.acfeat_params.onlineSoftVQ_minframeperclustersize = 78;
conf.settingconf.acfeat_params.onlineSoftVQ_numclusters = 200;


% acfeat
conf.settingconf.acfeat.slidingwindow.windowsize = 30; % window size. Default 60
conf.settingconf.acfeat.slidingwindow.Delta=10; % window slide. Default = half of window size
conf.settingconf.acfeat.timemethod = 'HAC'; % {'HAC','sum', 'sumHAC', 'softHac', 'HACtrail'}%HACtrail only tested for soft VQ
conf.settingconf.acfeat.HACtrail_length=2;%length of the VQ cluster sequenceconf.settingconf.acfeat.softVQ_numentries=3;
conf.settingconf.acfeat.numentries=3;
conf.settingconf.acfeat.usedense = false; % store acfeat as sparse or dense data
conf.settingconf.acfeat.HAC_lag = {2, 5, 9, 20}; % for HAC, one or multiple time lags, in frames


% NMF_params
conf.settingconf.NMF_params.nummodels = 1; % train multiple models (to test initialisation differences)
conf.settingconf.NMF_params.numiters = 100; % number of NMF iterations
conf.settingconf.NMF_params.numWcol_per_label = 1; % the number of W columns corresponding to content words is determined by this integer > 0 that describes with how many W columns each label is modelled
conf.settingconf.NMF_params.numgarbageWcol = 0.2; % this number specifies the number of W columns used to model non-content words, expressed as a fraction of the number of labels
conf.settingconf.NMF_params.seed=[10 50 60 70 80];%vector with randomseeds, al least one for each model ___.nummodels
conf.settingconf.NMF_params.fixedseeds=[10];

% HMM parameters
conf.settingconf.hmm.use_decoding_probs = true;
conf.settingconf.hmm.num_bwpass=20; % number of BW (Baum-Welch) passes
conf.settingconf.hmm.T_sparsity = 0;
conf.settingconf.hmm.Einit_NMF_rand_weight=1e-20;

% experiment parameters
conf.settingconf.expconf.usesharing = true; % whether to use word sharing (if specified) for determining folds
conf.settingconf.expconf.frametype= 'oracleaction'; % Which frame type to use for determining blocks. Options are "automatic","oracleaction","oraclecommand"
conf.settingconf.expconf.randomseedcrossval=[100];
conf.settingconf.expconf.randomseed=1111;
conf.settingconf.expconf.n_experiment = 5; % number of fold selections


