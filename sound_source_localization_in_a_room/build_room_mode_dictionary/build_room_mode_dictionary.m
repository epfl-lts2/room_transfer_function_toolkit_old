function [selected_positions, gound_truth_positions, signal] = ...
    build_room_mode_dictionary(Lx, Ly, Lz, ...
    MAX_X, MAX_Y, MAX_Z, ...
    STEPS_X, STEPS_Y, STEPS_Z, ...
    pos_r, N, WALL_IMPEDANCES, TEMPERATURE)
% position of grid nodes data
SAMPLING_STEP_X = MAX_X/STEPS_X;
SAMPLING_STEP_Y = MAX_Y/STEPS_Y;
SAMPLING_STEP_Z = MAX_Z/STEPS_Z;
x_coordinates = SAMPLING_STEP_X:SAMPLING_STEP_X:(MAX_X-SAMPLING_STEP_X);
y_coordinates = SAMPLING_STEP_Y:SAMPLING_STEP_Y:(MAX_Y-SAMPLING_STEP_Y);
z_coordinates = SAMPLING_STEP_Z:SAMPLING_STEP_Z:(MAX_Z-SAMPLING_STEP_Z);
positions = combvec(x_coordinates, y_coordinates, z_coordinates);

% room transfer function data
eigenfrequency_table = get_eigenfrequency_table(Lx, Ly, Lz, N, TEMPERATURE);
receiver_room_mode_table = get_room_mode_table (Lx, Ly, Lz, N, pos_r);
damping_factor_table = get_damping_factor_table(Lx, Ly, Lz, ...
    WALL_IMPEDANCES, N, TEMPERATURE);
K_table = get_K_table(Lx, Ly, Lz, N);
resonant_frequencies = eigenfrequency_table(:);
resonant_frequencies(resonant_frequencies == 0) = [];

% select uniformly at random the observation points on the sound source grid
% and resonant frequency grid to be taken into account for constructing the 
% dictionary
N_RESONANT_FREQUENCIES = 40;                        % height of the dictionary
N_POTENTIAL_POSITIONS = ceil(size(positions, 2)/2); % width of the dictionary
selected_frequencies = datasample(resonant_frequencies, ...
    N_RESONANT_FREQUENCIES, 'Replace', false);
selected_positions = datasample(positions, N_POTENTIAL_POSITIONS, 2, ...
    'Replace', false);

[signal, gound_truth_positions] = get_test_signal(N, Lx, Ly, Lz, ...
    SAMPLING_STEP_X, SAMPLING_STEP_Y, SAMPLING_STEP_Z, ...
    receiver_room_mode_table, eigenfrequency_table, ...
    damping_factor_table, K_table, TEMPERATURE, selected_frequencies);
% generate mode values for selected nodes and form a dictionary
tic

% STEP 1: generate the room transfer function part of the dictionary
dictionary_rtf = [];
for i = 1:length(selected_positions)
    source_room_mode_table = get_room_mode_table (Lx, Ly, Lz, N, ...
        Point3D(selected_positions(1, i), ...
        selected_positions(2, i), ...
        selected_positions(3, i)));
    [Hf, ~] = transfer_function_fourier(N, source_room_mode_table, ...
        receiver_room_mode_table, eigenfrequency_table, ...
        damping_factor_table, K_table, TEMPERATURE, selected_frequencies);
    Hf = abs(Hf);
    Hf = Hf/norm(Hf);
    dictionary_rtf = [dictionary_rtf Hf];
end

% STEP 2: generate the inverse discrete Fourier transform of the dictionary
% we need the values of the IDFT at the resonant frequencies
% requirements:
% 1. has Vandermonde form
% 2. covers resonant_frequencies
% dictionary_ift = conj(dftmtx(n))/n;

% dictionary = dictionary_ift*dictionary_rtf;
dictionary = dictionary_rtf;
elapsed_time = toc;

[m,n] = size(dictionary);
disp(['It took: ', num2str(elapsed_time), 's to create a dictionary.'])
disp(['The dictionary size is: ', num2str(m), 'x', num2str(n), '.'])
save('../data/dictionary.mat', 'dictionary', 'selected_positions', ...
    'Lx', 'Ly', 'Lz')
disp('Data written to the dictionary')

dictionary_benchmarking