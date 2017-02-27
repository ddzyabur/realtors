bigTable_max_expected = zeros(11,11);
bigTable_undervalued = zeros(11,11);
bigTable_diversity = zeros(11,11);
bigTable_diversity_std = zeros(11,11);
bigTable_undervalued_std = zeros(11,11);
bigTable_max_expected = zeros(11,11);
bigTable_KL = zeros(11,11);
run_id = '26-Feb-2017';
for index = 1:11
    allRuns_performance_max_expected = zeros(1,numRuns);
    allRuns_performance_diversity = zeros(1,numRuns);
    allRuns_performance_undervalued = zeros(1,numRuns);
    allRuns_performance_KL = zeros(1,numRuns);
    for run_no = 1:numRuns
        load( sprintf('vary_both_corrprior_date%s_run%04d_idx%04d', run_id, run_no,index));
        set_to_0_index = find(all_set_to_0==set_to_0);
        %set_to_0_index = 1;
        %heterogeneity_index = find(all_heterogeneity==heterogeneity);
        heterogeneity_index = 1;
        %heterogeneity_index = find(all_set_to_0_recSys==set_to_0_recSys);
        allRuns_performance_max_expected(run_no) = pack.performance_max_expected;
        %allRuns_performance_KL(run_no) = pack.performance_KL;
        allRuns_performance_Weitzman(run_no) = pack.performance_Weitzman;
        allRuns_performance_diversity(run_no) = pack.performance_diversity;
        allRuns_performance_undervalued(run_no) = pack.performance_undervalued;
        allRuns_netPayoffs_max_expected(run_no) = pack.netPayoffs_max_expected;
        allRuns_netPayoffs_diversity(run_no) = pack.netPayoffs_diversity;
        allRuns_netPayoffs_undervalued(run_no) = pack.netPayoffs_undervalued;
        %allRuns_netPayoffs_KL(run_no) = pack.netPayoffs_KL;
        allRuns_netPayoffs_Weitzman(run_no) = pack.netPayoffs_Weitzman;
    end
    bigTable_max_expected(heterogeneity_index, set_to_0_index)=sum(allRuns_performance_max_expected)/numRuns;
    bigTable_Weitzman(heterogeneity_index, set_to_0_index)=sum(allRuns_performance_Weitzman)/numRuns;
    bigTable_diversity(heterogeneity_index, set_to_0_index)=sum(allRuns_performance_diversity)/numRuns;
    bigTable_undervalued(heterogeneity_index, set_to_0_index)=sum(allRuns_performance_undervalued)/numRuns;
    bigTable_max_expected_std(heterogeneity_index, set_to_0_index)=std(allRuns_performance_max_expected);
    bigTable_diversity_std(heterogeneity_index, set_to_0_index)=std(allRuns_performance_diversity);
    bigTable_undervalued_std(heterogeneity_index, set_to_0_index)=std(allRuns_performance_undervalued);
    bigTable_netPayoffs_max_expected(heterogeneity_index, set_to_0_index)=sum(allRuns_netPayoffs_max_expected)/numRuns;
    bigTable_netPayoffs_diversity(heterogeneity_index, set_to_0_index)=sum(allRuns_netPayoffs_diversity)/numRuns;
    bigTable_netPayoffs_undervalued(heterogeneity_index, set_to_0_index)=sum(allRuns_netPayoffs_undervalued)/numRuns;
    bigTable_netPayoffs_Weitzman(heterogeneity_index, set_to_0_index)=sum(allRuns_netPayoffs_Weitzman)/numRuns;
end
