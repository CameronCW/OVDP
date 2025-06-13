% CAMERON WADE APPROX DIVISION by SHIFT ADDER GENERATOR
N = [3,5,6,7];  %DIVISIONS
max_shift = 16; %SIZE OF VALUES
maxerrorPerc = 0.1;
maxError = maxerrorPerc / 100;

for i = 1:length(N)
    [sh, err] = best_shift_add(1/N(i), max_shift,maxError);
    fprintf('N=%d: Shifts=%s, #Shifts=%d, Error=%.5f%%\n', N(i), mat2str(sh), length(sh), err);
end

% Function to approximate reciprocal by shift-add
function [shifts, err] = best_shift_add(target, max_shift,maxError)
    remain = target;
    shifts = [];
    for k = 2:max_shift
        val = 2^-k;
        if remain >= val
            remain = remain - val;
            shifts(end+1) = k; 
        end
        if remain < target * maxError % 
            break;
        end
    end
    approx = sum(2.^-shifts);
    err = abs(approx - target) / target * 100;
end
