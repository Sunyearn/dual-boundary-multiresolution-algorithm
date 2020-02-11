function [overlap] = find_overlap_all_node(Nx,Ny,nx,ny,mode)
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
            
            small_x(:,1:skip_y:end) = 1;
            small_y(1:skip_x:end,:) = 1;
            small = [reshape(small_x,numel(small_x),1);
                     reshape(small_y,numel(small_y),1)];
        otherwise
    end
return