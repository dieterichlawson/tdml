clear;
imp = importdata('../../data/gold/taps_euclid.csv',',',1);
names = imp.textdata(2:end,1);
all_data = [grp2idx(names) imp.data];

% rearrange
pr = all_data(:,3:3:15);
rp = all_data(:,5:3:14);
pp = all_data(:,17:2:23);
rr = all_data(:,18:2:24);
all_data = [all_data(:,1:2), pr, rp, pp, rr];

pins = unique(all_data(:,2));
num_folds = 5;
norm_type = 'cityblock';
features = {'pr';'pp';'rp';'rr'}';
thresholds = [10 10 10 10];
for pin = pins'
    data = all_data(all_data(:,2) == pin,:);
    confusion = zeros(2,2);
    inames = unique(data(:,1));
    
    disp(['***** Training classifiers for pin ' num2str(pin) ' *****']);
    disp(['      Number of people: ' num2str(size(inames,1)) ' Number of enrollments: ' num2str(size(data,1))]);
    for i = inames'
        disp(['      Person ' num2str(i)]);
        person_data  = data(data(:,1)==i,3:end);
        others = data(data(:,1) ~= i,3:end);
        thresholds = calc_thresholds_for_person(person_data,others,norm_type,features);
        thresholds
        cp = test_dc_for_person(person_data,others,thresholds,norm_type,features);
        get(cp)
        cp.diagnosticTable
        confusion = confusion + cp.diagnosticTable;
    end
    disp(['      Final confusion matrix for pin' num2str(pin)])
    confusion
end