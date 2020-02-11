function [real_big_edge_boundary,...
          real_big_edge_inside,...
          real_big_edge_useful,...
          real_big_edge_not_useful,...
          real_big_edge_overlap_or_ghost]=...
          find_big_edge_useful(Nx_big,Ny_big,Nedge_big,...
                              left_pos_at_big,right_pos_at_big,forward_pos_at_big,backward_pos_at_big)
    edge_x_big_control = zeros(Nx_big,Ny_big+1);
    edge_y_big_control = zeros(Nx_big+1,Ny_big);
    %% X big ͨ�����컯�ı�־��flag�����������
    % X initial useful �Ѵ����������е� x ����߶���� ������ flag 1
    edge_x_big_control(:,:) = 1;
    % X initial inside �Ѵ����������е� x ���ڲ���ߣ��ڲ��� edge x����������� flag 10
    edge_x_big_control(:,2:(end-1)) = 10;
    % X real big overlap ��ʵ�ʵ������ʷ��У�С���񸲸���������Ӧ�Ĵ����� x �����  ����
    edge_x_big_control(left_pos_at_big:right_pos_at_big,(forward_pos_at_big):(backward_pos_at_big+1)) = 20;
    % real overlap and ghost
    edge_x_big_control([(left_pos_at_big-1),(right_pos_at_big+1)],(forward_pos_at_big):(backward_pos_at_big+1)) = 19;
%     % X real big overlap ��ʵ�ʵ������ʷ��У�С���񸲸���������Ӧ�Ĵ����� x �����  ������
%     edge_x_big_control(left_pos_at_big:right_pos_at_big,(forward_pos_at_big):(backward_pos_at_big+1) ) = 20;
    %% reshape and find index of edge x
    edge_x_big_control = reshape(edge_x_big_control,Nx_big*(Ny_big+1),1 );
    real_big_edge_x_boundary = find(edge_x_big_control == 1);
    real_big_edge_x_inside = find( edge_x_big_control == 10 | edge_x_big_control == 19 );
    real_big_edge_x_useful = find( edge_x_big_control <= 19 );
    real_big_edge_x_not_useful = find( edge_x_big_control > 19 );
    real_big_edge_x_overlap_or_ghost = find( edge_x_big_control == 19 );
    %% Y big
    % Y initial useful �Ѵ����������е� y ����߶���� ������ flag 1
    edge_y_big_control(:,:) = 1;
    % Y initial inside �Ѵ����������е� y ���ڲ���߼�������� flag 10
    edge_y_big_control(2:(end-1),:) = 10;
    % Y real big overlap ��ʵ�ʵ������ʷ��У�С���񸲸���������Ӧ�Ĵ����� y ����� ����
    edge_y_big_control((left_pos_at_big):(right_pos_at_big+1),forward_pos_at_big:backward_pos_at_big) = 20;
    % Y real big real overlap and ghost
    edge_y_big_control((left_pos_at_big):(right_pos_at_big+1),[(forward_pos_at_big-1),(backward_pos_at_big+1)]) = 19;
%     % Y real big overlap ��ʵ�ʵ������ʷ��У�С���񸲸���������Ӧ�Ĵ����� y ����� ������
%     edge_y_big_control((left_pos_at_big):(right_pos_at_big+1),forward_pos_at_big:backward_pos_at_big) = 20;
    %% reshape and find index of edge y
    edge_y_big_control = reshape(edge_y_big_control,(Nx_big+1)*Ny_big,1 );
    real_big_edge_y_boundary = find(edge_y_big_control == 1);
    real_big_edge_y_inside = find( edge_y_big_control == 10 | edge_y_big_control == 19 );
    real_big_edge_y_useful = find( edge_y_big_control <= 19 );
    real_big_edge_y_not_useful = find( edge_y_big_control > 19 );
    real_big_edge_y_overlap_or_ghost = find( edge_y_big_control == 19 );
    % adjust
    real_big_edge_y_boundary = real_big_edge_y_boundary + Nedge_big(1);
    real_big_edge_y_inside   = real_big_edge_y_inside + Nedge_big(1);
    real_big_edge_y_useful   = real_big_edge_y_useful + Nedge_big(1);
    real_big_edge_y_not_useful   = real_big_edge_y_not_useful + Nedge_big(1);
    real_big_edge_y_overlap_or_ghost = real_big_edge_y_overlap_or_ghost + Nedge_big(1);
    %% add up
    real_big_edge_boundary = [real_big_edge_x_boundary;real_big_edge_y_boundary];
    real_big_edge_inside = [real_big_edge_x_inside;real_big_edge_y_inside];
    real_big_edge_useful = [real_big_edge_x_useful;real_big_edge_y_useful];
    real_big_edge_not_useful = [real_big_edge_x_not_useful;real_big_edge_y_not_useful];
    real_big_edge_overlap_or_ghost = [real_big_edge_x_overlap_or_ghost;real_big_edge_y_overlap_or_ghost];
end





