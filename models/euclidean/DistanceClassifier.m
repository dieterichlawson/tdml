classdef DistanceClassifier < handle
    %Distance Euclidean distance classifier
    %   A classifier based on 
    
    properties
        % Map holding mean statistics for each featureset (i.e. mean min, 
        % mean max, etc.. for pr, pp, rp, etc..)
        means
        % Map holding the 'template enrollment' for each
        % featureset, defined as the vector with the lowest average
        % distance to all others
        templates
        % Map holding the indices corresponding to each feature
        ranges
        % The number of taps per pin (should include enter as a tap)
        nTaps
        % The norm type, e.g. euclidean, seuclidean, etc...
        normType
        % The raw enrollment acquisitions
        data
    end
    
    methods

        % Constructor that accepts a matrix of enrollment attempts
        % and returns a DistanceClassifier.
        %
        % Enrollment attempt features must be arranged as follows:
        %
        % Cols 1 - num_taps: press to release latency
        % The next num_taps - 1 cols: press to press
        % The next num_taps - 1 cols: release to press
        % The next num_taps - 1 cols: release to release
        %
        % e.g.
        % 1-5 6-9 10-13 14-17
        %
        function DC = DistanceClassifier(data, normType, numTaps)
            DC.normType = normType;
            DC.nTaps = numTaps;
            DC.setRanges();
            DC.data = data;
            defaultFeatures = {'pp';'pr';'rp';'rr'}';
            DC.setMeans(defaultFeatures);
        end
        
        
        % accepts attempts as row vectors
        % and returns the class
        function classes = classify(DC, attempts, features, thresholds)
            % initialize list of output classes
            classes = zeros(size(attempts,1),1);
            % iterate over every attempt
            for att_i=1:size(attempts,1)
                att = attempts(att_i,:);
                stats = zeros(size(features,2),4);
                for i=1:size(features,2)
                    feature = features(i);
                    feature = feature{1};
                    stats(i,:) = DC.classifyFeature(att, feature);
                end
                % stats is now a num features x 4 array that holds the min,
                % max, mean, and temp stats for each feature. We now normalize
                % by the number of features.
                stats = mean(stats);
                if stats < thresholds
                    classes(att_i,:) = 1;
                else
                    classes(att_i,:) = 0;
                end
            end
            % the stats array will hold the min, max, mean and temp vectors
            % as row vectors for each of the selected features, 
           
        end 
    end
    
    methods (Access = private)
        
        % Generates the index ranges for each feature
        % based on the number of taps per pin.
        % We always generate all ranges even if we 
        % don't use a specific feature
        function setRanges(DC)
            DC.ranges = containers.Map;
            DC.ranges('pr') = 1:DC.nTaps;
            DC.ranges('pp') = (DC.nTaps+1):((DC.nTaps*2)-1);
            DC.ranges('rp') = DC.nTaps*2:(DC.nTaps*3)-2;
            DC.ranges('rr') = (DC.nTaps*3)-1:(DC.nTaps*4)-3;
        end
        
        % Returns all enrollment acquisitions of a specific
        % feature, i.e. it slices all enrollment acquisitions, leaving 
        % only the columns associated with the supplied feature handle
        function f = feature(DC, handle)
            f = DC.data(:,DC.ranges(handle));
        end
        
        % for each feature, calculate the mean statistics
        function setMeans(DC, features)
            DC.means = containers.Map;
            DC.templates = containers.Map;
            for handle = features
               [min_d, max_d, mean_d, temp_d, template] = DistanceClassifier.calc_means(DC.feature(handle{1}), DC.normType);
               DC.means(handle{1}) = [min_d, max_d, mean_d, temp_d];
               DC.means(handle{1});
               DC.templates(handle{1}) = template;
            end
        end

        % Calculate the classification statistics for a specific attempt
        % and feature handle
        function [min_d, max_d, mean_d, temp_d] = classifyFeature(DC, attempt, handle)
            % extract the specific feature values from the full attempt
            % vector
            att_feature = attempt(DC.ranges(handle));
            % calculate the distances between existing data and the
            % login attempt. This results in a column vector of distances
            % of each prior enrollment to the login attempt
            distances = pdist2(DC.feature(handle), att_feature, DC.normType);
            % retrive the stats for this feature
            feat_means = DC.means(handle);
            min_d = min(distances)/feat_means(1);
            max_d = max(distances)/feat_means(2);
            mean_d = mean(distances)/feat_means(3);
            % calculate the distance from the template
            temp_d = pdist2(DC.templates(handle), att_feature, DC.normType)/feat_means(4);
        end
    end
    
    methods (Static)
        
        % Given a norm type and a matrix of attempts, calculate the mean
        % statistics as well as the template. The vector of attempts is 
        % assumed to hold only one feature
        function [min_d, max_d, mean_d, temp_d, template] = calc_means(attempts, normType)
            % create matrix with pairwise distance between elements i.e.
            % dists(i,j) is the distance between vector i and j
            % normalized by the length of each vector (i.e.
            % size(attempts,2))
            dists = pdist(attempts,normType);
            dists = squareform(dists)/size(attempts,2);
            % remove diagonal 0 elements
            dists(logical(eye(size(dists)))) = [];
            dists = reshape(dists,size(attempts,1)-1, size(attempts,1));
            dists = dists';
            % remove extra elements
            dists(logical(eye(size(dists)))) = [];
            dists = reshape(dists,size(attempts,1)-1, size(attempts,1)-1)';
            % calculate desired stats
            % average minimum distance
            min_d = mean(min(dists));
            % average maximum distance
            max_d = mean(max(dists));
            % average mean distance
            mean_d = mean(mean(dists));
            % average distance from template
            % where the template is the vector with minumum average
            % distance to the other vectors (i.e. closest to all others)
            temp_d = min(mean(dists));
            ind = mean(dists) == temp_d;
            template = attempts(ind,:);
        end
    end
end