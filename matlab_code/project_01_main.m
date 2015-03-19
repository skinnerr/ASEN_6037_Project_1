%% Script to perform calculations and save figures for Project 1
%   ASEN 6037: Turbulence -- Prof. Peter Hamlington (Spring 2015)

% Clear screen
clc

% Clear all variables except raw turbulence data if it has been loaded.
clearvars -except HIT HST

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Specify the problem number and whether to save plots.
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
problem = '3.1';
save_plots = true;
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%%%
% Load data if not already in the workspace.
%   Data is loaded as 4-D array of doubles, indexed by (dimension,i,j,k).
%%%

if ~exist('HIT','var')
    fprintf('Loading isotropic (HIT) data...');
    [HIT(1,:,:,:), HIT(2,:,:,:), HIT(3,:,:,:)] = read_dns_data('HIT');
    fprintf(' done.\n');
end

if ~exist('HST','var')
    fprintf('Loading shear (HST) data...');
    [HST(1,:,:,:), HST(2,:,:,:), HST(3,:,:,:)] = read_dns_data('HST');
    fprintf(' done.\n');
end

%%%
% Execute problem-specific code.
%%%

if isempty(problem)
    error('No problem specified, so no calculations/graphs generated.');
end

fprintf(['Beginning code execution for Problem ',char(problem),'.\n']);

switch problem

    case '1.1'
        problem_1_1(HIT,HST);

    case '1.2'
        problem_1_2(HIT,HST,save_plots);

    case '1.3'
        problem_1_3(HIT,HST,save_plots);

    case '1.5'
        problem_1_5(HIT,HST,save_plots);

    case '1.6'
        problem_1_6(HIT,HST,save_plots);

    case '1.7'
        problem_1_7(HIT,HST,save_plots);
        
    case '1.8'
        problem_1_8(HIT,HST,save_plots);

    case '1.9'
        problem_1_9(HIT,HST,save_plots);

    case '1.10'
        problem_1_10(HIT,HST,save_plots);

    case '2.1'
        problem_2_1(HIT,save_plots);

    case {'2.2','2.3'}
        save_plots = save_plots && strcmp(problem,'2.2');
        problem_2_2_and_2_3(HIT,save_plots);

    case '2.4'
        problem_2_4(HIT);

    case '2.5'
        problem_2_5(HIT, save_plots);

    case '2.6'
        problem_2_6(HIT);

    case '2.8'
        problem_2_8(HIT, save_plots);

    case '2.9'
        problem_2_9(HIT, save_plots);
        
    case '3.1'
        problem_3_1(HIT, save_plots);

    otherwise
        fprintf('Desired problem %i has no associated plots.\n',problem);

end

fprintf('Code execution complete.\n');