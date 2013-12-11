run('../util/import_data');
run('../gda/gda.m');
csvwrite('gda_full_features.csv', evaluation_table);

% clear;
% run('../util/import_data');
% run('../svm/svm.m');
% csvwrite('svm_full_features.csv', evaluation_table);

% clear;
% run('../util/import_data');
% run('../logistic/linear.m');
% csvwrite('linear_full_features.csv', evaluation_table);