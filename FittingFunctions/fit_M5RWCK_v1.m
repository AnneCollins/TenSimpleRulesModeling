function [Xfit, LL, BIC] = fit_M5RWCK_v1(a, r)

obFunc = @(x) lik_M5RWCK_v1(a, r, x(1), x(2), x(3), x(4));

X0 = [rand exprnd(1) rand 0.5+exprnd(1)];
LB = [0 0 0 0];
UB = [1 inf 1 inf];
[Xfit, NegLL] = fmincon(obFunc, X0, [], [], [], [], LB, UB);

LL = -NegLL;
BIC = length(X0) * log(length(a)) + 2*NegLL;