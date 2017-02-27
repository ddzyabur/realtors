stop = 0;
while stop ==0
    netSearch_value = 0;
    levels_to_search = zeros(1,numAttrs);
    search_value = zeros(1,numAspects);
    %compute the benefit from searching each attribute
    for attr = 1:numAttrs
        ustar = current_ustar(attr);
        for level = 1:numLevels
            aspect = numLevels*(attr-1)+level;
            if searchedAspects(aspect)==0
                mean = consumerMeans_initial(aspect);
                var = consumerVars_initial(aspect);
            fun = @(w,mu,sigma) w.*exp(-(w-mu).^2/(2*sigma));
            search_value(aspect) = integral(@(w)fun(w,mean,var),ustar,Inf)/sqrt(var*2*pi);
            end
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
        current_means(levels_to_search+beginAttr-1)=true_partworths(levels_to_search+beginAttr-1);
        for attr = 1:numAttrs
            current_ustar(attr)=max(0,max(current_means(beginAttr(attr):endAttr(attr))));
        end
        time = time+1;
    end
end

expectedPayoff = -time*cost;
netPayoff = -time*cost;
for attr = 1:numAttrs
    [expectedUtil, level_chosen]= max(current_means(beginAttr(attr):endAttr(attr)));
    if expectedUtil>0
        expectedPayoff = expectedPayoff + expectedUtil;
        netPayoff = netPayoff + true_partworths(beginAttr(attr)+level_chosen-1);
    end
end

max_util = 0;
for attr = 1:numAttrs
    [util, level]= max(true_partworths(beginAttr(attr):endAttr(attr)));
    max_util = max_util + util;
end
