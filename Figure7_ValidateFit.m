%%%%% Bob Wilson & Anne Collins
%%%%% 2018
%%%%% Code to produce figure 7 in submitted paper "Ten simple rules for the
%%%%% computational modeling of behavioral data"


function Figure7_ValidateFit

addpath('./SimulationFunctions')
addpath('./AnalysisFunctions')
addpath('./HelperFunctions')
addpath('./FittingFunctions')
addpath('./LikelihoodFunctions')

name={'blind RL agent','RL agent'};

for iter=1:2
    % for each agent
    for rep=1:10%0
        rep
        if iter==1
            % simulate the blind agent
            alphaP=.3+.4*rand;
            beta = 4+5*rand;
            [D,P]=simulateflaw(alphaP,beta);
        else
            % simulate the RL agent
            alphaP=.6+.1*rand;
            beta = 2;
            [D,P]=simulate(alphaP,beta);
        end
        % store agent's performance
        toplot{iter}(rep,:,1)=mean(P);
        % fit the data with RL model
        [ps2,P2,L2]=fitRL(D);
        toplot{iter}(rep,:,4)=P2;% store posterior probability(correct) per trial
        toplot{iter}(rep,:,2)=L2;% store likelihood of chosen action
        % simulate the RL model with fit parameters
        [D,P]=simulate(ps2(1),10*ps2(2));
        % store performance of fit model
        toplot{iter}(rep,:,3)=mean(P);
    end
    col = {'k','k--','g','g--'};
    % plot the learning curves for each measure
end

%%
col1 = [250 167 19]/256;
col2 = [3 36 89]/256;

%%
figure(1); clf;
set(gcf, 'Position', [ 210   489   800   300])
ax = easy_gridOfEqualFigures([0.2 0.15], [0.08 0.11 0.11 0.02]);
axes(ax(1)); hold on;
type = 1;
for iter = 1:2
    e(iter,1) = errorbar(mean(toplot{iter}(:,:,type)),std(toplot{iter}(:,:,type))/sqrt(rep));
end
t = title({'''subject''' 'learning curves'});
legend({'blind RL' 'state-based RL' })
xlabel('time step')
ylabel('p(correct)')
% plot([0 16], [1 1]*1/3, 'k--')
% plot([0 16], [1 1]*2/3, 'k--')

axes(ax(2)); hold on;
type = 2;
for iter = 1:2
    e(iter,2) = errorbar(mean(toplot{iter}(:,:,type)),std(toplot{iter}(:,:,type))/sqrt(rep));
end
t(2) = title({'likelihood of' 'state-based RL model'});
xlabel('time step')
ylabel('likelihood of choice')
% plot([0 16], [1 1]*1/3, 'k--')
% plot([0 16], [1 1]*2/3, 'k--')


axes(ax(3)); hold on;
type = 3;
for iter = 1:2
    e(iter,3) = errorbar(mean(toplot{iter}(:,:,type)),std(toplot{iter}(:,:,type))/sqrt(rep));
end
t(3) = title({'simulated learning curves' 'from state-based RL'});
xlabel('time step')
ylabel('p(correct)')

set(e(1,:), 'color', col1)
set(e(2,:), 'color', col2)
set(e, 'linewidth', 2)
% set(ax, 'ylim', [0 1], 'xlim', [0 16], 'xtick', [1 5 10 15 20], ...
%     'tickdir', 'out', 'fontsize', 18, 'ytick', [0 1/3 2/3 1], ...
%     'yticklabel', {'0' '1/3' '2/3' 1})
set(ax, 'ylim', [0.2 1], 'xlim', [0 16], 'xtick', [1 5 10 15 20], ...
    'tickdir', 'out', 'fontsize', 18)
set(t, 'fontsize', 18, 'fontweight', 'normal')
% plot([0 16], [1 1]*1/3, 'k--')
% plot([0 16], [1 1]*2/3, 'k--')
addABCs(ax, [-0.06 0.12], 32)
saveFigurePdf(gcf, '~/Figures/Figure7')
% %%
% subplot(1,2,iter)
% hold on
% for type=1:4
%     errorbar(mean(toplot(:,:,type)),std(toplot(:,:,type))/sqrt(rep),col{type},'linewidth',2)
% end
% ylim([.2 1])
% legend('data','likelihood','simulation','posterior')
% set(gca,'fontsize',14)
% xlabel('iteration')
% ylabel('P(Correct)')
% title(name{iter})
%%
end

