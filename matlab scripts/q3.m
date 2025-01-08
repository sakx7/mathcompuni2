%% Q3
syms x(t) c;
m = 10;
k = 28;
c1 = 3; 
c2 = 50;
x0 = 0.18;
v0 = 0;
eq = m*diff(x,t,2) + c*diff(x,t) + k*x == 0;
vel = diff(x,t);
cond1 = x(0) == x0;
cond2 = vel(0) == v0;
Sol1 = dsolve(subs(eq,c, c1),[cond1,cond2]);
Sol2 = dsolve(subs(eq, c, c2),[cond1,cond2]);
tmin = 0;
tmax1 = 20;
tmax2 = 10;

fig = figure('Position', [100, 100, 800, 600]);
for i = 1:2
    ax(i) = subplot(2,1,i);
end

L1 = fplot(Sol1,[tmin, tmax1],'Parent',ax(1));
L1.Color = [0.5,0,0.7]; 
L1.LineWidth = 3;
L1.LineStyle = '-'; 

L2 = fplot(Sol2,[tmin, tmax2],'Parent',ax(2));
L2.Color = [0.5,0,0.7]; 
L2.LineWidth = 3;
L2.LineStyle = '-'; 

% Apply formatting to the first subplot
applyPlotFormatting(ax(1), fig, 'Displacement vs Time', 'Time, s', 'Displacement, m', '', 'displacement_plot');
% Apply formatting to the second subplot
applyPlotFormatting(ax(2), fig, 'Velocity vs Time', 'Time, s', 'Velocity, m/s', '', 'velocity_plot');

