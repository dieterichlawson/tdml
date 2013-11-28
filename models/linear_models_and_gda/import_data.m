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