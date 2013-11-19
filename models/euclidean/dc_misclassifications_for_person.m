function res = dc_misclassifications_for_person(person_data, others_data, thresholds, norm_type, features)
%UNTITLED4 Summary of this function goes here
%   Detailed explanation goes here
    ratio = 1;
    person_weight = (ratio*size(others_data,1))/size(person_data,1);
    cp = test_dc_for_person(person_data, others_data, thresholds, norm_type, features);
    num_wrong = cp.diagnosticTable(1,2)*person_weight + cp.diagnosticTable(2,1);
    res = num_wrong(1);
end

