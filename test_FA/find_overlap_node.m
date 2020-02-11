function [node_overlap] = find_overlap_node(Nnode_big,Nx_big,Ny_big,...
        Nnode_small,Nx_small,Ny_small,...
        left_pos_at_big,right_pos_at_big,forward_pos_at_big,backward_pos_at_big,ratio)
%% initial parameter
    ratio_x = ratio;
    ratio_y = ratio;
    
%     node_big = 1:Nnode_big;
%     node_big = reshape(node_big,Nx_big+1,Ny_big+1,Nz_big+1);
%     node_small = (Nnode_big+1):(Nnode_big+Nnode_small);
%     node_small = reshape(node_small,Nx_small+1,Ny_small+1,Nz_small+1);
%% index of nodes overlaped
%     temp_node_in_bmesh = node_big(left_pos_at_big:(right_pos_at_big+1),forward_pos_at_big:(backward_pos_at_big+1),:);
%     temp_node_in_smesh = node_small( ((left_pos_at_big-1)*ratio_x+1):ratio_x:(right_pos_at_big*ratio_x+1),...
%                         ((forward_pos_at_big-1)*ratio_y+1):ratio_y:(backward_pos_at_big*ratio_y+1),1:ratio_z:end );
    control_big = zeros(Nx_big+1,Ny_big+1);
    control_small = zeros(Nx_small+1,Ny_small+1);
    
    control_big([left_pos_at_big,(right_pos_at_big+1)],forward_pos_at_big:(backward_pos_at_big+1),:) = 1;
    control_big(left_pos_at_big:(right_pos_at_big+1),[forward_pos_at_big,(backward_pos_at_big+1)],:) = 1;
    
    control_small( [((left_pos_at_big-1)*ratio_x+1),(right_pos_at_big*ratio_x+1)],...
                        ((forward_pos_at_big-1)*ratio_y+1):ratio_y:(backward_pos_at_big*ratio_y+1)) = 1;
    control_small( ((left_pos_at_big-1)*ratio_x+1):ratio_x:(right_pos_at_big*ratio_x+1),...
                        [((forward_pos_at_big-1)*ratio_y+1),(backward_pos_at_big*ratio_y+1)]) = 1;
%% construct index
    index_overlap_node_bmesh = find(control_big == 1);
    index_overlap_node_smesh = find(control_small == 1);
    node_overlap = [index_overlap_node_bmesh , (index_overlap_node_smesh + Nnode_big)];
end