function [D,P]=simulateflaw(alphaP,beta)
alphaN=0;
k=0;
for s=1:10
    Q=ones(3,3)/3;
    for t=1:45
        k=k+1;
        o=1+rem(t-1,3);
        corA=1+rem(o-1,2);
        p=exp(beta*Q(1,:))/sum(exp(beta*Q(1,:)));
        cdf=[0 cumsum(p)];
        a=find(cdf<rand);a=a(end);
        r=a==corA;
        alpha = r*alphaP + (1-r)*alphaN;
        Q(o,a)=Q(o,a)+alpha*(r-Q(o,a));
        D(k,:)=[s,a,r];
        P(s,t)=r;
    end
end
P = (P(:,1:3:end)+P(:,2:3:end)+P(:,3:3:end))/3;
end

function [D,P]=simulate(alphaP,beta)
alphaN=0;
k=0;
for s=1:10
    Q=ones(3,3)/3;
    for t=1:45
        k=k+1;
        o=1+rem(t-1,3);
        corA=1+rem(o-1,2);
        p=exp(beta*Q(o,:))/sum(exp(beta*Q(o,:)));
        cdf=[0 cumsum(p)];
        a=find(cdf<rand);a=a(end);
        r=a==corA;
        alpha = r*alphaP + (1-r)*alphaN;
        Q(o,a)=Q(o,a)+alpha*(r-Q(o,a));
        D(k,:)=[s,a,r];
        P(s,t)=r;
    end
end
P = (P(:,1:3:end)+P(:,2:3:end)+P(:,3:3:end))/3;
end

function [ps2,P2,L2] = fitRL(D)
choice=D(:,2);
reward=D(:,3);
options=optimset('MaxFunEval',100000,'Display','off','algorithm','active-set');%

for init=1:20
    x0=rand(1,2);
    [pval,fval,bla,bla2] =fmincon(@(x) LLH2(x,choice,reward),x0,[],[],[],[],...
        [0 0],[1 1],[],options);
    ps2(init,:) = [pval,fval];
end
[~,i]=min(ps2(:,end));
ps2 = ps2(i,:);
[P2,L2]=Posterior2(ps2(1),ps2(2),choice,reward);
P2=mean(P2);
L2=mean(L2);
end


function llh=LLH2(p,choice,reward)

alphaP = p(1);
alphaN = 0;
beta=10*p(2);

k=0;
llh=0;
for s=1:10
    Q=ones(3,3)/3;
    llh=0;
    for t=1:45
        k=k+1;
        o=1+rem(t-1,3);
        corA=1+rem(o-1,2);
        a=choice(k);
        pr=exp(beta*Q(o,a))/sum(exp(beta*Q(o,:)));
        r=reward(k);
        alpha = r*alphaP + (1-r)*alphaN;
        Q(o,a)=Q(o,a)+alpha*(r-Q(o,a));
        llh=llh+log(pr);
    end
end
llh=-llh;
end


function [P,L]=Posterior2(alphaP,beta,choice,reward)

k=0;alphaN=0;
beta=10*beta;
for s=1:10
    Q=ones(3,3)/3;
    for t=1:45
        k=k+1;
        o=1+rem(t-1,3);
        corA=1+rem(o-1,2);
        pr=exp(beta*Q(o,:))/sum(exp(beta*Q(o,:)));
        a=choice(k);
        r=reward(k);
        alpha = r*alphaP + (1-r)*alphaN;
        Q(o,a)=Q(o,a)+alpha*(r-Q(o,a));
        P(s,t)=pr(corA);
        L(s,t)=pr(a);
    end
end
P = (P(:,1:3:end)+P(:,2:3:end)+P(:,3:3:end))/3;
L = (L(:,1:3:end)+L(:,2:3:end)+L(:,3:3:end))/3;
end