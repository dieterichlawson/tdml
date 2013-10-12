imp = importdata('data/taps.csv',',',1);
names = imp.textdata(2:end,1);
data = [grp2idx(names) imp.data];
data(:,2:end) = normalize(data(:,2:end));
