function coh_multip  = coh_multiplier(terminal_node)
% signs to multiply the three coherences leading to a terminal node, to get
% them relative to the choices


% switch terminal_node
%     case 8
%         coh_multip = [-1,-1,-1];
%     case 9
%         coh_multip = [-1,-1,1];
%     case 10
%         coh_multip = [-1,1,-1];
%     case 11
%         coh_multip = [-1,1,1];
%     case 12
%         coh_multip = [1,-1,-1];
%     case 13
%         coh_multip = [1,-1,1];
%     case 14
%         coh_multip = [1,1,-1];
%     case 15
%         coh_multip = [1,1,1];
% end


C = [-1,-1,-1;
     -1,-1,1;
     -1,1,-1;
     -1,1,1;
      1,-1,-1;
      1,-1,1;
      1,1,-1;
      1,1,1];
coh_multip = C(terminal_node-7,:);