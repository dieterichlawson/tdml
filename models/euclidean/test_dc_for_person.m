function cp = test_dc_for_person(person_data, others_data, thresholds, norm_type, features)
%test_dc_for_person tests the distance classifier for a given person
%   given a person's attempts, others' attempts, and the model parameters,
%   this method performs k-fold cross-validation on the data set and
%   reports the classifier performance
    num_folds = 4;
    num_taps = 5;
    indices = crossvalind('Kfold', size(person_data,1), num_folds);
    cp = classperf([zeros(size(others_data,1),1); ones(size(person_data,1),1)]);
    for fold = 1:num_folds
       test = (indices == fold);
       train = ~test;
       dc = DistanceClassifier(person_data(train,:),norm_type, num_taps);
       test_data = [others_data ; person_data(test,:)];
       classes = dc.classify(test_data, features, thresholds);
       classperf(cp,classes,logical([ones(size(others_data,1),1); test]));
    end
end
 
