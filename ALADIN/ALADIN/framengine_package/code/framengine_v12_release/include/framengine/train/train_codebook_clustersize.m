% train a codebook using k-means clustering
% based on code from Joris Driesen
% input
% 1) featmat (NxM dimensional matrix, N features, M samples)
% 2) numclusters - number of codewords
% 3) min_clustersize is th minimal number of datapoints that should form part
% of a cluster
% ouput
% 1) codebook - Nxnumclusters dimensional matrix
% 2) num_clusters is the number of clusters that can be obtained fulfilling
% the min_clustersize condition

function [codebook,membership,num_clusters] = train_codebook_clustersize(featmat,numclusters, conf)

computetype = conf.settingconf.computetype;

dim=size(featmat,1);

codebook = mean(featmat,2); %first prototype is the mean of all data
membership = ones(1,size(featmat,2)); %matrix stating for each datapoint in 'featmat' to which prototype it belongs
min_clustersize=conf.settingconf.acfeat.onlineSoftVQ_minframeperclustersize;

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
    [~,I]=sort(detcv,'descend');
    tel=1;
    k = I(tel);%splitting of cluster k with largest variance will take place in the following lines
    codebook_old=codebook;%remember codebook before splitting
    codebook = [codebook codebook(:,k)+1e-2*scv(k)*main_dir(:,k)];
    codebook(:,k) = codebook(:,k)-1e-2*scv(k)*main_dir(:,k);% two new clustercenters are added 
    % and the old one is removed for cluster k
    [codebook,esq,membership] = kmeans_correct(featmat,codebook,15,computetype);%find new clusters and membership
    
    while any(hist(membership,1:size(codebook,2))<min_clustersize)%check wether there is a cluster with 
        %less than 'min_clustersize' elements, if so, this while loop will
        %take place
        tel=tel+1;%take the index for the cluster with the next largest variance as the one with the largest 
        %leads to clusters with to little elements 
        if tel<=length(I)% check wether there are any clusters left to take, if yes continue            
            k=I(tel);%take the cluster with the second largest variance
            codebook=codebook_old;%take the old codebook before the bad cluster splitting violating 
            %the 'min_clustersize' constraint 
            codebook = [codebook codebook(:,k)+1e-2*scv(k)*main_dir(:,k)];%splitting of cluster with 
            %second largest variance in the next lines
            codebook(:,k) = codebook(:,k)-1e-2*scv(k)*main_dir(:,k);
            [codebook,esq,membership] = kmeans_correct(featmat,codebook,15,computetype);%obtained 'membership' will 
            %be checked in the while condition, if any cluster after new clustersplitting leads to a 
            %cluster with less than 'min_clustersize' elements, stay in the while loop.

        else %if all possible splittings will lead to clusters with less than 'min_clustersize' elements, 
            %then stop splitting and finalize the function   
            codebook=codebook_old;
            [codebook,esq,membership] = kmeans_correct(featmat,codebook,200,computetype);
            num_clusters=size(codebook,2);
            return
        end
    end
    %if 'numclusters' clusters are created and no cluster is smaller than 'min_clustersize',
    %the previous zhileloop is neglected, the result should be the same as
    %in the old version
end
[codebook,esq,membership] = kmeans_correct(featmat,codebook,200,computetype);
num_clusters=numclusters;



