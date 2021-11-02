function motion_energy_norm = normalize_to_coh(motion_energy,coh,samp_first,samp_last)
% function motion_energy_norm = normalize_to_coh(motion_energy,coh,samp_first,samp_last)

if nargin<4
    samp_last = size(motion_energy,2);
end

max_coh = max(coh);
inds = coh==max_coh;
maux = motion_energy(inds,samp_first:samp_last);
m = nanmean(maux(:));

motion_energy_norm = motion_energy * max_coh / m;

