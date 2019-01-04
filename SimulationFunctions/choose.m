function a = choose(p)

a = max(find([-eps cumsum(p)] < rand));
