function [Divergence_d,Divergence,...
          real_edge_boundary,real_edge_inside,real_edge_useful,real_edge_not_useful, ...
          real_node_boundary,real_node_inside,real_node_useful,real_node_not_useful] = ...
            make_divergence_operator(left_pos_at_big,right_pos_at_big,forward_pos_at_big,backward_pos_at_big,...
                                Dx_big,Dy_big,Dx_small,Dy_small,ratio)
% left_pos_at_big 大网格中与小网格重合区域的 最左侧 的网格位置（最左侧： x向的小号方向）
% right_pos_at_big 大网格中与小网格重合区域的 最右侧 的网格位置（左右侧： x向的大号方向）
% forward_pos_at_big 大网格中与小网格重合区域的 最前 的网格位置（最前： y向的小号方向）
% backward_pos_at_big 大网格中与小网格重合区域的最后 的网格位置（最后： y向的大号方向）
%% initial necessary parameters
    ratio_x = ratio;
    ratio_y = ratio;
% BIG
    Nx_big = length(Dx_big);
    Ny_big = length(Dy_big);
    % big edge num
    Nedge_x_big = Nx_big*(Ny_big+1);
    Nedge_y_big = (Nx_big+1)*Ny_big;
    Nedge_big = [Nedge_x_big,Nedge_y_big];
    sum_edge_big = sum(Nedge_big);
    % big node num
    Nnode_big = (Nx_big+1)*(Ny_big+1);
% SMALL
    Nx_small = length(Dx_small);
    Ny_small = length(Dy_small);
    % small edge num
    Nedge_x_small = Nx_small*(Ny_small + 1);
    Nedge_y_small = (Nx_small + 1)*Ny_small;
    Nedge_small = [Nedge_x_small,Nedge_y_small];
    sum_edge_small = sum(Nedge_small);
    % small node num
    Nnode_small = (Nx_small+1)*(Ny_small + 1);
%% Make initial Divergence topo
    [icol_big,irow_big,ivalue_big]=make_divergence_topo(Nx_big,Ny_big,Nedge_big,'N2E');
    [icol_small,irow_small,ivalue_small]=make_divergence_topo(Nx_small,Ny_small,Nedge_small,'N2E');
    irow_small = irow_small + Nnode_big;
    icol_small = icol_small + sum_edge_big;
%% FIND index overlap nodes
    [node_overlap] = find_overlap_node(Nnode_big,Nx_big,Ny_big,...
        Nnode_small,Nx_small,Ny_small,...
        left_pos_at_big,right_pos_at_big,forward_pos_at_big,backward_pos_at_big,ratio);
%% FIND index overlap edges
    [edge_Xx_overlap,edge_Yy_overlap,edge_Xxx_overlap,edge_Yyy_overlap] =...
                                      find_overlap_edge(Nedge_big,Nx_big,Ny_big,...
                                                        Nedge_small,Nx_small,Ny_small,...
                                left_pos_at_big,right_pos_at_big,forward_pos_at_big,backward_pos_at_big,ratio);
%% FIND index ghost edges
    [index_edge_x_ghost_y,...
          index_edge_y_ghost_x] =...
                            find_ghost_edge_2big( Nedge_big,Nx_big,Ny_big,...
                                            Nedge_small,Nx_small,Ny_small,...
                                          left_pos_at_big,right_pos_at_big,forward_pos_at_big,backward_pos_at_big,ratio);
%     [index_edge_x_ghost_yz,index_edge_y_ghost_xz] =...
%                             find_ghost_edge_4big( Nedge_big,Nx_big,Ny_big,Nz_big,...
%                                             Nedge_small,Nx_small,Ny_small,Nz_small,...
%                                           left_pos_at_big,right_pos_at_big,forward_pos_at_big,backward_pos_at_big,ratio);
%% Give coors to every edges
    [coor_edge_X_big,coor_edge_Y_big] = coor_edges(Dx_big,Dy_big);
    [coor_edge_X_small,coor_edge_Y_small] = coor_edges(Dx_small,Dy_small);
    coor_edge_all = [coor_edge_X_big;coor_edge_Y_big;coor_edge_X_small;coor_edge_Y_small];
%% Give the ghost edge topo value
    [real_edge_xY_ghost_topo] = give_ghost_edge_topo(index_edge_x_ghost_y,coor_edge_all,'xY');
