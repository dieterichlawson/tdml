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
    
    gda_fa_for_p = [];
    gda_fr_for_p = [];
    
    train_count = 0;
    train_error = 0;
    test_count = 0;
    test_error = 0;
    
    for i = users_pin_p'
        [training_data, training_labels, test_data, test_labels] = makeTestAndTrainData(data_pin_p, i, 100);
        
        % Get models from matlab function on training data
        gda_mdl = ClassificationDiscriminant.fit(training_data, training_labels);
        
        % Get predictions from matlab function
        gda_pred = predict(gda_mdl, test_data);
        gda_pred_train = predict(gda_mdl, training_data);
        
        [user_i_fa, user_i_fr] = evaluatePerf(gda_pred, test_labels);
        
        %[X,Y] = perfcurve(user_i_test_labels, gda_pred, 0);
        %plot(X,Y)
        %xlabel('False positive rate'); ylabel('True positive rate');
        
        gda_fa_for_p = [gda_fa_for_p, user_i_fa/(length(gda_pred)-15)];
        gda_fr_for_p = [gda_fr_for_p, user_i_fr/sum(test_labels)];
        disp(sum(test_labels));
        
        test_error_vector = abs(gda_pred - test_labels);
        test_error = test_error + sum(test_error_vector);
        test_count = test_count + length(gda_pred);
        
        train_error_vector = abs(gda_pred_train - training_labels);
        train_error = train_error + sum(train_error_vector);
        train_count = train_count + length(gda_pred_train);
    end
    
    % Set the PIN entry for this pin
    evaluation_table(1, pin_col) = p;
    % Set the average FA rate for this pin
    evaluation_table(2, pin_col) = sum(gda_fa_for_p)/length(gda_fa_for_p);
    % Set the average FR rate for this pin
    evaluation_table(3, pin_col) = sum(gda_fr_for_p)/length(gda_fr_for_p);
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

% % Make training and test data for pin p
%     for i = users_pin_p'
%         % data for person "i" finds all rows that belong to user i
%         % and then takes col's 3 -> end (1 = name, 2 = pin)
%         data_for_i = get_features_for_user(data_pin_p, i);
%         
%         % Build training and test data for this particular pin by merging the
%         % first 15 attempts for all user's with pin p into training_data and
%         % then merging the remaining 15 attempts for all user's with pin p into
%         % test_data
%         training_data_i = data_for_i(1:15,:);
%         test_data_i = data_for_i(16:end, :);
%         
%         % user_i = homogenous vector containing purely the user's id for
%         % each data example that has the user id and pin p
%         user_i = data_pin_p(data_pin_p(:,1)==i, 1);
%         training_label_i = user_i(1:15, 1);
%         
%         % [training_data_i, training_label_i] = remove_outliers(training_data_i, training_label_i);
%         
%         training_data = [training_data; training_data_i];
%         training_labels = [training_labels; training_label_i];
%         true_test_labels = [true_test_labels; user_i(16:end, 1)];
%         test_data = [test_data; test_data_i];
%     end

%   % Make and test classifier for each user
%     for i = users_pin_p'
%         user_i_train_labels = training_labels;
%         user_i_test_labels = true_test_labels;
%         
%         data_for_i = get_features_for_user(data_pin_p, i);
%         pos_train_data = data_for_i(1:15, :);
%         pos_train_labels = ones(size(pos_train_data));
%         
%         % Select 20 negative training examples
%         neg_indices = randperm(size(training_data) - 15, 20);
%         neg_indices = neg_indices + 15;
%         neg_train_data = zeros(20, size(training_data, 2));
%         
%         for i = 1:size(neg_indices)
%             neg_training_data(i, :) = training_data(neg_indices(i), :);
%         end
%         
%         % CRITICAL: First set the non-equal to zero and then set the equal
%         % id's to 1 (if other order, than the 1's aren't equal to id's and
%         % get zero'ed out)
%         % Idea: the training labels and test labels are currently labeled
%         % by the user_id's. Thus, for every entry that is not the current
%         % user's id, relabel to 0 (attacker), else relabel to 1 (true user)
%         user_i_train_labels(user_i_train_labels ~= i) = 0;
%         user_i_train_labels(user_i_train_labels == i) = 1;
%         user_i_test_labels(user_i_test_labels ~= i) = 0;
%         user_i_test_labels(user_i_test_labels == i) = 1;
%         
%         all_train_labels = [all_train_labels; user_i_train_labels];
%         all_test_labels = [all_test_labels; user_i_test_labels];
%         
%         % Get models from matlab function on training data
%         % lnr_mdl = GeneralizedLinearModel.fit(training_data, training_labels);
%         gda_mdl = ClassificationDiscriminant.fit(training_data, user_i_train_labels);
%         
%         % Get predictions from matlab function
%         % lnr_pred = predict(lnr_mdl, test_data);
%         gda_pred = predict(gda_mdl, test_data);
%         gda_pred_train = predict(gda_mdl, training_data);
%         
%         all_predict_train_labels = [all_predict_train_labels; gda_pred_train];
%         all_predict_test_labels = [all_predict_test_labels; gda_pred];
%         
%         user_i_fp = 0;
%         user_i_fn = 0;
%         % Evaluate against true_test_labels
%         for j=1:length(gda_pred)
%             if(gda_pred(j) ~= user_i_test_labels(j))
%                 % If we labeled an incorrect 0, then we incorrectly said
%                 % example was an attacker (false positive)
%                 if(gda_pred(j) == 0)
%                     user_i_fp = user_i_fp + 1;
%                     % Else, we incorrectly labeled an example as 1 (incorrectly
%                     % said example was true user - false negative)
%                 else
%                     user_i_fn = user_i_fn + 1;
%                 end
%             end
%         end
%         
%         %[X,Y] = perfcurve(user_i_test_labels, gda_pred, 0);
%         %plot(X,Y)
%         %xlabel('False positive rate'); ylabel('True positive rate');
%         
%         gda_fp_for_p = [gda_fp_for_p, user_i_fp/length(gda_pred)];
%         gda_fn_for_p = [gda_fn_for_p, user_i_fn/length(gda_pred)];
%         
%         test_error_vector = abs(gda_pred - user_i_test_labels);
%         test_error = test_error + sum(test_error_vector);
%         test_count = test_count + length(gda_pred);
%         
%         train_error_vector = abs(gda_pred_train - user_i_train_labels);
%         train_error = train_error + sum(train_error_vector);
%         train_count = train_count + length(gda_pred_train);
%     end
