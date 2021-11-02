function var_coh = var_per_coh(motion_energy,coh,first_sample,last_sample)

me = motion_energy(:,first_sample:last_sample);
ucoh = nanunique(coh);
var_coh = nan(length(ucoh),1);
for i=1:length(ucoh)
    inds = coh==ucoh(i);
    s = me(inds,:);
    var_coh(i) = nanvar(s(:));
end
