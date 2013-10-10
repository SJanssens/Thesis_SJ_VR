function D = eucdist(A,B,computetype)
    if nargin<3
        computetype = 2;
    end
    
    switch computetype 
        case 0 % use plain matlab
            % D = disteusq(A',B','x')';

            %AA=sum(A.*A,1); BB=sum(B.*B,1); ab=a'*b; 
            %D = sqrt(abs(repmat(aa',[1 size(bb,2)]) + repmat(bb,[size(aa,2) 1]) - 2*ab));

            A=A';
            B=B';

            dim = size(A,2);
            n1 = size(A,1);
            n2 = size(B,1);

            D = sum(bsxfun(@minus,reshape(A,[n1,1,dim]),reshape(B,[1,n2,dim])).^2,3);

            D = D';
        
        case 1 % use GPU matlab
            A=gpuArray(A');
            B=gpuArray(B');

            dim = size(A,2);
            n1 = size(A,1);
            n2 = size(B,1);

            D = sum(bsxfun(@minus,reshape(A,[n1,1,dim]),reshape(B,[1,n2,dim])).^2,3);

            D = gather(D');            
            
        case 2 % use mex
            D = eucl_dx_thread(A,B); % BlkSz-by-k
    end