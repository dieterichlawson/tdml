function [A] = normalize(A)
%normalize center the data and give it unit variance
%   subtracts the mean and divides by the standard deviation
%   assumes cols are variables and rows are observations
  m = mean(A);
  s = std(A);
  for i=1:size(A,1)
    A(i,:) = (A(i,:) - m)./s;
  end
end

