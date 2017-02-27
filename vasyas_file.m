numRuns = 10;
varying = all_set_to_0;
all_performance_max_expected_runs = zeros(numRuns,size(varying,2));
all_performance_diversity_runs = zeros(numRuns,size(varying,2));
all_performance_undervalued_runs = zeros(numRuns,size(varying,2));

% for run_no = 1:numRuns
%     load ( sprintf('vary_weight_truth_corrprior_large%02d', run_no));
%     all_performance_diversity_runs=all_performance_diversity_runs(1:2,1:6);
%     all_performance_undervalued_runs=all_performance_undervalued_runs(1:2,1:6);
% 	all_performance_max_expected_runs=all_performance_max_expected_runs(1:2,1:6);
%     all_performance_diversity_runs(run_no,:)=all_performance_diversity(1:6);
%     all_performance_undervalued_runs(run_no,:)=all_performance_undervalued(1:6);
%     all_performance_max_expected_runs(run_no,:)=all_performance_max_expected(1:6);
%     numRuns = 2;
% end
% for run_no = 1:numRuns
%     load ( sprintf('vary_weight_truth_corrprior_large%02d', run_no));
%     all_performance_diversity_run(run_no,:)=all_performance_diversity(1:6);
%     all_performance_undervalued_run(run_no,:)=all_performance_undervalued(1:6);
%     all_performance_max_expected_run(run_no,:)=all_performance_max_expected(1:6);
%end
for run_no = 1:numRuns
    load ( sprintf('vary_set_to_0_corrprior_large%02d', run_no));
    all_performance_diversity_runs(run_no,:)=all_performance_diversity;
    all_performance_undervalued_runs(run_no,:)=all_performance_undervalued;
    all_performance_max_expected_runs(run_no,:)=all_performance_max_expected;
end
figure;
plot(varying,sum(all_performance_max_expected_runs)/numRuns,'r')
hold on;
plot(varying,sum(all_performance_diversity_runs)/numRuns)
plot(varying,sum(all_performance_undervalued_runs)/numRuns,'k')
%%
max_expected_stdevs = std(all_performance_max_expected_runs);
diversity_stdevs = std(all_performance_diversity_runs);
undervalued_stdevs = std(all_performance_undervalued_runs);
figure;
errorbar(varying,sum(all_performance_max_expected_runs)/numRuns,max_expected_stdevs/sqrt(numRuns), 'r')
hold on;
errorbar(varying,sum(all_performance_diversity_runs)/numRuns,diversity_stdevs/sqrt(numRuns))
errorbar(varying,sum(all_performance_undervalued_runs)/numRuns,undervalued_stdevs/sqrt(numRuns), 'k')

%%
excel_output_max_expected = zeros(length(varying),2);
excel_output_undervalued = zeros(length(varying),2);
excel_output_diversity = zeros(length(varying),2);
excel_output_diversity(:,1)=sum(all_performance_diversity_runs)/numRuns;
excel_output_max_expected(:,1)=sum(all_performance_max_expected_runs)/numRuns;
excel_output_undervalued(:,1)=sum(all_performance_undervalued_runs)/numRuns;
excel_output_diversity(:,2)=diversity_stdevs;
excel_output_max_expected(:,2)=max_expected_stdevs;
excel_output_undervalued(:,2)=undervalued_stdevs;

