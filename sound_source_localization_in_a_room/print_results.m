function [  ] = print_results(gound_truth_positions, ...
    reconstructed_indices, position_grid, pos_r, Lx, Ly, Lz)
% show the potential postion grid
plot3(position_grid(1,:), position_grid(2,:), position_grid(3,:), 'o', ...
    'color', [145, 164, 196]/256, 'Linewidth', 3)
hold on
% show the ground truth positions
for i = 1:length(gound_truth_positions)
    [x, y, z] = get_coordinates(gound_truth_positions(i));
    plot3(x, y, z, 'ob', 'Linewidth', 5)
end

plot3(position_grid(1, reconstructed_indices), ...
    position_grid(2, reconstructed_indices), ...
    position_grid(3, reconstructed_indices), '*c', 'Linewidth', 5);

% show the microphone position
[x, y, z] = get_coordinates(pos_r);
plot3(x, y, z, 'o', 'MarkerFaceColor', 'r','MarkerSize', 10);
axis equal
xlim([0 Lx])
ylim([0 Ly])
zlim([0 Lz])
    
disp('Initial positions')
disp(gound_truth_positions)

reconstructed_indices = sort(reconstructed_indices);
disp('Reconstructed positions')
disp(position_grid(:, reconstructed_indices)')
end