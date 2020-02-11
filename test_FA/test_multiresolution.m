% main function
function test_multiresolution()
% fine
nx = 32;
ny = 32;
step_x = 50;
step_y = 50;
nedgex = nx*(ny+1);
nedgey = (nx+1)*ny;
nedge = [nedgex,nedgey];
ne = sum(nedge);
nnode = (nx+1)*(ny+1);
sum_fine_edge = sum(nedge);
dx = step_x * ones(nx,1);
dy = step_y * ones(ny,1);
% coarse
Nx = nx/2;
Ny = ny/2;
Nedgex = Nx*(Ny+1);
Nedgey = (Nx+1)*Ny;
Nedge = [Nedgex,Nedgey];
Ne = sum(Nedge);
Nnode = (Nx+1)*(Ny+1);
sum_coarse_edge = sum(Nedge);
Dx = step_x *2* ones(Nx,1);
Dy = step_y *2* ones(Ny,1);
%
ratio = 2;
left_pos_at_big = 4;
right_pos_at_big = Nx - (left_pos_at_big-1);
forward_pos_at_big = 4;
backward_pos_at_big = Ny - (forward_pos_at_big-1);


%% Gt
[Divergence,G,...
    real_node_boundary,real_node_inside,real_node_useful,real_node_not_useful,...
    real_edge_boundary,real_edge_inside,real_edge_useful,real_edge_not_useful,...
    real_overlap_node,real_ghostx_node,real_ghosty_node,real_ghostc_node,...
    real_ghostx_node_topo,real_ghosty_node_topo,real_ghostc_node_topo] =...
    make_gradient_operator(left_pos_at_big,right_pos_at_big,...
                           forward_pos_at_big,backward_pos_at_big,...
                           Dx,Dy,dx,dy,ratio);

DivG_mr = Divergence* G;

% set initial phi
%%
% initial_phi_big = rand(Nx+1,Ny+1)-0.5;
% 如果使用在0附近高斯分布的作为数据，那么局部计算得到的最大误差将是惊人的，这也提醒我们当信号的幅值足够小时，
% 即便没有其他噪音，但计算出来的误差也很大。因为使用一个绝对值极小的数参与离散模型的计算是相当危险的。
% initial_phi_big = rand(Nx+1,Ny+1);
%%
initial_phi_big = load('initial_phi_big.mat');
initial_phi_big = initial_phi_big.initial_phi_big;
initial_phi_small = zeros(nx+1,ny+1);
% find the index of overlapped nodes 
[index_overlap_node,index_skip_node] = find_overlapped(Nx,Ny,nx,ny,'NODE');
% 
initial_phi_small(index_overlap_node) = initial_phi_big;
initial_phi_small(2:2:end-1,:) = ( initial_phi_small(1:2:end-2,:) + initial_phi_small(3:2:end,:) )/2;
initial_phi_small(:,2:2:end-1) = ( initial_phi_small(:,1:2:end-2) + initial_phi_small(:,3:2:end) )/2;
% initial_phi = 150 * rand(size(DivG,1),1) - 50;
initial_phi = [reshape(initial_phi_big,numel(initial_phi_big),1);
               reshape(initial_phi_small,numel(initial_phi_small),1)];

% find the boundary index
[idNb,idNi]=get_bdidx2d(Nx,Ny,'NODE');
[idnb,idni]=get_bdidx2d(nx,ny,'NODE');

index_nb = [idNb;idnb+Nnode];
index_ni = [idNi;idni+Nnode];

%% mr
% index_nb_mr = intersect(index_nb,real_node_useful);
% index_ni_mr = intersect(index_ni,real_node_useful);
index_nb_mr = real_node_boundary;
index_ni_mr = real_node_inside;

GIVE = zeros(Nnode+nnode,1);
% GIVE((Nx+1)*Ny/2+Nx/2+1,1) = 0.01;
% GIVE(Nnode+(nx+1)*ny/2+nx/2+1,1) = 0.01;

% given0_mr = zeros(size(index_ni_mr,1),1);
given0_mr = GIVE(index_ni_mr);

