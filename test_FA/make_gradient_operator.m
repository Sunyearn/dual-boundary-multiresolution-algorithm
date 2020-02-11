function [Divergence,G,...
    real_node_boundary,real_node_inside,real_node_useful,real_node_not_useful,...
    real_edge_boundary,real_edge_inside,real_edge_useful,real_edge_not_useful,...
    real_overlap_node,real_ghostx_node,real_ghosty_node,real_ghostc_node,...
    real_ghostx_node_topo,real_ghosty_node_topo,real_ghostc_node_topo] =...
    make_gradient_operator(left_pos_at_big,right_pos_at_big,...
                           forward_pos_at_big,backward_pos_at_big,...
                           Dx,Dy,dx,dy,ratio)
%% Preparation
    ratio_x = ratio;
    ratio_y = ratio;
% BIG
    Nx = length(Dx);
    Ny = length(Dy);
    % big edge num
    Nedge_x = Nx*(Ny+1);
    Nedge_y = (Nx+1)*Ny;
    Nedge = [Nedge_x,Nedge_y];
    Ne = sum(Nedge);
    % big node num
    Nnode = (Nx+1)*(Ny+1);
% SMALL
    nx = length(dx);
    ny = length(dy);
    % small edge num
    nedge_x = nx*(ny + 1);
    nedge_y = (nx + 1)*ny;
    nedge = [nedge_x,nedge_y];
    ne = sum(nedge);
    % small node num
    nnode = (nx+1)*(ny + 1);
%% topo of gradient
[irowx_fine,irowy_fine,icolx_fine,icoly_fine,valuex_fine,valuey_fine] =...
                                                mk_grad_topo(nx,ny,nedge,'N2E');

[irowx_coarse,irowy_coarse,icolx_coarse,icoly_coarse,valuex_coarse,valuey_coarse] =...
                                                mk_grad_topo(Nx,Ny,Nedge,'N2E');
irow = [irowx_coarse;irowy_coarse;...
        irowx_fine + Ne;irowy_fine + Ne];
icol = [icolx_coarse;icoly_coarse;...
        icolx_fine + Nnode;icoly_fine + Nnode];
value = [valuex_coarse;valuey_coarse;valuex_fine;valuey_fine];
Gt = sparse(irow,icol,value,Ne+ne,Nnode+nnode);
% save divergence operator
Divergence_t = Gt';
%% overlap nodes
[overlap_node] = find_overlap_all(Nx,Ny,nx,ny,'NODE');% do not contain nodes on the boundary
[overlap_edge] = find_overlap_all(Nx,Ny,nx,ny,'EDGE');% do not contain nodes on the boundary
overlap_node(:,1) = overlap_node(:,1) + Nnode;
%% ghost nodes
[ghostx_node,ghosty_node,ghostc_node] = find_ghost_node2(Nx,Ny,nx,ny,'NODE'); % do not contain nodes on the boundary
ghostx_node(:,1) = ghostx_node(:,1) + Nnode;
ghosty_node(:,1) = ghosty_node(:,1) + Nnode;
ghostc_node(:,1) = ghostc_node(:,1) + Nnode;
%% find the useful nodes in big  mesh and small mesh
[real_node_boundary,real_node_inside,...
    real_node_useful,real_node_not_useful,...
    real_node_overlap_or_ghost,...
    real_small_node_replace_big_boundary] =find_useful_and_not_useful_node_index(...
                                            Nx,Ny,Nnode,...
                                            nx,ny,nnode,...
                                            left_pos_at_big,right_pos_at_big,forward_pos_at_big,backward_pos_at_big,ratio);
%% find the useful edges in big mesh and small mesh
[real_edge_boundary,...
    real_edge_inside,...
    real_edge_useful,...
    real_edge_not_useful,...
    real_edge_overlap_or_ghost] = find_inside_and_boundary_edge_index(...
                                Nx,Ny,Nedge,...
                                nx,ny,nedge,...
                                left_pos_at_big,right_pos_at_big,forward_pos_at_big,backward_pos_at_big,ratio);
% %% the index of nodes are overlapped and not useful(nodes belongs to small mesh)
% [~,index_overlap_and_not_useful,~]=intersect(overlap_node(:,1),real_node_overlap_ghost);
% %% the index of nodes are ghost and not useful(nodes belongs to small mesh)
% [~,index_ghostX_and_not_useful,~]=intersect(ghostx_node(:,1),real_node_overlap_ghost);
% [~,index_ghostY_and_not_useful,~]=intersect(ghosty_node(:,1),real_node_overlap_ghost);
% [~,index_ghostC_and_not_useful,~]=intersect(ghostc_node(:,1),real_node_overlap_ghost);

