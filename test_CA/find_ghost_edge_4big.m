% ghost edge 有两种类别，一种是用 2 个粗网格棱边代替细网格的棱边，另一种是用 4 个粗网格的棱边代替细网格的棱边。这里是第 2 种情况
% could be used in 3D
% not suitable for 2D situation
function [index_edge_x_ghost_yz,index_edge_y_ghost_xz] =...
                            find_ghost_edge_4big( Nedge_big,Nx_big,Ny_big,Nz_big,...
                                            Nedge_small,Nx_small,Ny_small,Nz_small,...
                                          left_pos_at_big,right_pos_at_big,forward_pos_at_big,backward_pos_at_big,ratio)
%% initial parameter
    ratio_x = ratio;
    ratio_y = ratio;
    ratio_z = ratio;
    sum_edge_big = sum(Nedge_big);
    
%% initial control matrix
    control_edge_x_big = zeros(Nx_big,Ny_big+1,Nz_big+1);
    control_edge_y_big = zeros(Nx_big+1,Ny_big,Nz_big+1);
    control_edge_z_big = zeros(Nx_big+1,Ny_big+1,Nz_big);
    
    control_edge_x_small = zeros(Nx_small,Ny_small+1,Nz_small+1);
    control_edge_y_small = zeros(Nx_small+1,Ny_small,Nz_small+1);
    control_edge_z_small = zeros(Nx_small+1,Ny_small+1,Nz_small);
%% find index of ghost edge x （粗网格edge替换后的算子拓扑与 y、z 坐标有关的部分）
    control_edge_x_big([(left_pos_at_big-1),(right_pos_at_big+1)],forward_pos_at_big:backward_pos_at_big,1:(end-1)) = 1;
    control_edge_x_big([(left_pos_at_big-1),(right_pos_at_big+1)],(forward_pos_at_big+1):(backward_pos_at_big+1),1:(end-1) )=...
       control_edge_x_big([(left_pos_at_big-1),(right_pos_at_big+1)],(forward_pos_at_big+1):(backward_pos_at_big+1),1:(end-1) )+ 10;
    
    control_edge_x_big([(left_pos_at_big-1),(right_pos_at_big+1)],forward_pos_at_big:backward_pos_at_big,2:end) =...
        control_edge_x_big([(left_pos_at_big-1),(right_pos_at_big+1)],forward_pos_at_big:backward_pos_at_big,2:end) + 1000i;
    control_edge_x_big([(left_pos_at_big-1),(right_pos_at_big+1)],(forward_pos_at_big+1):(backward_pos_at_big+1),2:end )=...
       control_edge_x_big([(left_pos_at_big-1),(right_pos_at_big+1)],(forward_pos_at_big+1):(backward_pos_at_big+1),2:end )+ 10000i;
    
    control_edge_x_big = reshape(control_edge_x_big,numel(control_edge_x_big),1);
    index_edge_x_ghostz1y1 = find(real(control_edge_x_big)==1 | real(control_edge_x_big)==11);
    index_edge_x_ghostz1y2 = find(real(control_edge_x_big)>=10);
    index_edge_x_ghostz2y1 = find(imag(control_edge_x_big)== 1000 | imag(control_edge_x_big)== 11000);
    index_edge_x_ghostz2y2 = find(imag(control_edge_x_big)>= 10000);
    
    for k = 1:(ratio_z-1)
        for j = 1:(ratio_y-1)
            control_edge_x_small([(left_pos_at_big-1)*ratio_x,(right_pos_at_big*ratio_x+1)],...
                            ((forward_pos_at_big-1)*ratio_y +1 +j):ratio_y:((backward_pos_at_big-1)*ratio_y +1 +j),...
                                        (1+k):ratio_z:(end-ratio_z+k) ) = (k-1)*(ratio_y-1) + j;
        end
    end
    control_edge_x_small = reshape(control_edge_x_small,numel(control_edge_x_small),1);
    for ii = 1:((ratio_y-1)*(ratio_z-1))
        index_small_edge_ghost_temp = find(control_edge_x_small == ii);
