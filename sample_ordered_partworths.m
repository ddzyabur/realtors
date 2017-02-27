function partworths = sample_ordered_partworths(heterogeneity,numLevels,mu_partworths,sigma_partworths,percent_0);

%numLevels = 5;
dummy = drchrnd(linspace(1,heterogeneity,numLevels),1);
[y,I] = sort(dummy);
x = randn(numLevels,1)*sqrt(sigma_partworths)+mu_partworths;
y = rand(numLevels,1);
for aspect = 1:numLevels
    if y(aspect)<percent_0
        x(aspect)=randn;
    end
end
%x = gaussmix(numLevels,0,mu_partworths,.5,sigma_partworths,percent_0);
x = sort(x);
partworths = x(I); %biggest one goes first