function [a, r, s] = simulate_fullRL_v1(alpha, beta, T)

% values for each state
% Q(a,s) = value of taking action a in state s
Q = zeros(3);

for t = 1:T
        
    
    s(t) = randi(3);
    
    % compute choice probabilities
    p = exp(beta * Q(:,s(t)));
    p = p / sum(p);
    
    % choose
    a(t) = choose(p');
    
    % determine reward
    switch s(t)
        case 1 
            
            if a(t) == 1
                r(t) = 1;
            else
                r(t) = 0;
            end
            
        case 2
            
            if a(t) == 1
                r(t) = 1;
            else
                r(t) = 0;
            end
            
        case 3
            
            if a(t) == 3
                r(t) = 1;
            else
                r(t) = 0;
            end
    end
    
    % update values
    Q(a(t),s(t)) = Q(a(t),s(t)) + alpha * (r(t) - Q(a(t),s(t)));
    
end
