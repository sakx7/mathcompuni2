addpath('functions/');

% Data
h = [0, 2300, 3000, 6100, 7900, 10000, 12000]; % Altitudes (m)
t_b = [100, 98.8, 95.1, 92.2, 90, 81.2, 75.6]; % Boiling temperatures (°C)

% Perform linear regression
p = polyfit(h, t_b, 1);

% Extract slope and intercept
slope = p(1);
intercept = p(2);

% Display results
fprintf('The slope of the line (rate of change) is: %.4f\n', slope);
fprintf('The y-intercept of the line is: %.4f\n', intercept);

% Generate line of best fit
x_fit = linspace(min(h), max(h), 100);
y_fit = polyval(p, x_fit);

% Plot data and line of best fit
figure;
ax = gca;
fig = gcf;

scatter(h, t_b, 'o'); % Plot data points
hold on;
plot(x_fit, y_fit, '-r', 'LineWidth', 2); % Plot line of best fit

applyPlotFormatting( ...
    ax, ...
    fig, ...
    'Altitudes vs. Boiling Temperatures', ... % Title
    'Altitude (m)', ... % X-axis label
    'Boiling Temperature (°C)', ... % Y-axis label
    {'Data Points', sprintf('h = %.3f t + %.3f', slope, intercept)}, ... % Legend entries
    'altitudes_vs_boiling_temperatures'); % Save filename
