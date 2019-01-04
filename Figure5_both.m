
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


%%

figure(1); clf;
set(gcf, 'Position', [400   405   900   400]);
ax = easy_gridOfEqualFigures([0.05 0.22], [0.1 0.14 0.03]);
axes(ax(1)); 
t = imageTextMatrix(CM1);
set(t(CM1'<0.3), 'color', 'w')
hold on;
[l1, l2] = addFacetLines(CM1);
set(t, 'fontsize', 22)
xlabel('fit model')
ylabel('simulated model')

axes(ax(2)); 
t = imageTextMatrix(CM2);
set(t(CM2'<0.3), 'color', 'w')
hold on;
[l1, l2] = addFacetLines(CM2);
set(t, 'fontsize', 22)
xlabel('fit model')
ylabel('simulated model')

set(ax, 'xtick', [1:5], 'ytick', [1:5], 'fontsize', 28, ...
    'xaxislocation', 'top', 'tickdir', 'out')
addABCs(ax, [-0.05 0.18], 50)

saveFigurePdf(gcf, './Figures/Figure5')