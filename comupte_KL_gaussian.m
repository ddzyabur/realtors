function KL = compute_KL_gaussian(mu_1, mu_2, sigma_1, sigma_2)
for attr = 1:length(mu_1)
    KL_attr = 0.5*sigma_1(attr)/sigma_2(attr)+(mu_1(attr)-mu_2(attr))^2/sigma_2(attr)+log(sigma_2(attr)/sigma_1(attr));
end
KL=sum(KL_attr)
%KL =0.5*log(sigma_1/sigma_2)+(sigma_1+(mu_1-mu_2)^2)/sigma_2-0.5;