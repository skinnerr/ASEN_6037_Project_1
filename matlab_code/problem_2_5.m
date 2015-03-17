function [] = problem_2_5( HIT, save_plots )

    % Calculate pseudo energy diss. rate and its mean over the domain.
    [pseudo_diss, pseudo_diss_mean] = problem_2_4(HIT);
    
    % Calculate epsilon / <epsilon>_xyz.
    epsilon_norm = pseudo_diss;% / pseudo_diss_mean;
    
    min_slice = min(min(epsilon_norm(:,:,128)));
    max_slice = max(max(epsilon_norm(:,:,128)));
    fprintf('Range of slice data is [%5.4d, %5.4d].\n', ...
            max_slice,min_slice);

    % Max/mins for all data for uniform colorbar scaling.
    cb_max = 12;
    cb_min = 0;
    colorbar_limits = [cb_min,cb_max];

    % Set size (inches) of PDF to output, and make figure.
    pdf_size = [6.5,3.5];
    h = figure('Position',aligned_position(...
                          100*pdf_size(1),100*pdf_size(2)), ...
               'PaperUnits','inches', ...
               'PaperSize',pdf_size, ...
               'PaperPosition',[0,0,pdf_size]);

    % Identify data to plot.
    % NOTE: this is transposed, so x and y are flipped now!
    image_data = squeeze(epsilon_norm(:,:,128))';

    % Create plot.
    imagesc(image_data)%,colorbar_limits);

    % Set figure properties.
    daspect([1,1,1]);
    colormap('jet');
    set(gca,'YDir','normal');   % Put origin at lower left.

%     % Label subplots with ticks, axis labels, and titles.
%     set(gca,'YTick',[1,65,129]);
%     set(gca,'YTickLabel',{'','',''});
%     set(gca,'XTick',[1,65,129,192,256]);
%     set(gca,'XTickLabel',{'','','','',''});
%     if dim == 1
%         ylabel(gca,'y');
%         set(gca,'YTick',[1,65,129]);
%         set(gca,'YTickLabel',{'0','','\pi'});
%     end
%     if k_index == 3
%         xlabel(gca,'x');
%         set(gca,'XTick',[1,65,129,192,256]);
%         set(gca,'XTickLabel',{'0','','\pi','','2\pi'});
%     end
%     if (k_index == 1) && (dim == 2)
%         title(gca,char(simulation_case));
%     end

    % Colorbar
    hbar = colorbar(); % Note: Not Planck's constant.
    ylabel(hbar,'\epsilon/\langle\epsilon\rangle_{xyz}');

    if save_plots
        % Save figures to file (dpdf = PDF file) (loose = uncropped)
        filename = ['../images/prob1_6_',char(simulation_case),'.pdf'];
        fprintf(['Saving <',filename,'>...']);
        print(h,'-dpdf','-loose',filename);
        fprintf(' done. \n');
    end

end

