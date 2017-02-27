
learning =0;%assume independence for computing search values
learning_approx = 1;%assume delta updating for computing search values
%m2 = ones(numAspects,1)*mu_partworths;
m2 = randn(numAspects,1)*.1+mu_partworths;
%rho_true_recommender = 0.4*sigma_partworths;
%%
%true_partworths = gaussmix(numAspects,0,m2,.5,.1,percent_0);
%  true_partworths = gaussmix(numAspects,0,mu_partworths,.5,sigma_partworths,percent_0);
% true_partworths = true_partworths';
true_partworths = all_true_partworths(iter,:);
max_util = 0;
for attr = 1:numAttrs
    [util, level]= max(true_partworths(beginAttr(attr):endAttr(attr)));
    max_util = max_util + util;
end
% X = mvnrnd([mu_partworths,mu_partworths],[sigma_partworths,rho_true_recommender; rho_true_recommender,sigma_partworths],numAspects);
% true_partworths = X(:,1)';
% recommenderMeans_initial = X(:,2)';

%consumerMeans_initial = exprnd(2,1,numAspects);
%randomly set some to 0
dummy = gaussmix(numAspects,0,mu_partworths,.5,sigma_partworths,percent_0_prior);

x= rand(1,numAspects);
%consumerMeans_initial = set_to_0*dummy'+(1-set_to_0)*true_partworths;
%consumerMeans_initial = set_to_0*x+(1-set_to_0)*true_partworths;
 consumerMeans_initial=true_partworths+randn(1,numAspects)*.5;
 for aspect = 1:numAspects
     if x(aspect)<set_to_0;
         consumerMeans_initial(aspect)=dummy(aspect);
         %consumerMeans_initial(aspect)=randn*.5;
     end
 end
 %consumerVars_initial = exprnd(.2,numAspects,1); %march 2016 run
 consumerVars_initial = exprnd(.2,numAspects,1);

rec_variance = .25;
%recommenderMeans_initial = randn(1,numAspects)*rec_mean_diff_variance+true_partworths;
%recommenderMeans_initial = true_partworths;
%recommenderMeans_initial(find(dummy<.5))=true_partworths(find(dummy<.5))+randn(1,length(find(dummy<.5)))*rec_mean_diff_variance;
dummy = gaussmix(numAspects,0,mu_partworths,.5,sigma_partworths,percent_0_prior);
weight_consumer = 0.3;

%recommenderMeans_initial = sum(all_true_partworths)/size(all_true_partworths,1);
%recommenderMeans_initial = weight_truth*true_partworths+(1-weight_truth)*recommenderMeans_initial;
%recommenderMeans_initial =
%weight_truth*consumerMeans_initial+(1-weight_truth)*recommenderMeans_initial;
%%Jan 2017 run
%recommenderMeans_initial = weight_truth*population_means' + (1-weight_truth)*consumerMeans_initial;
%recommenderMeans_initial = weight_truth*true_partworths + (1-weight_truth)*consumerMeans_initial;
%recommenderMeans_initial = weight_truth*true_partworths + (1-weight_truth)*consumerMeans_initial;
%recommenderMeans_initial(find(dummy>set_to_0))=consumerMeans_initial(dummy>set_to_0);

