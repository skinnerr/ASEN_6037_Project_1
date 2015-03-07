function [ position_array ] = aligned_position( width, height )
%% Generates the argument for the 'Position' property of a figure
% Inputs are:
%   width - desired figure width
%   height - desired figure height
% Why use this function? It aligns all windows by their upper right corners,
%   so they are easier to close in Windows OS.
%%%

    dist_from_top = 200;
    dist_from_right = 400;

    screen_size = get(groot,'ScreenSize');

    left = screen_size(3) - dist_from_right - width;
    bottom = screen_size(4) - dist_from_top - height;

    position_array = [left, bottom, width, height];

end