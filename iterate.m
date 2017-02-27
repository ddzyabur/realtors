clear all_netPayoffs all_max_utils;

rec_max_expected = 1;
rec_undervalued=1;
rec_diversity=1;
rec_KL = 0;
no_rec = 1;
rec_Weitzman = 1;
john_hack =1;
if john_hack==1
    rec_max_expected=1;
end
rec_mean_diff_variance = 0.1;
recommend2=1;
recommend3 = 0;

numIter=100;
% for iter = 1:numIter
%     run_sims
%     all_netPayoffs(iter)=netPayoff;
%     all_max_utils (iter)=max_util;
%     all_times (iter)=time;
% end
% 
% %sum(all_netPayoffs)/numIter
% sum(all_netPayoffs./all_max_utils)/numIter
% performance_max_expected = all_netPayoffs./all_max_utils;
% netPayoffs_max_expected = all_netPayoffs;
%%
if heterogeneity >=1
    all_true_partworths = zeros(numIter,numAspects);
    for iter = 1:numIter
        true_partworths = zeros(1,numAspects);
        for attr = 1:numAttrs
            %true_partworths(beginAttr(attr):endAttr(attr)) =
            %sample_ordered_partworths(heterogeneity,numLevels,mu_partworths,
            %.1,percent_0); %march 15 run
            true_partworths(beginAttr(attr):endAttr(attr)) =sample_ordered_partworths(heterogeneity,numLevels,mu_partworths,sigma_partworths,percent_0);
        end
        all_true_partworths(iter,:) = true_partworths;
    end
    %keyboard;
    recommenderMeans_initial = sum(all_true_partworths)/size(all_true_partworths,1);
end
for iter = 1:numIter
    %run_sims_sandbox;
    run_sims_corrprior;
    netPayoffs_diversity(iter) = netPayoff_diversity;
    %netPayoffs_KL(iter) = netPayoff_KL;
    netPayoffs_Weitzman(iter) = netPayoff_Weitzman;
    netPayoffs_no_rec(iter)=netPayoff_no_rec;
    netPayoffs_undervalued(iter) = netPayoff_undervalued;
    netPayoffs_max_expected(iter)=netPayoff_max_expected;
    all_max_utils (iter)=max_util;
    %all_times (iter)=time;
end

%sum(all_netPayoffs)/numIter
%performance_diversity = sum((netPayoffs_diversity - netPayoffs_no_rec)./(all_max_utils-netPayoffs_no_rec))/numIter;

%performance_max_expected = sum((netPayoffs_max_expected - netPayoffs_no_rec)./(all_max_utils-netPayoffs_no_rec))/numIter;


%%
interesting = find(all_max_utils-netPayoffs_no_rec>.5);
not_interesting = find(all_max_utils-netPayoffs_no_rec<1);

performance_diversity = sum(netPayoffs_diversity - netPayoffs_no_rec)/numIter;
%performance_KL = sum(netPayoffs_KL - netPayoffs_no_rec)/numIter;
performance_Weitzman = sum(netPayoffs_Weitzman - netPayoffs_no_rec)/numIter;
performance_diversity_interesting = sum((netPayoffs_diversity(interesting) - netPayoffs_no_rec(interesting)))/length(interesting);
performance_diversity_not_interesting = sum((netPayoffs_diversity(not_interesting) - netPayoffs_no_rec(not_interesting)))/length(not_interesting);
performance_undervalued = sum(netPayoffs_undervalued - netPayoffs_no_rec)/numIter;
performance_undervalued_interesting = sum((netPayoffs_undervalued(interesting) - netPayoffs_no_rec(interesting)))/length(interesting);
performance_undervalued_not_interesting = sum((netPayoffs_undervalued(not_interesting) - netPayoffs_no_rec(not_interesting)))/length(not_interesting);
performance_max_expected = sum(netPayoffs_max_expected - netPayoffs_no_rec)/numIter;
performance_max_expected_interesting = sum((netPayoffs_max_expected(interesting) - netPayoffs_no_rec(interesting)))/length(interesting);
performamce_max_expected_not_interesting = sum((netPayoffs_max_expected(not_interesting) - netPayoffs_no_rec(not_interesting)))/length(not_interesting);
%performance_KL_interesting = sum((netPayoffs_KL(interesting) - netPayoffs_no_rec(interesting)))/length(interesting);
%performamce_KL_not_interesting = sum((netPayoffs_KL(not_interesting) - netPayoffs_no_rec(not_interesting)))/length(not_interesting);

%%
% performance_diversity = sum(netPayoffs_diversity - netPayoffs_no_rec)/numIter;
% performance_diversity_interesting = sum((netPayoffs_diversity(interesting) - netPayoffs_no_rec(interesting))./netPayoffs_no_rec(interesting))/length(interesting)
% performance_diversity_not_interesting = sum((netPayoffs_diversity(not_interesting) - netPayoffs_no_rec(not_interesting))./netPayoffs_no_rec(not_interesting))/length(not_interesting);
% performance_undervalued = sum(netPayoffs_undervalued - netPayoffs_no_rec)/numIter;
% performance_undervalued_interesting = sum((netPayoffs_undervalued(interesting) - netPayoffs_no_rec(interesting))./netPayoffs_no_rec(interesting))/length(interesting)
% performance_undervalued_not_interesting = sum((netPayoffs_undervalued(not_interesting) - netPayoffs_no_rec(not_interesting))./netPayoffs_no_rec(not_interesting))/length(not_interesting);
% performance_max_expected = sum(netPayoffs_max_expected - netPayoffs_no_rec)/numIter;
% performance_max_expected_interesting = sum((netPayoffs_max_expected(interesting) - netPayoffs_no_rec(interesting))./netPayoffs_no_rec(interesting))/length(interesting)
% performamce_max_expected_not_interesting = sum((netPayoffs_max_expected(not_interesting) - netPayoffs_no_rec(not_interesting))./netPayoffs_no_rec(interesting))/length(not_interesting);