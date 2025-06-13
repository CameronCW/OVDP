trials = 1e5;
prize = randi(3, trials, 1);
choice = randi(3, trials, 1);

goat_doors = arrayfun(@(p,c) setdiff(1:3, [p, c]), prize, choice, 'UniformOutput', false);
host_removes = cellfun(@(g) g(randi(length(g))), goat_doors, 'UniformOutput', true);
switch_choice = arrayfun(@(c,h) setdiff(1:3, [c, h]), choice, host_removes, 'UniformOutput', false);
switch_choice = cellfun(@(x) x(1), switch_choice);

stay_win = prize == choice;
switch_win = prize == switch_choice;

subplot(1,2,1), bar(1, mean(stay_win)), ylim([0 1]), title('Stay'), set(gca, 'XTick', [])
subplot(1,2,2), bar(1, mean(switch_win)), ylim([0 1]), title('Switch'), set(gca, 'XTick', [])
