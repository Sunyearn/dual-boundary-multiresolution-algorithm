function [overlap] = find_overlap_all(Nx,Ny,nx,ny,mode)
    switch upper(mode)
        case 'NODE'
            % initialization
            small = zeros(nx+1,ny+1);
            big = zeros(Nx+1,Ny+1);
            skip_x = nx/Nx;
            skip_y = ny/Ny;
            % setup
            small(1:skip_x:end, 1:skip_y:end) = 1;
            big(1:end,1:end) = 1;
            % find
            big = find(big==1);
            small = find(small==1);
            % combination
            overlap = [small,big];
        case 'EDGE'
            skip_x = nx/Nx;
            skip_y = ny/Ny;
            small_x = zeros(nx,ny+1);
            small_y = zeros(nx+1,ny);
            
            big_x = zeros(Nx,Ny+1);
            big_y = zeros(Nx+1,Ny);
            
            for i_x = 1:skip_x
                small_x(i_x:skip_x:end-skip_x+i_x,1:skip_y:end) = i_x;
            end
            index_big = (1:numel(big_x))';
            index_small = [];
            for i_x = 1:skip_x
                temp_x = find(small_x == i_x);
                index_small = [index_small,temp_x];
            end
            overlap = [index_small,index_big];
            %%
            for i_y = 1:skip_y
                small_y(1:skip_x:end,i_y:skip_y:end-skip_y+i_y) = i_y;
            end
            index_big = (1:numel(big_y))';
            index_small = [];
            for i_y = 1:skip_y
                temp_y = find(small_y == i_y);
                index_small = [index_small,temp_y];
            end
            overlap = [overlap;...
                       (index_small+numel(small_x)),index_big+numel(big_x)];
        otherwise
            disp('The mode you chose is wrong in find_overlap_all.m');
    end
return