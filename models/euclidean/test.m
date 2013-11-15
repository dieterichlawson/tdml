imp = importdata('../../data/taps.csv',',',1);
names = imp.textdata(2:end,1);
data = [grp2idx(names) imp.data];
% rearrange
pr = [data(:,3), data(:,6), data(:,9), data(:,12), data(:,15)];
rp = [data(:,5), data(:,8), data(:,11), data(:,14)];
pp = [data(:,17), data(:,19), data(:,21), data(:,23)];
rr = [data(:,18), data(:,20), data(:,22), data(:,24)];
data = [data(:,1:2), pr, rp, pp, rr];

strnames = unique(names);
inames = unique(grp2idx(names));
for i = inames
    person_data = data(data(:,1)==i,:);
    others = data(data(:,1) ~= i,:);
    numfolds = size(person_data,1);
    for fold=1:numfolds
       training_data = person_data(fold*
    end
end
% num training examples
% num folds
