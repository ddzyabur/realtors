numAttrs = 3;
numLevels = 7;
numAspects = numLevels*numAttrs;
numProducts = numLevels^numAttrs;
allProducts = fullfact(repmat(numLevels,1,numAttrs));
%true_partworths = randn(1,numAspects);
%true_partworths = exprnd(2,1,numAspects);
%m2 = exprnd(2,numAspects,1);
mu_partworths = 2;
sigma_partworths = 1;
m2 = ones(numAspects,1)*mu_partworths;
%m2 = randn(numAspects,1)*.2*mu_partworths;
rho_true_recommender = 0.4*sigma_partworths;
percent_0 = 0;
%true_partworths = gaussmix(numAspects,0,m2,.5,.1,percent_0);
true_partworths = gaussmix(numAspects,0,mu_partworths,.5,.1,percent_0);
true_partworths = true_partworths';

% X = mvnrnd([mu_partworths,mu_partworths],[sigma_partworths,rho_true_recommender; rho_true_recommender,sigma_partworths],numAspects);
% true_partworths = X(:,1)';
% recommenderMeans_initial = X(:,2)';

%consumerMeans_initial = exprnd(2,1,numAspects);
%randomly set some to 0
consumerMeans_initial = true_partworths;
dummy = rand(1,numAspects);
set_to_0 = 0.6;
consumerMeans_initial(find(dummy<set_to_0))=0;
consumerVars_initial = exprnd(.1,numAspects,1);



rec_variance = .25;
%recommenderMeans_initial = randn(1,numAspects)*rec_mean_diff_variance+true_partworths;
%recommenderMeans_initial = true_partworths;
% recommenderMeans_initial(find(dummy<.5))=true_partworths(find(dummy<.5))+randn(1,length(find(dummy<.5)))*rec_mean_diff_variance;

recommenderMeans_initial = 0.5*consumerMeans_initial+0.5*m2';
% recommenderMeans_initial = (m2*(1-percent_0))';
% recommenderMeans_initial(find(dummy>set_to_0))=true_partworths(find(dummy>set_to_0));
% recommenderMeans_initial(find(dummy<set_to_0))=weight_truth*true_partworths(find(dummy<set_to_0))+(1-weight_truth)*m2(find(dummy<set_to_0))'*(1-percent_0);
% recommenderMeans_initial(find(dummy<set_to_0))=weight_truth*true_partworths(find(dummy<set_to_0));
%recommenderMeans_initial(find(dummy>set_to_0))=true_partworths(find(dummy>set_to_0))+randn(1,length(find(dummy>set_to_0)))*rec_mean_diff_variance;
recommenderVars_initial = exprnd(rec_variance,numAspects,1);

cost = 0.1;
endAttr = cumsum(repmat(numLevels,1,numAttrs));
beginAttr = [1,endAttr+1];
beginAttr(end)=[];
searchedAspects = zeros(1,numAspects);

allProducts_binary = zeros(numProducts, numAspects);
for product = 1:numProducts;
    allProducts_binary(product,allProducts(product,:)+beginAttr-1)=1;
end
all_utils = allProducts_binary*true_partworths';
%%
if no_rec ==1;
    current_means = consumerMeans_initial;
    time = 1;
    current_ustar = zeros(numAttrs,1); %this is assuming there is an additional attr level with known partworth 0
    for attr = 1:numAttrs
        current_ustar(attr)=max(0,max(current_means(beginAttr(attr):endAttr(attr))));
    end
    run_search
    netPayoff_no_rec = netPayoff;
end
%%
all_recs = 1;
if all_recs ==1;
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
end

%scatter(all_utils,all_netPayoffs)

%%
%optimize a recommendation



%1. recommend the highest expected util according to recommender
%2. recommend the highest undervalued attribute

