function [div_x,div_y] = make_divergence_denominator(Dx,Dy)
    Dx_add = [0;Dx;0];
    Dy_add = [0;Dy;0];

    node_Dx = (Dx_add(1:(end-1)) + Dx_add(2:end))/2;
    node_Dy = (Dy_add(1:(end-1)) + Dy_add(2:end))/2;
    
    [div_y,div_x] = meshgrid(node_Dy,node_Dx);
    Nx = length(node_Dx);
    Ny = length(node_Dy);
    div_x = reshape(div_x,Nx*Ny,1);
    div_y = reshape(div_y,Nx*Ny,1);
end