%         temp = [index_small_edge_ghost_temp,index_edge_x_ghost1,index_edge_x_ghost2];
          temp = [(index_small_edge_ghost_temp + sum_edge_big),index_edge_x_ghostz1y1,index_edge_x_ghostz1y2,...
                                                               index_edge_x_ghostz2y1,index_edge_x_ghostz2y2];
        if ii == 1
            index_edge_x_ghost_yz = temp;
        else
            index_edge_x_ghost_yz = [index_edge_x_ghost_yz;temp];
        end
    end
%% find index of ghost edge y （其中，粗网格edge替换后的算子拓扑与 x、z 坐标有关的部分）
    control_edge_y_big(left_pos_at_big:right_pos_at_big,[(forward_pos_at_big-1),(backward_pos_at_big+1)],1:(end-1)) = 1;
    control_edge_y_big((left_pos_at_big+1):(right_pos_at_big+1),[(forward_pos_at_big-1),(backward_pos_at_big+1)],1:(end-1))=...
       control_edge_y_big((left_pos_at_big+1):(right_pos_at_big+1),[(forward_pos_at_big-1),(backward_pos_at_big+1)],1:(end-1))+ 10;
   
   control_edge_y_big(left_pos_at_big:right_pos_at_big,[(forward_pos_at_big-1),(backward_pos_at_big+1)],2:end) =...
       control_edge_y_big(left_pos_at_big:right_pos_at_big,[(forward_pos_at_big-1),(backward_pos_at_big+1)],2:end)+ 1000i;
    control_edge_y_big((left_pos_at_big+1):(right_pos_at_big+1),[(forward_pos_at_big-1),(backward_pos_at_big+1)],2:end)=...
       control_edge_y_big((left_pos_at_big+1):(right_pos_at_big+1),[(forward_pos_at_big-1),(backward_pos_at_big+1)],2:end)+ 10000i;
    control_edge_y_big = reshape(control_edge_y_big,numel(control_edge_y_big),1);
    
    index_edge_y_ghostx1z1 = find(real(control_edge_y_big)==1 | real(control_edge_y_big)==11);
    index_edge_y_ghostx2z1 = find(real(control_edge_y_big)>=10);
    index_edge_y_ghostx1z2 = find(imag(control_edge_y_big)== 1000 | imag(control_edge_y_big)== 11000);
    index_edge_y_ghostx2z2 = find(imag(control_edge_y_big)>= 10000);
    
    for  k = 1:(ratio_z-1)
        for i = 1:(ratio_x-1)
            control_edge_y_small( ((left_pos_at_big-1)*ratio_x+1+i):ratio_x:(right_pos_at_big*ratio_x +1-ratio_x + i),...
                            [((forward_pos_at_big-1)*ratio_y),(backward_pos_at_big*ratio_y +1)],...
                                        (1+k):ratio_z:(end-ratio_z+k) ) = (k-1)*(ratio_x-1) + i;
        end
    end
    control_edge_y_small = reshape(control_edge_y_small,numel(control_edge_y_small),1);
    for ii = 1:((ratio_x-1)*(ratio_z-1))
        index_small_edge_ghost_temp = find(control_edge_y_small == ii);
%         temp = [index_small_edge_ghost_temp,index_edge_x_ghost1,index_edge_x_ghost2];
          temp = [(index_small_edge_ghost_temp + sum_edge_big + Nedge_small(1)),...
                                              index_edge_y_ghostx1z1+Nedge_big(1),index_edge_y_ghostx2z1+Nedge_big(1)...
                                              index_edge_y_ghostx1z2+Nedge_big(1),index_edge_y_ghostx2z2+Nedge_big(1)];
        if ii == 1
            index_edge_y_ghost_xz = temp;
        else
            index_edge_y_ghost_xz = [index_edge_y_ghost_xz;temp];
        end
    end
end














