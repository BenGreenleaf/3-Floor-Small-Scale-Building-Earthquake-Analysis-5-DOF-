% A matlab program to plot the theoretical response of the building in the
% 1A vibration lab.
% Based on code written by Penny Cox, now maintained by Aidan Reilly.
%  Tidied up by Jim Woodhouse October 2012
%
close all
clear all

m = 1.83; % mass of one floor
L = 0.2; % length
N = 4; % number of degrees of freedom
b = 0.08; % width
E = 210E9; % Young's Modulus
d = 0.001; % thickness
I = b*d*d*d/12; % second moment of area
k = (24*E*I)/(L*L*L); % static stiffness for each floor
c = 2.229;
k3d = 60.56;
m3d = 0.183;
c3d = 1.55;

k2d = 60.56;
m2d = 0.183;

points = [];

for c2d_variable = 1:500;
    c2d = c2d_variable/100;
    
    M = m*[1 0 0 0 0; 0 1 0 0 0; 0 0 1 0 0; 0 0 0 m3d/m 0; 0 0 0 0 m2d/m];
    K = k*[2 -1 0 0 0;-1 2+(k2d/k) -1 0 -(k2d/k);0 -1 (1+(k3d/k)) -k3d/k 0; 0 0 -k3d/k k3d/k 0; 0 -(k2d/k) 0 0 (k2d/k)];
    C = c*[2 -1 0 0 0;-1 2+(c2d/c) -1 0 -(c2d/c);0 -1 (1+(c3d/c)) -c3d/c 0; 0 0 -c3d/c c3d/c 0; 0 -(c2d/c) 0 0 (c2d/c)];


    syms w;
    
    % To include vibration absorbers, you will need to modify
    %   the mass and stiffness matrices (above)
    
    B = K + 1i*w*C - w^2*M;
    % harmonic solution for unit force at floor 1
    disp = (inv(B))*[1;0;0;0;0];
    
    % Calculate frequency response functions
    all_disp = [];
    for w = 1:130;
      B = K + 1i*w*C - w^2*M;  % include damping
      disp = B \ [1;0;0;0;0];       % harmonic response at floor 1
      all_disp = [all_disp disp];
    end
    w = 1:130;
    
    maxes = max(abs(all_disp), [], 2);
    avg_max = mean(maxes(1:3));

    newPoint = [c2d, avg_max];
    points = [points; newPoint];
    
end

plot(points(:,1), points(:,2), '-');   % 'o' = circle markers, '-' = connect lines (optional)
xlabel('C2d Value (N/s)'); ylabel('Avg Max Floor Displacement (m)');
title('C2d Damping Coefficient vs Avg Max Floor Displacement');
grid on;