% This script conducts an ablative feature analysis on our gda model to
% determine which features are the most valuable.

% Get results for the full feature set
run('../util/import_data');
NUM_NEG_TRAIN = 40;
% run('../gda/gda.m');
run('../svm/svm.m');
original_eval = evaluation_table;

% The general ablation process is to set the all columns to zero for the
% property we're ablating. Then we use nice Matlab logic to reformat the
% matrix so that only columns that have a non-zero entry are kept (i.e. all
% columns with zero are removed from the matrix)
total_col = size(data, 2);
col_per_tap = 3;
original_data = data;

% Fetch columns 1 - 16 to ablate the accelerometer data
data = data(:, 1:16);
no_accel_data = data;
% run('../gda/gda.m');
run('../svm/svm.m');
no_accel_eval = evaluation_table;

% Create data matrix with all SIZES removed
ablate_col = 4;
while ablate_col <= total_col
    data(:,ablate_col) = 0;
    ablate_col = ablate_col + col_per_tap;
end
data = data(:,any(data,1));
%run('../gda/gda.m');
run('../svm/svm.m');
no_size_eval = evaluation_table;

% Create data matrix with all DURATIONS removed
ablate_col = 3;
col_per_tap = 2;
while ablate_col <= total_col
    data(:,ablate_col) = 0;
    ablate_col = ablate_col + col_per_tap;
end
data = data(:,any(data,1));
%run('../gda/gda.m');
run('../svm/svm.m');
no_duration_eval = evaluation_table;

% % Create data matrix with all LATENCIES AND DURATIONS removed
% data = no_accel_data;
% ablate_lat = 5;
% ablate_dur = 3;
% while ablate_lat <= total_col
%     data(:,ablate_lat) = 0;
%     data(:,ablate_dur) = 0;
%     ablate_lat = ablate_lat + col_per_tap;
%     ablate_dur = ablate_dur + col_per_tap;
% end
% data = data(:,any(data,1));
% run('../gda/gda.m');
% %run('../svm/svm.m');
% only_size = evaluation_table;

%ablative_analysis_table = [original_eval; no_accel_eval; no_duration_eval; no_size_eval; no_latency_eval; only_size];
ablative_analysis_table = [original_eval; no_accel_eval; no_size_eval; no_duration_eval];
csvwrite('svm_ablative_analysis.csv', ablative_analysis_table);

% % Create data matrix with all LATENCIES removed
% data = original_data;
% ablate_col = 5;
% while ablate_col <= total_col
%     data(:,ablate_col) = 0;
%     ablate_col = ablate_col + col_per_tap;
% end
% data = data(:,any(data,1));
% run('../gda/gda.m');
% no_latency_eval = evaluation_table;
