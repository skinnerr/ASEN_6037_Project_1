function [] = problem_2_9( HIT, save_plots )
    
    % Calculate pseudo energy diss. rate and its mean over the domain.
    [enstrophy, enstrophy_mean] = problem_2_6(HIT);
    % Calculate epsilon / <epsilon>_xyz.
    enstrophy_norm = enstrophy / enstrophy_mean;
    
    % Calculate pseudo energy diss. rate and its mean over the domain.
    [pseudo_diss, pseudo_diss_mean] = problem_2_4(HIT);
    % Calculate epsilon / <epsilon>_xyz.
    energy_norm = pseudo_diss / pseudo_diss_mean;
    
    max_enst = max(max(max(enstrophy_norm(:,:,:))));
    min_enst = min(min(min(enstrophy_norm(:,:,:))));
    max_ener = max(max(max(energy_norm(:,:,:))));
    min_ener = min(min(min(energy_norm(:,:,:))));
    fprintf('Range of enstrophy norm is [%5.4d, %5.4d].\n', ...
            max_enst,min_enst);
    fprintf('Range of energy dissipation is [%5.4d, %5.4d].\n', ...
            max_ener,min_ener);
    
    %%%
    % Calculate PDFs.
    %%%
    
    % Binning properties.
    num_bins_enst = 2000;
    num_bins_ener = 1000;
    histogram_radius_enst = 40;
    histogram_radius_ener = 20;
    bin_edges_enst = linspace(0,histogram_radius_enst,num_bins_enst+1);
    bin_edges_ener = linspace(0,histogram_radius_ener,num_bins_ener+1);
    
    % Bin data.
    dist_enst = histcounts(enstrophy_norm,bin_edges_enst, ...
                        'Normalization','probability');
    dist_ener = histcounts(energy_norm,bin_edges_ener, ...
                        'Normalization','probability');
    
    % Grab bin centers.
    bin_centers_enst = zeros(1,num_bins_enst);
    bin_centers_ener = zeros(1,num_bins_ener);
    for i = 1:num_bins_enst
        bin_centers_enst(i) = (bin_edges_enst(i)+bin_edges_enst(i+1))/2;
    end
    for i = 1:num_bins_ener
        bin_centers_ener(i) = (bin_edges_ener(i)+bin_edges_ener(i+1))/2;
    end
    
    %%%
    % Plot PDFs and Gaussian fits.
    %%%
    
    % Double-check normalization.
    fprintf('Integral of enst: %5e.\n',sum(bin_centers_enst .* dist_enst));
    fprintf('Integral of ener: %5e.\n',sum(bin_centers_ener .* dist_ener));
    
    pdf_size = [6.5,3];
    h = figure('Position',aligned_position(...
                          100*pdf_size(1),100*pdf_size(2)), ...
               'PaperUnits','inches', ...
               'PaperSize',pdf_size, ...
               'PaperPosition',[0,0,pdf_size]);
    hold on;
    
    % Plot actual PDFs.
    plot(bin_centers_enst, dist_enst*(num_bins_enst/(2*histogram_radius_enst)), ...
         '-','LineWidth',2);
    plot(bin_centers_ener, dist_ener*(num_bins_ener/(2*histogram_radius_ener)), ...
         '-','LineWidth',2);
    
    % Legend
    legend('\Omega / \langle\Omega\rangle_{xyz}', ...
           '\epsilon / \langle\epsilon\rangle_{xyz}');
    
    % Display settings.
    hold off;
    xlim([0,3]);
    box on;
    ylabel('Probability Density');

    if save_plots
        % Save figures to file (dpdf = PDF file) (loose = uncropped)
        filename = ['../images/prob2_9.pdf'];
        fprintf(['Saving <',filename,'>...']);
        print(h,'-dpdf','-loose',filename);
        fprintf(' done. \n');
    end
    
end

