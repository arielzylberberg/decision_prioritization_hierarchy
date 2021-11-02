function confidence_right_motion = calc_confidence(ev_row, uni_mu, uni_sigma)

p = nan(length(uni_mu),length(ev_row));
for i=1:length(uni_mu)
    p(i,:) = normpdf(ev_row,uni_mu(i),uni_sigma(i));
end

p = prod(p,2);
p = p/sum(p);
pright = sum(p(uni_mu>0));
confidence_right_motion = pright; % now returns the confidence in rightward motion
% confidence = max(pright, 1-pright);

end