x= rand(1,numAspects);
recommenderMeans_initial = set_to_0_recSys*dummy'+(1-set_to_0_recSys)*true_partworths;
recommenderMeans_initial = (1-weight_consumer)*recommenderMeans_initial+weight_consumer*consumerMeans_initial;
% recommenderMeans_initial=true_partworths+randn(1,numAspects)*.5;
%  for aspect = 1:numAspects
%      if x(aspect)<set_to_0_recSys
%          recommenderMeans_initial(aspect)=consumerMeans_initial(aspect);
%          %recommenderMeans_initial(aspect)=dummy(aspect);
%          %consumerMeans_initial(aspect)=randn*.5;
%      end
%  end
% recommenderMeans_initial = (m2*(1-percent_0))';
% recommenderMeans_initial = (1-weight_truth)*(m2*(1-percent_0))' + weight_truth*true_partworths;
%  recommenderMeans_initial(find(dummy>set_to_0))=true_partworths(find(dummy>set_to_0));
 
 
% recommenderMeans_initial(find(dummy<set_to_0))=weight_truth*true_partworths(find(dummy<set_to_0))+(1-weight_truth)*m2(find(dummy<set_to_0))'*(1-percent_0);
% recommenderMeans_initial(find(dummy<set_to_0))=weight_truth*true_partworths(find(dummy<set_to_0));
%recommenderMeans_initial(find(dummy>set_to_0))=true_partworths(find(dummy>set_to_0))+randn(1,length(find(dummy>set_to_0)))*rec_mean_diff_variance;
recommenderVars_initial = exprnd(rec_variance,numAspects,1);

searchedAspects = zeros(1,numAspects);

allProducts_binary = zeros(numProducts, numAspects);
for product = 1:numProducts;
    allProducts_binary(product,allProducts(product,:)+beginAttr-1)=1;
end
all_utils = allProducts_binary*true_partworths';
current_means = consumerMeans_initial;
current_vars = consumerVars_initial;
%%
if no_rec ==1;
    current_means = consumerMeans_initial;
    time = 0;
    current_ustar = zeros(numAttrs,1); %this is assuming there is an additional attr level with known partworth 0
    for attr = 1:numAttrs
        current_ustar(attr)=max(0,max(current_means(beginAttr(attr):endAttr(attr))));
    end
    if learning ==1
        run_search_learning
    elseif learning_approx==1
        run_search_learning_approx
    else
        run_search
    end
    netPayoff_no_rec = netPayoff;
end

%%
all_recs = 0;
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
        time = 1;
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
    current_vars = consumerVars_initial;
    %compute all util expectations according to rec, and pick the max.
    utils_exp_rec = allProducts_binary*recommenderMeans_initial';
    if recommend2==0
        [max_exp_util,product_to_search]=max(utils_exp_rec);
        if learning ==1 || learning_approx==1
            aspects_to_update = find(allProducts_binary(product_to_search,:));
            for aspect_index = 1:length(aspects_to_update);
                aspect = aspects_to_update(aspect_index);
                %draw a sample from the true mean, signal variance
                sampled_weight = randn(1)*sqrt(signal_var)+true_partworths(aspect);
                current_means(aspect)=current_means(aspect)+current_vars(aspect)/(current_vars(aspect)+signal_var)*(sampled_weight-current_means(aspect));
                current_vars(aspect)=current_vars(aspect)*signal_var/(current_vars(aspect)+signal_var);
            end
        else
            searchedAspects=allProducts_binary(product_to_search,:);
            current_means(allProducts(product_to_search,:)+beginAttr-1)=true_partworths(allProducts(product_to_search,:)+beginAttr-1);
        end
    elseif recommend2==1
        sorted_utils = sort(utils_exp_rec,'descend');
        top2 = sorted_utils(1:2);
        rec1 = find(utils_exp_rec==top2(1));
        rec1= rec1(1);
        product_to_search = rec1;
        if learning ==1||learning_approx==1;
            aspects_to_update = find(allProducts_binary(product_to_search,:));
            for aspect_index = 1:length(aspects_to_update);
                aspect = aspects_to_update(aspect_index);
                %draw a sample from the true mean, signal variance
                sampled_weight = randn(1)*sqrt(signal_var)+true_partworths(aspect);
                current_means(aspect)=current_means(aspect)+current_vars(aspect)/(current_vars(aspect)+signal_var)*(sampled_weight-current_means(aspect));
                current_vars(aspect)=current_vars(aspect)*signal_var/(current_vars(aspect)+signal_var);
            end
        else
            searchedAspects=allProducts_binary(product_to_search,:);
            current_means(allProducts(product_to_search,:)+beginAttr-1)=true_partworths(allProducts(product_to_search,:)+beginAttr-1);
        end
        rec2 = find(utils_exp_rec==top2(2));
        rec2=rec2(1);
        product_to_search = rec2;
        if learning ==1||learning_approx==1
            aspects_to_update = find(allProducts_binary(product_to_search,:));
            for aspect_index = 1:length(aspects_to_update);
                aspect = aspects_to_update(aspect_index);
                %draw a sample from the true mean, signal variance
                sampled_weight = randn(1)*sqrt(signal_var)+true_partworths(aspect);
                current_means(aspect)=current_means(aspect)+current_vars(aspect)/(current_vars(aspect)+signal_var)*(sampled_weight-current_means(aspect));
                current_vars(aspect)=current_vars(aspect)*signal_var/(current_vars(aspect)+signal_var);
            end
        else
            searchedAspects=allProducts_binary(product_to_search,:);
            current_means(allProducts(product_to_search,:)+beginAttr-1)=true_partworths(allProducts(product_to_search,:)+beginAttr-1);
        end
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
    if learning ==1
        run_search_learning
    elseif learning_approx==1;
        run_search_learning_approx
    else
        run_search
    end
    netPayoff_max_expected=netPayoff;
