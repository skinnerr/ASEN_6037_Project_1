function [ xzAvg ] = problem_1_5( HIT, HST, save_plots )

    % xz-Averages for all y-slices and velocities. Indexed by (case,dim,y).
    xzAvg = zeros(2,3,129);
    
    for simulation_case = {'HIT','HST'}

        if (strcmp(simulation_case,'HIT'))
            vel = HIT;
            case_index = 1;
        else
            vel = HST;
            case_index = 2;
        end

        for j = 1:129
            for dim = 1:3
                xzAvg(case_index,dim,j) = ...
                    mean(mean(vel(dim,:,j,:)));
            end
        end

        % Set size (inches) of PDF to output, and make figure.
        pdf_size = [6.5,2];
        h = figure('Position',aligned_position(...
                              100*pdf_size(1),100*pdf_size(2)), ...
                   'PaperUnits','inches', ...
                   'PaperSize',pdf_size, ...
                   'PaperPosition',[0,0,pdf_size]);

        for dim = 1:3

            hsub(dim) = subplot(1,3,dim);
            plot(squeeze(xzAvg(case_index,dim,:)),'LineWidth',2);

            % Label subplots with ticks, axis labels, and titles.
            xlabel(gca,'y');
            xlim([1,129]);
            set(gca,'XTick',[1,65,129]);
            set(gca,'XTickLabel',{'0','\pi/2','\pi'});
            text(5,3, ...
                ['$\left<',char('u'+dim-1),'\right>_{xz}(y)$'], ...
                'Interpreter','LaTeX');
            ylim([-4,4]);
            if dim == 2
                title(gca,char(simulation_case));
            end
            if dim == 1
                ylabel(gca,{'Dimensionless','Magnitude'});
            else
                set(gca,'YTick',[]);
            end

        end

        for dim = 1:3

            % Reposition and resize subplots.
            % [left, bottom, width, height]
            position = get(hsub(dim),'pos');
            % Enlarge and shift subplots.
            position = position .* [1.05, 2.5, 1.3, 0.7];
            position = position + [-0.04,0,0,0];
            % Set position.
            set(hsub(dim),'pos',position)

        end

        if save_plots
            % Save figures to file (dpdf = PDF file) (loose = uncropped)
            filename = ['../images/prob1_5_',char(simulation_case),'.pdf'];
            fprintf(['Saving <',filename,'>...']);
            print(h,'-dpdf','-loose',filename);
            fprintf(' done. \n');
        end

    end

end

