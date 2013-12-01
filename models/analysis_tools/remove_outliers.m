function [optimized_training_set, optimized_labels] = remove_outliers(full_training_set, full_training_labels)
%UNTITLED4 Summary of this function goes here
%   Detailed explanation goes here
    optimized_training_set = full_training_set;
    optimized_labels = full_training_labels;
    feature_var = var(full_training_set);
    feature_mean = mean(full_training_set);
    
     disp('*************************');
     disp(feature_var);
     disp(feature_mean);
     disp('*************************');
    
    for r=1:size(full_training_set,1)
        row_i = optimized_training_set(r,:);
        row_i = abs(row_i - feature_mean);
        disp(row_i);
        row_i = row_i - 1.5 * feature_var;
        outliers = find(row_i > 0);
        if size(outliers, 1) > 0
%             disp('****************************************');
%             disp('found outlier');
%             disp('****************************************');
            optimized_training_set(r,:) = 0;
            
            % WARNING: ONLY WORKS IF LABELS DO NOT INCLUDE 0 AS
            % POSSIBILITY!!!!!!!
            optimized_labels(r,:) = 0;
        end
    end
    
    optimized_training_set = optimized_training_set(:,any(optimized_training_set,1));
    optimized_labels = optimized_labels(:,any(optimized_labels,1));
end

