clear;
imp = importdata('../../data/taps.csv',',',1);
names = imp.textdata(2:end,1);
data = [grp2idx(names) imp.data];
% rearrange
pr = data(:,3:3:15);
rp = data(:,5:3:14);
pp = data(:,17:2:23);
rr = data(:,18:2:24);
data = [data(:,1:2), pr, rp, pp, rr];

strnames = unique(names);
inames = unique(grp2idx(names));

num_folds = 5;
norm_type = 'euclidean';
features = {'pr';'pp';'rp';'rr'}';
thresholds = [10 10 10 10];
% for each person, do 5-fold cross validation
for i = inames'
    person_data  = data(data(:,1)==i,3:end);
    others = data(data(:,1) ~= i,3:end);
    thresholds = calc_thresholds_for_person(person_data,others,norm_type,features);
    thresholds
    cp = test_dc_for_person(person_data,others,thresholds,norm_type,features);
    get(cp)
    cp.diagnosticTable
    %cp.diagnosticTable(1,2) + cp.diagnosticTable(2,1)
end