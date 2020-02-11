function [irowx,irowy,icolx,icoly,valuex,valuey] =...
                                mk_grad_topo(Nx,Ny,Nelem,mode)
if nargin<3
    error('not enough input parameters')
elseif nargin<4
    mode='N2E';
end
switch upper(mode)
    case 'N2E'
        % Node 2 edgex
        Nx_dot = Nx + 1;
        Ny_dot = Ny + 1;
        Nelem2 = Nx_dot * Ny_dot;
        
        Nedge = Nelem;
        Nedgex = Nedge(1);
        
        irowx = reshape(ones(2,1)*(1:Nedgex),Nedgex*2,1);
        I = mod(1:Nedgex,Nx);
        I(I==0) = Nx;
        J = mod(ceil((1:Nedgex)/Nx),Ny_dot);
        J(J==0) = Ny_dot;
        icolx = reshape( [(J-1)*(Nx_dot)+I;...
                          (J-1)*(Nx_dot)+I+1],Nedgex*2,1);
        valuex = reshape([-ones(1,Nedgex);
                           ones(1,Nedgex)],Nedgex*2,1);
        % Node 2 edgey
        Nedgey = Nedge(2);
        irowy = reshape(ones(2,1)*(Nedgex+1:Nedgex+Nedgey),Nedgey*2,1);
        I = mod(1:Nedgey,Nx_dot);
        I(I==0) = Nx_dot;
        J = mod(ceil((1:Nedgey)/(Nx_dot)),Ny);
        J(J==0) = Ny;
        icoly = reshape([(J-1)*(Nx_dot)+I;...
                         (J)*(Nx_dot)+I],Nedgey*2,1);
        valuey = reshape([-ones(1,Nedgey);ones(1,Nedgey)],Nedgey*2,1); 
    otherwise
end
%     G = sparse([irowx;irowy],[icolx;icoly],[valuex;valuey],sum(Nelem),Nelem2);
end




