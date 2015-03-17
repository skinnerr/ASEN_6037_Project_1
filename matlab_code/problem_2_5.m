function [] = problem_2_5( HIT, save_plots )

    % Calculate pseudo energy diss. rate and its mean over the domain.
    [pseudo_diss, pseudo_diss_mean] = problem_2_4(HIT);
    
    % Calculate epsilon / <epsilon>_xyz.
    epsilon_norm = pseudo_diss / pseudo_diss_mean;
    
    data_min = min(min(epsilon_norm(:,:,128)));
    data_max = max(max(epsilon_norm(:,:,128)));
    fprintf('Range of slice data is [%5.4d, %5.4d].\n', ...
            data_min,data_max);

    % Max/mins for all data for uniform colorbar scaling.
    cb_max = 10.5;
    cb_min = 0;
    colorbar_limits = [cb_min,cb_max];

    % Set size (inches) of PDF to output, and make figure.
    pdf_size = [6.5,3];
    h = figure('Position',aligned_position(...
                          100*pdf_size(1),100*pdf_size(2)), ...
               'PaperUnits','inches', ...
               'PaperSize',pdf_size, ...
               'PaperPosition',[0,0,pdf_size]);

    % Identify data to plot.
    % NOTE: this is transposed, so x and y are flipped now!
    image_data = squeeze(epsilon_norm(:,:,128))';

    % Create plot.
    imagesc(image_data,colorbar_limits);

    % Set figure properties.
    daspect([1,1,1]);
    colormap('jet');
    set(gca,'YDir','normal');   % Put origin at lower left.

    % Label subplots with ticks, axis labels, and titles.
    ylabel(gca,'y');
    set(gca,'YTick',[1,33,65,97,129]);
    set(gca,'YTickLabel',{'0','','\pi/2','','\pi'});
    xlabel(gca,'x');
    set(gca,'XTick',[1,33,65,97,129,160,192,224,256]);
    set(gca,'XTickLabel',{'0','','\pi/2','','\pi','','3\pi/2','','2\pi'});

    % Colorbar
    hbar = colorbar(); % Note: Not Planck's constant.
    ylabel(hbar,'\epsilon / \langle\epsilon\rangle_{xyz}');

    if save_plots
        % Save figures to file (dpdf = PDF file) (loose = uncropped)
        filename = '../images/prob2_5.pdf';
        fprintf(['Saving <',filename,'>...']);
        print(h,'-dpdf','-loose',filename);
        fprintf(' done. \n');
    end

end

