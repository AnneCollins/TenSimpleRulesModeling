function [hx, hy] = addFacetLines(M)

% M = rand(10,5);
S = size(M);
lx = [0:S(2)]+0.5;
ly = [0:S(1)]+0.5;

for i = 1:length(lx)
    hx(i) = plot([lx(i) lx(i)], [0 S(1)]+0.5, 'k-');
end
for i = 1:length(ly)
    hy(i) = plot([0 S(2)]+0.5, [ly(i) ly(i)],  'k-');
end
xlim([0.5 S(2)+0.5])
ylim([0.5 S(1)+0.5])