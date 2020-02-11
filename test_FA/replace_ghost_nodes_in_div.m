function Div = replace_ghost_nodes_in_div(Div,real_ghost_node,real_ghost_node_topo,mode)
    switch upper(mode)
        case 'X'
            for i = 1:2 % column of ghost nodes
                temp0 = real_ghost_node(:,1);
                temp1 = real_ghost_node(:,1+i);
                value1 = real_ghost_node_topo(:,1+i);
                Div(temp0,:) = Div(temp0,:) + spdiags(value1,0,length(value1),length(value1))*Div(temp1,:);
            end
        case 'Y'
            for i = 1:2 % column of ghost nodes
                temp0 = real_ghost_node(:,1);
                temp1 = real_ghost_node(:,1+i);
                value1 = real_ghost_node_topo(:,1+i);
                Div(temp0,:) = Div(temp0,:) + spdiags(value1,0,length(value1),length(value1))*Div(temp1,:);
            end
        case 'C'
            for i = 1:4 % column of ghost nodes
                temp0 = real_ghost_node(:,1);
                temp1 = real_ghost_node(:,1+i);
                value1 = real_ghost_node_topo(:,1+i);
                Div(temp0,:) = Div(temp0,:) + spdiags(value1,0,length(value1),length(value1))*Div(temp1,:);
            end
    end
return