function [real_edge_boundary,...
          real_edge_inside,...
          real_edge_useful,...
          real_edge_not_useful,...
          real_edge_overlap_or_ghost] = find_inside_and_boundary_edge_index(...
                                Nx_big,Ny_big,Nedge_big,...
                                Nx_small,Ny_small,Nedge_small,...
                                left_pos_at_big,right_pos_at_big,forward_pos_at_big,backward_pos_at_big,ratio)
                            
    
    [real_big_edge_boundary,...
          real_big_edge_inside,...
          real_big_edge_useful,...
          real_big_edge_not_useful,...
          real_big_edge_overlap_or_ghost]=...
            find_big_edge_useful(Nx_big,Ny_big,Nedge_big,...
                         left_pos_at_big,right_pos_at_big,forward_pos_at_big,backward_pos_at_big);
                     
    [real_small_edge_boundary,...
        real_small_edge_inside,...
        real_small_edge_useful,...
        real_small_edge_not_useful,...
        real_small_edge_overlap_or_ghost]=...
            find_small_edge_useful(Nx_small,Ny_small,Nedge_small,Nedge_big,...
                                        left_pos_at_big,right_pos_at_big,forward_pos_at_big,backward_pos_at_big,ratio);
    
%     real_big_edge_useful = [];
    real_edge_boundary = [real_big_edge_boundary;real_small_edge_boundary];
    real_edge_inside   = [real_big_edge_inside;real_small_edge_inside];
    real_edge_useful = [real_big_edge_useful;real_small_edge_useful];
    real_edge_not_useful = [real_big_edge_not_useful;real_small_edge_not_useful];
    real_edge_overlap_or_ghost.small = real_small_edge_overlap_or_ghost;
    real_edge_overlap_or_ghost.big = real_big_edge_overlap_or_ghost;
end