function t = imageTextMatrix(M, xtl, ytl)

% M = rand(10,5);

imagesc(M)
for i = 1:size(M,1)
    for j = 1:size(M,2)
        t(j,i) = text(j,i, num2str(M(i,j)));
        set(t(j,i), 'horizontalalignment', 'center', ...
            'verticalalignment', 'middle');
    end
end
if exist('xtl') == 1
    set(gca, 'xtick', [1:length(xtl)], 'xticklabel', xtl)
end
if exist('ytl') == 1
    set(gca, 'ytick', [1:length(ytl)], 'yticklabel', ytl)
end