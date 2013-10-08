function [vad,Mnoisy] = vadIBI(sam,audioconf)

% Default config. To guarantee intended operation, you should always
% pass your own, though.

verbose = 0;
noiseFrames=20; % take mean of first 20 frames as noise floor
M=12; % decision interval    
thr=0.2;
MELfloor = 1e-50;
noisesniffing_frontback = true; % if true, sample noise from beginning and end of singal
noisesniffing_robust = true; % if true, sniffing is either from front or back, whichever has lowest energy

defconf.fs = 16000;           % sampling rate for internal processing
defconf.maxf = 8000;          % maximum frequency to be considered
defconf.minf = 64;            % maximum frequency to be considered
defconf.melbands = 26;        % mel band count (0 to disable)
defconf.framelen_ms = 25;     % millisecond length of each frame
defconf.framestep_ms = 10;    % millisecond step between frames
defconf.windowfunc = 'hamming';  % window function name
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
fs = audioconf.fs;
fhigh = audioconf.maxf;
flow = audioconf.minf;

framelen = ceil(fs * audioconf.framelen_ms / 1000);
frameshift = ceil(fs * audioconf.framestep_ms / 1000);

if audioconf.Nfft == 0
    Nfft = 2^nextpow2(framelen);
else
    Nfft = audioconf.Nfft;
end


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

if samchans>1
    % arbitrarely pick the first channel
    sam = sam(:,1);
end  

if melmode
    tMelMat = mel_matrix(fs, featbands, Nfft, 1, fhigh, flow)';
    if size(tMelMat, 1) ~= featbands
        fprintf('Mel matrix has %i bands (config: %i).\n', size(tMelMat, 1), featbands);
    end
    if size(tMelMat, 2) ~= (Nfft/2 + 1)
        fprintf('Mel matrix has %i FFT coeffs (expected: %i).\n', size(tMelMat, 2), Nfft/2 + 1);
    end
end


% Truncate to full frames, get the number.
numframes = floor((samlen-framelen+frameshift) / frameshift);
sam = sam(1:(numframes*frameshift+framelen-frameshift), :);

% DC removal - introduces a 1-unit filter delay, thus we discard the
% first sample. Note that this behaviour has changed from earlier
% versions of FE.
if audioconf.dcremoval
    sam = filter([1;-1], [1;-0.8], sam);
end
samtrlen = size(sam, 1); % trimmed length

% windowing
ind1 = 1:frameshift:samtrlen-1-framelen+frameshift;
% linear 1-step vector (1...frame length)
ind2 = (1:framelen)';
xW = sam(ind1(ones(framelen,1),:) + ind2(:,ones(1,numframes)) - 1);


% ------ here we transition from code in FE.m to vadIbi.m original code -----
    
y = xW.^2-ones(framelen,1)*mean(xW.^2);
try
    s=corr(xW,y,[1:framelen]);
catch
    s=[];
    for k=1:size(xW,2)
        s(:,k)=xcorr(y(:,k),xW(:,k),framelen/2);
    end
end

Y=fft(s,Nfft); 
Y(1,:)=0;
E=abs(max(tMelMat*Y(1:Nfft/2+1,:).^2,MELfloor));

        
sel=[1:featbands]; 




% if noisesniffing_frontback
%     En=mean(E(sel,[1:noiseFrames size(E,2)-noiseFrames:size(E,2)]),2);
% else
%     En=mean(E(sel,1:noiseFrames),2);
% end

frontnoise = E(sel,1:noiseFrames);
backnoise = E(sel,size(E,2)-noiseFrames:size(E,2));

En_front = mean(frontnoise,2);
En_back = mean(backnoise,2);
En_frontback = mean([frontnoise backnoise],2);


if noisesniffing_robust
    if sum(En_front)>sum(En_back)
        En=En_back;
    else
        En=En_front;
    end
else
    if noisesniffing_frontback
        En=En_frontback;
    else
        En=En_front;
    end
end






NbFr=size(E,2);
Mnoisy=zeros(1,NbFr);
for i=noiseFrames:NbFr-M
    Mnoisy(i)=log(sum(max(E(sel,i-M:i+M),[],2)./En)/length(sel));
end
Mnoisy=Mnoisy/max(Mnoisy);

% vad decision
vad=Mnoisy>thr;
