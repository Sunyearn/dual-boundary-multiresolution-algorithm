function [irow_sparse,icol_sparse,ivalue_sparse]=make_divergence_topo(Nx,Ny,Nelem,mode)
%% �����Ƕ���ʦ������ �ݶ����� �ġ����ˡ��ṹ�ģ����ڱ��������� ɢ������ �ġ����ˡ��ṹ,����ʱ����row��Ӧcol����col���Ӧrow
%  a simple function to create the 'topology' part of 3D gradient operator 
%  (matrix) for Finite difference method
%  basicly this just build the 'sign' part of 
%
%  grad(U) = ex(dUx/dx)+ey(dUy/dy)+ez(dUz/dz)
%          = ex((Ux(i+1)-Ux(i))/Dx(i))
%          + ey((Uy(j+1)-Uy(j))/Dy(j))
%          + ez((Uz(k+1)-Uz(k))/Dz(k))
%  which is essentially differencial operators along each axis 
%          1    2    3
%        3 *----*----* 1
%         /    /    /|
%      2 *----*----* |
%    Ex ^    /    /| * 2
%    1 *-->-*----* |/|
%      | Ey |    | * |
%   Ez V    |    |/| * 3
%      *----*----* |/
%      |    |    | *
%      |    |    |/
%      *----*----*
%  
%  modified to use sparse matrix (row, column, value format) to deal with
%  larger (not so large, actually) problems - this was MUCH easier to setup
%  when using full matrix...
%  Nelem could be 3 by 1 Nface or Nedge 
%  mode could be 'N2E' or 'C2F'   N2E �� C2F��ʲôģʽ�أ���node to edge �� cell to (inner) face 

%  DONG Hao 2012.07.11 in Beijing
%=========================================================================%
if nargin<3
    error('not enough input parameters')
elseif nargin<4
    mode='N2E';
end
switch upper(mode)
   case 'N2E' % node to edge
        Nedge = Nelem;
        Nelem2 = (Nx+1)*(Ny+1); % Nnode here
		% for x-edges (2*Nedgex edges in total)
		Nedgex = Nedge(1);
        % determine rows
		irowx = reshape(ones(2,1)*(1:Nedgex),Nedgex*2,1);%irowx����˼��row Ux�����i����irowx������ʲô�ã�������icolx�й���ô��
		% determine columns 
        % just a little trick to convert from 3d to 1d index
        I = mod(1:Nedgex,Nx);
        I(I==0) = Nx;   % ��ȥ�������Ϭ����������������������������������������������
        J  = mod(ceil((1:Nedgex)/(Nx)),(Ny+1));
        J(J==0) = Ny+1;
		icolx =reshape( [(J-1)*(Nx+1)+I ; ... %Ϊʲô��һ����ʾ��K��((Nx)*(Ny+1))�ı���ȡ��������ȴ��(Nx+1)*(Ny+1)�ı���
                         (J-1)*(Nx+1)+I+1 ],Nedgex*2,1); %???????????????????????????????
		% determine the topology - 
		valuex = reshape([-ones(1,Nedgex);
                           ones(1,Nedgex)] , Nedgex*2,1);
        
		% for y--edges (2*Nedgey edges in total)
		Nedgey = Nedge(2);
		% determine rows
		irowy = reshape(ones(2,1)*(Nedgex+1:Nedgex+Nedgey),Nedgey*2,1);
		% determine columns 
        I = mod(1:Nedgey,Nx+1);
        I(I==0) = Nx+1;
        J  = mod(ceil((1:Nedgey)/(Nx+1)),(Ny));
        J(J==0) = Ny;
		icoly =reshape([(J-1)*(Nx+1)+I; ... %?????????????????????????????????
                        (J)*(Nx+1)+I], Nedgey*2,1); %???????????????????????????????
		% determine the topology - 
		valuey = reshape([-ones(1,Nedgey);
                           ones(1,Nedgey)],Nedgey*2,1);   
    otherwise
        error('mode not recognized, must be N2E or C2F')
end 
%  now construct sparse matrix for all three directions
%  G should be Nedge by Nnode for NTE
%              Nface by Ncell for CTF
 irow_sparse = [irowx;irowy];
 icol_sparse = [icolx;icoly];
 ivalue_sparse = [valuex;valuey];
return