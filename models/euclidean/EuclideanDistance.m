classdef EuclideanDistance
    %EuclideanDistance Euclidean distance classifier
    %   Detailed explanation goes here
    
    properties
        means
        templates
        ranges
        nTaps
        normType
        data
    end
    
    methods
        % Constructor that accepts a matrix of enrollment attempts
        % and returns a EuclideanDistance classifier.
        % Enrollment attempt features must be arranged as follows:
        %
        % Cols 1 - num_taps: press to release latency
        % The next num_taps - 1 cols: press to press
        % The next num_taps - 1 cols: release to press
        % The next num_taps - 1 cols: release to release
        %
        % 1-5 6-9 10-13 14-17
        %
        function ED = EuclideanDistance(data, normType)
            defaultFeatures = ['pp','pr','rp','rr'];
            ED.normType = normType;
            ED.nTaps = (size(attempts,2)+3)/4;
            ED.setRanges();
            ED.data = data;
            ED.setMeans(defaultFeatures);
        end
        
        function class = classify(ED, attempt, features)
            features = ['pr','pp','rp','rr'];
            stats = zeros(size(features,2),4);
            for i=1:size(features,2)
                stats(i,:) = ED.classifyFeature(attempt, features(i));
            end
            stats = mean(stats);
            class = 1;
        end 
    end
    
    methods (Access = private)
        
        function ED = setRanges(ED)
            ED.ranges = containers.Map();
            ED.ranges('pr') = 1:ED.nTaps;
            ED.ranges('pp') = ED.nTaps+1:(ED.nTaps*2)-1;
            ED.ranges('rp') = ED.nTaps*2:(ED.nTaps*3)-2;
            ED.ranges('rr') = (ED.nTaps*3)-1:(ED.nTaps*4)-3;
        end
        
        function f = feature(ED, handle)
            f = ED.data(ED.ranges(handle));
        end
        
        % for each feature, calculate the mean statistics
        function setMeans(ED, features)
            ED.means = containers.Map;
            ED.templates = containers.Map();
            for handle = features
               stats = calc_means(ED.feature(handle), ED.normType);
               ED.means(handle) = stats(1:4);
               ED.templates(handle) = stats(5);
            end
        end
        

        function [min_d, max_d, mean_d, temp_d] = classifyFeature(ED, attempt, handle)
            % extract the specific feature values from the full attempt
            % vector
            att_feature = attempt(ED.ranges(handle));
            % calculate the distances between existing data and the
            % login attempt
            distances = dists(att_feature, ED.feature(handle),ED.normType);
            % calculate the stats
            feat_means = ED.means(handle);
            min_d = min(distances)/feat_means(1);
            max_d = max(distances)/feat_means(2);
            mean_d = mean(distances)/feat_means(3);
            % calculate the distance from the template
            temp_d = norm(ED.templates(handle) - att_feature,ED.normType)/feat_means(4);
        end
    end
    
    methods (Static)
        function [ D ] = dists(vector, points, normType)
            D = zeros(size(points,1),1);
            for i=1:size(points,1)
                D(i) = norm(vector - points(i,:), normType);
            end
        end
        
        function [min_d, max_d, mean_d, temp_d, template] = calc_means(attempts, normType)
            % create matrix with pairwise distance between elements
            % i.e. dists(i,j) is the distance between vector i and j
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

