% train a codebook using k-means clustering
% based on code from Joris Driesen
% input
% 1) featmat (NxM dimensional matrix, N features, M samples)
% 2) numclusters - number of codewords
% ouput
% 1) codebook - Nxnumclusters dimensional matrix

function [codebook,membership] = train_codebook(featmat,numclusters, conf)


computetype = conf.settingconf.computetype;


dim=size(featmat,1);

codebook = mean(featmat,2); %first prototype is the mean of all data
membership = ones(1,size(featmat,2)); %matrix stating for each datapoint in 'featmat' to which prototype it belongs


while size(codebook,2)<numclusters
    cv = cell(1,size(codebook,2));
    detcv = zeros(1,size(codebook,2));
    scv = zeros(1,size(codebook,2));
    
    main_dir = zeros(dim,size(codebook,2));
    for k = 1:size(codebook,2)
        cv{k} = cov(featmat(:,membership==k)');
        detcv(k) = det(cv{k});
        [U,S,V] = svd(cv{k});
        main_dir(:,k) = U(:,1);
        scv(k) = sqrt(S(1,1));
    end
    [dummy, k] = max(detcv);
    codebook = [codebook codebook(:,k)+1e-2*scv(k)*main_dir(:,k)];
    codebook(:,k) = codebook(:,k)-1e-2*scv(k)*main_dir(:,k);
    %disp(size(codebook,2));
    [codebook,esq,membership] = kmeans_correct(featmat,codebook,15,computetype);
end
[codebook,esq,membership] = kmeans_correct(featmat,codebook,200,computetype);




