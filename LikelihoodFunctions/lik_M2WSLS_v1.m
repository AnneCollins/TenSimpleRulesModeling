function NegLL = lik_M2WSLS_v1(a, r, epsilon)


% last reward/action (initialize as nan)
rLast = nan;
aLast = nan;


T = length(a);

% loop over all trial
for t = 1:T
    
     % compute choice probabilities
    if isnan(rLast)
        
        % first trial choose randomly
        p = [0.5 0.5];
        
    else
        
        % choice depends on last reward
        if rLast == 1
            
            % win stay (with probability 1-epsilon)
            p = epsilon/2*[1 1];
            p(aLast) = 1-epsilon/2;
            
        else
            
            % lose shift (with probability 1-epsilon)
            p = (1-epsilon/2) * [1 1];
            p(aLast) = epsilon / 2;
            
        end
    end
    
    % compute choice probability for actual choice
    choiceProb(t) = p(a(t));
    
    aLast = a(t);
    rLast = r(t);
end

% compute negative log-likelihood
NegLL = -sum(log(choiceProb));