function [] = problem_3_2( HIT, save_plots )
    
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
    num_bins_enst = 30;
    num_bins_ener = 30;
    histogram_radius_enst = 3.1;
    histogram_radius_ener = 3.1;
    bin_edges_enst = linspace(0,histogram_radius_enst,num_bins_enst+1);
    bin_edges_ener = linspace(0,histogram_radius_ener,num_bins_ener+1);
    
    % Calculate bin centers.
    bin_centers_enst = zeros(1,num_bins_enst);
    bin_centers_ener = zeros(1,num_bins_ener);
    for i = 1:num_bins_enst
        bin_centers_enst(i) = (bin_edges_enst(i)+bin_edges_enst(i+1))/2;
    end
    for i = 1:num_bins_ener
        bin_centers_ener(i) = (bin_edges_ener(i)+bin_edges_ener(i+1))/2;
    end
    
    % Bin bivariate data.
    dist_bivar = ...
         hist3([reshape(enstrophy_norm, [numel(enstrophy_norm),1]), ...
                reshape(energy_norm, [numel(energy_norm),1])], ...
               {bin_centers_enst,bin_centers_ener});
           
    % Normalize for probability per bin.
    dist_bivar = dist_bivar / sum(sum(dist_bivar));
    
    % Normalize for probability per unit squared.
    dist_bivar = dist_bivar / ...
                    ((num_bins_enst/histogram_radius_enst) * ...
                     (num_bins_ener/histogram_radius_ener));
                 
    % Bin univariate data.
    dist_enst = histcounts(enstrophy_norm,bin_edges_enst, ...
                        'Normalization','probability');
    dist_ener = histcounts(energy_norm,bin_edges_ener, ...
                        'Normalization','probability');
    
    % Normalize bivariate PDF by univariate PDFs.
    dist_bivar = dist_bivar ./ (dist_enst' * dist_ener);
    
    % Double-check univariate normalization.
    fprintf('Integral of enst PDF: %5e.\n', ...
            sum(bin_centers_enst .* dist_enst));
    fprintf('Integral of ener PDF: %5e.\n', ...
            sum(bin_centers_ener .* dist_ener));
    
    %%%
    % Plot joint PDF.
    %%%
    
    pdf_size = [5,4];
    h = figure('Position',aligned_position(...
                          100*pdf_size(1),100*pdf_size(2)), ...
               'PaperUnits','inches', ...
               'PaperSize',pdf_size, ...
               'PaperPosition',[0,0,pdf_size]);
    hold on;
    contourf(bin_centers_enst(1:end-1), ...
         bin_centers_ener(1:end-1), ...
         dist_bivar(1:end-1,1:end-1)',20,'EdgeColor','none');
    colormap('jet');
    xlabel('\epsilon / \langle\epsilon\rangle_{xyz}');
    ylabel('\Omega / \langle\Omega\rangle_{xyz}');
    xlim([0,3]);
    ylim([0,3]);
    daspect([1,1,1]);
    hbar = colorbar();
    ylabel(hbar,['I(\epsilon / \langle\epsilon\rangle_{xyz},', ...
                 '\Omega / \langle\Omega\rangle_{xyz})']);
    hold off;
    
    % Reposition and resize plot..
    % [left, bottom, width, height]
    position = get(gca,'pos');
    position = position + [0,0.05,0,-0.05];
    set(gca,'pos',position);

    if save_plots
        % Save figures to file (dpdf = PDF file) (loose = uncropped)
        filename = ['../images/prob3_2.pdf'];
        fprintf(['Saving <',filename,'>...']);
        print(h,'-dpdf','-loose',filename);
        fprintf(' done. \n');
    end
    
end

