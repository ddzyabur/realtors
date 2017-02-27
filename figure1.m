
numAttrs = 	3;
numLevels = 5;
numAspects = numLevels*numAttrs;
numProducts = numLevels^numAttrs;
endAttr = cumsum(repmat(numLevels,1,numAttrs));
beginAttr = [1,endAttr+1];
beginAttr(end)=[];
allProducts = fullfact(repmat(numLevels,1,numAttrs));
%true_partworths = randn(1,numAspects);
%true_partworths = exprnd(2,1,numAspects);
%m2 = exprnd(2,numAspects,1);
mu_partworths = 4;
sigma_partworths = 0.2;
percent_0 = 0.3;
numIter = 1000;
% all_true_partworths = zeros(numIter,numAspects);
%     for iter = 1:numIter
%         true_partworths = zeros(1,numAspects);
%         for attr = 1:numAttrs
%             true_partworths(beginAttr(attr):endAttr(attr)) = sample_ordered_partworths(heterogeneity,numLevels,mu_partworths, .1,percent_0);
%         end
%         all_true_partworths(iter,:) = true_partworths;
%     end

for iter = 1:1000
    delme = mvnrnd([2 2], [1 0; 0 1], numAspects);
    true_partworths = delme(:,1)';
    consumerMeans_initial = delme(:,2)';
%     true_partworths = all_true_partworths(iter,:);
%      dummy = gaussmix(numAspects,0,mu_partworths,.5,sigma_partworths,percent_0);
%      x= rand(numAspects,1);
%      consumerMeans_initial = set_to_0*dummy'+(1-set_to_0)*true_partworths;
    consumerVars_initial = exprnd(.1,numAspects,1);
    cost = 0.1;
    searchedAspects = zeros(1,numAspects);
    allProducts_binary = zeros(numProducts, numAspects);
    for product = 1:numProducts;
        allProducts_binary(product,allProducts(product,:)+beginAttr-1)=1;
    end
    all_utils = allProducts_binary*true_partworths';
    all_netPayoffs = zeros(1,numProducts);
    current_means = consumerMeans_initial;
    %for each product, create currentustar, currentmeans, and searched
    %attribute, then run search
    for product = 1:numProducts
        searchedAspects=allProducts_binary(product,:);
        current_means(allProducts(product,:)+beginAttr-1)=true_partworths(allProducts(product,:)+beginAttr-1);
        current_ustar = zeros(numAttrs,1); %this is assuming there is an additional attr level with known partworth 0
        for attr = 1:numAttrs
            current_ustar(attr)=max(0,max(current_means(beginAttr(attr):endAttr(attr))));
        end
        time = 2;
        run_search
        all_netPayoffs(product)=netPayoff;
        all_searchTimes(product)=time;
    end
    std(all_netPayoffs)
    %if std(all_netPayoffs)>.05 %min(all_netPayoffs)<11 | 
    if (max(all_netPayoffs)-min(all_netPayoffs)>1)
         [m,ind]=min(all_netPayoffs);
         %if all_utils(ind)==min(all_utils)
            figure;
            scatter(all_utils,all_netPayoffs)
            keyboard
         %end
    end
end