function y=stacklp(x,N)

if nargin<2,
  N=5;
end

[D,T]=size(x);
xext=x(:,[ones(1,N) 1:T T*ones(1,N)]);

y=zeros((2*N+1)*D,T);
if islogical(x), y=logical(y);end % copy logical property
for k=0:2*N,
  y(k*D+(1:D),:)=xext(:,k+1:k+T);
end