end

%%
if rec_Weitzman==1
    Weitzman_penalty = 1;
    current_means = consumerMeans_initial;
    current_vars = consumerVars_initial;
    current_ustar = zeros(numAttrs,1);
    mean_recSys = recommenderMeans_initial;
    for attr = 1:numAttrs
        ustar = current_ustar(attr);
        for level = 1:numLevels
            aspect = numLevels*(attr-1)+level;
            mean_consumer = current_means(aspect);
            var_consumer = current_vars(aspect);
            var_recSys = recommenderVars_initial(aspect);
            fun = @(w,mu,sigma) w.*exp(-(w-mu).^2/(2*sigma));
            %search_value(aspect) = integral(@(w)fun(w,mean,var),ustar,Inf)/sqrt(var*2*pi);
            search_value_consumer(aspect) = integral(@(w)fun(w,mean_consumer,var_consumer),ustar,Inf);
            %search_value_recSys(aspect)=integral(@(w)fun(w,mean_recSys,var_recSys),ustar,Inf);
        end
    end
    search_value_difference_products = allProducts_binary*(mean_recSys-Weitzman_penalty*search_value_consumer)';
    if set_to_0==.6
    %keyboard;
    end
    [max_exp_util,product_to_search]=max(search_value_difference_products);
    if learning ==1||learning_approx==1;
        recommenderMeans_updated=recommenderMeans_initial;
        aspects_to_update = find(allProducts_binary(product_to_search,:));
        for aspect_index = 1:length(aspects_to_update);
            aspect = aspects_to_update(aspect_index);
            %draw a sample from the true mean, signal variance
            sampled_weight = randn(1)*sqrt(signal_var)+true_partworths(aspect);
            current_means(aspect)=current_means(aspect)+current_vars(aspect)/(current_vars(aspect)+signal_var)*(sampled_weight-current_means(aspect));
            current_vars(aspect)=current_vars(aspect)*signal_var/(current_vars(aspect)+signal_var);
            search_value_consumer(aspect) = integral(@(w)fun(w,current_means(aspect),current_vars(aspect)),ustar,Inf);
            recommenderMeans_updated(aspect)=recommenderMeans_initial(aspect)+recommenderVars_initial(aspect)/(recommenderVars_initial(aspect)+signal_var)*(sampled_weight-recommenderMeans_initial(aspect));
        end
    else
        searchedAspects=allProducts_binary(product_to_search,:);
        current_means(allProducts(product_to_search,:)+beginAttr-1)=true_partworths(allProducts(product_to_search,:)+beginAttr-1);
    end
    if recommend2 ==1;
        search_value_difference_products = allProducts_binary*(recommenderMeans_updated-Weitzman_penalty*search_value_consumer)';
        for level = 1:numLevels
            aspect = numLevels*(attr-1)+level;
            mean_consumer = current_means(aspect);
            var_consumer = current_vars(aspect);
            mean_recSys = recommenderMeans_updated(aspect);
            var_recSys = recommenderVars_initial(aspect);
            fun = @(w,mu,sigma) w.*exp(-(w-mu).^2/(2*sigma));
            %search_value(aspect) = integral(@(w)fun(w,mean,var),ustar,Inf)/sqrt(var*2*pi);
            search_value_consumer(aspect) = integral(@(w)fun(w,mean_consumer,var_consumer),ustar,Inf);
            %search_value_recSys(aspect)=integral(@(w)fun(w,mean_recSys,var_recSys),ustar,Inf);
        end
    end
    search_value_difference_products = allProducts_binary*(mean_recSys-Weitzman_penalty*search_value_consumer)';
    [max_exp_util,product_to_search]=max(search_value_difference_products);
    if learning ==1||learning_approx==1;
        aspects_to_update = find(allProducts_binary(product_to_search,:));
        for aspect_index = 1:length(aspects_to_update);
            aspect = aspects_to_update(aspect_index);
            %draw a sample from the true mean, signal variance
            sampled_weight = randn(1)*sqrt(signal_var)+true_partworths(aspect);
            current_means(aspect)=current_means(aspect)+current_vars(aspect)/(current_vars(aspect)+signal_var)*(sampled_weight-current_means(aspect));
            current_vars(aspect)=current_vars(aspect)*signal_var/(current_vars(aspect)+signal_var);
        end
    else
        searchedAspects=allProducts_binary(product_to_search,:);
        current_means(allProducts(product_to_search,:)+beginAttr-1)=true_partworths(allProducts(product_to_search,:)+beginAttr-1);
    end
    current_ustar = zeros(numAttrs,1); %this is assuming there is an additional attr level with known partworth 0
    for attr = 1:numAttrs
        current_ustar(attr)=max(0,max(current_means(beginAttr(attr):endAttr(attr))));
    end
    time = 1;
    if learning ==1
        run_search_learning
    elseif learning_approx==1
        run_search_learning_approx
    else
        run_search
    end
    netPayoff_Weitzman = netPayoff;
    if netPayoff<-.3
        keyboard;
    end
