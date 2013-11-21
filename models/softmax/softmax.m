clear;
data_with_names = importdata('../../data/taps.csv', ',',1);

% From 2nd to final row (1st row is the category title 'name' in db), take 1st col (names)
ids = data_with_names.textdata(2:end, 1);
% Relabel the ids to numerical values (labels)
label_vector = grp2idx(ids);

% data is now a matrix with the numerical labels (instead of id's) and the
% data for each attempt on a row
data = [label_vector data_with_names.data(:,1:end-8)];
labels = unique(label_vector);

% Training Softmax requires a matrix consisting of the first 15 attempts for each user (training_data)
training_data = [];
% And a corresponding 15*n length column vector of the labels (user_id's) for each of those attempts
training_labels = [];
% Test data is final 15 taps
test_data = [];
test_labels = [];

% Create matrix of user training data and test data
%for i = labels'
for i = labels'
    % data for person "i" finds all rows that belong to user i
	% and then takes col's 3 -> end (1 = name, 2 = pin)
	data_for_i = data(data(:,1)==i, 3:end);
	label_for_i = data(data(:,1)==i, 1);
	
	% training data is first 15 rows/attempts, test data is next 15 rows/attempts
	training_data_i = data_for_i(1:15,:);
	training_data = [training_data; training_data_i];
    
	training_label_i = label_for_i(1:15);
    training_labels = [training_labels; training_label_i];
	
	test_data_i = data_for_i(16:end, :);
    test_data = [test_data; test_data_i];
    %test_labels = [test_labels; labels_for_i(16:end)];
end

softmax_coefficients = mnrfit(training_data, training_labels);
softmax_probabilities = mnrval(softmax_coefficients, test_data);
[largest_probabilities,user_predictions] = max(softmax_probabilities, [], 2);
%classperf(
disp(user_predictions)