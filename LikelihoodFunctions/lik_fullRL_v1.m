function [NegLL, choiceProb, CP] = lik_fullRL_v1(a, r, s, alpha, beta)

% values for each state
% Q(a,s) = value of taking action a in state s
Q = zeros(3);

T = length(a);
for t = 1:T
        
    % compute choice probabilities
    p = exp(beta * Q(:,s(t)));
    p = p / sum(p);
    CP(:,t) = p;
    
    % compute probability of chosen option
    choiceProb(t) = p(a(t));
    
    % update values
    Q(a(t),s(t)) = Q(a(t),s(t)) + alpha * (r(t) - Q(a(t),s(t)));
    
end

% compute negative log-likelihood
NegLL = -sum(log(choiceProb));