end
%%

if rec_undervalued==1
    current_means = consumerMeans_initial;
    current_vars = consumerVars_initial;
    %find attrs the consumer has low prior on but that could be high.
    utils_difference = allProducts_binary*(recommenderMeans_initial-consumerMeans_initial)';
    %pick the product that has high expected utility and high utility
    %difference
    [max_exp_util,product_to_search]=max(utils_difference);
    if john_hack ==1;
        if max_exp_util <.02
            [max_exp_util,product_to_search]=max(utils_exp_rec);
        end
    end
    if learning ==1||learning_approx==1;
        aspects_to_update = find(allProducts_binary(product_to_search,:));
        for aspect_index = 1:length(aspects_to_update);
            aspect = aspects_to_update(aspect_index);
            %draw a sample from the true mean, signal variance
            sampled_weight = randn(1)*sqrt(signal_var)+true_partworths(aspect);
            current_means(aspect)=current_means(aspect)+current_vars(aspect)/(current_vars(aspect)+signal_var)*(sampled_weight-current_means(aspect));
            current_vars(aspect)=current_vars(aspect)*signal_var/(current_vars(aspect)+signal_var);
        end
    else
        searchedAspects=allProducts_binary(product_to_search,:);
        current_means(allProducts(product_to_search,:)+beginAttr-1)=true_partworths(allProducts(product_to_search,:)+beginAttr-1);
    end
    if recommend2 ==1;
        utils_difference = allProducts_binary*(recommenderMeans_initial-current_means)';
        [max_exp_util,product_to_search]=max(utils_difference);
        if learning ==1||learning_approx==1;
            aspects_to_update = find(allProducts_binary(product_to_search,:));
            for aspect_index = 1:length(aspects_to_update);
                aspect = aspects_to_update(aspect_index);
                %draw a sample from the true mean, signal variance
                sampled_weight = randn(1)*sqrt(signal_var)+true_partworths(aspect);
                current_means(aspect)=current_means(aspect)+current_vars(aspect)/(current_vars(aspect)+signal_var)*(sampled_weight-current_means(aspect));
                current_vars(aspect)=current_vars(aspect)*signal_var/(current_vars(aspect)+signal_var);
            end
        else
            searchedAspects=allProducts_binary(product_to_search,:);
            current_means(allProducts(product_to_search,:)+beginAttr-1)=true_partworths(allProducts(product_to_search,:)+beginAttr-1);
        end
    end
    current_ustar = zeros(numAttrs,1); %this is assuming there is an additional attr level with known partworth 0
    for attr = 1:numAttrs
        current_ustar(attr)=max(0,max(current_means(beginAttr(attr):endAttr(attr))));
    end
    time = 1;
    if learning ==1
        run_search_learning
    elseif learning_approx==1
        run_search_learning_approx
    else
        run_search
    end
    netPayoff_undervalued = netPayoff;
    if netPayoff<-.3
        keyboard;
    end
