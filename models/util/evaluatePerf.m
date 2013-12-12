function [fa, fr] = evaluatePerf(pred_labels, true_labels)

fa = 0;
fr = 0;
% Evaluate against true_test_labels
for j=1:length(pred_labels)
    if(pred_labels(j) ~= true_labels(j))
        % If true label is attacker, then we falsely accepted
        if(true_labels(j) == 0)
            fa = fa + 1;
        % Else, we incorrectly rejceted true user
        else
            fr = fr + 1;
        end
    end
end

end