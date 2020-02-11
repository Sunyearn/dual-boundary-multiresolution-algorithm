function G = replace_ghost_nodes(G,real_ghost_node,real_ghost_node_topo,mode)
    switch upper(mode)
        case 'X'
            for i = 1:2 % column of ghost nodes
                temp0 = real_ghost_node(:,1);
                temp1 = real_ghost_node(:,1+i);
                value1 = real_ghost_node_topo(:,1+i);
                G(:,temp1) = G(:,temp1) + G(:,temp0)*spdiags(value1,0,length(value1),length(value1));
            end
        case 'Y'
            for i = 1:2 % column of ghost nodes
                temp0 = real_ghost_node(:,1);
                temp1 = real_ghost_node(:,1+i);
                value1 = real_ghost_node_topo(:,1+i);
                G(:,temp1) = G(:,temp1) + G(:,temp0)*spdiags(value1,0,length(value1),length(value1));
            end
        case 'C'
            for i = 1:4 % column of ghost nodes
                temp0 = real_ghost_node(:,1);
                temp1 = real_ghost_node(:,1+i);
                value1 = real_ghost_node_topo(:,1+i);
                G(:,temp1) = G(:,temp1) + G(:,temp0)*spdiags(value1,0,length(value1),length(value1));
            end
    end
return