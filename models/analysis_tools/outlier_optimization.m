% We expect import_data to be called before this.

for user=users'
    user_features = get_features_for_user(data, user);
    feature_var = var(user_features);
    feature_mean = mean(user_features);
    disp('*************************');
    disp(['For user = ' num2str(user)]);
    disp(feature_var);
    disp(feature_mean);
    disp('*************************');
end