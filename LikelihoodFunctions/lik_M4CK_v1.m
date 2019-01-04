function NegLL = lik_M4CK_v1(a, r, alpha_c, beta_c)


CK = [0 0];


T = length(a);

% loop over all trial
for t = 1:T
    
    % compute choice probabilities
    p = exp(beta_c*CK) / sum(exp(beta_c*CK));
    
    % compute choice probability for actual choice
    choiceProb(t) = p(a(t));
    
    % update choice kernel
    CK = (1-alpha_c) * CK;
    CK(a(t)) = CK(a(t)) + alpha_c * 1;
    
end

% compute negative log-likelihood
NegLL = -sum(log(choiceProb));