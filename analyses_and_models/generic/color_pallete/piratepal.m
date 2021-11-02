function C=piratepal(len,ch)
% colors from pirate palette (R)
% INPUTS
% len- number of color output needed
% ch - color choice(see below)

% <colors choice>  <MaxLength>
% 
% 1. basel                10
% 2. pony                 9
% 3. xmen                 8
% 4. decision             6
% 5. southpark            6
% 6. google               4
% 7. eternal              7
% 8. evildead             6
% 9. usualsuspects        7
% 10. ohbrother           7
% 11. appletv             6
% 12. brave               5
% 13. bugs                5
% 14. cars                5
% 15. nemo                5
% 16. rat                 5
% 17. up                  5
% 18. espresso            5
% 19. ipod                7
% 20. info                9
% 21. info2               15

R=load('COLORS');R=R.COLORS;
C=double(R(ch).C(1:len,:))./255;


end