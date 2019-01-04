function out = analysis_WSLS_v1(a, r)

aLast = [nan a(1:end-1)];
stay = aLast == a;
rLast = [nan r(1:end-1)];

winStay = nanmean(stay(rLast == 1));
loseStay = nanmean(stay(rLast == 0));
out = [loseStay winStay];