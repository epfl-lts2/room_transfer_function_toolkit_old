function [  ] = print_results(gound_truth_positions, ...
    reconstructed_indices, position_grid, pos_r, Lx, Ly, Lz)
% show the potential postion grid
plot3(position_grid(1,:), position_grid(2,:), position_grid(3,:), 'oy')
hold on
% show the ground truth positions
[x, y, z] = get_coordinates(gound_truth_positions(1));
plot3(x, y, z, 'ob', 'Linewidth', 3);
[x, y, z] = get_coordinates(gound_truth_positions(2));
plot3(x, y, z, 'ob', 'Linewidth', 3);
[x, y, z] = get_coordinates(gound_truth_positions(3));
plot3(x, y, z, 'ob', 'Linewidth', 3);
% show the reconstructed positions
plot3(position_grid(1, reconstructed_indices), ...
    position_grid(2, reconstructed_indices), ...
    position_grid(3, reconstructed_indices), '*g', 'Linewidth', 3);

% show the microphone position
[x, y, z] = get_coordinates(pos_r);
plot3(x, y, z, 'o', 'MarkerFaceColor', 'r','MarkerSize', 10);
xlim([0 Lx])
ylim([0 Ly])
zlim([0 Lz])
axis equal
    
disp('Initial positions')
disp(gound_truth_positions)

reconstructed_indices = sort(reconstructed_indices);
disp('Reconstructed positions')
disp(position_grid(:, reconstructed_indices)')
end