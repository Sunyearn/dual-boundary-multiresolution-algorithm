function [real_small_node_boundary,...
          real_small_node_inside,...
          real_small_node_useful,...
          real_small_node_not_useful,...
          real_small_node_overlap_or_ghost,...
          real_small_node_replace_big_boundary]= ...
                              find_small_node_useful(Nx_small,Ny_small,Nnode_big,...
                                     left_pos_at_big,right_pos_at_big,forward_pos_at_big,backward_pos_at_big,ratio)
%% initial control matrix and parameter
    node_small_control = zeros(Nx_small+1,Ny_small+1);
    ratio_x = ratio;
    ratio_y = ratio;
%% set boundary
%% set inside
    node_small_control( 2:end-1,2:end-1 ) = 10;
%% set useful
% % fine nodes on interface not activated
    node_small_control( ((left_pos_at_big-1)*ratio_x+1+1):(right_pos_at_big*ratio_x),...
                            ((forward_pos_at_big-1)*ratio_y+1+1):(backward_pos_at_big*ratio_y) ) = 20;
%% set nodes being overlapped or ghosted
    node_small_control( [((left_pos_at_big-1)*ratio_x+1),(right_pos_at_big*ratio_x+1)],...
                            ((forward_pos_at_big-1)*ratio_y+1):(backward_pos_at_big*ratio_y+1) ) = 1;
    node_small_control( ((left_pos_at_big-1)*ratio_x+1):(right_pos_at_big*ratio_x+1),...
                            [((forward_pos_at_big-1)*ratio_y+1),(backward_pos_at_big*ratio_y+1)] ) = 1;
%% set nodes in small grid to replace the boundary nodes in big grid
    node_small_control( [1,end],1:ratio_y:end ) = 2;
    node_small_control( 1:ratio_x:end,[1,end] ) = 2;
%% reshape and find the indexes
    node_small_control = reshape(node_small_control,(Nx_small+1)*(Ny_small+1),1);
    
    real_small_node_not_useful  = find(node_small_control < 20);
    real_small_node_boundary  = find(node_small_control < 0);
    real_small_node_inside  = find(node_small_control == 20);
    real_small_node_useful = find(node_small_control == 20);
    real_small_node_overlap_or_ghost = find(node_small_control == 1);
    real_small_node_replace_big_boundary  = find(node_small_control == 2 );% 用于替换粗网格的边界值
%% adjust
    real_small_node_not_useful  = real_small_node_not_useful + Nnode_big;
    real_small_node_boundary  = real_small_node_boundary + Nnode_big;
    real_small_node_inside  = real_small_node_inside + Nnode_big;
    real_small_node_useful = real_small_node_useful + Nnode_big;
    real_small_node_overlap_or_ghost = real_small_node_overlap_or_ghost + Nnode_big;
    real_small_node_replace_big_boundary = ...
                            real_small_node_replace_big_boundary + Nnode_big;
end