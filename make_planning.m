function make_planning(file_in)
% Festival schedule generator
%   Input:
%   - file_in: .txt file with the acts (as per the example)
%   Output:
%   - Schedule at the command window
%   - Figure with the schedule

acts = readtable(file_in);
acts.Properties.VariableNames = ["name", "t_start", "t_end"];

%sort by starting time
acts_sorted = sortrows(acts,2);

%create the first stage with the first act, and store the time a stage
%becomes availalbe
stages(1).act_sort_idx = 1;
stages(1).t_end = acts_sorted(1,:).t_end;

for idx_stage = 2:size(acts_sorted,1)
    act = acts_sorted(idx_stage,:);

    %check which stage has space, select earliest possiblity (=longest
    %changeover gap for the roadies)
    t_gap = [stages.t_end] - act.t_start;
    [best_gap,best_stage] = min(t_gap);

    if best_gap < 0 %found a stage, add the act
        stages(best_stage).act_sort_idx = [stages(best_stage).act_sort_idx, idx_stage];
        stages(best_stage).t_end = act.t_end;
    else  %if all options were too late --> new stage required
        stages(end+1).act_sort_idx = idx_stage;
        stages(end).t_end = act.t_end;
    end
end

%% output - print schedule:
disp('------ Schedule ------')

for idx_stage = 1:numel(stages)
    fprintf('Stage %i\n', idx_stage);
    for idx_act = 1:numel(stages(idx_stage).act_sort_idx)
        act = acts_sorted(stages(idx_stage).act_sort_idx(idx_act),:);
        fprintf('Act: %s \t : %i-%i\n', act.name{1}, act.t_start, act.t_end);
    end
    disp('')
end

%% output - figure:
x_spacing = 0.05;
y_spacing = 0.1;
y_ticks={};
colors = jet(numel(stages)*2);

fig = figure;
for idx_stage = 1:numel(stages)
    y_ticks{end+1} = ['Stage ', num2str(idx_stage)];
    for idx_act = 1:numel(stages(idx_stage).act_sort_idx)
        act = acts_sorted(stages(idx_stage).act_sort_idx(idx_act),:);
        rectangle('Position',[act.t_start, idx_stage-0.5+y_spacing, act.t_end-act.t_start+1-x_spacing, 1-2*y_spacing], ...
             'Curvature',0.4,'FaceColor',colors(numel(stages)+idx_stage,:));
        text((act.t_end+1-act.t_start)/2 + act.t_start, idx_stage, strrep(act.name,'_',' '), ...
            'HorizontalAlignment','center','VerticalAlignment','middle');
        hold on
    end
end

grid on
xlabel('time [hr]')
xticks(0:1:(max(acts(:,:).t_end+2)))
yticks(1:numel(stages))
yticklabels(y_ticks)
title('Festival Schedule')
fig.WindowState = 'maximized';

end