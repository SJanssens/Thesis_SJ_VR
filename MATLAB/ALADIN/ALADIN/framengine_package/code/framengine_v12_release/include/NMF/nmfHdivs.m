function H2=nmfHdivs(V, W, H, NbIter,computetype)
% nmfdivs: nmf for a sparse matrix using divergence
% estimate H only


if nargin<4 || isempty(NbIter)
    NbIter=30;
end
if nargin<5
    computetype = 2;
end
if computetype==1 % GPU selected
    computetype=0; % GPU not yet implemented, use CPU
end

orgDim=size(V,2);

SV=sum(V,1);
iZero=SV==0;
SV(iZero)=[];
V(:,iZero)=[];

[I,J,v]=find(V);
if min(v)<0, error('Negative values in data!'); end
% correct matlab's default orientation of the result
if size(V,1)==1,
    I=I';
    J=J';
    v=v';
end

% Dimensions
vdim = size(V,1);
samples = size(V,2);

% Create initial matrices
sumW=sum(W,1)';
if nargin<3 || isempty(H)
    H = W'*V;
    H = full(H*sparse(1:samples,1:samples,SV./(sumW'*H) )); % NEW
end


% Start iteration
for iter=1:NbIter,
    % Compute new W and H (Lee and Seung; NIPS*2000)
    % Q = sparse(I,J,v./whs,vdim,samples);
    % H = H.*(W'*Q)./sumW(:,ones(1,samples));
    switch computetype
        case 0 % use plain matlab
            Q = V./(W*H);
            H = H.*(W'*Q)./sumW(:,ones(1,samples));
            %H = spdiag(1./sum(W,1))*klupdate_H_thread(V,W,H);
            %H = full(H*sparse(1:samples,1:samples,SV./(sumW'*H) )); % NEW            
        case 1 % use GPU matlab
            % not implemented yet, requires moving all matrices to GPU
            % OUTSIDE the loop or we wont have speedups.
        case 2 % use mex
            H = spdiag(1./sum(W,1))*klupdate_H_thread(V,W,H);
    end
    
    % Renormalize so rows of H have constant energy
    %     norms = sqrt(sum(H.^2,2));
    %     H = H./(norms*ones(1,samples));
    %     W = W.*(ones(vdim,1)*norms');

end
H2=zeros(size(H,1),orgDim);
H2(:,~iZero)=H;

