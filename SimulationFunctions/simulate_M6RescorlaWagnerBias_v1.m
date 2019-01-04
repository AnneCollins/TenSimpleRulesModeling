function [a, r] = simulate_M6RescorlaWagnerBias_v1(T, mu, alpha, beta, Qbias)

Q = [0.5 0.5];

for t = 1:T
    
    % compute choice probabilities
    V = Q;
    V(1) = V(1) + Qbias;
    p = exp(beta*V) / sum(exp(beta*V));
    
    % make choice according to choice probababilities
    a(t) = choose(p);
    
    % generate reward based on choice
    r(t) = rand < mu(a(t));
    
    % update values
    delta = r(t) - Q(a(t));
    Q(a(t)) = Q(a(t)) + alpha * delta;

end

