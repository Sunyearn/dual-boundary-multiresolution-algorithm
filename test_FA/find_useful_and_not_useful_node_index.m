function [real_node_boundary,...
          real_node_inside,...
          real_node_useful,...
          real_node_not_useful,...
          real_node_overlap_ghost,...
          real_small_node_replace_big_boundary] =...
              find_useful_and_not_useful_node_index(Nx_big,Ny_big,Nnode,...
                                                    Nx_small,Ny_small,nnode,...
                                            left_pos_at_big,right_pos_at_big,forward_pos_at_big,backward_pos_at_big,ratio)
                            
    
    [real_big_node_boundary,...
     real_big_node_inside,...
     real_big_node_useful,...
     real_big_node_not_useful,...
     real_big_node_overlap_or_ghost]=...
            find_big_node_useful(Nx_big,Ny_big,...
                         left_pos_at_big,right_pos_at_big,forward_pos_at_big,backward_pos_at_big);
                     
    [real_small_node_boundary,...
     real_small_node_inside,...
     real_small_node_useful,...
     real_small_node_not_useful,...
     real_small_node_overlap_or_ghost,...
     real_small_node_replace_big_boundary]=...
            find_small_node_useful(Nx_small,Ny_small,Nnode,...
                                        left_pos_at_big,right_pos_at_big,forward_pos_at_big,backward_pos_at_big,ratio);
    
%     real_big_edge_useful = [];
    real_node_boundary = [real_big_node_boundary;real_small_node_boundary];
    real_node_inside   = [real_big_node_inside;real_small_node_inside];
    real_node_useful = [real_big_node_useful;real_small_node_useful];
    real_node_not_useful = [real_big_node_not_useful;real_small_node_not_useful];
%     real_node_overlap_ghost = [real_big_node_overlap_or_ghost,real_small_node_overlap_or_ghost];
    real_node_overlap_ghost.small = real_small_node_overlap_or_ghost;
    real_node_overlap_ghost.big = real_big_node_overlap_or_ghost;
    real_small_node_replace_big_boundary = ...
                 [real_small_node_replace_big_boundary,real_big_node_boundary];
end