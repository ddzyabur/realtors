function y = gaussmix(n,m1,m2,s1,s2,alpha)
y = zeros(n,1);
U = rand(n,1);
I = (U < alpha);
y = I.*(randn(n,1)*s1+m1) + (1-I).*(randn(n,1)*s2 + m2);