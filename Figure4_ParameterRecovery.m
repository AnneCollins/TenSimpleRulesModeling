clear

addpath('./SimulationFunctions')
addpath('./AnalysisFunctions')
addpath('./HelperFunctions')
addpath('./FittingFunctions')
addpath('./LikelihoodFunctions')

global AZred AZblue AZcactus AZsky AZriver AZsand AZmesa AZbrick

AZred = [171,5,32]/256;
AZblue = [12,35,75]/256;
AZcactus = [92, 135, 39]/256;
AZsky = [132, 210, 226]/256;
AZriver = [7, 104, 115]/256;
AZsand = [241, 158, 31]/256;
AZmesa = [183, 85, 39]/256;
AZbrick = [74, 48, 39]/256;


% experiment parameters
T   = 1000;         % number of trials
mu  = [0.2 0.8];    % mean reward of bandits



% Model 3: Rescorla Wagner
for count = 1:100
    alpha = rand;
    beta = exprnd(10);
    [a, r] = simulate_M3RescorlaWagner_v1(T, mu, alpha, beta);
    [Xf, LL, BIC] = fit_M3RescorlaWagner_v1(a, r);
    
    Xsim(1,count) = alpha;
    Xsim(2,count)  = beta;
    Xfit(1,count) = Xf(1);
    Xfit(2,count)  = Xf(2);
    
    
    
end

%% basic parameter recovery plots
names = {'learning rate' 'softmax temperature'};
symbols = {'\alpha' '\beta'};
figure(1); clf;
set(gcf, 'Position', [811   613   600   300])
[~,~,~,ax] = easy_gridOfEqualFigures([0.2  0.1], [0.1 0.18 0.04]);
for i= 1:size(Xsim,1)
    axes(ax(i)); hold on;
    plot(Xsim(i,:), Xfit(i,:), 'o', 'color', AZred, 'markersize', 8, 'linewidth', 1)
    xl = get(gca, 'xlim');
    plot(xl, xl, 'k--')
    
end


set(ax(1,2),'xscale', 'log', 'yscale' ,'log')

axes(ax(1)); t = title('learning rate');
axes(ax(2)); t(2) = title('softmax temperature');

axes(ax(1)); xlabel('simulated \alpha'); ylabel('fit \alpha'); 
axes(ax(2)); xlabel('simulated \beta'); ylabel('fit \beta'); 


set(ax, 'tickdir', 'out', 'fontsize', 18)
set(t, 'fontweight', 'normal')
addABCs(ax(1), [-0.07 0.08], 32)
addABCs(ax(2), [-0.1 0.08], 32, 'B')
set(ax, 'tickdir', 'out')
for i= 1:size(Xsim,1)
    axes(ax(i));
    xl = get(gca, 'xlim');
    plot(xl, xl, 'k--')
end
saveFigurePdf(gcf, '~/Desktop/Figure4')
