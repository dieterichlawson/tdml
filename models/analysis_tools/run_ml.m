run('../util/import_data');
run('../gda/gda.m');
evaluation_table(2, length(pins) + 1) = sum(evaluation_table(2,:))/length(pins);
evaluation_table(3, length(pins) + 1) = sum(evaluation_table(3,:))/length(pins);
csvwrite('gda_full_features.csv', evaluation_table);

clear;
run('../util/import_data');
run('../svm/svm.m');
evaluation_table(2, length(pins) + 1) = sum(evaluation_table(2,:))/length(pins);
evaluation_table(3, length(pins) + 1) = sum(evaluation_table(3,:))/length(pins);
csvwrite('svm_full_features.csv', evaluation_table);