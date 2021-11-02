function pe_with_blocks = pcoh_given_pright_with_blocks(uni_e, pe_noblocks, pright_given_blocked)

    I = uni_e>0; % assumes there are no zero vals
    pe_with_blocks = pe_noblocks; % init
    pe_with_blocks(I) = pe_with_blocks(I)/(sum(pe_with_blocks(I))) * pright_given_blocked;
    J = I==0;
    pe_with_blocks(J) = pe_with_blocks(J)/(sum(pe_with_blocks(J))) * (1-pright_given_blocked);
    
end