if rec_max_expected==1
    current_means = consumerMeans_initial;
    %compute all util expectations according to rec, and pick the max.
    utils_exp_rec = allProducts_binary*recommenderMeans_initial';
    if recommend2==0
        [max_exp_util,product]=max(utils_exp_rec);
        searchedAspects=allProducts_binary(product,:);
        current_means(allProducts(product,:)+beginAttr-1)=true_partworths(allProducts(product,:)+beginAttr-1);
    elseif recommend2==1
        sorted_utils = sort(utils_exp_rec,'descend');
        top2 = sorted_utils(1:2);
        rec1 = find(utils_exp_rec==top2(1));
        rec1= rec1(1);
        searchedAspects=allProducts_binary(rec1,:);
        current_means(allProducts(rec1,:)+beginAttr-1)=true_partworths(allProducts(rec1,:)+beginAttr-1);
        rec2 = find(utils_exp_rec==top2(2));
        rec2=rec2(1);
        searchedAspects=searchedAspects+allProducts_binary(rec1,:);
        searchedAspects=min(1,searchedAspects);
        current_means(allProducts(rec2,:)+beginAttr-1)=true_partworths(allProducts(rec2,:)+beginAttr-1);
    elseif recommend3 ==1
        sorted_utils = sort(utils_exp_rec,'descend');
        top3 = sorted_utils(1:3);
        rec1 = find(utils_exp_rec==top3(1));
        rec1= rec1(1);
        searchedAspects=allProducts_binary(rec1,:);
        current_means(allProducts(rec1,:)+beginAttr-1)=true_partworths(allProducts(rec1,:)+beginAttr-1);
        rec2 = find(utils_exp_rec==top2(2));
        rec2=rec2(1);
        searchedAspects=searchedAspects+allProducts_binary(rec1,:);
        searchedAspects=min(1,searchedAspects);
        current_means(allProducts(rec2,:)+beginAttr-1)=true_partworths(allProducts(rec2,:)+beginAttr-1);
    end
    current_ustar = zeros(numAttrs,1); %this is assuming there is an additional attr level with known partworth 0
    for attr = 1:numAttrs
        current_ustar(attr)=max(0,max(current_means(beginAttr(attr):endAttr(attr))));
    end
    time = 1;
    run_search
    netPayoff_max_expected=netPayoff;
end

%%

if rec_undervalued==1
    current_means = consumerMeans_initial;
    %find attrs the consumer has low prior on but that could be high.
    utils_difference = allProducts_binary*(recommenderMeans_initial-consumerMeans_initial)';
    %pick the product that has high expected utility and high utility
    %difference
    [max_exp_util,product]=max(utils_difference);
    searchedAspects=allProducts_binary(product,:);
    current_means(allProducts(product,:)+beginAttr-1)=true_partworths(allProducts(product,:)+beginAttr-1);
    if recommend2 ==1;
        utils_difference = allProducts_binary*(recommenderMeans_initial-current_means)';
        [max_exp_util,product]=max(utils_difference);
        searchedAspects=allProducts_binary(product,:);
        current_means(allProducts(product,:)+beginAttr-1)=true_partworths(allProducts(product,:)+beginAttr-1);
    end
    current_ustar = zeros(numAttrs,1); %this is assuming there is an additional attr level with known partworth 0
    for attr = 1:numAttrs
        current_ustar(attr)=max(0,max(current_means(beginAttr(attr):endAttr(attr))));
    end
    time = 1;
    run_search
    netPayoff_undervalued = netPayoff;
end

%%
if rec_diversity==1
    diversity_penalty = .8;
    current_means = consumerMeans_initial;
    %compute the consumer's high expected value, and penalize for having
    %same attributes
    [max_consumer_exp,consumers_choice]=max(allProducts_binary*current_means');
    %number of attrs in common with tht product:
    num_common_attrs = allProducts_binary*allProducts_binary(consumers_choice,:)';
    utils_difference = allProducts_binary*recommenderMeans_initial'-num_common_attrs*diversity_penalty;
    [max_exp_util,product]=max(utils_difference);
    searchedAspects=allProducts_binary(product,:);
    current_means(allProducts(product,:)+beginAttr-1)=true_partworths(allProducts(product,:)+beginAttr-1);
    if recommend2==1
        [max_consumer_exp,consumers_choice]=max(allProducts_binary*current_means');
        %number of attrs in common with tht product:
        num_common_attrs = allProducts_binary*allProducts_binary(consumers_choice,:)';
        utils_difference = allProducts_binary*recommenderMeans_initial'-num_common_attrs*diversity_penalty;
        [max_exp_util,product]=max(utils_difference);
        searchedAspects=allProducts_binary(product,:);
        current_means(allProducts(product,:)+beginAttr-1)=true_partworths(allProducts(product,:)+beginAttr-1);
    end
    current_ustar = zeros(numAttrs,1); %this is assuming there is an additional attr level with known partworth 0
    for attr = 1:numAttrs
        current_ustar(attr)=max(0,max(current_means(beginAttr(attr):endAttr(attr))));
    end
    time = 1;
    run_search
    netPayoff_diversity=netPayoff;
end
