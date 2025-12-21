%% Unicycle Ghost Plotter
% Extract data from the Timeseries object
t = out.sim_pose.Time;
data = squeeze(out.sim_pose.Data); % Result is [N x 3] matrix

x_sim = data(:,1);
y_sim = data(:,2);
th_sim = data(:,3);

% --- Configuration ---
decimation = 20;    % Plot every 20th point (adjust for density)
robotScale = 0.15;  % Adjust size of the triangles
ghostColor = [0 0.4470 0.7410]; % MATLAB blue

figure('Color', 'w');
hold on; grid on; box on;
axis equal;
xlabel('X [m]'); ylabel('Y [m]');
title('Unicycle Trajectory Ghost Plot');

% --- Plotting Loop ---
for i = 1:decimation:length(t)
    % Current Pose
    x = x_sim(i);
    y = y_sim(i);
    theta = th_sim(i);
    
    % Define Triangle (local coordinates)
    % Pointing right at 0 radians
    V = [-1, -0.6; 2, 0; -1, 0.6] * robotScale; 
    
    % Rotation Matrix
    R = [cos(theta), -sin(theta); 
         sin(theta),  cos(theta)];
    
    % Transform vertices to global frame
    V_global = (R * V')' + [x, y];
    
    % Draw the ghost
    patch('Faces', [1 2 3], 'Vertices', V_global, ...
          'FaceColor', 'none', ...
          'EdgeColor', ghostColor, ...
          'LineWidth', 0.5, ...
          'EdgeAlpha', 0.6); % Transparency for better overlapping
end

% Plot the final position in RED to highlight it
final_V = ([cos(th_sim(end)) -sin(th_sim(end)); sin(th_sim(end)) cos(th_sim(end))] * ...
          ([-1, -0.6; 2, 0; -1, 0.6] * robotScale)')' + [x_sim(end), y_sim(end)];
patch('Faces', [1 2 3], 'Vertices', final_V, 'FaceColor', 'none', 'EdgeColor', 'r', 'LineWidth', 2);

% Plot the continuous path line
plot(x_sim, y_sim, 'k--', 'LineWidth', 1);