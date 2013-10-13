classdef EuclideanDistance
    %UNTITLED3 Summary of this class goes here
    %   Detailed explanation goes here
    
    properties
        EnrollmentAttempts
        Variability
    end
    
    methods
        function ED = EuclideanDistance(EnrollmentAttempts)
            ED.EnrollmentAttempts = EnrollmentAttempts;
            ED.Variability = computeVariability(EnrollmentAttempts);
        end 
    end
    
    methods (Access = private)
       variability = computeVariability(EnrollmentAttempts) 
    end
end

