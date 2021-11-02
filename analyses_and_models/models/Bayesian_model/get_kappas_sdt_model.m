function [kappas, v_theta, noise_scalings] = get_kappas_sdt_model()

datadir = '../detection_model/';
nsuj = 4;
for i=1:nsuj
    filename = (['optim',num2str(i),'.mat']);
    a = load(fullfile(datadir,filename),'theta');
    kappas(i) = a.theta(1);
    noise_scalings(i) = a.theta(6);
    v_theta(i,:) = a.theta;
end