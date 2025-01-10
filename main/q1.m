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


% Data
h = [0, 2300, 3000, 6100, 7900, 10000, 12000]; % Altitudes (m)
t_b = [100, 98.8, 95.1, 92.2, 90, 81.2, 75.6]; % Boiling temperatures (degrees)

% Perform linear regression
p = polyfit(h, t_b, 1);

% Extract slope and intercept
slope = p(1);
intercept = p(2);

% Display results
fprintf('The slope of the line (rate of change) is: %.4f\n', slope);
fprintf('The y-intercept of the line is: %.4f\n', intercept);
disp('-------------Linear Function-----------------')
fprintf('T_b = %.4f h + %.4f \n', slope, intercept);

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
    'Boiling Temperature (^\circ{C})', ... % Y-axis label
    {'Data Points', sprintf('h = %.3f t + %.3f', slope, intercept)}, ... % Legend entries
    'altitudes_vs_boiling_temperatures'); % Save filename
