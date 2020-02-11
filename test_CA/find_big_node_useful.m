function [real_big_node_boundary,...
          real_big_node_inside,...
          real_big_node_useful,...
          real_big_node_not_useful,...
          real_big_node_overlap_or_ghost]= ...
                                           find_big_node_useful(Nx_big,Ny_big,...
                                                  left_pos_at_big,right_pos_at_big,forward_pos_at_big,backward_pos_at_big)
%% initial control matrix
    node_big_control = zeros(Nx_big+1,Ny_big+1);
%% set inside node flag
% initial inside flag
    node_big_control(2:(end-1),2:(end-1)) = 10;
%% set useful not node flag
    % Coarse node activated on interface
    node_big_control((left_pos_at_big+1):(right_pos_at_big),(forward_pos_at_big+1):(backward_pos_at_big)) = 20;
%% truely overlapped or be ghosted
    node_big_control((left_pos_at_big):(right_pos_at_big+1),[(forward_pos_at_big),(backward_pos_at_big+1)]) = 1;
    node_big_control([(left_pos_at_big),(right_pos_at_big+1)],(forward_pos_at_big):(backward_pos_at_big+1)) = 1;
%% reshape and find the indexes
    node_big_control = reshape(node_big_control,(Nx_big+1)*(Ny_big+1),1);
    
    real_big_node_useful  = find(node_big_control < 20);
    real_big_node_overlap_or_ghost = find(node_big_control == 1);
    real_big_node_boundary  = find(node_big_control == 0);
    real_big_node_inside  = find(node_big_control >0 & node_big_control < 20);
    real_big_node_not_useful = find(node_big_control == 20);
end