rhs_mr = given0_mr - DivG_mr(index_ni_mr,index_nb_mr) * initial_phi(index_nb_mr);
real_phi_inside_mr = DivG_mr(index_ni_mr,index_ni_mr)\rhs_mr;

%% pure fine mesh and coarse mesh solution
[irowx_fine,irowy_fine,icolx_fine,icoly_fine,valuex_fine,valuey_fine] =...
                                                mk_grad_topo(nx,ny,nedge,'N2E');

[irowx_coarse,irowy_coarse,icolx_coarse,icoly_coarse,valuex_coarse,valuey_coarse] =...
                                                mk_grad_topo(Nx,Ny,Nedge,'N2E');
irow = [irowx_coarse;irowy_coarse;...
        irowx_fine + sum_coarse_edge;irowy_fine + sum_coarse_edge];
icol = [icolx_coarse;icoly_coarse;...
        icolx_fine + Nnode;icoly_fine + Nnode];
value = [valuex_coarse;valuey_coarse;valuex_fine;valuey_fine];
Gt = sparse(irow,icol,value,sum_fine_edge+sum_coarse_edge,nnode+Nnode);

Ledge=cal_edgelength(Dx,Dy,'EDGE');
ledge=cal_edgelength(dx,dy,'EDGE');
Lledge = [Ledge;ledge];
G1 = spdiags(1./Lledge,0,Ne+ne,Ne+ne) * Gt;   % 梯度计算

Divt = Gt';
[Div_x,Div_y] = make_divergence_denominator(Dx,Dy);
[div_x,div_y] = make_divergence_denominator(dx,dy);
divide_Divt = Divt;
    index_big_edge_x = 1 : Nedge(1);
    index_big_edge_y = (Nedge(1) + 1) : Ne;

    index_small_edge_x = Ne + 1 : Ne + nedge(1);
    index_small_edge_y = Ne + (nedge(1) + 1) : Ne + ne;
divide_Divt(1:Nnode,index_big_edge_x) = spdiags(1./Div_x,0,length(Div_x),length(Div_x)) *...
                                                                divide_Divt(1:Nnode,index_big_edge_x);
divide_Divt(1:Nnode,index_big_edge_y) = spdiags(1./Div_y,0,length(Div_y),length(Div_y)) *...
                                                                divide_Divt(1:Nnode,index_big_edge_y);
divide_Divt(Nnode+1:end,index_small_edge_x) = spdiags(1./div_x,0,length(div_x),length(div_x)) *...
                                                                divide_Divt(Nnode+1:end,index_small_edge_x);
divide_Divt(Nnode+1:end,index_small_edge_y) = spdiags(1./div_y,0,length(div_y),length(div_y)) *...
                                                                divide_Divt(Nnode+1:end,index_small_edge_y);

DivG = divide_Divt * G1;
% given01 = zeros(size(index_ni,1),1);
given01 = GIVE(index_ni);
rhs1 = given01 - DivG(index_ni,index_nb) * initial_phi(index_nb);
real_phi_inside1 = DivG(index_ni,index_ni)\rhs1;
phi1 = initial_phi;
phi1(index_ni) = real_phi_inside1;
%%

phi_big = reshape(phi1(1:Nnode),Nx+1,Ny+1);
phi_small = reshape(phi1(Nnode+1:end),nx+1,ny+1);
plotfield2d(phi_big,[0 0],Dx,Dy);
plotfield2d(phi_small,[0 0],dx,dy);

phi_mr = phi1;
phi_mr(index_ni_mr) = real_phi_inside_mr;
phi_big_mr = reshape(phi_mr(1:Nnode),Nx+1,Ny+1);
phi_small_mr = reshape(phi_mr(Nnode+1:end),nx+1,ny+1);
plotfield2d(phi_big_mr,[0 0],Dx,Dy);
plotfield2d(phi_small_mr,[0 0],dx,dy);

small_fine_minus_mr = abs((phi_small-phi_small_mr)./phi_small)*100;
big_fine_minus_mr = abs((phi_big-phi_big_mr)./phi_big)*100;
plotfield2d(big_fine_minus_mr,[0 0],Dx,Dy);
plotfield2d(small_fine_minus_mr,[0 0],dx,dy);
end











