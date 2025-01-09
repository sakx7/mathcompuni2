% Constants
g = 9.81;  % gravity (m/s^2)
L = 1;     % pendulum length (m)

% Time span for simulation
tspan = [0 15];

% Function to create state-space representation of pendulum dynamics
function dydt = pendulum_dynamics(t, y, a_func)
    % y(1) = theta
    % y(2) = theta_dot
    g = 9.81;
    L = 1;
    a = a_func(t);  % Get acceleration at time t
    
    dydt = zeros(2,1);
    dydt(1) = y(2);
    dydt(2) = (a*cos(y(1)) - g*sin(y(1)))/L;
end

% Define acceleration functions for each case
a_const = @(t) 5;           % Case a & b: constant acceleration
a_linear = @(t) 0.5*t;      % Case c: linear acceleration

% Solve using ode45 for each case
% Case a: constant acceleration, theta(0) = 0.5
[t_a, y_a] = ode45(@(t,y) pendulum_dynamics(t, y, a_const), tspan, [0.5; 0]);

% Case b: constant acceleration, theta(0) = 3
[t_b, y_b] = ode45(@(t,y) pendulum_dynamics(t, y, a_const), tspan, [3; 0]);

% Case c: linear acceleration, theta(0) = 3
[t_c, y_c] = ode45(@(t,y) pendulum_dynamics(t, y, a_linear), tspan, [3; 0]);

% Animation function
function animate_pendulum(t, y, case_label)
    figure('Name', ['Pendulum Motion - Case ', case_label]);
    L = 1;  % pendulum length
    
    % Calculate pendulum position
    x = L * sin(y(:,1));
    z = -L * cos(y(:,1));
    
    % Create animation
    for i = 1:length(t)
        % Plot pendulum rod
        plot([0 x(i)], [0 z(i)], 'b-', 'LineWidth', 2);
        hold on
        
        % Plot bob
        plot(x(i), z(i), 'ro', 'MarkerFaceColor', 'r', 'MarkerSize', 10);
        
        % Plot pivot point
        plot(0, 0, 'ko', 'MarkerFaceColor', 'k', 'MarkerSize', 5);
        
        % Set axis properties
        axis([-1.5 1.5 -1.5 1.5]);
        grid on
        title(sprintf('Pendulum Motion - Case %s (t = %.2f s)', case_label, t(i)));
        xlabel('x (m)');
        ylabel('z (m)');
        
        hold off
        drawnow
        pause(0.01);
    end
end

% Create animations for each case
animate_pendulum(t_a, y_a, 'a');
animate_pendulum(t_b, y_b, 'b');
animate_pendulum(t_c, y_c, 'c');

% Plot angular displacement vs time for comparison
figure('Name', 'Angular Displacement Comparison');
plot(t_a, y_a(:,1), 'b-', 'LineWidth', 1.5);
hold on
plot(t_b, y_b(:,1), 'r-', 'LineWidth', 1.5);
plot(t_c, y_c(:,1), 'g-', 'LineWidth', 1.5);
grid on
xlabel('Time (s)');
ylabel('Angular Displacement (rad)');
legend('Case a', 'Case b', 'Case c');
title('Angular Displacement vs Time');