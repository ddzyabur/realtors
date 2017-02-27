clear all;
run_id = date;
numAttrs = 	2;
numLevels = 6;
numAspects = numLevels*numAttrs;
numProducts = numLevels^numAttrs;
endAttr = cumsum(repmat(numLevels,1,numAttrs));
beginAttr = [1,endAttr+1];
beginAttr(end)=[];
allProducts = fullfact(repmat(numLevels,1,numAttrs));
mu_partworths = 3;
sigma_partworths = .5;
percent_0 = .2;
percent_0_prior = .5;
numRuns = 10;
outsideUtil = 6;
cost = 0.1;
for run_no = 1:numRuns
    
all_set_to_0 = 0:.1:1;
%all_set_to_0 = .4;
%all_heterogeneity = 1:1.5:16;
%all_heterogeneity = 0:.1:1;
%all_set_to_0_recSys = 0:.1:1;
all_set_to_0_recSys = .6;
weight_consumer = .3;

index = 1;
for set_to_0 = all_set_to_0
for set_to_0_recSys = all_set_to_0_recSys
    disp(set_to_0_recSys)
    heterogeneity = 6;
    iterate;
    params.set_to_0_recSys = set_to_0_recSys ;
    params.set_to_0      = set_to_0;
    params.numIter       = numIter;
    params.signal_var = signal_var;
    params.weight_consumer  = weight_consumer;
 
    
    clear pack;
    pack.params                   = params;
%     pack.performance_max_expected = performance_max_expected_interesting;
%     pack.netPayoffs_max_expected  = sum(netPayoffs_max_expected)/numIter;
%     pack.netPayoffs_diversity     = sum(netPayoffs_diversity)/numIter;
%     pack.performance_diversity    = performance_diversity_interesting;
%     pack.performance_undervalued  = performance_undervalued_interesting;
%     pack.netPayoffs_undervalued   = sum(netPayoffs_undervalued)/numIter;
%     pack.netPayoffs_no_rec        = sum(netPayoffs_no_rec)/numIter;
%     pack.max_util                 = sum(all_max_utils)/numIter; 
    pack.performance_max_expected = performance_max_expected;
    pack.netPayoffs_max_expected  = sum(netPayoffs_max_expected)/numIter;
    %pack.performance_KL= performance_KL;
    pack.performance_Weitzman= performance_Weitzman;
    %pack.netPayoffs_KL  = sum(netPayoffs_KL)/numIter;
    pack.netPayoffs_Weitzman  = sum(netPayoffs_Weitzman)/numIter;
    pack.netPayoffs_diversity     = sum(netPayoffs_diversity)/numIter;
    pack.performance_diversity    = performance_diversity;
    pack.performance_undervalued  = performance_undervalued;
    pack.netPayoffs_undervalued   = sum(netPayoffs_undervalued)/numIter;
    pack.netPayoffs_no_rec        = sum(netPayoffs_no_rec)/numIter;
    pack.max_util                 = sum(all_max_utils)/numIter; 
  
    save( sprintf('vary_both_corrprior_date%s_run%04d_idx%04d', run_id, run_no,index));
    index = index + 1;
end
end
end

fullGrid_extract_values
figure;
plot(bigTable_undervalued(1,:))
hold on;
plot(bigTable_diversity(1,:),'r')
plot(bigTable_max_expected(1,:),'k')
plot(bigTable_Weitzman(1,:),'g')

