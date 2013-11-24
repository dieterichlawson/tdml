% This Matlab script splits the data into training and test sets by:
% taking the user's first fifteen taps and making that the training set,
% then taking the remaining ~15 taps and making that the test set. The idea
% is that the last 15 taps were done after a 30 second pause, so we would
% like to test that a user's rhythm is consistent over time and that we can
% recognize this rhythm over time.

clear;
data_with_names = importdata('../../data/taps.csv', ',',1);

% From 2nd to final row (1st row is the category title 'name' in db), take 1st col (names)
ids = data_with_names.textdata(2:end, 1);
% Relabel the ids to numerical values (labels)
user_label_vector = grp2idx(ids);

% data is now a matrix with the numerical labels (instead of id's) and the
% data for each attempt on a row. Need to subtract last 8 items in each row
% to get rid of the redundant tap timing features
data = [user_label_vector data_with_names.data(:,1:end-8)];
users = unique(user_label_vector);

% Get list of all unique pins in data
pins = unique(data(:,2));

% for each pin, build a model for the pin and test each
% user on the pin's model
for p = pins'
    % Training is first 15 attempts
    training_data = [];
    % Test data is final 15 taps
    test_data = [];
    
    % Labels for the training/test data
    training_labels = [];
    true_test_labels = [];
    
    % data_pin_p = all data rows for people with pin p
    data_pin_p = data(data(:,2) == p,:);
    % users_pin_p = unique list of users with pin p
    users_pin_p = unique(data_pin_p(:,1));
    
    % Make training and test data for pin p
    for i = users_pin_p'
        % data for person "i" finds all rows that belong to user i
        % and then takes col's 3 -> end (1 = name, 2 = pin)
        data_for_i = data_pin_p(data_pin_p(:,1)==i, 3:end);
        
        % Build training and test data for this particular pin by merging the
        % first 15 attempts for all user's with pin p into training_data and
        % then merging the remaining 15 attempts for all user's with pin p into
        % test_data
        training_data_i = data_for_i(1:15,:);
        training_data = [training_data; training_data_i];
        test_data_i = data_for_i(16:end, :);
        test_data = [test_data; test_data_i];
        
        % user_i = homogenous vector containing purely the user's id for
        % each data example that has the user id and pin p
        user_i = data_pin_p(data_pin_p(:,1)==i, 1);
        training_labels = [training_labels; user_i(1:15, 1)];
        true_test_labels = [true_test_labels; user_i(16:end, 1)];
    end
    
    gda_fp_for_p = [];
    gda_fn_for_p = [];
    
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
        gda_mdl = ClassificationDiscriminant.fit(training_data, user_i_training_labels);
        
        % Get predictions from matlab function
        % lnr_pred = predict(lnr_mdl, test_data);
        gda_pred = predict(gda_mdl, test_data);
        
        user_i_fp = 0;
        user_i_fn = 0;
        % Evaluate against true_test_labels
        % lnr_errors = 0;
        for j=1:length(gda_pred)
            if(gda_pred(j) ~= user_i_test_labels(j))
                % If we labeled an incorrect 0, then we incorrectly said
                % example was an attacker (false positive)
                if(gda_pred(j) == 0)
                    user_i_fp = user_i_fp + 1;
                    % Else, we incorrectly labeled an example as 1 (incorrectly
                    % said example was true user - false negative)
                else
                    user_i_fn = user_i_fn + 1;
                end
            end
            
            % if(lnr_pred(j) ~= user_i_test_labels(j))
            %    lnr_errors = lnr_errors + 1;
            % end
        end
        
        gda_fp_for_p = [gda_fp_for_p, user_i_fp/length(gda_pred)];
        gda_fn_for_p = [gda_fn_for_p, user_i_fn/length(gda_pred)];
        % lnr_error_rate = lnr_errors / length(lnr_pred);
    end
    
    % disp(['For pin = ' num2str(p) ' the total error rate = ']);
    % disp(gda_error_rate);
    disp(['For pin = ' num2str(p) ' the fn rates (called attacker the true user) = ']);
    disp(gda_fn_for_p);
    disp(['For pin = ' num2str(p) ' the fp rates (caller a true user an attacker) = ']);
    disp(gda_fp_for_p);
    disp('**********************************************************');
end