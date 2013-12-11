run('../util/import_data');
run('../gda/gda.m');
csvwrite('gda_full_features.csv', evaluation_table);