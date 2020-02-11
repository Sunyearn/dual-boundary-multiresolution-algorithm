function [idxb,idxi]=get_bdidx2d(Nx,Ny,mode)
% a simple script to get the boundary (and internal index) index for
% edges, faces and nodes for vectorized matrix for 3D FD grid
% set here counters for Edges, Faces and Nodes of the grid


% 这个函数应该和物理场的X、Y、Z三个分量有关系
switch upper(mode)
    case 'EDGE'  %棱边元是按照棱边的方向排列，先排x向（即先排列x方向相关的边界问题），再排y方向，最后是z方向。每一个方向里最内层循环为行（第一个坐标），外层循环为列（第二个坐标），最外层是高（第三个坐标）
        x = ones(Nx,Ny+1); %与x方向平行的棱边矩阵
        y = ones(Nx+1,Ny); %与y方向平行的棱边矩阵
        % set the boundaries to be zeros...
        % upper and lower boundary:
        y([1,end],:)=0;
        % left and right boundary:
        x(:,[1,Ny+1])=0;
        
        t = [reshape(x,Nx*(Ny+1),1); ...
             reshape(y,(Nx+1)*Ny,1)];
    case 'FACE'  %面元是按照面的法向方向排列，先排x向（即先排列x方向相关的边界问题），再排y方向，最后是z方向。每一个方向里最内层循环为行（第一个坐标），外层循环为列（第二个坐标），最外层是高（第三个坐标）
        x = ones(Nx+1,Ny);
        y = ones(Nx,Ny+1);
        
        t = [reshape(x,(Nx+1)*Ny,1); ...
             reshape(y,Nx*(Ny+1),1)];
    case 'NODE'  %节点元是按照节点，在各向同性问题中没有方向的概念，最内层循环为行（第一个坐标），外层循环为列（第二个坐标），最外层是高（第三个坐标）
        x = ones(Nx+1,Ny+1);
        % set the boundaries to be zeros...
        % upper and lower boundary:
        x([1,Nx+1],:)=0;
        % left and right boundary:
        x(:,[1,Ny+1])=0;
        
        t = reshape(x,(Nx+1)*(Ny+1),1);
    otherwise
        error('mode not recognized, must be EDGE, FACE or NODE')
end
% interior edges/faces/nodes
idxi = find(t==1);
% boundary edges/faces/nodes
idxb = find(t==0);
return