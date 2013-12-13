run('../util/import_data');

neg_sizes = [15; 35; 55; 75; 95; 115; 135; 150];

gda_far = zeros(8,1);
gda_frr = zeros(8,1);
svm_far = zeros(8,1);
svm_frr = zeros(8,1);

for z=1:8
    
NUM_NEG_TRAIN = neg_sizes(z);
    
run('../gda/gda.m');
evaluation_table(2, length(pins) + 1) = sum(evaluation_table(2,:))/length(pins);
evaluation_table(3, length(pins) + 1) = sum(evaluation_table(3,:))/length(pins);
gda_far(z,1) = evaluation_table(2, length(pins) + 1);
gda_frr(z,1) = evaluation_table(3, length(pins) + 1);
if(NUM_NEG_TRAIN == 35)
	csvwrite('gda_35.csv', evaluation_table);
elseif(NUM_NEG_TRAIN == 55)
    csvwrite('gda_55.csv', evaluation_table); 
end

% csvwrite('gda_full_features.csv', evaluation_table);
% clear;
% run('../util/import_data');
% run('../rforest/rforest.m');
% evaluation_table(2, length(pins) + 1) = sum(evaluation_table(2,:))/length(pins);
% evaluation_table(3, length(pins) + 1) = sum(evaluation_table(3,:))/length(pins);
% csvwrite('rforest_full_features.csv', evaluation_table);
% clear;
% run('../util/import_data');
run('../svm/svm.m');
evaluation_table(2, length(pins) + 1) = sum(evaluation_table(2,:))/length(pins);
evaluation_table(3, length(pins) + 1) = sum(evaluation_table(3,:))/length(pins);
svm_far(z,1) = evaluation_table(2, length(pins) + 1);
svm_frr(z,1) = evaluation_table(3, length(pins) + 1);
% csvwrite('svm_full_features.csv', evaluation_table);
end

final_table = zeros(6, 8);
final_table(1,:) = neg_sizes;
final_table(2,:) = gda_far';
final_table(3,:) = gda_frr';
final_table(5,:) = svm_far';
final_table(6,:) = svm_frr';

csvwrite('neg_analysis.csv', final_table);

xlabel('Negative training set size');
ylabel('Error rate');
gda_plot = plot(neg_sizes, gda_far, '-or', neg_sizes, gda_frr, '--*g');
%svm_plot = plot(neg_sizes, svm_far, '-or', neg_sizes, svm_frr, '--*g');
