function [real_edge_ghost_topo] = give_ghost_edge_topo(real_edge_ghost,coor_edge_all,mode)
% xY: ghost edge x in y direction
% xZ: ghost edge x in z direction
% yX: ghost edge y in x direction
% yZ: ghost edge y in z direction
% xYZ: ghost edge x in y,z direction
% yXZ: ghost edge y in x,z direction

real_edge_ghost_topo = zeros(size(real_edge_ghost));
real_edge_ghost_topo(:,1) = real_edge_ghost(:,1); % 第一列是小网格中的 ghost edge 在所有的edge排序中的序号

switch mode
    case 'xY'
        divident3 = abs(coor_edge_all(real_edge_ghost(:,3),2) - coor_edge_all(real_edge_ghost(:,1),2) ) ;
        divident2 = abs(coor_edge_all(real_edge_ghost(:,2),2) - coor_edge_all(real_edge_ghost(:,1),2) ) ;
        divisor = abs(coor_edge_all(real_edge_ghost(:,2),2) - coor_edge_all(real_edge_ghost(:,3),2) ) ;
        real_edge_ghost_topo(:,2) = divident3./divisor;
        real_edge_ghost_topo(:,3) = divident2./divisor;
    case 'xZ'
        divident3 = abs(coor_edge_all(real_edge_ghost(:,3),3) - coor_edge_all(real_edge_ghost(:,1),3) ) ;
        divident2 = abs(coor_edge_all(real_edge_ghost(:,2),3) - coor_edge_all(real_edge_ghost(:,1),3) ) ;
        divisor = abs(coor_edge_all(real_edge_ghost(:,2),3) - coor_edge_all(real_edge_ghost(:,3),3) ) ;
        real_edge_ghost_topo(:,2) = divident3./divisor;
        real_edge_ghost_topo(:,3) = divident2./divisor;
    case 'yX'
        divident3 = abs(coor_edge_all(real_edge_ghost(:,3),1) - coor_edge_all(real_edge_ghost(:,1),1) ) ;
        divident2 = abs(coor_edge_all(real_edge_ghost(:,2),1) - coor_edge_all(real_edge_ghost(:,1),1) ) ;
        divisor = abs(coor_edge_all(real_edge_ghost(:,2),1) - coor_edge_all(real_edge_ghost(:,3),1) ) ;
        real_edge_ghost_topo(:,2) = divident3./divisor;
        real_edge_ghost_topo(:,3) = divident2./divisor;
    case 'yZ'
        divident3 = abs(coor_edge_all(real_edge_ghost(:,3),3) - coor_edge_all(real_edge_ghost(:,1),3) ) ;
        divident2 = abs(coor_edge_all(real_edge_ghost(:,2),3) - coor_edge_all(real_edge_ghost(:,1),3) ) ;
        divisor = abs(coor_edge_all(real_edge_ghost(:,2),3) - coor_edge_all(real_edge_ghost(:,3),3) ) ;
        real_edge_ghost_topo(:,2) = divident3./divisor;
        real_edge_ghost_topo(:,3) = divident2./divisor;
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    case 'xYZ'
        divident2_y = abs(coor_edge_all(real_edge_ghost(:,2),2) - coor_edge_all(real_edge_ghost(:,1),2) ) ;
        divident2_z = abs(coor_edge_all(real_edge_ghost(:,2),3) - coor_edge_all(real_edge_ghost(:,1),3) ) ;
        
        divident3_y = abs(coor_edge_all(real_edge_ghost(:,3),2) - coor_edge_all(real_edge_ghost(:,1),2) ) ;
        divident3_z = abs(coor_edge_all(real_edge_ghost(:,3),3) - coor_edge_all(real_edge_ghost(:,1),3) ) ;
        
        divident4_y = abs(coor_edge_all(real_edge_ghost(:,4),2) - coor_edge_all(real_edge_ghost(:,1),2) ) ;
        divident4_z = abs(coor_edge_all(real_edge_ghost(:,4),3) - coor_edge_all(real_edge_ghost(:,1),3) ) ;
        
        divident5_y = abs(coor_edge_all(real_edge_ghost(:,5),2) - coor_edge_all(real_edge_ghost(:,1),2) ) ;
        divident5_z = abs(coor_edge_all(real_edge_ghost(:,5),3) - coor_edge_all(real_edge_ghost(:,1),3) ) ;
        
        divisor_y = abs(coor_edge_all(real_edge_ghost(:,2),2) - coor_edge_all(real_edge_ghost(:,3),2) ) ;
        divisor_z = abs(coor_edge_all(real_edge_ghost(:,2),3) - coor_edge_all(real_edge_ghost(:,4),3) ) ;
        
        divisor = divisor_y.*divisor_z;
        divident2 = divident2_y.*divident2_z;
        divident3 = divident3_y.*divident3_z;
        divident4 = divident4_y.*divident4_z;
        divident5 = divident5_y.*divident5_z;
        
        real_edge_ghost_topo(:,2) = divident5./divisor;
        real_edge_ghost_topo(:,3) = divident4./divisor;
        real_edge_ghost_topo(:,4) = divident3./divisor;
        real_edge_ghost_topo(:,5) = divident2./divisor;
    case 'yXZ'
        divident2_x = abs(coor_edge_all(real_edge_ghost(:,2),1) - coor_edge_all(real_edge_ghost(:,1),1) ) ;
        divident2_z = abs(coor_edge_all(real_edge_ghost(:,2),3) - coor_edge_all(real_edge_ghost(:,1),3) ) ;
        
        divident3_x = abs(coor_edge_all(real_edge_ghost(:,3),1) - coor_edge_all(real_edge_ghost(:,1),1) ) ;
        divident3_z = abs(coor_edge_all(real_edge_ghost(:,3),3) - coor_edge_all(real_edge_ghost(:,1),3) ) ;
        
        divident4_x = abs(coor_edge_all(real_edge_ghost(:,4),1) - coor_edge_all(real_edge_ghost(:,1),1) ) ;
        divident4_z = abs(coor_edge_all(real_edge_ghost(:,4),3) - coor_edge_all(real_edge_ghost(:,1),3) ) ;
        
        divident5_x = abs(coor_edge_all(real_edge_ghost(:,5),1) - coor_edge_all(real_edge_ghost(:,1),1) ) ;
        divident5_z = abs(coor_edge_all(real_edge_ghost(:,5),3) - coor_edge_all(real_edge_ghost(:,1),3) ) ;
        
        divisor_x = abs(coor_edge_all(real_edge_ghost(:,2),1) - coor_edge_all(real_edge_ghost(:,3),1) ) ;
        divisor_z = abs(coor_edge_all(real_edge_ghost(:,2),3) - coor_edge_all(real_edge_ghost(:,4),3) ) ;
        
        divisor = divisor_x.*divisor_z;
        divident2 = divident2_x.*divident2_z;
        divident3 = divident3_x.*divident3_z;
        divident4 = divident4_x.*divident4_z;
        divident5 = divident5_x.*divident5_z;
        
        real_edge_ghost_topo(:,2) = divident5./divisor;
        real_edge_ghost_topo(:,3) = divident4./divisor;
        real_edge_ghost_topo(:,4) = divident3./divisor;
        real_edge_ghost_topo(:,5) = divident2./divisor;
end
end