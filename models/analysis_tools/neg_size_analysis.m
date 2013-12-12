run('../util/import_data');
NUM_INTERVALS = 8;
START_SIZE = 15;
MAX_NEG_SIZE = 125;
neg_incr = (MAX_NEG_SIZE - START_SIZE) / (NUM_INTERVALS - 1);
neg_train_size = zeros(NUM_INTERVALS,1);
neg_train_size(1,1) = START_SIZE;

for i=2:NUM_INTERVALS
    neg_train_size(i, 1) = floor(neg_train_size(i-1,1) + neg_incr);
end

gda_far = zeros(NUM_INTERVALS, 1);
gda_frr = zeros(NUM_INTERVALS, 1);
for i=1:NUM_INTERVALS
    NUM_NEG_TRAIN = neg_train_size(i,1);
    run('../gda/gda.m');
    
    gda_far(i, 1) = sum(evaluation_table(2,:))/length(pins);
    gda_frr(i, 1) = sum(evaluation_table(3,:))/length(pins);
end
disp(gda_far);
disp(gda_frr);

svm_far = zeros(NUM_INTERVALS, 1);
svm_frr = zeros(NUM_INTERVALS, 1);
for i=1:NUM_INTERVALS
    NUM_NEG_TRAIN = neg_train_size(i,1);
    run('../svm/svm.m');
    
    svm_far(i, 1) = sum(evaluation_table(2,:))/length(pins);
    svm_frr(i, 1) = sum(evaluation_table(3,:))/length(pins);
end