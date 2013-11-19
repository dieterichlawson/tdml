function x = calc_thresholds_for_person(person_data, others_data, norm_type, features )
%UNTITLED3 Summary of this function goes here
%   Detailed explanation goes here
    x0 = [10 10 10 10];
    fun = @(x) dc_misclassifications_for_person(person_data, others_data, x, norm_type, features);
    options = optimset('Display','iter','MaxIter',30,'MaxFunEvals',100,'TolFun',10,'PlotFcns',@optimplotfval);
    [x, fval, exitflag, output] = fminsearch(fun, x0,options);
end

