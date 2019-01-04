function [Xfit, LL, BIC] = fit_M6RescorlaWagnerBias_v1(a, r)

obFunc = @(x) lik_M6RescorlaWagnerBias_v1(a, r, x(1), x(2), x(3));

X0 = [rand exprnd(1) rand*0.2];
LB = [0 0 -1];
UB = [1 inf 1];
[Xfit, NegLL] = fmincon(obFunc, X0, [], [], [], [], LB, UB);




LL = -NegLL;
BIC = length(X0) * log(length(a)) + 2*NegLL;