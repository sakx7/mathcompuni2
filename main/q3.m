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
    ax.FontSize = 9;
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
disp('---------Input Parameters--------');
m = input('Enter the mass (m) in kg: ');
k = input('Enter the spring constant (k) in N/m: ');
x0 = input('Enter the initial displacement (x0) in m: ');

v0 = input('Enter the initial velocity (v(0)) IVP in m/s: ');

c1 = input('Case 1: Enter the first damping coefficient (c1) in Ns/m: ');
c2 = input('Case 2: Enter the second damping coefficient (c2) in Ns/m: ');

disp('--------------------------------');

% Define symbolic variables
syms x(t) c; % syms requires Symbolic Math Toolbox.

% Differential Equation
eq = m*diff(x, t, 2) + c*diff(x, t) + k*x == 0;
disp('Differential Equation:');
formattedEq = sprintf('%s * d^2x/dt^2 + %s * dx/dt + %s x = 0', ...
    (m), (c), (k));
disp(formattedEq);

% Velocity
vel = diff(x, t);

% Initial Conditions
cond1 = x(0) == x0;
cond2 = vel(0) == v0;

% Solve for both damping coefficients
disp('Solving differential equations...');
Sol1 = dsolve(subs(eq, c, c1), [cond1, cond2]);
Sol2 = dsolve(subs(eq, c, c2), [cond1, cond2]);

disp('Solution for c1:');
disp(Sol1);
disp('Solution for c2:');
disp(Sol2);

% Time ranges
tmin = 0;
tmax1 = 20;
tmax2 = 10;

% Plotting
disp('Generating plots...');
fig = figure('Position', [100, 100, 800, 600]);

for i = 1:2
    ax(i) = subplot(2, 1, i);
end

% Plot solutions
L1 = fplot(Sol1, [tmin, tmax1], 'Parent', ax(1));
L1.Color = [0.5, 0, 0.7]; 
L1.LineWidth = 3;
L1.LineStyle = '-'; 

L2 = fplot(Sol2, [tmin, tmax2], 'Parent', ax(2));
L2.Color = [0.5, 0, 0.7]; 
L2.LineWidth = 3;
L2.LineStyle = '-'; 

% Apply formatting
applyPlotFormatting(ax(1), fig, 'Displacement vs Time', 'Time, s', 'Displacement, m', '', '');
disp('Applied formatting to subplot 1.');
applyPlotFormatting(ax(2), fig, 'Velocity vs Time', 'Time, s', 'Velocity, m/s', '', 'displacement_velocity_plot');

disp('Applied formatting to subplots.');
disp('Plots generated and saved if filename provided.');
