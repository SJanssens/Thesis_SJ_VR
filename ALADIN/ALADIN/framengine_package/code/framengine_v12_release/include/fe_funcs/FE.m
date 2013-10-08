% Yet another feature extractor, this time with CHiME in mind.
% Some cleanup, more support for customised audio parameters.
% Updated 9th Aug 2011
%
% Outputs have been changed. Currently no logarithms are taken here any 
% more. 
%
% Input:
% - 'sam' is a the audio, either as column or row channels vectors. 
%   (Longer dimension is treated as time, shorter as channel count.)
% - 'audioconf' is as defined in getconfigs.m . All of its parameters
%   ARE respected now, so pass a temporary, edited copy if you want
%   to change the behaviour.
%
% Output:
% - 'feats' is a [bands x frames x featchannels] array of mel features.
%   If audioconf.melbands is zero, FFT magnitudes are returned instead.
% - 'energies' is a [frames x audiochannels] matrix of frame energies
% - 'frameaudio' is a [framelen x frames x audiochannels] array of chopped
%   audio data (with preprocessing but without the window function).
% - 'frameFFT' is an [FFTlow x frames x audiochannels] array of frame FFTs.
%   The windowing function has been applied, and the result has been
%   truncated to Nfft/2 + 1 bands. However, no abs is taken. You can
%   do this in the calling function, or pick the abs values from 'feats'
%   by using zero melbands.
% 
% The main feature output respects audioconf.featchannels, which should
% be either the same as audioconf.channels (the number of input streams)
% or 1 (downmixed to mono by taking the mean of feature channels). Other 
% outputs use original audio channels, because their averaging is not as 
% well defined. Note that there is a significant difference between
% averaging the audio (causing waveform level phase attenuation) and the
% abs-FFT or Mel features (phase-invariant energy mean). If the former is
% what you need, downmix the audio in the calling function.
%
% Some warnings are shown if audio parameters are missing or they do not
% match with the data.

function [feats, energies, frameaudio, frameFFT] = FE(sam, audioconf)

verbose = 0;

% Default config. To guarantee intended operation, you should always
% pass your own, though.

defconf.channels = 2;         % input channels, in CHiME always 2
defconf.featchannels = 1;     % feature level channels
defconf.fs = 16000;           % sampling rate for internal processing
defconf.maxf = 8000;          % maximum frequency to be considered
defconf.minf = 64;            % maximum frequency to be considered
defconf.melbands = 26;        % mel band count (0 to disable)
defconf.framelen_ms = 25;     % millisecond length of each frame
defconf.framestep_ms = 10;    % millisecond step between frames
defconf.windowfunc = 'hamming';  % window function name
defconf.preemphasis = 0.97;   % 0 to disable
defconf.dcremoval = true;     % DC removal in the feature extractor
defconf.Nfft = 0;             % Number of FFT bands (0 to calculate from framelength)

if nargin < 2
    if verbose
        disp('No audioconf given, using defaults.')
    end
    audioconf = defconf;
else
    fldnames = fieldnames(defconf);
    for fl = 1:length(fldnames)
        if ~isfield(audioconf, fldnames{fl})
            if verbose
                fprintf('Field %s missing, copying from defaults.\n', fldnames{fl})
            end
            audioconf.(f)=defconf.(f);
        end
    end
end

% Fetch the shorthand variables.
featbands = audioconf.melbands;
featchans = audioconf.featchannels;
fs = audioconf.fs;
fhigh = audioconf.maxf;
flow = audioconf.minf;

framelen = ceil(fs * audioconf.framelen_ms / 1000);
frameshift = ceil(fs * audioconf.framestep_ms / 1000);
% framelen = (fs * audioconf.framelen_ms / 1000);
% frameshift = (fs * audioconf.framestep_ms / 1000);

if audioconf.Nfft == 0
    Nfft = 2^nextpow2(framelen);
else
    Nfft = audioconf.Nfft;
end

winfunc = str2func(audioconf.windowfunc);
win = winfunc(framelen);

if featbands == 0
    melmode = false;
else
    melmode = true;
end

% Switch audio to columns.
if size(sam, 1) < size(sam,2)
    sam = sam';
end