end


%%
if rec_KL ==1
    %     for each product, compute KL divergence
    current_means = consumerMeans_initial;
    current_vars = consumerVars_initial;
    all_KLs = zeros(1,numProducts)
    for product = 1:numProducts
        sigma_1 = current_vars(allProducts(product,:)+beginAttr-1);
        sigma_2 = recommenderVars_initial(allProducts(product,:)+beginAttr-1);
        mu_1 = consumerMeans_initial(allProducts(product,:)+beginAttr-1);
        mu_2 = recommenderMeans_initial(allProducts(product,:)+beginAttr-1);
        all_KLs(product)=compute_KL_gaussian(mu_1,mu_2,sigma_1,sigma_2);
    end
    [max_KL,product_to_search]=max(all_KLs);
    %update priors
    aspects_to_update = find(allProducts_binary(product_to_search,:));
    for aspect_index = 1:length(aspects_to_update);
        aspect = aspects_to_update(aspect_index);
        %draw a sample from the true mean, signal variance
        sampled_weight = randn(1)*sqrt(signal_var)+true_partworths(aspect);
        current_means(aspect)=current_means(aspect)+current_vars(aspect)/(current_vars(aspect)+signal_var)*(sampled_weight-current_means(aspect));
        current_vars(aspect)=current_vars(aspect)*signal_var/(current_vars(aspect)+signal_var);
    end
    if recommend2==1
        sigma_1 = current_vars(allProducts(product,:)+beginAttr-1);
        mu_1 = consumerMeans_initial(allProducts(product,:)+beginAttr-1);
            all_KLs = zeros(1,numProducts)
    for product = 1:numProducts
        sigma_1 = current_vars(allProducts(product,:)+beginAttr-1);
        sigma_2 = recommenderVars_initial(allProducts(product,:)+beginAttr-1);
        mu_1 = consumerMeans_initial(allProducts(product,:)+beginAttr-1);
        mu_2 = recommenderMeans_initial(allProducts(product,:)+beginAttr-1);
        all_KLs(product)=compute_KL_gaussian(mu_1,mu_2,sigma_1,sigma_2);
    end
    [max_KL,product_to_search]=max(all_KLs);
    for aspect_index = 1:length(aspects_to_update);
        aspect = aspects_to_update(aspect_index);
        %draw a sample from the true mean, signal variance
        sampled_weight = randn(1)*sqrt(signal_var)+true_partworths(aspect);
        current_means(aspect)=current_means(aspect)+current_vars(aspect)/(current_vars(aspect)+signal_var)*(sampled_weight-current_means(aspect));
        current_vars(aspect)=current_vars(aspect)*signal_var/(current_vars(aspect)+signal_var);
    end
    end
    current_ustar = zeros(numAttrs,1); %this is assuming there is an additional attr level with known partworth 0
    for attr = 1:numAttrs
        current_ustar(attr)=max(0,max(current_means(beginAttr(attr):endAttr(attr))));
    end
    time = 1;
    if learning ==1
        run_search_learning
    elseif learning_approx==1;
        run_search_learning_approx
    else
        run_search
    end
    netPayoff_KL=netPayoff;
