function Figure6_fitUnimportantParams

% Generate and recover: simulate with RLbias, fit with RL and RL bias
for rep=1:100
    rep
    % pick learning rate between .1 and .5
    alpha=.1+.4*rand;
    % pick inverse temperature between 1 and 9
    beta = 1+8*rand;
    % pick left-right bias between 0 and .2
    bias = .2*rand;
    % generate data
    D=simulate(alpha,beta,bias);
    % fit with both models
    [ps1,ps2]=fitRL(D);
    % save results: true params (1-3), RL fit params (4-6), RLbias params
    % (7-9).
    data(rep,:)=[alpha,beta,bias, [ps1(:,1:2) 0*ps1(:,1)],ps2(:,1:3)];
end

% rescale the fit inverse temperatures
data(:,5)=10*data(:,5);
data(:,8)=10*data(:,8);

% plot true against recovered parameters
names={'\alpha','\beta','bias'};


figure(1); clf;
set(gcf, 'Position', [440   378   700   450]);
wg = [0.09 0.1 0.1 0.03];
hg = [0.12 0.23 0.1];
[ax, hb, wb] = easy_gridOfEqualFigures(hg, wg);

AZred = [171,5,32]/256;
for i=1:2% for each parameter
    % top line: fits with classic RL
    axes(ax(i)); hold on;
    plot(data(:,i),data(:,3+i),'o', 'color', AZred, 'markersize', 8, 'linewidth', 1);
    if i == 1; xlim([0 0.6]); end
    plot(xlim,xlim,'k--')
    l = lsline;
    set(l, 'linewidth', 3)
    
    xlabel(['simulated ',names{i}])
    ylabel(['fit ',names{i}])
end

for i = 1:3
    % bottom line: fits with RL + bias.
    axes(ax(i+3)); hold on;
    plot(data(:,i),data(:,6+i),'o', 'color', AZred, 'markersize', 8, 'linewidth', 1)
    plot(xlim,xlim,'k--')
    if i == 1; xlim([0 0.6]); end
    l = lsline;
    set(l, 'linewidth', 3)
    hold on
    
    xlabel(['simulated ',names{i}])
    ylabel(['fit ',names{i}])
    
end
set(ax([1 4]), 'xtick', [0:0.2:0.6], 'ylim', [0 1])
set(ax(3), 'visible', 'off')
x1 = wg(1)/3;
x2 = sum(wb(1:2))+wg(2);
y1 = sum(hb(1:2)+hg(1:2)');
h = annotation('textbox', [x1 y1 x2 hg(end)], 'string', 'model 3 without bias', ...
    'horizontalalignment', 'left', 'fontsize', 24, 'linestyle', 'none', ...
    'fontweight', 'bold')

x1 = wg(1)/3;
x2 = sum(wb(1:3))+sum(wg(2:3));
y1 = sum(hb(1)+hg(1)');
h = annotation('textbox', [x1 y1 x2 hg(end)], 'string', 'model 3 including bias', ...
    'horizontalalignment', 'left', 'fontsize', 24, 'linestyle', 'none', ...
    'fontweight', 'bold')

set(ax, 'fontsize', 18, 'tickdir', 'out')

saveFigurePdf(gcf, '~/Desktop/Figure6b')






end

function D=simulate(alpha,beta,bias)
% simulate RL
k=0;
for s=1:10
    % define the correct action for this block
    if mod(s,2) == 1
        corA = 1;
    else
        corA = 2;
    end
    %corA=1+(rand>.5);
    % initialize Q-values
    Q=[.5 .5];
    % run 50 trials
    for t=1:50
        k=k+1;
        % bias in favor of choice 1 in the softmax
        p2=1/(1+exp(beta*(bias+Q(1)-Q(2))));
        % select an action, decide if correct
        a=1+(rand<p2);
        c=a==corA;
        % probabilistically determine reward
        if rand<.8,r=c;else r=1-c;end
        % RL update
        Q(a)=Q(a)+alpha*(r-Q(a));
        % store the data
        D(k,:)=[s,a,r];
    end
end
end

function [ps1,ps2] = fitRL(D)
choice=D(:,2);
reward=D(:,3);
options=optimset('MaxFunEval',100000,'Display','off','algorithm','active-set');%

% fit with no bias RL
for init=1:20
    % 20 starting points
    x0=rand(1,2);
    [pval,fval,bla,bla2] =fmincon(@(x) LLH1(x,choice,reward),x0,[],[],[],[],...
        [0 0],[1 1],[],options);
    ps1(init,:) = [pval,fval];
end
[~,i]=min(ps1(:,end));
ps1 = ps1(i,:);

% fit with bias RL
for init=1:20
    x0=rand(1,3);
    [pval,fval,bla,bla2] =fmincon(@(x) LLH2(x,choice,reward),x0,[],[],[],[],...
        [0 0 0],[1 1 1],[],options);
    ps2(init,:) = [pval,fval];
end
[~,i]=min(ps2(:,end));
ps2 = ps2(i,:);

end


function llh=LLH1(p,choice,reward)
% compute likelihood function for no bias RL
alpha = p(1);
beta=10*p(2);
bias=0;
k=0;
for s=1:10
    Q=[.5 .5];
    llh=0;
    for t=1:50
        k=k+1;
        p2=1/(1+exp(beta*(bias+Q(1)-Q(2))));
        pr=[1-p2 p2];
        a=choice(k);
        r=reward(k);
        
        Q(a)=Q(a)+alpha*(r-Q(a));
        llh=llh+log(pr(a));
    end
end
llh=-llh;
end

function llh=LLH2(p,choice,reward)
% compute likelihood function for bias RL

alpha = p(1);
beta=10*p(2);
bias=p(3);

k=0;
llh=0;
for s=1:10
    Q=[.5 .5];
    for t=1:50
        k=k+1;
        p2=1/(1+exp(beta*(bias +Q(1)-Q(2))));
        pr=[1-p2 p2];
        a=choice(k);
        r=reward(k);
        
        Q(a)=Q(a)+alpha*(r-Q(a));
        llh=llh+log(pr(a));
    end
end
llh=-llh;
end