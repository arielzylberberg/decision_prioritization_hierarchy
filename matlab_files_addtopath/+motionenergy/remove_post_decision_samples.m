function motion_energy = remove_post_decision_samples(motion_energy,In2,In3)
% function motion_energy = remove_post_decision_samples(motion_energy,rt_sample)
% or 
% function motion_energy = remove_post_decision_samples(motion_energy,times,rt)
% fills with nan's the values from rt_sample (included) to the end of the
% trial

if nargin==2
    rt_sample = In2;
elseif nargin ==3 
    times = In2;
    rt = In3;
    % sanity check
    if length(times)~=size(motion_energy,2)
        error('sizes dont match')
    end
    rt_sample = findclose(times,rt);
end



if length(rt_sample)~=size(motion_energy,1)
    error('dimension mismatch')
end

for i=1:size(motion_energy,1)
     if isnan(rt_sample(i)) || rt_sample(i)<1
         motion_energy(i,:) = nan;
     else
        motion_energy(i,rt_sample(i):end) = nan;
     end
end