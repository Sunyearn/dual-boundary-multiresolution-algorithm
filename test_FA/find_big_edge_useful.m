function [real_big_edge_boundary,...
          real_big_edge_inside,...
          real_big_edge_useful,...
          real_big_edge_not_useful,...
          real_big_edge_overlap_or_ghost]=...
          find_big_edge_useful(Nx_big,Ny_big,Nedge_big,...
                              left_pos_at_big,right_pos_at_big,forward_pos_at_big,backward_pos_at_big)
    edge_x_big_control = zeros(Nx_big,Ny_big+1);
    edge_y_big_control = zeros(Nx_big+1,Ny_big);
    %% X big 通过差异化的标志（flag）来划分棱边
    % X initial useful 把大网格中所有的 x 向棱边都激活， 并赋予 flag 1
    edge_x_big_control(:,:) = 1;
    % X initial inside 把大网格中所有的 x 向内部棱边（内部的 edge x）激活，并赋予 flag 10
    edge_x_big_control(:,2:(end-1)) = 10;
    % X real big overlap 把实际的网格剖分中，小网格覆盖区域所对应的大网格 x 向棱边  激活
    edge_x_big_control(left_pos_at_big:right_pos_at_big,(forward_pos_at_big):(backward_pos_at_big+1)) = 20;
    % real overlap and ghost
    edge_x_big_control([(left_pos_at_big-1),(right_pos_at_big+1)],(forward_pos_at_big):(backward_pos_at_big+1)) = 19;
%     % X real big overlap 把实际的网格剖分中，小网格覆盖区域所对应的大网格 x 向棱边  不激活
%     edge_x_big_control(left_pos_at_big:right_pos_at_big,(forward_pos_at_big):(backward_pos_at_big+1) ) = 20;
    %% reshape and find index of edge x
    edge_x_big_control = reshape(edge_x_big_control,Nx_big*(Ny_big+1),1 );
    real_big_edge_x_boundary = find(edge_x_big_control == 1);
    real_big_edge_x_inside = find( edge_x_big_control == 10 | edge_x_big_control == 19 );
    real_big_edge_x_useful = find( edge_x_big_control <= 19 );
    real_big_edge_x_not_useful = find( edge_x_big_control > 19 );
    real_big_edge_x_overlap_or_ghost = find( edge_x_big_control == 19 );
    %% Y big
    % Y initial useful 把大网格中所有的 y 向棱边都激活， 并赋予 flag 1
    edge_y_big_control(:,:) = 1;
    % Y initial inside 把大网格中所有的 y 向内部棱边激活，并赋予 flag 10
    edge_y_big_control(2:(end-1),:) = 10;
    % Y real big overlap 把实际的网格剖分中，小网格覆盖区域所对应的大网格 y 向棱边 激活
    edge_y_big_control((left_pos_at_big):(right_pos_at_big+1),forward_pos_at_big:backward_pos_at_big) = 20;
    % Y real big real overlap and ghost
    edge_y_big_control((left_pos_at_big):(right_pos_at_big+1),[(forward_pos_at_big-1),(backward_pos_at_big+1)]) = 19;
%     % Y real big overlap 把实际的网格剖分中，小网格覆盖区域所对应的大网格 y 向棱边 不激活
%     edge_y_big_control((left_pos_at_big):(right_pos_at_big+1),forward_pos_at_big:backward_pos_at_big) = 20;
    %% reshape and find index of edge y
    edge_y_big_control = reshape(edge_y_big_control,(Nx_big+1)*Ny_big,1 );
    real_big_edge_y_boundary = find(edge_y_big_control == 1);
    real_big_edge_y_inside = find( edge_y_big_control == 10 | edge_y_big_control == 19 );
    real_big_edge_y_useful = find( edge_y_big_control <= 19 );
    real_big_edge_y_not_useful = find( edge_y_big_control > 19 );
    real_big_edge_y_overlap_or_ghost = find( edge_y_big_control == 19 );
    % adjust
    real_big_edge_y_boundary = real_big_edge_y_boundary + Nedge_big(1);
    real_big_edge_y_inside   = real_big_edge_y_inside + Nedge_big(1);
    real_big_edge_y_useful   = real_big_edge_y_useful + Nedge_big(1);
    real_big_edge_y_not_useful   = real_big_edge_y_not_useful + Nedge_big(1);
    real_big_edge_y_overlap_or_ghost = real_big_edge_y_overlap_or_ghost + Nedge_big(1);
    %% add up
    real_big_edge_boundary = [real_big_edge_x_boundary;real_big_edge_y_boundary];
    real_big_edge_inside = [real_big_edge_x_inside;real_big_edge_y_inside];
    real_big_edge_useful = [real_big_edge_x_useful;real_big_edge_y_useful];
    real_big_edge_not_useful = [real_big_edge_x_not_useful;real_big_edge_y_not_useful];
    real_big_edge_overlap_or_ghost = [real_big_edge_x_overlap_or_ghost;real_big_edge_y_overlap_or_ghost];
end





