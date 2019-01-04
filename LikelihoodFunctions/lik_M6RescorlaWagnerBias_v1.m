function NegLL = lik_M6RescorlaWagnerBias_v1(a, r, alpha, beta, Qbias)


Q = [0.5 0.5];


T = length(a);

% loop over all trial
for t = 1:T
    
    % compute choice probabilities
    V = Q;
    V(1) = V(1) + Qbias;
    p = exp(beta*V) / sum(exp(beta*V));
    
    % compute choice probability for actual choice
    choiceProb(t) = p(a(t));
    
    % update values
    delta = r(t) - Q(a(t));
    Q(a(t)) = Q(a(t)) + alpha * delta;

end

% compute negative log-likelihood
NegLL = -sum(log(choiceProb));