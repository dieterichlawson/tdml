clear;
imp = importdata('../../data/gold/taps_accel.csv',',',1);
names = imp.textdata(2:end,1);
all_data = [grp2idx(names) imp.data(:,1:end)];

pins = unique(all_data(:,2));
num_folds = 4;
for pin = pins'
    data = all_data(all_data(:,2) == pin,:);
    inames = unique(data(:,1));
    disp(['***** Training classifiers for pin ' num2str(pin) ' *****']);
    disp(['      Number of people: ' num2str(size(inames,1)) ' Number of enrollments: ' num2str(size(data,1))]);
    indices = crossvalind('Kfold', size(data, 1), num_folds);
    cp = classperf(data(:,1));
    for fold = 1:num_folds
       test = (indices == fold);
       train = ~test;
       softmax_coefficients = mnrfit(data(train,3:end), data(train,1));
       softmax_probabilities = mnrval(softmax_coefficients, data(test,3:end));
       [probs, classes] = max(softmax_probabilities,[],2);
       classperf(cp, classes, test);
    end
    cp.diagnosticTable
    get(cp)
end