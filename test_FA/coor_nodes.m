function [coor_node] = coor_nodes(Dx,Dy)
    Nx = length(Dx);
    Ny = length(Dy);
    
    coor_x = [0;Dx];
    coor_y = [0;Dy];
    
    coor_x = cumsum(coor_x);
    coor_y = cumsum(coor_y);
    
    [coor_node_y,coor_node_x] = meshgrid(coor_y,coor_x);
    coor_node_x = reshape(coor_node_x,(Nx+1)*(Ny+1),1);
    coor_node_y = reshape(coor_node_y,(Nx+1)*(Ny+1),1);
    
    coor_node = [coor_node_x,coor_node_y];
end