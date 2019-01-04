function [a, r] = simulate_M5RWCK_v1(T, mu, alpha, beta, alpha_c, beta_c)

Q = [0.5 0.5];
CK = [0 0];

for t = 1:T
    
    % compute choice probabilities
    V = beta * Q + beta_c * CK;
    p = exp(V) / sum(exp(V));
                
    % make choice according to choice probababilities
    a(t) = choose(p);
    
    % generate reward based on choice
    r(t) = rand < mu(a(t));
    
    % update values
    delta = r(t) - Q(a(t));
    Q(a(t)) = Q(a(t)) + alpha * delta;

    % update choice kernel
    CK = (1-alpha_c) * CK;
    CK(a(t)) = CK(a(t)) + alpha_c * 1;
            
    
end
