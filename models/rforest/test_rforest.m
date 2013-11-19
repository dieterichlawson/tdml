clear;
imp = importdata('../../data/taps.csv',',',1);
names = imp.textdata(2:end,1);
% data is poorly conditioned because of extra
% features at the end, so remove them
all_data = [grp2idx(names) imp.data(:,1:end-8)];

pins = unique(all_data(:,2));
num_folds = 4;
ntrees = 20;

for pin = pins'
    pin_data = all_data(all_data(:,2) == pin,:);
    inames = unique(pin_data(:,1));
    
    disp(['***** Training classifiers for pin ' num2str(pin) ' *****']);
    disp(['      Number of people: ' num2str(size(inames,1)) ' Number of enrollments: ' num2str(size(pin_data,1))]);
    conf_mat = zeros(2,2);
    for i = inames'
        disp(['      Person ' num2str(i)]);
        % pull the person's data out
        person_ind = pin_data(:,1)==i;
        indices = crossvalind('Kfold', size(pin_data, 1), num_folds);
        cp = classperf(person_ind);
        for fold = 1:num_folds
            test = (indices == fold);
            train = ~test;
            % train the ensemble
            B = TreeBagger(ntrees,pin_data(train,3:end), person_ind(train,1));
            % predict on the test data
            classes = predict(B, pin_data(test,3:end));
            % update performance
            classperf(cp, cellfun(@str2num, classes), test);
            %[pin_data(test,1) cellfun(@str2num, classes)]
        end
        cp.diagnosticTable
        conf_mat = conf_mat + cp.diagnosticTable;
        %get(cp)
    end
    conf_mat
    disp(['fn_rate = ' conf_mat(1,2)/(sum(conf_fat(:,1))]);
    disp(['fp_rate = ' conf_mat(2,1)/(sum(conf_fat(:,2))]);
end