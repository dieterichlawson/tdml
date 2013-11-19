function res = dc_misclassifications_for_person(person_data, others_data, thresholds, norm_type, features)
%UNTITLED4 Summary of this function goes here
%   Detailed explanation goes here
    max_lockout_perc = 0.15;
    cp = test_dc_for_person(person_data, others_data, thresholds, norm_type, features);
    fp_rate = cp.diagnosticTable(2,1)/(cp.diagnosticTable(2,1)+cp.diagnosticTable(1,1));
    fn_rate = cp.diagnosticTable(1,2)/(cp.diagnosticTable(1,2)+cp.diagnosticTable(2,2));
   
    if fn_rate > max_lockout_perc
        res = Inf('double');
    else
        res = 2*fp_rate + fn_rate;
    end
end

