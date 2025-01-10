function applyPlotFormatting(ax, fig, titleText, xlabelText, ylabelText, legendText, filename)
    if ~isempty(titleText)
        title(ax, titleText);
    end
    if ~isempty(xlabelText)
        xlabel(ax, xlabelText);
    end
    if ~isempty(ylabelText)
        ylabel(ax, ylabelText);
    end
    fig.Color = 'w';
    ax.XGrid = 'on';
    ax.YGrid = 'on';
    ax.XMinorGrid = 'on';
    ax.YMinorGrid = 'on';
    ax.XMinorTick = 'on';
    ax.YMinorTick = 'on';
    ax.TickDir = 'out';
    ax.FontName = 'Calibri';
    ax.FontSize = 12;
    if ~isempty(legendText) && ~isequal(legendText, 'None')
        legend(ax, legendText, 'Location', 'best', 'Interpreter', 'latex');
    end
    if ~isempty(filename) && ~strcmp(filename, 'None')
        outputDir = 'graphs_images';
        savePath = fullfile(outputDir,[filename,'.jpeg']);
        if ~exist(outputDir, 'dir')
            [status, msg] = mkdir(outputDir);
            if ~status
                error('Unable to create the directory "%s": %s', outputDir, msg);
            end
        end    
        try
            print(fig, savePath, '-djpeg');
        catch ME
            warning('MATLAB:%s', ME.identifier, ...
                ['Error saving image to "%s".\n' ...
                'Attempting to save in the current directory instead.\n' ...
                'Error details: %s'], savePath, ME.message);
            savePath = fullfile(pwd, [filename, '.jpeg']);
            print(fig, savePath, '-djpeg');
        end
    end
end

% Prompt user for parameters
disp('--------- Input Parameters --------');
m = input('Enter mass (m) in kg: ');
k = input('Enter spring constant (k) in N/m: ');
x0 = input('Enter initial displacement (x0) in m: ');
v0 = input('Enter initial velocity (v(0)) IVP in m/s: ');
c1 = input('Case 1: Enter first damping coefficient (c1) in Ns/m: ');
c2 = input('Case 2: Enter second damping coefficient (c2) in Ns/m: ');
disp('--------------------------------');

% Define symbolic variables
syms x(t) c; % Define symbolic variables for displacement and damping

% Differential Equation
eq = m * diff(x, t, 2) + c * diff(x, t) + k * x == 0;
disp('Differential Equations:');
fprintf('For c1 : %.2f * d^2x/dt^2 + %.2f * dx/dt + %.2f * x = 0\n', m, c1, k);
fprintf('For c2 : %.2f * d^2x/dt^2 + %.2f * dx/dt + %.2f * x = 0\n', m, c2, k);

% Velocity
vel = diff(x, t);

% Initial Conditions
cond1 = x(0) == x0;
cond2 = vel(0) == v0;

% Solve for both damping coefficients
disp('Solving differential equations...');
Sol1 = dsolve(subs(eq, c, c1), [cond1, cond2]);
Sol2 = dsolve(subs(eq, c, c2), [cond1, cond2]);

% Display the displacement solutions
disp('Solution for c1 (x(t)):');
disp(Sol1);
disp('Solution for c2 (x(t)):');
disp(Sol2);

% Compute and display the velocity (v(t)) as the derivative of the solutions
Vel1 = diff(Sol1, t);
Vel2 = diff(Sol2, t);

disp('Velocity for c1 (v(t)):');
disp(Vel1);
disp('Velocity for c2 (v(t)):');
disp(Vel2);

% Time ranges
tmin = 0;
tmax1 = 20;
tmax2 = 10;

% Plotting
fig = figure('Position', [100, 100, 800, 800]);

% Create LaTeX strings for legend
legendStr1_disp = latex(Sol1);
legendStr2_disp = latex(Sol2);
legendStr1_vel = latex(Vel1);
legendStr2_vel = latex(Vel2);

% Escape backslashes in the LaTeX string

% Displacement plot
ax1 = subplot(2,1,1);
hold on;
fplot(Sol1, [tmin, tmax1], 'r', 'LineWidth', 2);
fplot(Sol2, [tmin, tmax2], 'b', 'LineWidth', 2);
hold off;
applyPlotFormatting(ax1, fig, 'Displacement vs Time', 'Time (s)', 'Displacement (m)', ...
    {['$' legendStr1_disp '$'], ['$' legendStr2_disp '$']}, '');

% Velocity plot
ax2 = subplot(2,1,2);
hold on;
fplot(Vel1, [tmin, tmax1], 'r', 'LineWidth', 2);
fplot(Vel2, [tmin, tmax2], 'b', 'LineWidth', 2);
hold off;
applyPlotFormatting(ax2, fig, 'Velocity vs Time', 'Time (s)', 'Velocity (m/s)', ...
    {['$' legendStr1_vel '$'], ['$' legendStr2_vel '$']}, 'damped_oscillation');
