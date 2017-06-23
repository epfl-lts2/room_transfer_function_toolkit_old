clc; clear; close all
load('../data/config.mat')
col = ['r';'g';'b';'k';'y'];


N = 3;                     % how many room modes to calculate
NUMBER_OF_WALLS = 6;
WALL_IMPEDANCES = 0.01*ones(NUMBER_OF_WALLS,1);
Lx = 3.9; Ly = 8.15; Lz = 3.35;
[ pos_s, pos_mt, pos_me, SPATIAL_SAMPLING_STEP ] = get_positions ...
    ( Lx, Ly, Lz, TEMPERATURE, 50, 1 );
[x, y, z] = get_coordinates(pos_mt(1));

x_steps = 0.1:SPATIAL_SAMPLING_STEP/150:Lx;
y_steps = 0.1:SPATIAL_SAMPLING_STEP/150:Ly;
z_steps = 0.1:SPATIAL_SAMPLING_STEP/150:Lz;

figure
subplot(2,2,1)
pos_mx = [];
pos_my = [];
pos_mz = [];
for i = 1:length(x_steps)
    pos_mx = [pos_mx; Point3D(x_steps(i),y,z)];
end
for i = 1:length(y_steps)
    pos_my = [pos_my; Point3D(x,y_steps(i),z)];
end
for i = 1:length(z_steps)
    pos_mz = [pos_mz; Point3D(x,y,z_steps(i))];
end
draw_sensor_placement( Lx, Ly, Lz, pos_s, pos_mx, pos_my, pos_mz, ...
    SPATIAL_SAMPLING_STEP, col )

pos_s = Point3D(1, 1, 1);
eigenfrequency_table = get_eigenfrequency_table(Lx, Ly, Lz, N, TEMPERATURE);
receiver_room_mode_table = get_room_mode_table (Lx, Ly, Lz, N, pos_s);
damping_factor_table = get_damping_factor_table(Lx, Ly, Lz, ...
    WALL_IMPEDANCES, N, TEMPERATURE);
K_table = get_K_table(Lx, Ly, Lz, N);

resonant_frequencies = [];
c = 346;
MAX = 5;
for x = 0:MAX
    for y = 0:MAX
        for z = 0:MAX
            if(~(x == 0 && y == 0 && z == 0))
                f = c/2*sqrt((x/Lx)^2+(y/Ly)^2+(z/Lz)^2);
                resonant_frequencies = [resonant_frequencies f];
            end
        end
    end
end

FREQUENCY_MIN = 0; FREQUENCY_MAX = 500; FREQUENCY_STEP = 0.01;
freq = FREQUENCY_MIN:FREQUENCY_STEP:FREQUENCY_MAX;
SCHROEDER_FREQUENCY = 217;

subplot(2,2,2)
rir_pos_mx = [];
rir_pos_my = [];
rir_pos_mz = [];
% for each group we will have a image with the height of the peaks
for i = 1:length(pos_mx)
    source_room_mode_table = get_room_mode_table (Lx, Ly, Lz, N, ...
        pos_mx(i));
    %% The continuous function (amplitude and phase)
    [Hf, ~] = transfer_function_fourier(N, source_room_mode_table, ...
        receiver_room_mode_table, eigenfrequency_table, ...
        damping_factor_table, K_table, TEMPERATURE, ...
        resonant_frequencies);
    rir_pos_mx = [rir_pos_mx; 20*log10(abs(Hf))];
end
imagesc(rir_pos_mx)
colormap winter
colorbar
title('Variation over x (red)')
xlabel('frequency [Hz]')
ylabel('microphone')

subplot(2,2,3)
% for each group we will have a image with the height of the peaks
for i = 1:length(pos_my)
    source_room_mode_table = get_room_mode_table (Lx, Ly, Lz, N, ...
        pos_my(i));
    %% The continuous function (amplitude and phase)
    [Hf, ~] = transfer_function_fourier(N, source_room_mode_table, ...
        receiver_room_mode_table, eigenfrequency_table, ...
        damping_factor_table, K_table, TEMPERATURE, ...
        resonant_frequencies);
    rir_pos_my = [rir_pos_my; 20*log10(abs(Hf))];
end
imagesc(rir_pos_my)
colormap winter
colorbar
title('Variation over y (green)')
xlabel('frequency [Hz]')
ylabel('microphone')


subplot(2,2,4)
% for each group we will have a image with the height of the peaks
for i = 1:length(pos_mz)
    source_room_mode_table = get_room_mode_table (Lx, Ly, Lz, N, ...
        pos_mz(i));
    %% The continuous function (amplitude and phase)
    [Hf, ~] = transfer_function_fourier(N, source_room_mode_table, ...
        receiver_room_mode_table, eigenfrequency_table, ...
        damping_factor_table, K_table, TEMPERATURE, ...
        resonant_frequencies);
    rir_pos_mz = [rir_pos_mz; 20*log10(abs(Hf))];
end
imagesc(resonant_frequencies,1:length(pos_mz),rir_pos_mz)
colormap winter
colorbar
title('Variation over z (blue)')
xlabel('frequency [Hz]')
ylabel('microphone')