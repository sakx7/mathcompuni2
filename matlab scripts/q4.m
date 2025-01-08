% Part A

% Define symbolic variables for resistance and voltages

syms R v_1 v_2

% Create the node admittance matrix (NAM) for the circuit

NAM = [2*R -R 0; -R 3*R -R; 0 -R 2*R];
b = [v_1; 0; v_2];
I = sym('I', [3, 1]);

% Method 1: Solve system using Cramer's Rule

% Calculate the determinant of the original matrix
delta_0 = det(NAM);

% Calculate currents using Cramer's Rule by replacing columns with b vector
for k = 1:3
    mNAM = NAM;
    mNAM(:, k) = b;
    delta_k = det(mNAM);
    I(k) = delta_k / delta_0;
end

% Add calculations for branch currents i4 and i5
I = [I;I(1)-I(2);I(2)-I(3)];

% Display results from Cramer's Rule method
disp('Currents using division (Cramer''s Rule):')
for k = 1:length(I)
    fprintf('i%d = %s\n', k, char(I(k)))
end

% Method 2: Solve system using matrix inverse
NAM_inv = inv(NAM);
I2 = NAM_inv*b;
I2 = [I2;I2(1)-I2(2);I2(2)-I2(3)];

% Display results from matrix inverse method
disp('Currents using matrix inverse:')
for k = 1:length(I2)
    fprintf('i%d = %s\n', k, char(I2(k)))
end

% Part B: Numerical computation with user-provided values
disp('----------------------------------------------------------')

% Get numerical values from user for resistance and voltages
Rs = input('Give me the R in ohms: ');
v1s = input('Give me the v_1 in volts: ');
v2s = input('Give me the v_2 in volts: ');

% Substitute numerical values into symbolic solutions and compute currents
% Display results for both methods with 6 decimal precision
I_num_c = vpa(subs(I, {R, v_1, v_2}, {Rs, v1s, v2s}), 6);
disp('Currents with given R and v_1, v_2 using Cramer''s Rule:')
for k = 1:5
    fprintf('i%d = %.6f\n', k, double(I_num_c(k)))
end

I_num_inv = vpa(subs(I2, {R, v_1, v_2}, {Rs, v1s, v2s}), 6);
disp('Currents with given R and v_1, v_2 using Matrix Inverse:')
for k = 1:length(I2)
    fprintf('i%d = %.6f\n', k, double(I_num_inv(k)))
end