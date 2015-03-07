function [] = problem_1_8( HIT, HST, save_plots )

    %%%
    % Set up preliminaries: velocity averages and data structures.
    %%%

    % xz-average velocities for the HST case.
    xzAvgShear = zeros(3,129); % Indexed by (dim,y_index).
    for y_index = 1:129
        for dim = 1:3
            xzAvgShear(dim,y_index) = mean(mean(HST(dim,:,y_index,:)));
        end
    end
    
    % xyz-average velocities for the HIT case.
    xyzAvgIso = zeros(3,1);
    for dim = 1:3
        xyzAvgIso(dim) = mean(mean(mean(HIT(dim,:,:,:))));
    end

    % xz- and xyz-average Reynolds stresses for the HIT and HST cases.
    xyzAvgReynoldsIso = zeros(3,3);
    xzAvgReynoldsShear = zeros(3,3,129);
    
    %%%
    % Get isotropic (HIT) Reynolds stress averages.
    %%%
    
    for i = 1:3
    for j = 1:3
        
        % Skip over redundant calculations. We will only do (i,j) cases of
        %   (1,1), (2,2), (3,3), (1,2), (1,3), and (2,3) [upper triangle].
        if i > j
            continue
        end
        
        % Calculate Reynolds stress field and average over whole domain.
        uprime_i = HIT(i,:,:,:) - xyzAvgIso(i);
        uprime_j = HIT(j,:,:,:) - xyzAvgIso(i);
        reynolds_stress_field = uprime_i .* uprime_j;
        xyzAvgReynoldsIso(i,j) = mean(mean(mean(reynolds_stress_field)));
        
    end
    end
    
    %%%
    % Get shear (HST) Reynolds stress averages.
    %%%
    
    for i = 1:3
    for j = 1:3
    for y_index = 1:129
        
        % Skip over redundant calculations (see above).
        if i > j
            continue
        end
        
        % Calculate Reynolds stress field and average over y-coordinate.
        uprime_i = HST(i,:,y_index,:) - xzAvgShear(i,y_index);
        uprime_j = HST(j,:,y_index,:) - xzAvgShear(j,y_index);
        reynolds_stress_field = uprime_i .* uprime_j;
        xzAvgReynoldsShear(i,j,y_index) = ...
            mean(mean(mean(reynolds_stress_field)));
        
    end
    end
    end
    
    %%%
    % And finally plot results.
    %%%
    
    ij_to_plot_number(1,1) = 1;
    ij_to_plot_number(2,2) = 2;
    ij_to_plot_number(3,3) = 3;
    ij_to_plot_number(1,2) = 4;
    ij_to_plot_number(1,3) = 5;
    ij_to_plot_number(2,3) = 6;

    % Set size (inches) of PDF to output, and make figure.
    pdf_size = [6.5,3];
    h = figure('Position',aligned_position(...
                          100*pdf_size(1),100*pdf_size(2)), ...
               'PaperUnits','inches', ...
               'PaperSize',pdf_size, ...
               'PaperPosition',[0,0,pdf_size]);

    for i = 1:3
    for j = 1:3

        if i > j
            continue
        end
        
        plot_number = ij_to_plot_number(i,j);
        hsub(plot_number) = subplot(2,3,plot_number);
        hold on;
        plot(xyzAvgReynoldsIso(i,j)*ones(129,1),'--','LineWidth',2);
        plot(squeeze(xzAvgReynoldsShear(i,j,:)),'LineWidth',2);
        box on;
        hold off;

        % Label subplots with ticks, axis labels, and titles.
        text(7,1.6,['$',char('u'+i-1),'''',char('u'+j-1), ...
            '''$'], 'Interpreter','LaTeX');
        xlim([1,129]);
        ylim([-1,2]);
        set(gca,'XTick',[1,65,129]);
        set(gca,'YTick',[-1,0,1,2]);
        if mod(plot_number-1,3) == 0
            ylabel(gca,{'Dimensionless','Magnitude'});
        else
            set(gca,'YTickLabel',{'','','',''});
        end
        if plot_number > 3
            xlabel(gca,'y');
            set(gca,'XTickLabel',{'0','\pi/2','\pi'});
        else
            set(gca,'XTickLabel',{'','',''});
        end
        
        if plot_number == 3
            hleg = legend('HIT \langle \cdot \rangle_{xyz}', ...
                          'HST \langle \cdot \rangle_{xz}(y)', ...
                          'Interpreter','LaTeX');
            leg_pos = get(hleg,'pos');
            set(hleg,'pos',[0.72,0.48,leg_pos(3),leg_pos(4)]);
        end

    end
    end

    for plot_number = 1:6

        % Reposition and resize subplots.
        % [left, bottom, width, height]
        position = get(hsub(plot_number),'pos');
        % Enlarge and shift subplots.
        position = position .* [0.95,0.9,1.1,1];
        position = position + [0,0.07,0,0];
        % Set position.
        set(hsub(plot_number),'pos',position)
        
    end

    if save_plots
        % Save figures to file (dpdf = PDF file) (loose = uncropped)
        filename = ['../images/prob1_8.pdf'];
        fprintf(['Saving <',filename,'>...']);
        print(h,'-dpdf','-loose',filename);
        fprintf(' done. \n');
    end

end

