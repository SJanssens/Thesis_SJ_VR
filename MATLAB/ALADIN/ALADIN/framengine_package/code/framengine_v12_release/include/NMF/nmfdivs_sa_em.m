function [W,H,divergence]=nmfdivs_sa_em( V, rdim, T, W, H, computetype)
% nmfdivs_sa_em: nmf for a sparse matrix using divergence
% with simulated annealing; update formulae from pLSA
% Author: Hugo Van hamme - K.U.Leuven
% partially inspired on Patrick Hoyer's and Kris Demuynck's implementations
%
% compute V=W*H (approximately) by minimization of the divergence
% rdim = common dimension of W and H
% T = cooling temperature in simulated anealing. Take a function that gradually decreases to 0.
%   Adds noise to W and H at every iteration, scaled with its max element. So T should be (a lot)
%   less than 1. The total number of iterations = length(T).
%   If you don't want simulated annealing, set T=zeros(1,200) for 200 iterations
% W, H: optional initialization matrices


    
VT=V';
SV=full(sum(V,1));

% Dimensions
vdim = size(V,1);
samples = size(V,2);

% Create initial matrices
if nargin<4 || isempty(W)
    W = abs(randn(vdim,rdim))+0.01;
end
W = bsxfun(@rdivide, W, sum(W,1));
if nargin<5 || isempty(H),
%     H = abs(randn(rdim,samples))+0.01;
    H = W'*V;
    H = full(bsxfun(@times,H,SV./sum(H,1)));
end
if nargin<6
    computetype = 2;
end
if computetype==1 % GPU selected
    computetype=0; % GPU not yet implemented, use CPU
end
    

% Start iteration
first=1; wb_pos=0;
divergence=zeros(1,length(T));
for iter=1:length(T),
    if T(iter)
        H = H+(max(H(:))*T(iter))*rand(size(H));
        W = W+(max(W(:))*T(iter))*rand(size(W));
	W = bsxfun(@rdivide, W, sum(W,1));
    end
    H = bsxfun(@times,H,SV./sum(H,1));
    if nargout>2, divergence(iter)=kleval2(V,W,H); end;

    % Compute new W and H
    % H_old = H;
    switch computetype
        case 0 % use plain matlab
            H = nmfHdivs(V,W,H,1,0);
            W = nmfHdivs(VT,H',W',1,0)';            
        case 1 % use GPU matlab
            % not implemented yet, requires moving all matrices to GPU
            % OUTSIDE the loop or we wont have speedups.
        case 2 % use mex
            H = klupdate_H_thread(V,W,H);
            W = klupdate_H_thread(VT,H',W')';
            % W = klupdate_W_thread(V,W,H);
    end
    W=max(bsxfun(@rdivide,W,sum(W,1)),1e-15);

    perc = ceil(20*iter/length(T));
    if perc>wb_pos,
	    wb_pos=perc;
	    if first==1, 
		    first=0; 
		    fprintf('NMF: |');
	    else
		    fprintf('\b\b\b\b\b\b\b\b\b\b\b\b\b\b\b\b\b\b\b\b\b');
	    end
	    fprintf(1,'%c',ones(1,wb_pos-1)*'='); fprintf(1,'>');
	    fprintf(1,'%c',ones(1,20-wb_pos)*' ');
	    fprintf(1,'|');
    end

end
fprintf('\n');
H = bsxfun(@times,H,SV./sum(H,1));
