close all; clc;

%% TRANSIENT RESPONSE SIMULATION (TIME DOMAIN)
% Define time vector
tspan = 0:0.001:120; % 5 seconds with 1 ms timestep

fs = 500;          % sampling frequency in Hz
t_data = (0:length(f0)-1)/fs;  % time vector for the samples

% Define different force inputs at floor 1
F_impulse = @(t) [1*(t<0.01);0;0];       % short impulse of 0.01 s
F_step    = @(t) [1*(t>=0);0;0];         % step input starting at t=0
F_sine    = @(t) [sin(2*pi*5*t);0;0];    % 5 Hz sinusoidal force
F_interp = @(t) [interp1(t_data, f0, t, 'linear', 0); 0; 0]; 
% Choose the input you want
F = F_interp; % replace with F_step or F_sine as needed

% Define the ODE function
odefun = @(t,x) [x(N+1:end); M\(-K*x(1:N) - C*x(N+1:end) + F(t))];

% Initial condition: zero displacement and velocity
x0 = zeros(2*N,1);

% Solve the ODE
[t_sol, x_sol] = ode45(odefun, tspan, x0);

% Extract displacements
x_disp = x_sol(:,1:N);
x_vel  = x_sol(:,N+1:2*N);   % velocity

x_acc = zeros(length(t_sol), N); 
for i = 1:length(t_sol)
    x_acc(i,:) = (M \ (F_interp(t_sol(i)) - C*x_vel(i,:).' - K*x_disp(i,:).')).';
end

peak_disp = max(abs(x_disp));
peak_acc = max(abs(x_acc));

[~, idx_disp] = max(abs(x_disp));
t_peak_disp = t_sol(idx_disp);

[~, idx_acc] = max(abs(x_acc));
t_peak_acc = t_sol(idx_acc);

fprintf('Peak Response for Each Floor:\n');
fprintf('Floor\tDisplacement (m)\tTime (s)\tAcceleration (m/s^2)\tTime (s)\n');

for i = 1:N
    fprintf('%d\t\t\t%.4f\t\t\t%.4f\t\t%.4f\t\t\t\t\t%.4f\n',...
        i, peak_disp(i), t_peak_disp(i), peak_acc(i), t_peak_acc(i));
end

% Plot transient response of each floor
figure
hold on
plot(t_sol, x_disp(:,1), 'b', 'LineWidth',1.5)
plot(t_sol, x_disp(:,2), 'r', 'LineWidth',1.5)
plot(t_sol, x_disp(:,3), 'g', 'LineWidth',1.5)
xlabel('Time (s)')
ylabel('Displacement (m)')
title('Transient Response of 3-Floor Building')
legend('Floor 1','Floor 2','Floor 3')
grid on

figure
plot(t_data, f0)
xlabel('Time (s)')
ylabel('Force (N)')
title('Input Force')
grid on

figure
hold on
plot(t_sol, x_acc(:,1), 'b', 'LineWidth',1.5)
plot(t_sol, x_acc(:,2), 'r', 'LineWidth',1.5)
plot(t_sol, x_acc(:,3), 'g', 'LineWidth',1.5)
xlabel('Time (s)')
ylabel('Acceleration (m/s^2)')
title('Transient Acceleration of 3-Floor Building')
legend('Floor 1','Floor 2','Floor 3')
grid on

