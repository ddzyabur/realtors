function search_value = compute_search_value(current_mu, current_sigma,cost,num_samples,delta)
%from Chick and Frazier 2012, page 559
s=current_sigma^(2/3)/(cost^(2/3)*num_samples);
search_value = b_ChickFrazier(s)-delta/cost^(1/3)/current_sigma^(2/3);