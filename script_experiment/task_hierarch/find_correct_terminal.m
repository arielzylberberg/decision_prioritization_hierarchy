function nodo = find_correct_terminal(tree,vDir)

nodo = 1;
terminal = 0;
while terminal == 0
    inds = tree.connections(:,1)==nodo;
    I = tree.connections(inds,2);
    x = [tree.nodes(I).x];
    if vDir(nodo)==0 % right
        [~,ind] = max(x);
    elseif vDir(nodo)==180 %left
        [~,ind] = min(x);
    end
    nodo = I(ind);
    if nodo>7
        terminal = 1;
    end
end




end