run('../util/import_data');

neg_sizes = [20; 35; 50; 70; 90; 110; 130; 150];

gda_far = zeros(8,1);
gda_frr = zeros(8,1);
svm_far = zeros(8,1);
svm_frr = zeros(8,1);

gtrain_far = zeros(8,1);
gtrain_frr = zeros(8,1);
strain_far = zeros(8,1);
strain_frr = zeros(8,1);

for z=1:8
NUM_NEG_TRAIN = neg_sizes(z);
    
run('../gda/gda.m');
evaluation_table(2, length(pins) + 1) = sum(evaluation_table(2,:))/length(pins);
evaluation_table(3, length(pins) + 1) = sum(evaluation_table(3,:))/length(pins);
evaluation_table(4, length(pins) + 1) = sum(evaluation_table(4,:))/length(pins);
evaluation_table(5, length(pins) + 1) = sum(evaluation_table(5,:))/length(pins);
gda_far(z,1) = evaluation_table(2, length(pins) + 1);
gda_frr(z,1) = evaluation_table(3, length(pins) + 1);
gtrain_far(z,1) = evaluation_table(4, length(pins) + 1);
gtrain_frr(z,1) = evaluation_table(5, length(pins) + 1);

run('../svm/svm.m');
evaluation_table(2, length(pins) + 1) = sum(evaluation_table(2,:))/length(pins);
evaluation_table(3, length(pins) + 1) = sum(evaluation_table(3,:))/length(pins);
evaluation_table(4, length(pins) + 1) = sum(evaluation_table(4,:))/length(pins);
evaluation_table(5, length(pins) + 1) = sum(evaluation_table(5,:))/length(pins);
svm_far(z,1) = evaluation_table(2, length(pins) + 1);
svm_frr(z,1) = evaluation_table(3, length(pins) + 1);
strain_far(z,1) = evaluation_table(4, length(pins) + 1);
strain_frr(z,1) = evaluation_table(5, length(pins) + 1);
end

final_table = zeros(12, 8);
final_table(1,:) = neg_sizes;
final_table(2,:) = gda_far';
final_table(3,:) = gda_frr';
final_table(5,:) = svm_far';
final_table(6,:) = svm_frr';
final_table(8,:) = gtrain_far';
final_table(9,:) = gtrain_frr';
final_table(11,:) = strain_far';
final_table(12,:) = strain_frr';

csvwrite('neg_analysis.csv', final_table);

plot(neg_sizes, gda_far, '-or', neg_sizes, gda_frr, '-*g');
%svm_plot = plot(neg_sizes, svm_far, '-or', neg_sizes, svm_frr, '--*g');


% csvwrite('gda_full_features.csv', evaluation_table);
% clear;
% run('../util/import_data');
% run('../rforest/rforest.m');
% evaluation_table(2, length(pins) + 1) = sum(evaluation_table(2,:))/length(pins);
% evaluation_table(3, length(pins) + 1) = sum(evaluation_table(3,:))/length(pins);
% csvwrite('rforest_full_features.csv', evaluation_table);
% clear;
% run('../util/import_data');
