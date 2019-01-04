function [a, r] = simulate_M4ChoiceKernel_v1(T, mu, alpha_c, beta_c)

CK = [0 0];

for t = 1:T
    
    % compute choice probabilities
    p = exp(beta_c*CK) / sum(exp(beta_c*CK));
    
    % make choice according to choice probababilities
    a(t) = choose(p);
    
    % generate reward based on choice
    r(t) = rand < mu(a(t));
    
    % update choice kernel
    CK = (1-alpha_c) * CK;
    CK(a(t)) = CK(a(t)) + alpha_c * 1;
            
    
end
