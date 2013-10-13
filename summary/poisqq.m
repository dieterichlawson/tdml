
imp = importdata('data/taps.csv',',',1);
data = [imp.data(:,5) imp.data(:,8) imp.data(:,11) imp.data(:,14) imp.data(:,17)];
p = poissrnd(ones(1000,1)*mean(data));
for i=1:5
    subplot(3,2,i);
    qqplot(data(:,i),p(:,i))
    grid on
end