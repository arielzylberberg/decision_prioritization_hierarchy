function parents = get_parents(node)

parents_fnode = [1,nan, nan, nan; 
                 2, 1, nan, nan; 
                 3, 1, nan, nan; 
                 4, 1, 2, nan; 
                 5, 1, 2, nan; 
                 6, 1, 3, nan; 
                 7, 1, 3, nan;
                 8, 1, 2, 4;
                 9, 1, 2, 4;
                 10, 1, 2, 5;
                 11, 1, 2, 5;
                 12, 1, 3, 6;
                 13, 1, 3, 6;
                 14, 1, 3, 7;
                 15, 1, 3, 7];
             
p = parents_fnode(node,2:end);
parents = p(~isnan(p));