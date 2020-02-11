function [real_small_node_boundary,real_small_node_inside,real_small_node_useful,real_small_node_not_useful]= ...
                              find_small_node_useful(Nx_small,Ny_small,Nnode_big,...
                                     left_pos_at_big,right_pos_at_big,forward_pos_at_big,backward_pos_at_big,ratio)
%% initial control matrix and parameter
    node_small_control = zeros(Nx_small+1,Ny_small+1);
    ratio_x = ratio;
    ratio_y = ratio;
%% set boundary
%% set inside
    node_small_control( 2:end-1,2:end-1 ) = 10;
%% set not useful
% % fine nodes on interface not activated
    node_small_control( ((left_pos_at_big-1)*ratio_x+1):(right_pos_at_big*ratio_x+1),...
                            ((forward_pos_at_big-1)*ratio_y+1):(backward_pos_at_big*ratio_y+1) ) = 20;
% % % fine nodes on interface activated
%     node_small_control( ((left_pos_at_big-1)*ratio_x+1+1):(right_pos_at_big*ratio_x),...
%                             ((forward_pos_at_big-1)*ratio_y+1+1):(backward_pos_at_big*ratio_y) ) = 10;
%% reshape and find the indexes
    node_small_control = reshape(node_small_control,(Nx_small+1)*(Ny_small+1),1);
    
    real_small_node_not_useful  = find(node_small_control == 20);
    real_small_node_boundary  = find(node_small_control == 0);
    real_small_node_inside  = find(node_small_control == 10);
    real_small_node_useful = find(node_small_control < 20);
%% adjust
    real_small_node_not_useful  = real_small_node_not_useful + Nnode_big;
    real_small_node_boundary  = real_small_node_boundary + Nnode_big;
    real_small_node_inside  = real_small_node_inside + Nnode_big;
    real_small_node_useful = real_small_node_useful + Nnode_big;
end