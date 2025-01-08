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
    if ~isempty(legendText) && ~strcmp(legendText, 'None')
        legend(ax, legendText, 'Location', 'best');
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
