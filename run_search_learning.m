stop = 0;
% current_means = consumerMeans_initial;
% current_vars = consumerVars_initial;
% time = 0;
signal_var = 0.01; %sigma_i^2 in chick Frazier, known to consumer
num_samples = zeros(numProducts,1);
search_values = zeros(numProducts,1);
initial_product_vars =  allProducts_binary*current_vars;
initial_product_means = allProducts_binary*current_means';
current_product_vars =  allProducts_binary*current_vars;
current_product_means = allProducts_binary*current_means';
n_0 = signal_var./current_product_vars;
n=n_0;
while stop ==0
        for product = 1:numProducts
        %compute max excluding product, including outside good=0
        dummy = current_product_means;
        dummy(product)=outsideUtil;
        delta = abs(current_product_means(product)-max(dummy));
        search_values(product) = compute_search_value(current_product_means(product), current_product_vars(product),cost,n_0(product),delta);
    end
    if max(search_values)<0
        stop =1;
    else 
        [max_search_value, product_to_search] = max(search_values);
        %update the means, vars of the attributes of the product
        aspects_to_update = find(allProducts_binary(product_to_search,:));
        for aspect_index = 1:length(aspects_to_update);
            aspect = aspects_to_update(aspect_index);
            %draw a sample from the true mean, signal variance
            sampled_weight = randn(1)*sqrt(signal_var)+true_partworths(aspect);
            current_means(aspect)=current_means(aspect)+current_vars(aspect)/(current_vars(aspect)+signal_var)*(sampled_weight-current_means(aspect));
            current_vars(aspect)=current_vars(aspect)*signal_var/(current_vars(aspect)+signal_var);
        end
        num_samples(product_to_search)=num_samples(product_to_search)+1;
        n(product_to_search)=n(product_to_search)+1;
        time = time+1;
        current_product_vars =  allProducts_binary*current_vars;
current_product_means = allProducts_binary*current_means';
    end
end

[expected_util,chosen_product]= max(current_product_means);
netPayoff = allProducts_binary(chosen_product,:)*true_partworths'-time*cost;
