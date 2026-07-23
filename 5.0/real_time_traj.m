function real_time_traj(x, y, theta)

    persistent h_fig h_pacman initialized


    if isempty(initialized)
        initialized = false;
    end


    scale = 0.8; 
    base_x = [0.6; -0.4; -0.2; -0.4] * scale; 
    base_y = [0.0;  0.4;  0.0; -0.4] * scale;

    x_new = base_x * cos(theta) - base_y * sin(theta) + x;
    y_new = base_x * sin(theta) + base_y * cos(theta) + y;

    disegna_mappa = false;
    if ~initialized
        disegna_mappa = true;
    elseif ~ishandle(h_fig)
        disegna_mappa = true; 
    end

 
    if disegna_mappa
        
        h_fig = figure(1); 
        clf(h_fig); 
        set(h_fig);
        hold on; 
        axis equal; 
        axis([-11 11 -13 11]);
        

      
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

        -6, 3, 2.5, 3
        -6, -6, 2.5, 3
    ];
        for i=1:size(blocks,1)
            rectangle('Position',blocks(i,:),'FaceColor',[0 0 0.2],'EdgeColor','k');
        end

        circles = [ 
        -1, 5, 2, 2
        -1, -7, 2, 2
        -7, -1, 2, 2
    
        ];
        for i=1:size(circles,1)
            rectangle('Position',circles(i,:),'Curvature',[1 1],'FaceColor',[0 0 0.2],'EdgeColor','k');
        end
        
        squares = [
    
        % parking spot block
        -1, -1, 2, 2
    ];
        for i=1:size(squares,1)
            rectangle('Position',squares(i,:),'EdgeColor','k');
        end

        h_pacman = patch(x_new, y_new, 'y', 'EdgeColor', 'k', 'LineWidth', 1.5);
        
        initialized = true;
        
    else
     
        if ishandle(h_pacman)
             set(h_pacman, 'XData', x_new, 'YData', y_new);
        end
        
        drawnow limitrate; 
    end
end