samlen = size(sam, 1);
samchans = size(sam, 2);

if samchans ~= audioconf.channels
    if verbose
        fprintf('Warning: Audio has %i channels, config states %i.\n', samchans, audioconf.channels);
    end
end

if melmode
    melmat = mel_matrix(fs, featbands, Nfft, 1, fhigh, flow)';
    if size(melmat, 1) ~= featbands
        fprintf('Mel matrix has %i bands (config: %i).\n', size(melmat, 1), featbands);
    end
    if size(melmat, 2) ~= (Nfft/2 + 1)
        fprintf('Mel matrix has %i FFT coeffs (expected: %i).\n', size(melmat, 2), Nfft/2 + 1);
    end
end

% Truncate to full frames, get the number.
numframes = floor((samlen-framelen+frameshift) / frameshift);
sam = sam(1:(numframes*frameshift+framelen-frameshift), :);

% DC removal - introduces a 1-unit filter delay, thus we discard the
% first sample. Note that this behaviour has changed from earlier
% versions of FE.
if audioconf.dcremoval
    samf = filter([1;-1], [1;-0.999], [zeros(1,samchans);sam]);
    sam = samf(2:end, :);
end
samtrlen = size(sam, 1); % trimmed length

% Pre-emphasis if nonzero. Can be done for the whole audio at once.
if (audioconf.preemphasis > 0)
    sam = [zeros(1, samchans); sam(2:samtrlen, :) - audioconf.preemphasis * sam(1:(end-1), :)];
end

if melmode
    tmpfeats = zeros(featbands, numframes, samchans);
else
    tmpfeats = zeros(Nfft/2 + 1, numframes, samchans);
end

energies = zeros(numframes, samchans);
frameaudio = zeros(framelen, numframes, samchans);
frameFFT = zeros(Nfft/2+1, numframes, samchans);


% Process channels one by one. Trying to perform these ops simultaneously
% for all channels might be possible but tricky.
for c = 1:samchans
    
    % starting sample numbers of each frame
    ind1 = 1:frameshift:samtrlen-1-framelen+frameshift;
    % linear 1-step vector (1...frame length)
    ind2 = (1:framelen)';
    
    % Pick frame audio. The index matrix (framelen x numframes) consists 
    % of four summed parts:
    % 1) Constant column vectors, each denoting the frame's start sample.
    % 2) Increasing sample index column vectors
    % 3) Scalar jump to get into the correct channel in linear indexing
    % 4) -1 because the first two indices are both one-based.
    %
    %       [start1  start2 ]   [ 1    1  ]
    %  sam( [ ...     ...   ] + [...  ... ] + channel jump - 1) =
    %       [start1  start2 ]   [frl  frl ]
    %
    %       [ start1+1   start2+1  ]
    %  sam( [   ...        ...     ] + channel jump - 1)
    %       [start1+frl start2+frl ]
    %
    % Thus we get an index matrix, where each frame column picks the 
    % samples belonging to it. These samples are then fetched to 'fra'.
    
    fra = sam(ind1(ones(framelen,1),:) + ind2(:,ones(1,numframes)) + (c-1)*samtrlen - 1);
    frameaudio(:,:,c) = fra;

    % Calculate the energies.
    energies(:,c) = sum(fra.^2,1)';            
        
    % Apply window function, take FFT.
    fFFT = fft(win(:,ones(1,numframes)) .* fra, Nfft);
    % Truncate and reset constant factor, but do not take abs yet.
    fFFT(1,:) = 0;
    fFFT = fFFT(1:Nfft/2+1,:);
    
    % Store the returned FFTs with phase.
    frameFFT(:,:,c) = fFFT;
    
    if melmode
        tmpfeats(:,:,c) = melmat * abs(fFFT);
    else
        tmpfeats(:,:,c) = abs(fFFT);
    end
end

% Flatten the features if downmixing to 1 is defined.
if featchans == 1 
    if samchans > 1
        feats = mean(tmpfeats, 3);
    else
        feats = tmpfeats;
    end
else
    if samchans ~= featchans
        fprintf('Requested %i feature channels for %i audio - not defined. Returning %i.\n', featchans, samchans, samchans)
    end
    feats = tmpfeats;
end