end
%%
if rec_diversity==1
    diversity_penalty = 1;
    current_means = consumerMeans_initial;
    current_vars = consumerVars_initial;
    %compute the consumer's high expected value, and penalize for having
    %same attributes
    [max_consumer_exp,consumers_choice]=max(allProducts_binary*current_means');
    %number of attrs in common with tht product:
    num_common_attrs = allProducts_binary*allProducts_binary(consumers_choice,:)';
    utils_difference = allProducts_binary*recommenderMeans_initial'-num_common_attrs*diversity_penalty;
    [max_exp_util,product_to_search]=max(utils_difference);
    if learning ==1||learning_approx==1
        aspects_to_update = find(allProducts_binary(product_to_search,:));
        for aspect_index = 1:length(aspects_to_update);
            aspect = aspects_to_update(aspect_index);
            %draw a sample from the true mean, signal variance
            sampled_weight = randn(1)*sqrt(signal_var)+true_partworths(aspect);
            current_means(aspect)=current_means(aspect)+current_vars(aspect)/(current_vars(aspect)+signal_var)*(sampled_weight-current_means(aspect));
            current_vars(aspect)=current_vars(aspect)*signal_var/(current_vars(aspect)+signal_var);
        end
    else
        searchedAspects=allProducts_binary(product_to_search,:);
        current_means(allProducts(product_to_search,:)+beginAttr-1)=true_partworths(allProducts(product_to_search,:)+beginAttr-1);
    end
    if recommend2==1
        [max_consumer_exp,consumers_choice]=max(allProducts_binary*current_means');
        seen_attrs = allProducts_binary(consumers_choice,:)';
        seen_attrs(find(allProducts_binary(product_to_search,:)))=1;
        %number of attrs in common with tht product:
        num_common_attrs = allProducts_binary*seen_attrs;
        utils_difference = allProducts_binary*recommenderMeans_initial'-num_common_attrs*diversity_penalty;
        [max_exp_util,product_to_search]=max(utils_difference);
        if learning ==1||learning_approx==1;
            aspects_to_update = find(allProducts_binary(product_to_search,:));
            for aspect_index = 1:length(aspects_to_update);
                aspect = aspects_to_update(aspect_index);
                %draw a sample from the true mean, signal variance
                sampled_weight = randn(1)*sqrt(signal_var)+true_partworths(aspect);
                current_means(aspect)=current_means(aspect)+current_vars(aspect)/(current_vars(aspect)+signal_var)*(sampled_weight-current_means(aspect));
                current_vars(aspect)=current_vars(aspect)*signal_var/(current_vars(aspect)+signal_var);
            end
        else
            searchedAspects=allProducts_binary(product,:);
            current_means(allProducts(product_to_search,:)+beginAttr-1)=true_partworths(allProducts(product_to_search,:)+beginAttr-1);
        end
    end
    current_ustar = zeros(numAttrs,1); %this is assuming there is an additional attr level with known partworth 0
    for attr = 1:numAttrs
        current_ustar(attr)=max(0,max(current_means(beginAttr(attr):endAttr(attr))));
    end
    time = 1;
    if learning ==1
        run_search_learning
    elseif learning_approx==1;
        run_search_learning_approx
    else
        run_search
    end
    netPayoff_diversity=netPayoff;
end