%     [real_edge_xZ_ghost_topo] = give_ghost_edge_topo(index_edge_x_ghost_z,coor_edge_all,'xZ');
    
    [real_edge_yX_ghost_topo] = give_ghost_edge_topo(index_edge_y_ghost_x,coor_edge_all,'yX');
%     [real_edge_yZ_ghost_topo] = give_ghost_edge_topo(index_edge_y_ghost_z,coor_edge_all,'yZ');
%     
%     [real_edge_xYZ_ghost_topo] = give_ghost_edge_topo(index_edge_x_ghost_yz,coor_edge_all,'xYZ');
%     [real_edge_yXZ_ghost_topo] = give_ghost_edge_topo(index_edge_y_ghost_xz,coor_edge_all,'yXZ');
%% Make divergence's denominator
    [div_x_big,div_y_big] = make_divergence_denominator(Dx_big,Dy_big);
    [div_x_small,div_y_small] = make_divergence_denominator(Dx_small,Dy_small);
    div_x = [div_x_big;div_x_small];
    div_y = [div_y_big;div_y_small];
%% Find index to delete or keep
    % find inside and boundary edge index
    [real_edge_boundary,real_edge_inside,real_edge_useful,real_edge_not_useful] = find_inside_and_boundary_edge_index(...
                                Nx_big,Ny_big,Nedge_big,...
                                Nx_small,Ny_small,Nedge_small,...
                                left_pos_at_big,right_pos_at_big,forward_pos_at_big,backward_pos_at_big,ratio);
    [real_node_boundary,real_node_inside,real_node_useful,real_node_not_useful] = find_inside_and_boundary_node_index(...
                                Nx_big,Ny_big,Nnode_big,...
                                Nx_small,Ny_small,Nnode_small,...
                                left_pos_at_big,right_pos_at_big,forward_pos_at_big,backward_pos_at_big,ratio);
%% Construct the real divergence operator
% Initial the Divergence
    Divergence = sparse([irow_big;irow_small],[icol_big;icol_small],[ivalue_big;ivalue_small],...
                                                            (Nnode_big+Nnode_small),(sum_edge_big+sum_edge_small) );
% Change overlap edge
    Divergence(:,edge_Xx_overlap(:,1)) = Divergence(:,edge_Xx_overlap(:,1)) + Divergence(:,edge_Xx_overlap(:,2));
    Divergence(:,edge_Yy_overlap(:,1)) = Divergence(:,edge_Yy_overlap(:,1)) + Divergence(:,edge_Yy_overlap(:,2));
    
    Divergence(:,edge_Xxx_overlap(:,1)) = Divergence(:,edge_Xxx_overlap(:,1)) + Divergence(:,edge_Xxx_overlap(:,2));
    Divergence(:,edge_Xxx_overlap(:,1)) = Divergence(:,edge_Xxx_overlap(:,1)) + Divergence(:,edge_Xxx_overlap(:,3));
    
    Divergence(:,edge_Yyy_overlap(:,1)) = Divergence(:,edge_Yyy_overlap(:,1)) + Divergence(:,edge_Yyy_overlap(:,2));
    Divergence(:,edge_Yyy_overlap(:,1)) = Divergence(:,edge_Yyy_overlap(:,1)) + Divergence(:,edge_Yyy_overlap(:,3));
    
    Divergence(:,edge_Xx_overlap(:,2)) = 0;
    Divergence(:,edge_Yy_overlap(:,2)) = 0;
    Divergence(:,edge_Xxx_overlap(:,2)) = 0;
    Divergence(:,edge_Xxx_overlap(:,3)) = 0;
    Divergence(:,edge_Yyy_overlap(:,2)) = 0;
    Divergence(:,edge_Yyy_overlap(:,3)) = 0;
