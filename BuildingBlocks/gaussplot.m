clearvars;
sigma = pi/15;
cent = pi/2;
count = 1;
for val = pi/4:pi/72:3*pi/4
    newy(count) = normpdf(val,cent,sigma);
    newx(count) = val;
    count = count+1;
end

plot(newx,10*newy)