function [overlap,skip] = find_overlapped_mr(Nx,Ny,nx,ny,num_bx,num_by,mode)
if (num_bx < Nx) && (num_by < Ny)
    switch upper(mode)
        case 'NODE'
            small = zeros(nx+1,ny+1);
            skip_x = nx/Nx;
            skip_y = ny/Ny;
            small(1:skip_x:end,1:skip_y:end) = 1;
            small = reshape(small,numel(small),1);
        case 'EDGE'
            skip_x = nx/Nx;
            skip_y = ny/Ny;
            small_x = zeros(nx,ny+1);
            small_y = zeros(nx+1,ny);
            
            small_x(:,1:skip_y:end) = 1;
            small_y(1:skip_x:end,:) = 1;
            small = [reshape(small_x,numel(small_x),1);
                     reshape(small_y,numel(small_y),1)];
        otherwise
    end
    overlap = find(small==1);
    skip = find(small==0);
else
    disp('In code find_overlapped_mr.m, (num_bx,num_by) is out of (Nx,Ny)');
    overlap = [];
    skip = [];
end
return