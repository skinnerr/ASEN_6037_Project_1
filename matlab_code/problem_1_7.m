function [] = problem_1_7( HIT, HST, save_plots )

    % Max/mins for all data for uniform colorbar scaling.
    vel_max = 1.0;
    vel_min = -1.0;
    colorbar_limits = [vel_min,vel_max];

    for simulation_case = {'HIT'}

        if (strcmp(simulation_case,'HIT'))
            vel = HIT;
        else
            vel = HST;
        end
    
        % Get the mean velocity components thoroughout the whole domain.
        xyzAvg = zeros(3,1);
        for dim = 1:3
            xyzAvg(dim) = mean(mean(mean(vel(dim,:,:,:))));
        end

        % Set size (inches) of PDF to output, and make figure.
        pdf_size = [6.5,3.5];
        h = figure('Position',aligned_position(...
                              100*pdf_size(1),100*pdf_size(2)), ...
                   'PaperUnits','inches', ...
                   'PaperSize',pdf_size, ...
                   'PaperPosition',[0,0,pdf_size]);

        % Loop over slice coordinates and velocity dimensions
        k = [1,128,256];
        for k_index = 1:3
        for dim = 1:3

            % Create subplot and position it.
            hsub(k_index,dim) = subplot(3,3,dim+3*(k_index-1));
            
            % Identify data to plot.
            % NOTE: this is transposed, so x and y are flipped now!
            image_data = squeeze(vel(dim,:,:,k(k_index)))';
            
            % Subtract off $<u_i>_{xyz}$.
            image_data = image_data - xyzAvg(dim);
            
            % Create plot.
            imagesc(image_data,colorbar_limits);

            % Set figure properties.
            daspect([1,1,1]);
            colormap('jet');
            set(gca,'YDir','normal');   % Put origin at lower left.

            % Annotate with velocity component label.
            text(10,20,[char('u'+dim-1),'''']);
            text(10,108,['k = ',num2str(k(k_index))]);
            %text(10,60,num2str(mean(mean(image_data))));

            % Label subplots with ticks, axis labels, and titles.
            set(gca,'YTick',[1,65,129]);
            set(gca,'YTickLabel',{'','',''});
            set(gca,'XTick',[1,65,129,192,256]);
            set(gca,'XTickLabel',{'','','','',''});
            if dim == 1
                ylabel(gca,'y');
                set(gca,'YTick',[1,65,129]);
                set(gca,'YTickLabel',{'0','','\pi'});
            end
            if k_index == 3
                xlabel(gca,'x');
                set(gca,'XTick',[1,65,129,192,256]);
                set(gca,'XTickLabel',{'0','','\pi','','2\pi'});
            end
            if (k_index == 1) && (dim == 2)
                title(gca,char(simulation_case));
            end

        end
        end

        for k_index = 1:3
        for dim = 1:3

            % Reposition and resize subplots.
            % [left, bottom, width, height]
            % Note: since aspect ratio is set, modify either width or
            %   height and then use figure size to tune other padding.
            position = get(hsub(k_index,dim),'pos');
            % Make room for colorbar, and then shift if necessary.
            position = position .* [0.9, 1, 1.1, 1];
            position = position + [-0.03,0.01,0,0];
            position = position + (k_index-1)*[0,0.03,0,0];
            % Set position.
            set(hsub(k_index,dim),'pos',position)

        end
        end

        % Colorbar
        hbar = colorbar(); % Note: Not Planck's constant.
        set(hbar,'Position',[0.88,0.17,0.03,0.75]+[-0.03,0.01,0,0]);
        ylabel(hbar,'Dimensionless Velocity Magnitude');

        if save_plots
            % Save figures to file (dpdf = PDF file) (loose = uncropped)
            filename = ['../images/prob1_7_',char(simulation_case),'.pdf'];
            fprintf(['Saving <',filename,'>...']);
            print(h,'-dpdf','-loose',filename);
            fprintf(' done. \n');
        end

    end

end

