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
    % Training is first 15 attempts
    training_data = [];
    % Test data is final 15 taps
    test_data = [];
    
    % Labels for the training/test data
    training_labels = [];
    true_test_labels = [];
    
    [data_pin_p, users_pin_p] = get_data_for_pin(data, p);
    
    % Make training and test data for pin p
    for i = users_pin_p'
        % data for person "i" finds all rows that belong to user i
        % and then takes col's 3 -> end (1 = name, 2 = pin)
        data_for_i = get_features_for_user(data_pin_p, i);
        
        if(size(data_for_i,1) < 20) 
            continue;
        end
        % Build training and test data for this particular pin by merging the
        % first 15 attempts for all user's with pin p into training_data and
        % then merging the remaining 15 attempts for all user's with pin p into
        % test_data
        training_data_i = data_for_i(1:15,:);
        test_data_i = data_for_i(16:end, :);
        
        % user_i = homogenous vector containing purely the user's id for
        % each data example that has the user id and pin p
        user_i = data_pin_p(data_pin_p(:,1)==i, 1);
        training_label_i = user_i(1:15, 1);
        
        % [training_data_i, training_label_i] = remove_outliers(training_data_i, training_label_i);
        
        training_data = [training_data; training_data_i];
        training_labels = [training_labels; training_label_i];
        true_test_labels = [true_test_labels; user_i(16:end, 1)];
        test_data = [test_data; test_data_i];
    end
    
    logistic_fp_for_p = [];
    logistic_fn_for_p = [];
    
    train_count = 0;
    train_error = 0;
    test_count = 0;
    test_error = 0;
    
    % Make and test classifier for each user
    for i = users_pin_p'
        user_i_training_labels = training_labels;
        user_i_test_labels = true_test_labels;
        
        % CRITICAL: First set the non-equal to zero and then set the equal
        % id's to 1 (if other order, than the 1's aren't equal to id's and
        % get zero'ed out)
        % Idea: the training labels and test labels are currently labeled
        % by the user_id's. Thus, for every entry that is not the current
        % user's id, relabel to 0 (attacker), else relabel to 1 (true user)
        user_i_training_labels(user_i_training_labels ~= i) = 0;
        user_i_training_labels(user_i_training_labels == i) = 1;
        user_i_test_labels(user_i_test_labels ~= i) = 0;
        user_i_test_labels(user_i_test_labels == i) = 1;
        
        % Get models from matlab function on training data
        % lnr_mdl = GeneralizedLinearModel.fit(training_data, training_labels);
        logistic_mdl = GeneralizedLinearModel.fit(training_data, user_i_training_labels);
        
        % Get predictions from matlab function
        logistic_pred = predict(logistic_mdl, test_data);
        logistic_pred_train = predict(logistic_mdl, training_data);
        
        user_i_fp = 0;
        user_i_fn = 0;
        % Evaluate against true_test_labels
        for j=1:length(logistic_pred)
            if(logistic_pred(j) ~= user_i_test_labels(j))
                test_error = test_error + 1;
                % If we labeled an incorrect 0, then we incorrectly said
                % example was an attacker (false positive)
                if(logistic_pred(j) == 0)
                    user_i_fp = user_i_fp + 1;
                    % Else, we incorrectly labeled an example as 1 (incorrectly
                    % said example was true user - false negative)
                else
                    user_i_fn = user_i_fn + 1;
                end
            end
            
            test_count = test_count + 1;
        end
        
        logistic_fp_for_p = [logistic_fp_for_p, user_i_fp/length(logistic_pred)];
        logistic_fn_for_p = [logistic_fn_for_p, user_i_fn/length(logistic_pred)];
        
        % COMPUTE TRAINING ERROR
        for j=1:length(logistic_pred_train)
            if(logistic_pred_train(j) ~= user_i_training_labels(j))
                train_error = train_error + 1;
            end
            train_count = train_count + 1;
        end
    end
    
    % Set the PIN entry for this pin
    evaluation_table(1, pin_col) = p;
    % Set the average FP rate for this pin
    evaluation_table(2, pin_col) = sum(logistic_fp_for_p)/length(logistic_fp_for_p);
    % Set the average FN rate for this pin
    evaluation_table(3, pin_col) = sum(logistic_fn_for_p)/length(logistic_fp_for_p);
    
    % Test error
    evaluation_table(4, pin_col) = test_error / test_count;
    evaluation_table(5, pin_col) = train_error / train_count;
    
    disp(['For pin = ' num2str(p) ' the total # errors =  ' num2str(test_error) ' the total count = ' num2str(test_count)]);
    
    
    pin_col = pin_col + 1;
end

% format long;
% disp('Evaluation table:');
% disp(evaluation_table);
% disp('**********************************************************');
