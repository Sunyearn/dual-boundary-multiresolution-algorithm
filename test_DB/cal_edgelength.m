function Ledge=cal_edgelength(Dx,Dy,mode)
% a simple function to build the edge length vector for differential
% operators 
%  Ledge   |Lface|
% |-----|-----|-----|
% |     |     |     |
% |     |     |     |
% |-----|-----|-----|
% |     |     |     |
% |     |     |     |
% |-----|-----|-----|
% mode could be 'EDGE' or 'NODE' ����Ӧ����"EDGE"��"FACE"�ɣ�
if nargin<2
    error('not enough input parameters')
elseif nargin<3
    mode='EDGE';
end
Nx=size(Dx,1);
Ny=size(Dy,1);
switch upper(mode)
    case 'EDGE'
        Nedgex=(Nx)*(Ny+1);
        Nedgey=(Nx+1)*(Ny);
        [Ly,Lx]=meshgrid(Dy,Dx);%֮���԰ѵ�һ�������Ӧdy������Ϊ�ڵ��þ���ʱ���ǣ�����ϰ���õ�һ������λ�ô����У��ڶ�������λ�ô�����
        % padding the extra rows,columns or layers %
        % ΪʲôҪ��������С��кͲ㡷����Ϊ����Ķ����С��С����Ӧ���������������Ԫ��Ӧ���е�����
        Lx(:,Ny+1)=Lx(:,Ny);
        
        Ly(Nx+1,:)=Ly(Nx,:);
    case 'FACE'
        Nedgex=(Nx+1)*Ny;
        Nedgey=Nx*(Ny+1);      
%         DDx=([Dx;0]+[0;Dx])/2;
%         DDy=([Dy;0]+[0;Dy])/2;  %%%  DONG
%         DDz=([Dz;0]+[0;Dz])/2;
        DDx=([Dx;0]+[0;Dx])/2;
        DDy=([Dy;0]+[0;Dy])/2;
        [Ly,Lx]=meshgrid(DDy,DDx);
        % subtracting the extra rows,columns or layers ɾȥ������С��кͲ�
        Lx(:,Ny+1,:)=[];
        
        Ly(Nx+1,:,:)=[];
    otherwise
        error('mode not recognized, must be EDGE or FACE.')
end
Ledge = [reshape(Lx,Nedgex,1);...
         reshape(Ly,Nedgey,1)];
return








