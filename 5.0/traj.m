%% Note: run section by section, not all in once 
% (last section regards plot of the results and requires Simulink data to run)

%% Map generation
clf; figure(gcf);
axis equal; hold on; axis([-11 11 -13 11]);
title('Simplified Pac-Man Level with Closed Trajectory')

walls = {[-10 -10 20 1], [-10 9 20 1], [-10 -10 1 19], [9 -10 1 9], [9 1 1 8]};
        for k=1:numel(walls)
            rectangle('Position',walls{k},'FaceColor',[0 0 0.2],'EdgeColor','k');
        end

blocks = [
    % upper map blocks
    -8 5 0.5 3
    -8 7.5 3 0.5
    7.5 5 0.5 3
    5 7.5 3 0.5
    % lower map blocks
    -8 -8 0.5 3
    -8 -8 3 0.5
    7.5 -8 0.5 3
    5 -8 3 0.5

    % entrance
    5, 1, 4, 0.5
    5, -1.5, 4, 0.5
    
    %other blocks
    -6, 3, 2.5, 3
    -6, -6, 2.5, 3
];

% circles ([xc - r, yc - r])
circles = [ 
    -1, 5, 2, 2
    -1, -7, 2, 2
    -7, -1, 2, 2
    
];

squares = [
    
    % parking spot 
    -1, -1, 2, 2
];
for i=1:size(blocks,1)
    rectangle('Position',blocks(i,:),'FaceColor',[0 0 0.2],'EdgeColor','k')
end

for i=1:size(circles,1)
    rectangle('Position',circles(i,:),'Curvature',[1 1],'FaceColor',[0 0 0.2],'EdgeColor','k');
end

for i=1:size(squares,1)
    rectangle('Position',squares(i,:),'EdgeColor','k');
end



%% trajectory points

waypoints = [
    10,   0;
     4,   0;
     4,   5;
   8.5,   2;
   8.5, 8.5;
     4, 8.5;
     4,   6;
     2,   6;
    -2,   6;
     -3,   6;
     -3,   1;
     -5,  -1
     ];


traj_x_1 = waypoints(1:8, 1);
traj_y_1 = waypoints(1:8, 2);

traj_x_2 = waypoints(9:12, 1);
traj_y_2 = waypoints(9:12, 2);

circle_start = waypoints(8,:);
circle_end = waypoints(9,:);

centre = [(circle_start(1) + circle_end(1))/2, (circle_start(2) + circle_end(2))/2];
radius = 2;

start_ang = atan2(circle_start(2) - centre(2), circle_start(1) - centre(1));
stop_ang = atan2(circle_end(2) - centre(2), circle_end(1) - centre(1));

theta = linspace(start_ang, stop_ang, 100);
x_c = centre(1) + radius * cos(theta);
y_c = centre(2) + radius * sin(theta);

plot(traj_x_1, traj_y_1, 'b-o', 'LineWidth', 2, 'MarkerFaceColor', 'y');
plot(x_c, y_c, 'b', 'LineWidth', 2);
plot(traj_x_2, traj_y_2, 'b-o', 'LineWidth', 2, 'MarkerFaceColor', 'y');



%% angular velocity

speed = 15;
ang_velocity = 3;
distances_1 = zeros(1,size(traj_x_1,1)-1);
distances_2 = zeros(1,size(traj_x_2,1)-1);

for i = 1:size(traj_x_1,1)-1
    dist = norm(waypoints(i,:) - waypoints(i+1,:));
    distances_1(i) = dist;
end

for i = 1:size(traj_x_2,1)-1
    dist = norm(waypoints(i+8,:) - waypoints(i+9,:));
    distances_2(i) = dist;
end

delta_theta = stop_ang - start_ang;
circular_path_time = delta_theta / ang_velocity;

time_1 = [0, distances_1/speed];
time_2 = (distances_2/speed) + 0.3;
full_time = [time_1, circular_path_time, time_2];
time_vec_circ = zeros(1,size(full_time,2));

for i = 1:size(full_time,2)-1
    time_vec_circ(i+1) = time_vec_circ(i) + full_time(i+1);
end

for i = 1:size(time_vec_circ,2)-1
    if time_vec_circ(i) == time_vec_circ(i+1)
        time_vec_circ(i+1) = time_vec_circ(i+1);
    end
end

time_vec_circ = time_vec_circ';

%% plot (run after performing simulation in Simulink)

plot(out.sim_pose1.Data(:,1), out.sim_pose1.Data(:,2), 'r-o');


hold off



