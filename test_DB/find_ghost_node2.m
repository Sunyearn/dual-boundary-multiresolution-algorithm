function [ghostx,ghosty,ghostc] = find_ghost_node2(Nx,Ny,nx,ny,mode)
    switch upper(mode)
        case 'NODE'
            % ghost central 
            ratio_x = nx/Nx;
            ratio_y = ny/Ny;
            % initialization
            small = zeros(nx+1,ny+1);
            big = zeros(Nx+1,Ny+1);
            for i_x = 1:2
                for i_y = 1:2
                    big(:) = 0;
                    big(i_x:end-2+i_x, i_y:end-2+i_y) = 1;
                    index = find(big==1);
                    if i_x ==1 && i_y==1
                        temp_bigc = index;
                    else
                        temp_bigc = [temp_bigc,index];
                    end
                end
            end
            for i_x = 1:(ratio_x-1)
                for i_y = 1:(ratio_y-1)
                    small(:) = 0;
                    small(1+i_x:ratio_x:end-ratio_x+i_x,1+i_y:ratio_y:end-ratio_y+i_y) = 1;
                    index = find(small==1);
                    if i_x ==1 && i_y==1
                        ghostc = [index,temp_bigc];
                    else
                        ghostc = [ghostc;
                                  index,temp_bigc];
                    end
                end
            end
            % ghost edge x
            small = zeros(nx+1,ny+1);
            big = zeros(Nx+1,Ny+1);
            for i_x = 1:2
                big(:) = 0;
                big(i_x:end-2+i_x,:) = 1;
                index = find(big==1);
                if i_x ==1
                    temp_bigx = index;
                else
                    temp_bigx = [temp_bigx,index];
                end
            end
            for i_x = 1:(ratio_x-1)
                small(:) = 0;
                small(1+i_x:ratio_x:end-ratio_x+i_x,1:ratio_y:end) = 1;
                index = find(small==1);
                if i_x ==1
                    ghostx = [index,temp_bigx];
                else
                    ghostx = [ghostx;
                              index,temp_bigx];
                end
            end
            % ghost nodes on big y edges
            small = zeros(nx+1,ny+1);
            big = zeros(Nx+1,Ny+1);
            for i_y = 1:2
                big(:) = 0;
                big(:,i_y:end-2+i_y) = 1;
                index = find(big==1);
                if i_y ==1
                    temp_bigy = index;
                else
                    temp_bigy = [temp_bigy,index];
                end
            end
            for i_y = 1:(ratio_y-1)
                small(:) = 0;
                small(1:ratio_x:end,1+i_y:ratio_y:end-ratio_y+i_y) = 1;
                index = find(small==1);
                if i_y ==1
                    ghosty = [index,temp_bigy];
                else
                    ghosty = [ghosty;
                              index,temp_bigy];
                end
            end
        case 'EDGE'
            ratio_x = nx/Nx;
            ratio_y = ny/Ny;
            small_x = zeros(nx,ny+1);
            small_y = zeros(nx+1,ny);
            
            small_x(:,1:ratio_y:end) = 1;
            small_y(1:ratio_x:end,:) = 1;
            small = [reshape(small_x,numel(small_x),1);
                     reshape(small_y,numel(small_y),1)];
        otherwise
    end
return