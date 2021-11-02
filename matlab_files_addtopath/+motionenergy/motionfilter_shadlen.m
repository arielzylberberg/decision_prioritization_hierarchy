function [energy_right,energy_left] = motionfilter_shadlen(stim,sampleduration,varargin)
%stim: time, irrelevant, relevant
%http://www.lifesci.sussex.ac.uk/home/George_Mather/EnergyModel.htm

sigmac  = 0.5; %era 0.35 grados
sigmag  = 0.05; %grados
t_const = 60;
degperbin = 0.0260; % leerlo de afuera !!!
doplot = 0;
speed_deg_per_sec_for_plot = 5; %only for plot !!

max_t = 0.3;      % Duration of impulse response (sec)
max_x = 0.8;         %Half-width of filter (deg)

slow_n = 5; % Width of the slow temporal filter
fast_n = 3; % Width of the fast temporal filter
beta = 1;  % Beta. Represents the weighting of the negative

degperbin_y = nan;

for i=1:length(varargin)
    if isequal(varargin{i},'sigmac')
        sigmac = varargin{i+1};
    elseif isequal(varargin{i},'sigmag')
        sigmag = varargin{i+1};
    elseif isequal(varargin{i},'t_const')
        t_const = varargin{i+1};
    elseif isequal(varargin{i},'max_t')
        max_t = varargin{i+1};
    elseif isequal(varargin{i},'max_x')
        max_x = varargin{i+1};
    elseif isequal(varargin{i},'degperbin')    
        degperbin = varargin{i+1};
    elseif isequal(varargin{i},'degperbin_y')    
        degperbin_y = varargin{i+1};
    elseif isequal(varargin{i},'speed_deg_per_sec')    
        speed_deg_per_sec_for_plot = varargin{i+1};
    elseif isequal(varargin{i},'doplot')
        doplot = varargin{i+1};
    elseif isequal(varargin{i},'slow_n')
        slow_n = varargin{i+1};
    elseif isequal(varargin{i},'fast_n')
        fast_n = varargin{i+1};
    elseif isequal(varargin{i},'beta')
        beta = varargin{i+1};
    end
end

%corregir segun dimension de stim
% [nt_stim,n_irrelevant,nx_stim] = size(stim);

dt = sampleduration; % time per sample
dx = degperbin;
if isnan(degperbin_y)
    degperbin_y = degperbin;
end
dy = degperbin_y;
%--------------------------------------------------------------------------
%           Create component spatiotemporal filters
%--------------------------------------------------------------------------

x_filt_aux  = 0:dx:max_x;
x_filt      = sort(unique([x_filt_aux -x_filt_aux]));% A row vector holding spatial sampling intervals
nx          = length(x_filt);


alfa        = atan(x_filt/sigmac);
even_x      = (cos(alfa).^4 .* cos(4*alfa)); %even
odd_x       = (cos(alfa).^4 .* sin(4*alfa)); %odd
even_x      = reshape(even_x,[1 1 nx]);
odd_x       = reshape(odd_x,[1 1 nx]);


% spatial filter in the orthogonal dimension
max_y       = 0.2;
y_filt_aux  = 0:dy:max_y;
% A row vector holding spatial sampling intervals
y_filt      = sort(unique([y_filt_aux -y_filt_aux]));
ny          = length(y_filt);
gauss_y     = exp(-y_filt.^2/sigmag.^2);% despues permuto dimensiones
gauss_y     = reshape(gauss_y,[1 ny 1]);


%tiempo
% max_t   = 0.3;      % Duration of impulse response (sec)
t_filt  = [0:dt:max_t]'; % A column vector holding temporal sampling intervals
nt      = length(t_filt);

% prev. version
% slow_t  = (t_const*t_filt).^5.*exp(-t_const*t_filt).*(1/factorial(5)-(t_const*t_filt).^2/factorial(5+2));
% fast_t  = (t_const*t_filt).^3.*exp(-t_const*t_filt).*(1/factorial(3)-(t_const*t_filt).^2/factorial(3+2));


% Temporal filter response (formula as in Adelson & Bergen, 1985, Eq. 1)
fast_t = (t_const*t_filt).^fast_n .* exp(-t_const*t_filt).*(1/factorial(fast_n)-beta.*((t_const*t_filt).^2)/factorial(fast_n+2));
slow_t = (t_const*t_filt).^slow_n .* exp(-t_const*t_filt).*(1/factorial(slow_n)-beta.*((t_const*t_filt).^2)/factorial(slow_n+2));



%--------------------------------------------------------------------------
%           Convolve
%--------------------------------------------------------------------------

