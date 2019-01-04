function [a, r] = simulate_M1random_v1(T, mu, b)

for t = 1:T
    
    % compute choice probabilities
    p = [b 1-b];
    
    % make choice according to choice probababilities
    a(t) = choose(p);
    
    % generate reward based on choice
    r(t) = rand < mu(a(t));
    
end
