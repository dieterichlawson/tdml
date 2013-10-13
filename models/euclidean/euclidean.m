imp = importdata('data/taps.csv',',',1);
names = imp.textdata(2:end,1);
data = [grp2idx(names) imp.data];
data(:,2:end) = normalize(data(:,2:end));

%for each person
% intialize mean min
% initialize mean max
% initialize mean dist
% intialize min mean
% for each vector
  % intialize min dist
  % initialize max dist
  % initialize mean
 % for each other vector
    % compute distances between vectors
    % add to mean
    % compare with min and max
 %end
 % stuff
%end