% aux calculations
stimy               = convn(gauss_y,stim);
oddx_stimy          = convn(odd_x,stimy);
evenx_stimy         = convn(even_x,stimy);
fast_oddx_stimy     = convn(fast_t,oddx_stimy);
slow_oddx_stimy     = convn(slow_t,oddx_stimy);
fast_evenx_stimy    = convn(fast_t,evenx_stimy);
slow_evenx_stimy    = convn(slow_t,evenx_stimy);

% go
resp_right_1    = - fast_oddx_stimy + slow_evenx_stimy;
resp_right_2    =   slow_oddx_stimy + fast_evenx_stimy;
resp_left_1     =   fast_oddx_stimy + slow_evenx_stimy;
resp_left_2     = - slow_oddx_stimy + fast_evenx_stimy;

%--------------------------------------------------------------------------
%         Square the filter output
%--------------------------------------------------------------------------
resp_left_1     = resp_left_1.^2;
resp_left_2     = resp_left_2.^2;
resp_right_1    = resp_right_1.^2;
resp_right_2    = resp_right_2.^2;

% %--------------------------------------------------------------------------
% %         Normalise the filter output
% %--------------------------------------------------------------------------
% 
energy_right    = resp_right_1 + resp_right_2;
energy_left     = resp_left_1 + resp_left_2;
% 
% % Calc total energy
% total_energy    = sum(energy_right(:))+sum(energy_left(:));
% 
% % Normalise each directional o/p by total output
% RR1 = sum(resp_right_1(:))/total_energy;
% RR2 = sum(resp_right_2(:))/total_energy;
% LR1 = sum(resp_left_1(:))/total_energy;
% LR2 = sum(resp_left_2(:))/total_energy;
% 
% %--------------------------------------------------------------------------
% %         Sum the paired filters in each direction
% %--------------------------------------------------------------------------
% right_Total = RR1+RR2;
% left_Total  = LR1+LR2;
% %--------------------------------------------------------------------------
% 
% %--------------------------------------------------------------------------
% %         Calculate net energy as the R-L difference
% %--------------------------------------------------------------------------
% % motion_energy = right_Total - left_Total;


%% plot the filters
% doplot = 1;
if (doplot)
    
    % % Step 1c: combine space and time to create spatiotemporal filters
    e_slow = slow_t * even_x(:)';    %SE/TS
    e_fast = fast_t * even_x(:)';   %SE/TF
    o_slow = slow_t * odd_x(:)';   %SO/TS
    o_fast = fast_t * odd_x(:)';   % SO/TF
    % %
    % % %--------------------------------------------------------------------------
    % % %         STEP 2: Create spatiotemporally oriented filters
    % % %--------------------------------------------------------------------------
    left_1  = o_fast + e_slow;      % L1
    left_2  = -o_slow + e_fast;     % L2
    right_1 = -o_fast + e_slow;    % R1
    right_2 = o_slow + e_fast;     % R2

    
    figure(3)
%     xx = [0 10]*degperbin;
    
    xx = [0 1]*speed_deg_per_sec_for_plot*(3*dt);%para plotear 5 grados por sec
    tt = [0 3]*dt;
    imagesc(x_filt,t_filt,left_1)
    hold on; plot(xx,tt,-xx,tt,'b')
    xlabel('deg'); ylabel('time')
    
    figure(4)
    subplot(2,2,1);
    imagesc(x_filt,t_filt,left_1)
    hold on; plot(xx,tt,-xx,tt,'b')
    xlabel('deg'); ylabel('time')
    subplot(2,2,2); imagesc(x_filt,t_filt,left_2)
    hold on; plot(xx,tt,-xx,tt,'b')
    subplot(2,2,3); imagesc(x_filt,t_filt,right_1)
    hold on; plot(xx,tt,-xx,tt,'b')
    subplot(2,2,4); imagesc(x_filt,t_filt,right_2)
    hold on; plot(xx,tt,-xx,tt,'b')
    
    %fourier - in prep
    NFFTt = 100;
    NFFTx = 100;
    ff = abs(fftshift(fft2(right_1,NFFTt,NFFTx)));
    Fsx = 1/dx;
    fx  = Fsx/2*[-1:2/NFFTx:1-2/NFFTx];
    Fst = 1/dt;
    ft  = Fst/2*[-1:2/NFFTt:1-2/NFFTt];
    
    figure(5)
    imagesc(ft,fx,ff')
    xlabel('temporal freq (Hz)')
    ylabel('spatial freq (c/deg)')
    hold on
    xx = xlim;
    speed = speed_deg_per_sec_for_plot;%deg/sec
    yy = -1/speed * xx; 
    plot(xx,yy,'r')
    
%     pause

    
end

