function [train_data, train_labels, test_data, test_labels] = makeTestAndTrainData(full_data, user_i, train_size)

% Extract features to get data matrix for user and data matrix for all
% other users (negatives)
[pos_features, neg_features] = extract_features(full_data, user_i);

% Make train + test positive data matrix and labels vector
pos_train_data = pos_features(1:15, :);
pos_train_labels = ones(size(pos_train_data, 1) ,1);

pos_test_data = pos_features(16:end, :);
pos_test_labels = ones(size(pos_test_data, 1), 1);

% Make train + test negative data matrix and labels vector
% NUM_NEG_TRAIN = 20;
% neg_indices = randperm(size(neg_features, 1), NUM_NEG_TRAIN);

% neg_indices = randperm(size(neg_features, 1), 25);
% neg_train_data = neg_features(neg_indices, :);
% neg_train_labels = zeros(size(neg_train_data, 1), 1);
% neg_test_data = neg_features;
% neg_test_data(neg_indices, :) = [];
% neg_test_labels = zeros(size(neg_test_data, 1), 1);

% 150 is just the standin value for the full neg set
if(train_size == 150)
    neg_train_data = neg_features(1:2:end, :);
    neg_train_labels = zeros(size(neg_train_data, 1), 1);
    neg_test_data = neg_features(2:2:end, :);
    neg_test_labels = zeros(size(neg_test_data, 1), 1);
else
    neg_indices = randperm(size(neg_features, 1), train_size);
    neg_train_data = neg_features(neg_indices, :);
    neg_train_labels = zeros(size(neg_train_data, 1), 1);
    neg_test_data = neg_features;
    neg_test_data(neg_indices, :) = [];
    neg_test_labels = zeros(size(neg_test_data, 1), 1);
end

% disp(size(neg_train_data,1));
% disp(size(neg_test_data,1));

train_data = [pos_train_data; neg_train_data];
train_labels = [pos_train_labels; neg_train_labels];
test_data = [pos_test_data; neg_test_data];
test_labels = [pos_test_labels; neg_test_labels];

end