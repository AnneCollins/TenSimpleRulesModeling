function NegLL = lik_M5RWCK_v1(a, r, alpha, beta, alpha_c, beta_c)

Q = [0.5 0.5];
CK = [0 0];


T = length(a);

% loop over all trial
for t = 1:T
    
    % compute choice probabilities
    V = beta * Q + beta_c * CK;
    p = exp(V) / sum(exp(V));
    
    % compute choice probability for actual choice
    choiceProb(t) = p(a(t));
    
    % update values
    delta = r(t) - Q(a(t));
    Q(a(t)) = Q(a(t)) + alpha * delta;

    % update choice kernel
    CK = (1-alpha_c) * CK;
    CK(a(t)) = CK(a(t)) + alpha_c * 1;
    
end

% compute negative log-likelihood
NegLL = -sum(log(choiceProb));