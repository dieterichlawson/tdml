% This Matlab script splits the data into training and test sets by:
% taking the user's first fifteen taps and making that the training set,
% then taking the remaining ~15 taps and making that the test set. The idea
% is that the last 15 taps were done after a 30 second pause, so we would
% like to test that a user's rhythm is consistent over time and that we can
% recognize this rhythm over time.
% NOTE: import_data MUST BE CALLED BEFORE THIS SCRIPT
% (../util/import_data)

addpath('../util');
addpath('../analysis_tools');

% for each pin, build a model for the pin and test each
% user on the pin's model

% Row 1 = pins
% Row 2 = false positive rate
% Row 3 = false negative rate
% Row 4 = test error rate
% Row 5 = train error rate
evaluation_table = zeros(5,length(pins));
pin_col = 1;

for p = pins'    
    [data_pin_p, users_pin_p] = get_data_for_pin(data, p);
    
    rforest_fa_for_p = [];
    rforest_fr_for_p = [];
    
    train_count = 0;
    train_error = 0;
    test_count = 0;
    test_error = 0;
    
    for i = users_pin_p'
        [training_data, training_labels, test_data, test_labels] = makeTestAndTrainData(data_pin_p, i, 15);
        
        % Get models from matlab function on training data
        rforest_mdl = TreeBagger(20,training_data, training_labels);
        
        % Get predictions from matlab function
        rforest_pred = predict(rforest_mdl, test_data);
        rforest_pred_train = predict(rforest_mdl, training_data);
        rforest_pred = cellfun(@str2num, rforest_pred);
        rforest_pred_train = cellfun(@str2num, rforest_pred_train);
        
        [user_i_fa, user_i_fr] = evaluatePerf(rforest_pred, test_labels);
        
        rforest_fa_for_p = [rforest_fa_for_p, user_i_fa/(length(rforest_pred)-sum(test_labels))];
        rforest_fr_for_p = [rforest_fr_for_p, user_i_fr/sum(test_labels)];
        
        test_error_vector = abs(rforest_pred - test_labels);
        test_error = test_error + sum(test_error_vector);
        test_count = test_count + length(rforest_pred);
        
        train_error_vector = abs(rforest_pred_train - training_labels);
        train_error = train_error + sum(train_error_vector);
        train_count = train_count + length(rforest_pred_train);
    end
    
    % Set the PIN entry for this pin
    evaluation_table(1, pin_col) = p;
    % Set the average FA rate for this pin
    evaluation_table(2, pin_col) = sum(rforest_fa_for_p)/length(rforest_fa_for_p);
    % Set the average FR rate for this pin
    evaluation_table(3, pin_col) = sum(rforest_fr_for_p)/length(rforest_fr_for_p);
    % Test error
    evaluation_table(4, pin_col) = test_error / test_count;
    evaluation_table(5, pin_col) = train_error / train_count;
    
    disp(['For pin = ' num2str(p) ' the total # errors =  ' num2str(test_error) ' the total count = ' num2str(test_count)]);
    
    pin_col = pin_col + 1;
end