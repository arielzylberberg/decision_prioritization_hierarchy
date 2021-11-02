function motion_energy = remove_pre_stim_samples(motion_energy,In2,In3)
% function motion_energy = remove_pre_stim_samples(motion_energy,In2,In3)
% fills with nan's the values from 1 to rt_sample (included)
% If three arguments given, In2 and In3 are time_vec and stim_time respectively


if nargin==2
    stim_sample = In2;
elseif nargin ==3 
    times = In2;
    stim_time = In3;
    % sanity check
    if length(times)~=size(motion_energy,2)
        error('sizes dont match')
    end
    stim_sample = findclose(times,stim_time);
end



if length(stim_sample)~=size(motion_energy,1)
    error('dimension mismatch')
end

[N,K] = size(motion_energy);
for i=1:N
     if isnan(stim_sample(i)) || stim_sample(i)>K
         motion_energy(i,:) = nan;
     else
        motion_energy(i,1:stim_sample(i)) = nan;
     end
end