function [coor_edge_X,coor_edge_Y] = coor_edges(Dx,Dy)
    Nx = length(Dx);
    Ny = length(Dy);
    
    coor_x = [0;Dx];
    coor_y = [0;Dy];
    
    coor_x = cumsum(coor_x);
    coor_y = cumsum(coor_y);
    
    middle_x = (coor_x(1:(end-1)) + coor_x(2:end) )/2;
    middle_y = (coor_y(1:(end-1)) + coor_y(2:end) )/2;
    
    [coor_edge_X_y,coor_edge_X_x] = meshgrid(coor_y,middle_x);
    [coor_edge_Y_y,coor_edge_Y_x] = meshgrid(middle_y,coor_x);
    
    coor_edge_X_x = reshape(coor_edge_X_x,Nx*(Ny+1),1);
    coor_edge_X_y = reshape(coor_edge_X_y,Nx*(Ny+1),1);
    
    coor_edge_Y_x = reshape(coor_edge_Y_x,(Nx+1)*Ny,1);
    coor_edge_Y_y = reshape(coor_edge_Y_y,(Nx+1)*Ny,1);
    
    coor_edge_X = [coor_edge_X_x,coor_edge_X_y];
    coor_edge_Y = [coor_edge_Y_x,coor_edge_Y_y];
end