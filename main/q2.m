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
h = [0 3 6 9 12 15 18 21 24 27 30 33];
D = [1.2 0.91 0.66 0.47 0.31 0.19 0.12 0.075 0.046 0.029 0.018 0.011];

% Combine the arrays into a 2xN matrix also known as zipping
data = [h; D];

% Create first figure
fig1 = figure;
fig1.Color = [1, 1, 1];

% Loop for subplots
for i = 1:4
    ax(i) = subplot(2, 2, i);
    L(i) = line(data(1, :), data(2, :), 'Parent', ax(i));
    
    % Configure line properties
    L(i).Color = [0.2, 0.7, 0];
    L(i).LineWidth = 3;
    L(i).LineStyle = '-';
    
    % Apply axis transformations based on subplot
    switch i
        case 1
            ax(i).XScale = 'linear';
            ax(i).YScale = 'linear';
            title = 'Linear Scale';  % Legend for linear axes
        case 2
            ax(i).XScale = 'log';
            ax(i).YScale = 'linear';
            title = 'Log-Linear Scale';  % Legend for log-linear axes
        case 3
            ax(i).XScale = 'linear';
            ax(i).YScale = 'log';
            title = 'Linear-Log Scale';  % Legend for linear-log axes
        case 4
            ax(i).XScale = 'log';
            ax(i).YScale = 'log';
            title = 'Log-Log Scale';  % Legend for log-log axes
    end
    if i==5
        applyPlotFormatting(ax(i), fig1,title,'\ith \rm, km','\itD\rm, kg/m^{3}','','');
    else
        applyPlotFormatting(ax(i), fig1,title,'\ith \rm, km','\itD\rm, kg/m^{3}','', 'subplts');
    end
end

% Adjust scales for specific subplots
ax(2).XScale = 'log';
ax(3).YScale = 'log';
ax(4).XScale = 'log';
ax(4).YScale = 'log';

% Fit data to exponential model

res = fit(data(1, :)', data(2, :)', 'exp1');

% fit requires one of the following:
%   Curve Fitting Toolbox
%   Model-Based Calibration Toolbox
%   Predictive Maintenance Toolbox
%   SimBiology
%   Statistics and Machine Learning Toolbox 


% Create second figure for the fitted curve
fig2 = figure;
fig2.Color = [1, 1, 1];

% Generate fitted line data
hplot = linspace(min(data(1, :)), max(data(1, :)), 1000);
Dplot = res.a * exp(res.b * hplot);

% Plot data and fitted curve
ax1 = subplot(1, 1, 1);

% Plot original data points
Y1 = line(data(1, :), data(2, :), 'Parent', ax1);
Y1.Color = 'r';
Y1.LineStyle = 'none';
Y1.LineWidth = 2;
Y1.Marker = 'o';
Y1.MarkerSize = 8;

% Plot fitted curve
Y2 = line(hplot, Dplot, 'Parent', ax1);
Y2.Color = 'g';
Y2.LineStyle = '-';
Y2.LineWidth = 2;

fprintf('D = %.3f e^{%.3f h}\n', res.a, res.b)

% Add title and labels using the applyPlotFormatting function
applyPlotFormatting(ax1, fig2, 'Exponential Fit', '\ith \rm, km', '\itD\rm, kg/m^{3}', ...
    {'Data Points', sprintf('$\\mathit{D} = %.3f e^{%.3f \\mathit{h}}$', res.a, res.b)}, 'fitted_curve');
