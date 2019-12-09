
%%%%% Bob Wilson & Anne Collins
%%%%% 2018
%%%%% Code to produce figure 5 in submitted paper "Ten simple rules for the
%%%%% computational modeling of behavioral data"


clear


CM = zeros(5);

T = 1000;
mu = [0.2 0.8];


%%

CM1 = [1 0 0 0 0
    0.01 0.99 0 0 0
    0.34 0.12 0.54 0 0
    0.35 0.09 0 0.54 0.01
    0.14 0.04 0.26 0.26 0.3];


CM2 = [    0.9700    0.0300         0         0         0
    0.0400    0.9600         0         0         0
    0.0600         0    0.9400         0         0
    0.0600         0    0.0100    0.9300         0
    0.0300         0    0.1000    0.1500    0.7200];


%% inverse confusion matrices
for i = 1:size(CM1,2)
    iCM1(:,i) = CM1(:,i) / sum(CM1(:,i));
    iCM2(:,i) = CM2(:,i) / sum(CM2(:,i));
end



%%

figure(1); clf;
set(gcf, 'Position', [400   405   900   800]);
ax = easy_gridOfEqualFigures([0.02 0.23 0.17], [0.1 0.14 0.03]);
axes(ax(1)); 
t = imageTextMatrix(CM1);
set(t(CM1'<0.3), 'color', 'w')
hold on;
[l1, l2] = addFacetLines(CM1);
set(t, 'fontsize', 18)
xlabel('fit model')
ylabel('simulated model')

axes(ax(2)); 
t = imageTextMatrix(CM2);
set(t(CM2'<0.3), 'color', 'w')
hold on;
[l1, l2] = addFacetLines(CM2);
set(t, 'fontsize', 18)
xlabel('fit model')
ylabel('simulated model')

a = annotation('textbox', [0 0.94 1 0.06]);
set(a, 'string', 'confusion matrix: p(fit model | simulated model)', 'fontsize', 38, ...
    'horizontalalignment', 'center', ...
    'linestyle', 'none', 'fontweight', 'normal')

axes(ax(3)); 
t = imageTextMatrix(round(100*iCM1)/100);
set(t(iCM1'<0.3), 'color', 'w')
hold on;
[l1, l2] = addFacetLines(CM1);
set(t, 'fontsize', 18)
xlabel('fit model')
ylabel('simulated model')

axes(ax(4)); 
t = imageTextMatrix(round(100*iCM2)/100);
set(t(iCM2'<0.3), 'color', 'w')
hold on;
[l1, l2] = addFacetLines(iCM2);
set(t, 'fontsize', 18)
xlabel('fit model')
ylabel('simulated model')

a = annotation('textbox', [0 0.94-0.52 1 0.06]);
set(a, 'string', 'inversion matrix: p(simulated model | fit model)', 'fontsize', 38, ...
    'horizontalalignment', 'center',...
    'linestyle', 'none', 'fontweight', 'normal')


set(ax, 'xtick', [1:5], 'ytick', [1:5], 'fontsize', 24, ...
    'xaxislocation', 'top', 'tickdir', 'out')
addABCs(ax, [-0.05 0.08], 40)
saveFigurePdf(gcf, '~/Desktop/Figure5')
% saveFigurePdf(gcf, './Figures/Figure5')