%% the index of nodes are overlapped and not useful(nodes belongs to small mesh)
[~,index_overlap_and_not_useful,~]=intersect(overlap_node(:,1),real_node_overlap_or_ghost.small);
%% the index of nodes are ghost and not useful(nodes belongs to small mesh)
[~,index_ghostX_and_not_useful,~]=intersect(ghostx_node(:,1),real_node_overlap_or_ghost.small);
[~,index_ghostY_and_not_useful,~]=intersect(ghosty_node(:,1),real_node_overlap_or_ghost.small);
[~,index_ghostC_and_not_useful,~]=intersect(ghostc_node(:,1),real_node_overlap_or_ghost.small);
%% pick out the real overlap and ghost nodes
% overlap
real_overlap_node = overlap_node(index_overlap_and_not_useful,:);
% ghost
real_ghostx_node = ghostx_node(index_ghostX_and_not_useful,:);
real_ghosty_node = ghosty_node(index_ghostY_and_not_useful,:);
real_ghostc_node = ghostc_node(index_ghostC_and_not_useful,:);
%% calculate the real topo value of ghost parts, according to the coordinates of nodes
% calculate the coordinates of every nodes
[coor_node_big] = coor_nodes(Dx,Dy);
[coor_node_small] = coor_nodes(dx,dy);
coor_node = [coor_node_big;coor_node_small];
% construct real topo of ghost parts
real_ghostx_node_topo = give_ghost_node_topo(real_ghostx_node,coor_node,'X');
real_ghosty_node_topo = give_ghost_node_topo(real_ghosty_node,coor_node,'Y');
real_ghostc_node_topo = give_ghost_node_topo(real_ghostc_node,coor_node,'C');
%% (dp/dx,dp/dy) initial G
Ledge=cal_edgelength(Dx,Dy,'EDGE');
ledge=cal_edgelength(dx,dy,'EDGE');
Lledge = [Ledge;ledge];
% initialize the gradient operator
initial_G = spdiags(1./Lledge,0,Ne+ne,Ne+ne) * Gt;   % Ã›∂»º∆À„
G = initial_G;
% G(:,real_overlap_node(:,2)) = G(:,real_overlap_node(:,2)) + G(:,real_overlap_node(:,1));
G(:,real_overlap_node(:,1)) = G(:,real_overlap_node(:,1)) + G(:,real_overlap_node(:,2));
% % replace the ghost nodes
% if ~isempty(real_ghostx_node)
%     G = replace_ghost_nodes(G,real_ghostx_node,real_ghostx_node_topo,'X');
% else
% end
% if ~isempty(real_ghosty_node)
%     G = replace_ghost_nodes(G,real_ghosty_node,real_ghosty_node_topo,'Y');
% else
% end
% if ~isempty(real_ghostc_node)
%     G = replace_ghost_nodes(G,real_ghostc_node,real_ghostc_node_topo,'C');
% else
% end
G(:,real_node_not_useful) = 0;
G(real_edge_not_useful,:) = 0;
%% make divergence dx,dy etc.
[Div_x,Div_y] = make_divergence_denominator(Dx,Dy);
[div_x,div_y] = make_divergence_denominator(dx,dy);

index_big_edge_x = 1 : Nedge(1);
index_big_edge_y = (Nedge(1) + 1) : Ne;
index_small_edge_x = Ne + 1 : Ne + nedge(1);
index_small_edge_y = Ne + (nedge(1) + 1) : Ne + ne;

Divergence = Divergence_t;
Divergence(1:Nnode,index_big_edge_x) =...
                spdiags(1./Div_x,0,length(Div_x),length(Div_x)) *...
                                  Divergence_t(1:Nnode,index_big_edge_x);
Divergence(1:Nnode,index_big_edge_y) =...
                spdiags(1./Div_y,0,length(Div_y),length(Div_y)) *...
                                  Divergence_t(1:Nnode,index_big_edge_y);
Divergence(Nnode+1:end,index_small_edge_x) =...
                spdiags(1./div_x,0,length(div_x),length(div_x)) *...
                                  Divergence_t(Nnode+1:end,index_small_edge_x);
Divergence(Nnode+1:end,index_small_edge_y) =...
                spdiags(1./div_y,0,length(div_y),length(div_y)) *...
                                  Divergence_t(Nnode+1:end,index_small_edge_y);
Divergence(real_overlap_node(:,1),:) = Divergence(real_overlap_node(:,1),:) +...
                                            Divergence(real_overlap_node(:,2),:);
% if ~isempty(real_ghostx_node)
%     Divergence = replace_ghost_nodes_in_div(...
%                         Divergence,real_ghostx_node,real_ghostx_node_topo,'X');
% else
% end
% if ~isempty(real_ghosty_node)
%     Divergence = replace_ghost_nodes_in_div(...
%                         Divergence,real_ghosty_node,real_ghosty_node_topo,'Y');
% else
% end
% if ~isempty(real_ghostc_node)
%     Divergence = replace_ghost_nodes_in_div(...
%                         Divergence,real_ghostc_node,real_ghostc_node_topo,'C');
% else
% end
Divergence(real_node_not_useful,:) = 0;
Divergence(:,real_edge_not_useful) = 0;
return
















