rec_max_expected = 1;
rec_undervalued=0;


all_mean_payoffs = zeros(1,11);
%rec_diff_variance = [.07:.01:.16];

for index = 1:length(rec_diff_variance);
    rec_mean_diff_variance = rec_diff_variance(index);
    iterate
    all_mean_payoffs(index)=sum(all_netPayoffs)/numIter;
end
    
payoffs_max_expected = all_mean_payoffs;

rec_max_expected = 0;
rec_undervalued=1;

all_mean_payoffs = zeros(1,11);

for index = 1:length(rec_diff_variance);
    rec_mean_diff_variance = rec_diff_variance(index);
    iterate
    all_mean_payoffs(index)=sum(all_netPayoffs)/numIter;
end
    
payoffs_diversity = all_mean_payoffs;