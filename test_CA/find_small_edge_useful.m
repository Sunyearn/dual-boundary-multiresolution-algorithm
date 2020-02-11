function [real_small_edge_boundary,real_small_edge_inside,real_small_edge_useful,real_small_edge_not_useful]=...
                        find_small_edge_useful(Nx_small,Ny_small,Nedge_small,Nedge_big,...
                                        left_pos_at_big,right_pos_at_big,forward_pos_at_big,backward_pos_at_big,ratio)
    ratio_x = ratio;
    ratio_y = ratio;
    sum_edge_big = sum(Nedge_big);
    
    edge_x_small_control = zeros(Nx_small,Ny_small+1);
    edge_y_small_control = zeros(Nx_small+1,Ny_small);
    %% X small 通过差异化的标志（flag）来划分棱边
%     % X initial inside 把小网格有效区域的所有的 x 向内部棱边 激活
%     edge_x_small_control(((left_pos_at_big-1)*ratio_x+1):(right_pos_at_big*ratio_x),...
%                            ((forward_pos_at_big-1)*ratio_y+1):(backward_pos_at_big*ratio_y+1)) = 10;
    % X initial inside 把小网格有效区域的所有的 x 向内部棱边 不激活
    edge_x_small_control(((left_pos_at_big-1)*ratio_x+1):(right_pos_at_big*ratio_x),...
                           ((forward_pos_at_big-1)*ratio_y+1+1):(backward_pos_at_big*ratio_y)) = 10;
    %% reshape and find index of edge x
    edge_x_small_control = reshape(edge_x_small_control,Nx_small*(Ny_small+1),1 );
    real_small_edge_x_boundary = find(edge_x_small_control == 1);
    real_small_edge_x_inside = find( edge_x_small_control == 10 );
    real_small_edge_x_useful = find( edge_x_small_control > 0 );
    real_small_edge_x_not_useful = find( edge_x_small_control == 0 );
    % adjust
    real_small_edge_x_boundary = real_small_edge_x_boundary + sum_edge_big;
    real_small_edge_x_inside = real_small_edge_x_inside + sum_edge_big;
    real_small_edge_x_useful = real_small_edge_x_useful + sum_edge_big;
    real_small_edge_x_not_useful = real_small_edge_x_not_useful + sum_edge_big;
    %% Y small
%     % Y initial inside 把小网格有效区域的所有的 y 向内部棱边 激活
%     edge_y_small_control( ((left_pos_at_big-1)*ratio_x+1):(right_pos_at_big*ratio_x+1),...
%                            ((forward_pos_at_big-1)*ratio_y+1):(backward_pos_at_big*ratio_y)) = 10;
    % Y initial inside 把小网格有效区域的所有的 y 向内部棱边 不激活
    edge_y_small_control( ((left_pos_at_big-1)*ratio_x+1+1):(right_pos_at_big*ratio_x),...
                           ((forward_pos_at_big-1)*ratio_y+1):(backward_pos_at_big*ratio_y)) = 10;
    %% reshape and find index of edge y
    edge_y_small_control = reshape(edge_y_small_control,(Nx_small+1)*Ny_small,1 );
    real_small_edge_y_boundary = find(edge_y_small_control == 1);
    real_small_edge_y_inside = find( edge_y_small_control == 10 );
    real_small_edge_y_useful = find( edge_y_small_control > 0 );
    real_small_edge_y_not_useful = find( edge_y_small_control == 0 );
    % adjust
    real_small_edge_y_boundary = real_small_edge_y_boundary + sum_edge_big + Nedge_small(1);
    real_small_edge_y_inside = real_small_edge_y_inside + sum_edge_big + Nedge_small(1);
    real_small_edge_y_useful = real_small_edge_y_useful + sum_edge_big + Nedge_small(1);
    real_small_edge_y_not_useful = real_small_edge_y_not_useful + sum_edge_big + Nedge_small(1);
    %% add up
    real_small_edge_boundary = [real_small_edge_x_boundary;real_small_edge_y_boundary];
    real_small_edge_inside = [real_small_edge_x_inside;real_small_edge_y_inside];
    real_small_edge_useful = [real_small_edge_x_useful;real_small_edge_y_useful];
    real_small_edge_not_useful = [real_small_edge_x_not_useful;real_small_edge_y_not_useful];
end








