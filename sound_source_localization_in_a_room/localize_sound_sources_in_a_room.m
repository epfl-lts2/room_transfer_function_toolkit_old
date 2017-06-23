function [] = localize_sound_sources_in_a_room()
close all; clc

addpath('../room_transfer_function_toolkit_matlab');
addpath('build_room_mode_dictionary');
addpath('reconstruct_locations_of_sources');

% Input data
Lx = 3.9; Ly = 8.15; Lz = 3.35;
STEPS_X = 15; STEPS_Y = 15; STEPS_Z = 15;
pos_r = Point3D(7*Lx/STEPS_X, 3*Ly/STEPS_Y, Lz/STEPS_Z);
NUMBER_OF_WALLS = 6;
WALL_IMPEDANCES = 0.01*ones(NUMBER_OF_WALLS, 1);
TEMPERATURE = 25;

% tunable parameters
% part of the room that we are observing
MAX_X = Lx;
MAX_Y = Ly;
MAX_Z = Lz;
% up to which order of room modes to observe the data
N = 4;

figure('units','normalized','outerposition',[0 0 1 1])
termination = true;
i = 0;
while termination 
    i = i + 1;
    disp(['----------------------------------------------------------'])
    disp(['Attempt: ', num2str(i), '.'])
    
    % builf the room mode dictionary
    [selected_positions, gound_truth_positions, signal] = ...
        build_room_mode_dictionary(Lx, Ly, Lz, ...
        MAX_X, MAX_Y, MAX_Z, STEPS_X, STEPS_Y, STEPS_Z, ...
        pos_r, N, WALL_IMPEDANCES, TEMPERATURE);
    
    % try to recover the locations
    [reconstructed_indices, reconstruction_error]  = ...
        reconstruct_locations(signal, length(gound_truth_positions));
    if((reconstruction_error < 0.001) && sum(sum(reconstructed_indices))~=NaN)
        print_results(gound_truth_positions, reconstructed_indices, ...
            selected_positions, pos_r, Lx, Ly, Lz);
        termination = false;
    end
end