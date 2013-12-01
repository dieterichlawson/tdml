function [data_pin_p, users_pin_p] = get_data_for_pin(full_data, pin)
% get_data_for_pin takes in the full data matrix from import_data and a numerical 
% pin code. We then fetch all data rows (including user id + pin columns)
% that have this pin code and return them in matrix data_pin_p.
% Additionally, we get a list of all users (user id's) that have pin p

    % data_pin_p = all data rows for people with pin p
    data_pin_p = full_data(full_data(:,2) == pin,:);
    % users_pin_p = unique list of users with pin p
    users_pin_p = unique(data_pin_p(:,1));
end

