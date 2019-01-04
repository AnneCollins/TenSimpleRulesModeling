function [Xfit, LL, BIC] = fit_M1random_v1(a, r)

obFunc = @(x) lik_M1random_v1(a, r, x);

X0 = rand;
LB = 0;
UB = 1;
[Xfit, NegLL] = fmincon(obFunc, X0, [], [], [], [], LB, UB);

LL = -NegLL;
BIC = length(X0) * log(length(a)) + 2*NegLL;