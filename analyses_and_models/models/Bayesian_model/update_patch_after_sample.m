function posterior = update_patch_after_sample(x,px,ev_sample,s)

px = px/sum(px);

likelihood = normpdf(ev_sample,x,s);
posterior = likelihood.*px;
posterior = posterior/sum(posterior);

end