% Change ghost edge
%     index_edge_x_ghost_y; index_edge_x_ghost_z;
%     index_edge_y_ghost_x; index_edge_y_ghost_z;
%     index_edge_x_ghost_yz; index_edge_y_ghost_xz;
%     real_edge_xY_ghost_topo;
%     real_edge_xZ_ghost_topo;
%     
%     real_edge_yX_ghost_topo;
%     real_edge_yZ_ghost_topo;
%     
%     real_edge_xYZ_ghost_topo;
%     real_edge_yXZ_ghost_topo;
    % xY
    for ii = 1:2
        big_temp = index_edge_x_ghost_y(:,ii+1);
        [value_big_temp,index_big_temp] = sort(big_temp); 
        reshape_big_index = reshape(index_big_temp,(ratio_y-1),length(index_big_temp)/(ratio_y-1)); % gai
        reshape_big_value = reshape(value_big_temp,(ratio_y-1),length(value_big_temp)/(ratio_y-1));
        for iy = 1:(ratio_y-1)
            real_x_edge_ghost_big_a = (reshape_big_value(iy,:))';
            real_x_edge_ghost_small_a = index_edge_x_ghost_y((reshape_big_index(iy,:))',1);
            real_x_edge_ghost_topo_big_a = real_edge_xY_ghost_topo((reshape_big_index(iy,:))',ii+1);
            N_temp  = length(real_x_edge_ghost_big_a);
            
            Divergence(:,real_x_edge_ghost_big_a) = Divergence(:,real_x_edge_ghost_big_a) + ...
                                                    Divergence(:,real_x_edge_ghost_small_a) * ...
                                                    spdiags(real_x_edge_ghost_topo_big_a,0,N_temp,N_temp)/2;
        end
    end
    Divergence(:,index_edge_x_ghost_y(:,1)) = 0;
    % yX
    for ii = 1:2
        big_temp = index_edge_y_ghost_x(:,ii+1);
        [value_big_temp,index_big_temp] = sort(big_temp); 
        reshape_big_index = reshape(index_big_temp,(ratio_x-1),length(index_big_temp)/(ratio_x-1)); % gai
        reshape_big_value = reshape(value_big_temp,(ratio_x-1),length(value_big_temp)/(ratio_x-1));
        for ix = 1:(ratio_x-1)
            real_y_edge_ghost_big_a = (reshape_big_value(ix,:))';
            real_y_edge_ghost_small_a = index_edge_y_ghost_x((reshape_big_index(ix,:))',1);
            real_y_edge_ghost_topo_big_a = real_edge_yX_ghost_topo((reshape_big_index(ix,:))',ii+1);
            N_temp  = length(real_y_edge_ghost_big_a);
            
            Divergence(:,real_y_edge_ghost_big_a) = Divergence(:,real_y_edge_ghost_big_a) + ...
                                                    Divergence(:,real_y_edge_ghost_small_a) * ...
                                                    spdiags(real_y_edge_ghost_topo_big_a,0,N_temp,N_temp)/2;
        end
    end
    Divergence(:,index_edge_y_ghost_x(:,1)) = 0;
% Setup some unnecessary columns and rows to zeros
    Divergence(:,real_edge_not_useful) = 0;
    Divergence(real_node_not_useful,:) = 0;
% Make catalogue of the Divergence operator
    index_big_node = 1:Nnode_big;
    index_small_node = (Nnode_big + 1):(Nnode_big + Nnode_small);
    
    index_big_edge_x = 1 : Nedge_big(1);
    index_big_edge_y = (Nedge_big(1) + 1) : (Nedge_big(1) + Nedge_big(2) );
    index_big_edge_z = (Nedge_big(1) + Nedge_big(2) + 1) : sum_edge_big;
    
    index_small_edge_x = (sum_edge_big + 1) : (sum_edge_big + Nedge_small(1) );
    index_small_edge_y = (sum_edge_big + Nedge_small(1) + 1) : (sum_edge_big + Nedge_small(1) + Nedge_small(2) );
    index_small_edge_z = (sum_edge_big + Nedge_small(1) + Nedge_small(2) + 1) : (sum_edge_big + sum_edge_small);
% Construct (Divergence topo)/denominator
    Divergence_d = Divergence;
    % node big - edge x
    Divergence_d(index_big_node,index_big_edge_x) = spdiags(1./div_x_big,0,length(div_x_big),length(div_x_big)) * ...
                                                    Divergence_d(index_big_node,index_big_edge_x);
    % node big - edge y
    Divergence_d(index_big_node,index_big_edge_y) = spdiags(1./div_y_big,0,length(div_y_big),length(div_y_big)) * ...
                                                    Divergence_d(index_big_node,index_big_edge_y);
    % node small - edge x
    Divergence_d(index_small_node,[index_big_edge_x,index_small_edge_x]) = ...
                                spdiags(1./div_x_small,0,length(div_x_small),length(div_x_small)) * ...
                                                    Divergence_d(index_small_node,[index_big_edge_x,index_small_edge_x]);
    % node small - edge y
    Divergence_d(index_small_node,[index_big_edge_y,index_small_edge_y]) = ...
                                spdiags(1./div_y_small,0,length(div_y_small),length(div_y_small)) * ...
                                                    Divergence_d(index_small_node,[index_big_edge_y,index_small_edge_y]);
end























