function [BIC, iBEST, BEST] = fit_all_v1(a, r)

[~, ~, BIC(1)] = fit_M1random_v1(a, r);
[~, ~, BIC(2)] = fit_M2WSLS_v1(a, r);
[~, ~, BIC(3)] = fit_M3RescorlaWagner_v1(a, r);
[~, ~, BIC(4)] = fit_M4CK_v1(a, r);
[~, ~, BIC(5)] = fit_M5RWCK_v1(a, r);

[M, iBEST] = min(BIC);
BEST = BIC == M;
BEST = BEST / sum(BEST);