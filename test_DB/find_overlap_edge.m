function [edge_Xx_overlap,edge_Yy_overlap,edge_Xxx_overlap,edge_Yyy_overlap] =...
                                                find_overlap_edge(Nedge_big,Nx_big,Ny_big,...
                                                                  Nedge_small,Nx_small,Ny_small,...
                                        left_pos_at_big,right_pos_at_big,forward_pos_at_big,backward_pos_at_big,ratio)
%% initial parameter
    ratio_x = ratio;
    ratio_y = ratio;
    sum_edge_big = sum(Nedge_big);
%     node_big = 1:Nnode_big;
%     node_big = reshape(node_big,Nx_big+1,Ny_big+1,Nz_big+1);
%     node_small = (Nnode_big+1):(Nnode_big+Nnode_small);
%     node_small = reshape(node_small,Nx_small+1,Ny_small+1,Nz_small+1);
%% index of 1 small edge x overlaped
%     temp_node_in_bmesh = node_big(left_pos_at_big:(right_pos_at_big+1),forward_pos_at_big:(backward_pos_at_big+1),:);
%     temp_node_in_smesh = node_small( ((left_pos_at_big-1)*ratio_x+1):ratio_x:(right_pos_at_big*ratio_x+1),...
%                         ((forward_pos_at_big-1)*ratio_y+1):ratio_y:(backward_pos_at_big*ratio_y+1),1:ratio_z:end );
    control_big_edge_x = zeros(Nx_big,Ny_big+1);
    control_small_edge_x = zeros(Nx_small,Ny_small+1);
    
    control_big_edge_x([(left_pos_at_big-1),(right_pos_at_big+1)],forward_pos_at_big:(backward_pos_at_big+1)) = 1;
    control_small_edge_x( [(left_pos_at_big-1)*ratio_x,(right_pos_at_big*ratio_x+1)],...
                        ((forward_pos_at_big-1)*ratio_y+1):ratio_y:(backward_pos_at_big*ratio_y+1)) = 1;
% construct index edge x
    index_overlap_edge_x_bmesh = find(control_big_edge_x == 1);
    index_overlap_edge_x_smesh = find(control_small_edge_x == 1);
    edge_Xx_overlap = [index_overlap_edge_x_bmesh , (index_overlap_edge_x_smesh + sum_edge_big)];
%% index 1 small edge y overlaped
%     temp_node_in_bmesh = node_big(left_pos_at_big:(right_pos_at_big+1),forward_pos_at_big:(backward_pos_at_big+1),:);
%     temp_node_in_smesh = node_small( ((left_pos_at_big-1)*ratio_x+1):ratio_x:(right_pos_at_big*ratio_x+1),...
%                         ((forward_pos_at_big-1)*ratio_y+1):ratio_y:(backward_pos_at_big*ratio_y+1),1:ratio_z:end );
    control_big_edge_y = zeros(Nx_big+1,Ny_big);
    control_small_edge_y = zeros(Nx_small+1,Ny_small);
    
    control_big_edge_y(left_pos_at_big:(right_pos_at_big+1),[(forward_pos_at_big-1),(backward_pos_at_big+1)]) = 1;
    control_small_edge_y( ((left_pos_at_big-1)*ratio_x+1):ratio_x:(right_pos_at_big*ratio_x+1),...
                        [(forward_pos_at_big-1)*ratio_y,(backward_pos_at_big*ratio_y+1)]) = 1;
% construct index edge y
    index_overlap_edge_y_bmesh = find(control_big_edge_y == 1);
    index_overlap_edge_y_smesh = find(control_small_edge_y == 1);
    edge_Yy_overlap =[(index_overlap_edge_y_bmesh + Nedge_big(1) ),(index_overlap_edge_y_smesh +sum_edge_big +Nedge_small(1) )];
%% index of 2 small edges x overlaped
%     temp_node_in_bmesh = node_big(left_pos_at_big:(right_pos_at_big+1),forward_pos_at_big:(backward_pos_at_big+1),:);
%     temp_node_in_smesh = node_small( ((left_pos_at_big-1)*ratio_x+1):ratio_x:(right_pos_at_big*ratio_x+1),...
%                         ((forward_pos_at_big-1)*ratio_y+1):ratio_y:(backward_pos_at_big*ratio_y+1),1:ratio_z:end );
    control_big_edge_x = zeros(Nx_big,Ny_big+1);
    control_small_edge_x = zeros(Nx_small,Ny_small+1);
    
    control_big_edge_x( left_pos_at_big:right_pos_at_big,[forward_pos_at_big,(backward_pos_at_big+1)] ) = 1;
    for i_ratio = 1: ratio_x
        control_small_edge_x( ((left_pos_at_big-1)*ratio_x+ i_ratio):ratio_x:((right_pos_at_big-1)*ratio_x+ i_ratio),...
                        [((forward_pos_at_big-1)*ratio_y+1),(backward_pos_at_big*ratio_y+1)] ) = i_ratio;
    end
    index_overlap_edge_x_bmesh = find(control_big_edge_x == 1);
    for i_ratio = 1 : ratio_x
        temp_index = find(control_small_edge_x == i_ratio);
        temp_index = temp_index + sum_edge_big;
        if i_ratio == 1
            edge_Xxx_overlap = temp_index;
        else
            edge_Xxx_overlap = [edge_Xxx_overlap,temp_index];
        end
    end
% construct index edge x
    edge_Xxx_overlap = [index_overlap_edge_x_bmesh , edge_Xxx_overlap];
%% index 2 small edges y overlaped
%     temp_node_in_bmesh = node_big(left_pos_at_big:(right_pos_at_big+1),forward_pos_at_big:(backward_pos_at_big+1),:);
%     temp_node_in_smesh = node_small( ((left_pos_at_big-1)*ratio_x+1):ratio_x:(right_pos_at_big*ratio_x+1),...
%                         ((forward_pos_at_big-1)*ratio_y+1):ratio_y:(backward_pos_at_big*ratio_y+1),1:ratio_z:end );
    control_big_edge_y = zeros(Nx_big+1,Ny_big);
    control_small_edge_y = zeros(Nx_small+1,Ny_small);
    
    control_big_edge_y([left_pos_at_big,(right_pos_at_big+1)],forward_pos_at_big:backward_pos_at_big ) = 1;
    for i_ratio = 1 : ratio_y
        control_small_edge_y( [((left_pos_at_big-1)*ratio_x+1),(right_pos_at_big*ratio_x+1)],...
                ((forward_pos_at_big-1)*ratio_y + i_ratio):ratio_y:((backward_pos_at_big-1)*ratio_y + i_ratio) ) = i_ratio;
    end
    index_overlap_edge_y_bmesh = find(control_big_edge_y == 1);
    index_overlap_edge_y_bmesh = index_overlap_edge_y_bmesh + Nedge_big(1);
    for i_ratio = 1 : ratio_y
        temp_index = find(control_small_edge_y == i_ratio);
        temp_index = temp_index + sum_edge_big + Nedge_small(1);
        if i_ratio == 1
            edge_Yyy_overlap = temp_index;
        else
            edge_Yyy_overlap = [edge_Yyy_overlap,temp_index];
        end
    end
% construct index edge x
    edge_Yyy_overlap = [index_overlap_edge_y_bmesh , edge_Yyy_overlap];
end








