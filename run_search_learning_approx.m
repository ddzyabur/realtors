stop = 0;
% current_means = consumerMeans_initial;
% current_vars = consumerVars_initial;
% time = 0;
signal_var = 0.0000001; %sigma_i^2 in chick Frazier, known to consumer
%signal_var = 0.0001; 
num_samples = zeros(numProducts,1);
search_values = zeros(numProducts,1);
initial_product_vars =  allProducts_binary*current_vars;
initial_product_means = allProducts_binary*current_means';
current_product_vars =  allProducts_binary*current_vars;
current_product_means = allProducts_binary*current_means';
n_0 = signal_var./current_product_vars;
n=n_0;
while stop ==0
   netSearch_value = 0;
    levels_to_search = zeros(1,numAttrs);
    search_value = zeros(1,numAspects);
    %compute the benefit from searching each attribute
    for attr = 1:numAttrs
        ustar = current_ustar(attr);
        for level = 1:numLevels
            aspect = numLevels*(attr-1)+level;
             mean = current_means(aspect);
                var = current_vars(aspect);
            fun = @(w,mu,sigma) w.*exp(-(w-mu).^2/(2*sigma));
            %search_value(aspect) = integral(@(w)fun(w,mean,var),ustar,Inf)/sqrt(var*2*pi);
            search_value(aspect) = integral(@(w)fun(w,mean,var),ustar,Inf);
        end
        %pick the level that is best to search
        [search,bestLevel]=max(search_value(beginAttr(attr):endAttr(attr)));
        netSearch_value = netSearch_value + search;
        levels_to_search(attr)=bestLevel;
    end
    if netSearch_value <cost
        stop =1;
    else
        searchedAspects(levels_to_search+beginAttr-1)=1;
         %update the means, vars of the attributes of the product
        aspects_to_update = levels_to_search+beginAttr-1;
        for aspect_index = 1:length(aspects_to_update);
            aspect = aspects_to_update(aspect_index);
            %draw a sample from the true mean, signal variance
            sampled_weight = randn(1)*sqrt(signal_var)+true_partworths(aspect);
            current_means(aspect)=current_means(aspect)+current_vars(aspect)/(current_vars(aspect)+signal_var)*(sampled_weight-current_means(aspect));
            current_vars(aspect)=current_vars(aspect)*signal_var/(current_vars(aspect)+signal_var);
        end
        for attr = 1:numAttrs
            current_ustar(attr)=max(0,max(current_means(beginAttr(attr):endAttr(attr))));
        end
        time = time+1;
        current_product_vars =  allProducts_binary*current_vars;
current_product_means = allProducts_binary*current_means';
    end
end

[expected_util,chosen_product]= max(current_product_means);
netPayoff = allProducts_binary(chosen_product,:)*true_partworths'-time*cost;
