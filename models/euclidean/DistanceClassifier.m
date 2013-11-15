classdef DistanceClassifier
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
        % The norm type, 
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
        function DC = DistanceClassifier(data, normType)
            defaultFeatures = ['pp','pr','rp','rr'];
            DC.normType = normType;
            DC.nTaps = (size(attempts,2)+3)/4;
            DC.setRanges();
            DC.data = data;
            DC.setMeans(defaultFeatures);
        end
        
        function class = classify(DC, attempt, features)
            features = ['pr','pp','rp','rr'];
            stats = zeros(size(features,2),4);
            for i=1:size(features,2)
                stats(i,:) = DC.classifyFeature(attempt, features(i));
            end
            stats = mean(stats);
            class = 1;
        end 
    end
    
    methods (Access = private)
        
        % Generates the index ranges for each feature
        % based on the number of taps per pin.
        % We always generate all ranges even if we 
        % don't use a specific feature
        function DC = setRanges(DC)
            DC.ranges = containers.Map();
            DC.ranges('pr') = 1:DC.nTaps;
            DC.ranges('pp') = DC.nTaps+1:(DC.nTaps*2)-1;
            DC.ranges('rp') = DC.nTaps*2:(DC.nTaps*3)-2;
            DC.ranges('rr') = (DC.nTaps*3)-1:(DC.nTaps*4)-3;
        end
        
        % Returns all enrollment acquisitions of a specific
        % feature, i.e. it slices all enrollment acquisitions, leaving 
        % only the columns associated with the supplied feature handle
        function f = feature(DC, handle)
            f = DC.data(DC.ranges(handle));
        end
        
        % for each feature, calculate the mean statistics
        function setMeans(DC, features)
            DC.means = containers.Map;
            DC.templates = containers.Map();
            for handle = features
               stats = calc_means(DC.feature(handle), DC.normType);
               DC.means(handle) = stats(1:4);
               DC.templates(handle) = stats(5);
            end
        end

        % Calculate the classification statistics for a specific attempt
        % and feature handle
        function [min_d, max_d, mean_d, temp_d] = classifyFeature(DC, attempt, handle)
            % extract the specific feature values from the full attempt
            % vector
            att_feature = attempt(DC.ranges(handle));
            % calculate the distances between existing data and the
            % login attempt
            distances = pdist2(DC.feature(handle), att_feature, DC.normType);
            % calculate the stats
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
            dists = squareform(pdist(attempts,normType));
            sdists = dists;
            % remove diagonal 0 elements
            sdists(logical(eye(size(dists)))) = [];
            reshape(sdists,size(dists,1)-1, size(dists,2));
            % calculate desired stats
            % average minimum distance
            min_d = mean(min(sdists));
            % average maximum distance
            max_d = mean(max(sdists));
            % average mean distance
            mean_d = mean(mean(sdists));
            % average distance from template
            % where the template is the vector with minumum average
            % distance to the other vectors (i.e. closest to all others)
            temp_d = min(mean(sdists));
            template = attempts(a == tempd,:);
        end
    end
end