function [real_node_ghost_topo] = give_ghost_node_topo(real_node_ghost,coor_node,mode)
% xY: ghost edge x in y direction
% xZ: ghost edge x in z direction
% yX: ghost edge y in x direction
% yZ: ghost edge y in z direction
% xYZ: ghost edge x in y,z direction
% yXZ: ghost edge y in x,z direction

if isempty(real_node_ghost)
    real_node_ghost_topo = [];
else

real_node_ghost_topo = zeros(size(real_node_ghost));
real_node_ghost_topo(:,1) = real_node_ghost(:,1); % 第一列是小网格中的 ghost edge 在所有的edge排序中的序号

switch upper(mode)
    case 'X'
        divident3 = abs(coor_node(real_node_ghost(:,3),1) - coor_node(real_node_ghost(:,1),1) ) ;
        divident2 = abs(coor_node(real_node_ghost(:,2),1) - coor_node(real_node_ghost(:,1),1) ) ;
        divisor = abs(coor_node(real_node_ghost(:,2),1) - coor_node(real_node_ghost(:,3),1) ) ;
        real_node_ghost_topo(:,2) = divident3./divisor;
        real_node_ghost_topo(:,3) = divident2./divisor;
    case 'Y'
        divident3 = abs(coor_node(real_node_ghost(:,3),2) - coor_node(real_node_ghost(:,1),2) ) ;
        divident2 = abs(coor_node(real_node_ghost(:,2),2) - coor_node(real_node_ghost(:,1),2) ) ;
        divisor = abs(coor_node(real_node_ghost(:,2),2) - coor_node(real_node_ghost(:,3),2) ) ;
        real_node_ghost_topo(:,2) = divident3./divisor;
        real_node_ghost_topo(:,3) = divident2./divisor;
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    case 'C'
        divident2_x = abs(coor_node(real_node_ghost(:,2),1) - coor_node(real_node_ghost(:,1),1) ) ;
        divident2_y = abs(coor_node(real_node_ghost(:,2),2) - coor_node(real_node_ghost(:,1),2) ) ;
        
        divident3_x = abs(coor_node(real_node_ghost(:,3),1) - coor_node(real_node_ghost(:,1),1) ) ;
        divident3_y = abs(coor_node(real_node_ghost(:,3),2) - coor_node(real_node_ghost(:,1),2) ) ;
        
        divident4_x = abs(coor_node(real_node_ghost(:,4),1) - coor_node(real_node_ghost(:,1),1) ) ;
        divident4_y = abs(coor_node(real_node_ghost(:,4),2) - coor_node(real_node_ghost(:,1),2) ) ;
        
        divident5_x = abs(coor_node(real_node_ghost(:,5),1) - coor_node(real_node_ghost(:,1),1) ) ;
        divident5_y = abs(coor_node(real_node_ghost(:,5),2) - coor_node(real_node_ghost(:,1),2) ) ;
        
        divisor_x = abs(coor_node(real_node_ghost(:,2),1) - coor_node(real_node_ghost(:,5),1) ) ;
        divisor_y = abs(coor_node(real_node_ghost(:,2),2) - coor_node(real_node_ghost(:,5),2) ) ;
        
        divisor = divisor_y.*divisor_x;
        divident2 = divident2_x.*divident2_y;
        divident3 = divident3_y.*divident3_x;
        divident4 = divident4_y.*divident4_x;
        divident5 = divident5_y.*divident5_x;
        
        real_node_ghost_topo(:,2) = divident5./divisor;
        real_node_ghost_topo(:,3) = divident4./divisor;
        real_node_ghost_topo(:,4) = divident3./divisor;
        real_node_ghost_topo(:,5) = divident2./divisor;
end
end
return