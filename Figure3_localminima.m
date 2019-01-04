%%%%% Bob Wilson & Anne Collins
%%%%% 2018
%%%%% Code to produce figure 3 in submitted paper "Ten simple rules for the
%%%%% computational modeling of behavioral data"


clear all
% dfine a range of learning rates to test
alphas = [0.05:.05:1];
% define a range of softmax parameters to test
betas = [1 5:5:50];
% define a range of WM reliance to test
rhos=[0:.05:1];
% define a range of capacities to test
Ks=2:6;


% define simulation parameters
realalpha=.1;
realbeta=10;
realrho=.9;
realK=4;
%% simulate the RLWM task

b=0;
t=0;
for rep=1:3 % three repetitions of each set size
    for ns=2:6 % block of set size ns
        b=b+1;
        update(t+1)=1;
        % initialize WM mixture weight
        w=realrho*(min(1,realK/ns));
        % initialize RL and WM agents
        Q = .5+zeros(ns,3);
        WM = .5+zeros(ns,3);
        %define a sequence of trials with 15 iterations of each stimulus
        trials = repmat(1:ns,1,15);
        % loop over trials
        for s=trials
            t=t+1;
            % RL policy
            softmax1 = exp(realbeta*Q(s,:))/sum(exp(realbeta*Q(s,:)));
            % WM policy
            softmax2 = exp(50*WM(s,:))/sum(exp(50*WM(s,:)));
            % mixture policy
            pr = (1-w)*softmax1 + w*softmax2;
            % action choice
            r=rand;
            if r<pr(1)
                choice(t)=1;
            elseif r<pr(1)+pr(2)
                choice(t)=2;
            else
                choice(t)=3;
            end
            % reward correct action (arbitrarily defined here)
            rew(t)= choice(t)==(rem(s,3)+1);
            % update RL and WM agents
            Q(s,choice(t))=Q(s,choice(t))+realalpha*(rew(t)-Q(s,choice(t)));
            WM(s,choice(t))=rew(t);
            % store information
            stim(t)=s;
            setsize(t)=ns;
        end
    end
end
% check that it worked by making sure that performance in higher set sizes
% is lower than in high set sizes
update(t)=0;
for ns=2:6
    [ns mean(rew(setsize==ns))]
end
%% brute force computation of LLH for multiple parameters
i1=0;
for alpha=alphas
    i1=i1+1
    i2=0;
    for beta=betas
        i2=i2+1
        j1=0;
        for rho=rhos
            j1=j1+1;
            j2=0;
            for K=Ks
                j2=j2+1;
                l=0;
                for t=1:length(stim)
                    s=stim(t);
                    if update(t)
                        Q = .5+zeros(setsize(t),3);
                        WM2 = .5+zeros(setsize(t),3);
                    end
                    w=rho*(min(1,K/setsize(t)));
                    softmax1 = exp(beta*Q(s,:))/sum(exp(beta*Q(s,:)));
                    softmax2 = exp(50*WM(s,:))/sum(exp(50*WM(s,:)));
                    pr = (1-w)*softmax1 + w*softmax2;
                    l=l+log(pr(choice(t)));
                    Q(s,choice(t))=Q(s,choice(t))+alpha*(rew(t)-Q(s,choice(t)));
                    WM(s,choice(t))=rew(t);
                end
                llh(i1,i2,j1,j2)=l;
            end
        end
    end
end

%% plot the likelihood surfact projected on dimensions alpha and rho

figure;

% project
llh2=squeeze(max(max(llh,[],4),[],2));
% take out extreme values, because they make plotting less visually
% readable
llh2=llh2(1:end-1,1:end-1);
% find extrema
mi=min(llh2(:));
ma=max(llh2(:));
x=repmat(1:length(alphas)-1,length(rhos)-1,1)';
y=repmat(1:length(rhos)-1,length(alphas)-1,1);
[~,i]=max(llh2(:));
% plot the surface
imagesc(alphas(1:end-1),rhos(1:end-1),llh2',[mi,ma])
colorbar
hold on
plot(alphas(x(i)),rhos(y(i)),'ok')
plot(realalpha,realrho,'xr')
xlabel('alpha')
ylabel('rho')
    set(gca,'fontsize',16)
saveFigurePdf(gcf, '~/Figures/Figure3a')

%% plot 1d versions of the likelihood
ps{1}=alphas;na{1}='alpha';
ps{2}=betas;na{2}='beta';
ps{3}=rhos;na{3}='rho';
ps{4}=Ks;na{4}='K';

figure
for i=1%:4
    out=setdiff(1:4,i);
    llh1=squeeze(max(max(max(llh,[],out(3)),[],out(2)),[],out(1)));
    [v,w]=max(llh1);
    %subplot(1,4,i)
    plot(ps{i},llh1,'o-','linewidth',2)
    hold on
    plot(ps{i}(w),v,'rx','linewidth',2)
    set(gca,'fontsize',16)
    title(na{i})
    ylabel(llh)
end

%% save resulting figure
saveFigurePdf(gcf, '~/Figures/Figure3b')