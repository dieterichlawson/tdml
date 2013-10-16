function [ min, max, mean, temp ] = compute_variability(EnrollmentAttempts)
%compute_variability This function computes the 'variability' of a set of
%enrollment attempts
%
%   Accepts a set of enrollment attempts and computes various statistics
%   over them, such as the mean minimum and max distances between pairs,
%   the mean distance between all pairs, and 'temp', the mean distance to
%   the enrollment attempt that is closest to all other attempts. These
%   statistics are used in the Euclidean Distance classifier to measure
%   the variability of a person's tap biometrics.
minmean = [Inf('double') -1];
min = 0; max = 0; mean = 0;
for i=1:size(EnrollmentAttempts,1)
    vmin = Inf('double');
    vmax = -Inf('double');
    vmean = 0;
    for j=1:size(EnrollmentAttempts,1)
        if i == j; continue; end
        dist = norm(EnrollmentAttempts(i,:) - EnrollmentAttempts(j,:));
        vmean = vmean + dist;
        if dist > vmax ; vmax = dist; end
        if dist < vmin ; vmin = dist; end
    end
    vmean = vmean / (size(EnrollmentAttempts,1)-1);
    if(vmean < minmean(1)) minmean = [vmean i]; end
    min = min + vmin;
    max = max + vmax;
    mean = mean + vmean;
end
min = min / size(EnrollmentAttempts,1);
max = max / size(EnrollmentAttempts,1);
mean = mean / size(EnrollmentAttempts,1);
closest = minmean(2);
temp = 0;
for i=1:size(EnrollmentAttempts,1)
    if i == closest; continue; end
    temp = temp + norm(EnrollmentAttempts(closest,:) - EnrollmentAttempts(i,:));
end
temp = temp / (size(EnrollmentAttempts,1)-1);
end
