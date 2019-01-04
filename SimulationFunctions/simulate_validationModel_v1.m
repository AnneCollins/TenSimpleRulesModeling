function [AA, RR, QQ] = simulate_validationModel_v1(alpha, beta, T)
Q = [0 0 0];
for t = 1:T
    
    s = randi(3);
    
    % compute choice probabilities
    p = exp(beta * Q);
    p = p / sum(p);
    
    % choose
    a = choose(p);
    
    % determine reward
    switch s
        case 1 
            
            if a == 1
                r = 1;
            else
                r = 0;
            end
            
        case 2
            
            if a == 1
                r = 1;
            else
                r = 0;
            end
            
        case 3
            
            if a == 3
                r = 1;
            else
                r = 0;
            end
    end
    
    % update values
    Q(a) = Q(a) + alpha * (r - Q(a));
    QQ(:,t) = Q;
    AA(t) = a;
    RR(t) = r;
end