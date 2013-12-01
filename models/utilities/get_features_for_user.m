function [features_for_user] = get_features_for_user(full_data, user_id)
% Takes in a matrix with multiple users; each row also includes the user_id
% and the pin of that user. Given a user_id, we will return a matrix that
% only consists of data rows that belong to that user_id and we will remove
% the user_id and pin columns (col 1, 2) from the matrix.
    features_for_user = full_data(full_data(:,1)==user_id, 3:end);
end

