N = [3,5,6,7];
max_shift = 20;
for i = 1:length(N)
    [sh, err] = best_shift_add(1/N(i), max_shift);
    fprintf('N=%d: Shifts=%s, #Shifts=%d, Error=%.5f%%\n', N(i), mat2str(sh), length(sh), err);
end




x = 0:(2^16 - 1);
N = 1:7;
errors = zeros(1, numel(N));

for idx = 1:numel(N)
    n = N(idx);
    switch n
        case 1
            approx = x;
        case 2
            approx = bitshift(x, -1);
        case 3
            approx = bitshift(x, -1) + bitshift(x, -2) - bitshift(x, -5);
        case 4
            approx = bitshift(x, -2);
        case 5
            approx = bitshift(x, -2) + bitshift(x, -4);
        case 6
            approx = bitshift(x, -2) + bitshift(x, -3) - bitshift(x, -6);
        case 7
            approx = bitshift(x, -3) + bitshift(x, -5) + bitshift(x, -6);
    end
    exact = x / n;
    err = abs(double(approx) - exact) ./ (exact + (exact == 0)); % Avoid div by 0
    errors(idx) = max(err) * 100; % percentage
end

disp('Worst-case % error for N=1:7');
disp(array2table(errors, 'VariableNames', compose('N%d', N)));


%% Percentage error ignoring truncation (purely mathematical now)

N = 1:7;
approx_mult = [1, 0.5, 0.5 + 0.25 - 0.03125, 0.25, 0.25 + 0.0625, 0.25 + 0.125 - 0.015625, 0.125 + 0.03125 + 0.015625];

errors = abs(approx_mult - (1 ./ N)) ./ (1 ./ N) * 100;

disp('Multiplier % error for N=1:7 ignoring truncation');
disp(array2table(errors, 'VariableNames', compose('N%d', N)));

%%

N = [3 5 6 7];
true_mult = 1 ./ N;

approx_mult = [
    2^-2 + 2^-4 + 2^-6;   % for N=3
    2^-3 + 2^-4 + 2^-6;   % for N=5
    2^-3 + 2^-5 + 2^-6;   % for N=6
    2^-3 + 2^-6           % for N=7
];

errors = abs(approx_mult - true_mult) ./ true_mult * 100;

disp('Multiplier % error for N=3,5,6,7');
disp(array2table(errors, 'VariableNames', compose('N%d', N)));

%


