% main function
function test_cheva()
% fine
nx = 16;
ny = 16;
step_x = 50;
step_y = 100;
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

%% Gt
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
G = spdiags(1./Lledge,0,Ne+ne,Ne+ne) * Gt;   % Ã›∂»º∆À„
%% Div
Divt = Gt';

[Div_x,Div_y] = make_divergence_denominator(Dx,Dy);
[div_x,div_y] = make_divergence_denominator(dx,dy);
divide_Divt = Divt;

    index_big_edge_x = 1 : Nedge(1);
    index_big_edge_y = (Nedge(1) + 1) : Ne;

    index_small_edge_x = Ne + 1 : Ne + nedge(1);
    index_small_edge_y = Ne + (nedge(1) + 1) : Ne + ne;
    
% % node big - edge x
%     Divergence(index_big_node,index_big_edge_x) = spdiags(1./div_x_big,0,length(div_x_big),length(div_x_big)) * ...
%                                                     Divergence(index_big_node,index_big_edge_x);
%     % node big - edge y
%     Divergence(index_big_node,index_big_edge_y) = spdiags(1./div_y_big,0,length(div_y_big),length(div_y_big)) * ...
%                                                     Divergence(index_big_node,index_big_edge_y);
%     % node big - edge z
%     Divergence(index_big_node,index_big_edge_z) = spdiags(1./div_z_big,0,length(div_z_big),length(div_z_big)) * ...
%                                                     Divergence(index_big_node,index_big_edge_z);
divide_Divt(1:Nnode,index_big_edge_x) = spdiags(1./Div_x,0,length(Div_x),length(Div_x)) *...
                                                                divide_Divt(1:Nnode,index_big_edge_x);
divide_Divt(1:Nnode,index_big_edge_y) = spdiags(1./Div_y,0,length(Div_y),length(Div_y)) *...
                                                                divide_Divt(1:Nnode,index_big_edge_y);
divide_Divt(Nnode+1:end,index_small_edge_x) = spdiags(1./div_x,0,length(div_x),length(div_x)) *...
                                                                divide_Divt(Nnode+1:end,index_small_edge_x);
divide_Divt(Nnode+1:end,index_small_edge_y) = spdiags(1./div_y,0,length(div_y),length(div_y)) *...
                                                                divide_Divt(Nnode+1:end,index_small_edge_y);
DivG = divide_Divt * G;

% set initial phi
initial_phi_big = rand(Nx+1,Ny+1);
initial_phi_small = zeros(nx+1,ny+1);
    % find the overlapped nodes 
index = find_overlapped(Nx,Ny,nx,ny,'NODE');
% 
initial_phi_small(index) = initial_phi_big;
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

given0 = zeros(size(index_ni,1),1);
rhs = given0 - DivG(index_ni,index_nb) * initial_phi(index_nb);

real_phi_inside = DivG(index_ni,index_ni)\rhs;

phi = initial_phi;
phi(index_ni) = real_phi_inside;
phi_big = reshape(phi(1:Nnode),Nx+1,Ny+1);
phi_small = reshape(phi(Nnode+1:end),nx+1,ny+1);

plotfield2d(phi_big,[0 0],Dx,Dy);
plotfield2d(phi_small,[0 0],dx,dy);
end











