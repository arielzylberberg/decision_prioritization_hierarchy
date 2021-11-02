function ev = sample_ev_from_belief(uni_e,pe_with_blocks,sigma_e,constrain_positive)

I = ones(size(uni_e))==1;
if constrain_positive
    I(uni_e<0) = 0;
end

media = randsample(uni_e(I),1,true,pe_with_blocks(I));
ev = media + randn*sigma_e;

end