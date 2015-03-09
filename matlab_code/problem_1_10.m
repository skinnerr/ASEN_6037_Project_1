function [] = problem_1_10( HIT, HST, save_plots )

    %%%
    % Set up preliminaries: velocity averages and data structures.
    %%%

    % xz-average velocities for the HST case.
    uwAvgShear = zeros(3,129); % Indexed by (dim,y_index).
    for y_index = 1:129
        for dim = 1:3
            uwAvgShear(dim,y_index) = mean(mean(HST(dim,:,y_index,:)));
        end
    end
    
    % xyz-average velocities for the HIT case.
    uvwAvgIso = zeros(3,1);
    for dim = 1:3
        uvwAvgIso(dim) = mean(mean(mean(HIT(dim,:,:,:))));
    end

    % Velocity fluctuations for each case.
    uvwPrimeShear = zeros(3,256,129,256);
    for dim = 1:3
        for j = 1:129
            uvwPrimeShear(dim,:,j,:) = HST(dim,:,j,:) - uwAvgShear(dim,j);
        end
    end
    uvwPrimeIso = zeros(3,256,129,256);
    for dim = 1:3
        uvwPrimeIso(dim,:,:,:) = HIT(dim,:,:,:) - uvwAvgIso(dim);
    end
    
    %%%
    % Calculate PDFs for HIT and HST fluctuation velocities
    %%%
    
    % Binning properties.
    num_bins = 1200;
    histogram_radius = 6;
    bin_edges = linspace(-histogram_radius,histogram_radius,num_bins+1);
    
    % Slices' y-coordinates.
    j_slice_to_j = @(j) j*32;
    num_slices = 3;
    
    % Bin HIT data.
    HIT_dist = zeros(3,num_bins);
    for dim = 1:3
        HIT_dist(dim,:) = ...
            histcounts(uvwPrimeIso(dim,:,:,:),bin_edges, ...
                'Normalization','probability');
    end
    
    % Bin HST data.
    HST_dist = zeros(3,num_slices,num_bins);
    for dim = 1:3
        for j_slice = 1:num_slices
            j = j_slice_to_j(j_slice);
            HST_dist(dim,j_slice,:) = ...
                histcounts(uvwPrimeShear(dim,:,j,:),bin_edges, ...
                    'Normalization','probability');
        end
    end
    
    % Grab bin centers.
    bin_centers = zeros(1,num_bins);
    for i = 1:num_bins
        bin_centers(i) = (bin_edges(i)+bin_edges(i+1))/2;
    end
    
    %%%
    % Plot PDFs!
    %%%
    
    pdf_size = [6.5,5.5];
    h = figure('Position',aligned_position(...
                          100*pdf_size(1),100*pdf_size(2)), ...
               'PaperUnits','inches', ...
               'PaperSize',pdf_size, ...
               'PaperPosition',[0,0,pdf_size]);
    
    rows = 4;
    cols = 3;
    for row = 1:rows;
    for col = 1:cols;
        
        plot_number = col + cols*(row-1);
        hsubs(row,col) = subplot(rows,cols,plot_number); %#ok<AGROW>
        
        if (plot_number <= 3)
            % Set up data for HIT case.
            dim = col;
            dist = squeeze(HIT_dist(dim,:));
        else
            % Set up data for HST case.
            dim = col;
            j_slice = row-1;
            dist = squeeze(HST_dist(dim,j_slice,:))';
        end
        
        %%%
        % Plot selected data.
        %%%
        
        hold on;
        % Plot real distribution.
        plot(bin_centers, ...
            dist*(num_bins/(2*histogram_radius)), ...
            '-','LineWidth',2);
        % Calculate and plot Gaussian fit.
        avg = 0;
        dev = 0;
        for i = 1:num_bins
            avg = avg + dist(i) * bin_centers(i);
            dev = dev + dist(i) * bin_centers(i)^2;
        end
        dev = sqrt(dev);
        gaussian = ...
            (1/(dev*sqrt(2*pi)))*exp(-(bin_centers-avg).^2/(2*dev^2));
        plot(bin_centers,gaussian,'--','LineWidth',1);
        hold off;
        box on;
        % Set titles.
        if plot_number == 2
            title('HIT');
        elseif plot_number == 5
            title('HST');
        end
        % Setup informational text.
        if row == 1
            text(-1.2,4.5,{'Full','volume'});
        else
            text(-3.3,0.65, ...
                {'Slice at',['j = ',num2str(j_slice_to_j(j_slice))]});
        end
        % Setup x-axis.
        if row == 1
            xlim([-1.3,1.3]);
            set(gca,'XTick',-1:0.5:1);
        else
            xlim([-3.5,3.5]);
            set(gca,'XTick',-3:3);
        end
        if row == rows
            xlabel([char('u'+(dim-1)),'''']);
        else
            if row ~= 1
                set(gca,'XTickLabel',{''});
            end
        end
        % Setup y-axis.
        if row == 1
            ylim([0,6]);
            set(gca,'YTick',0:2:6);
        else
            ylim([0,0.82]);
            set(gca,'YTick',0:0.2:0.8);
        end
        if col == 1
            if row == 1
                ylabel({'Probability','Density'});
            elseif row == 3
                hYLabelShear = ylabel('Probability Density');
            end
        else
            set(gca,'YTickLabel','');
        end
        
    end
    end

    for row = 1:rows
    for col = 1:cols

        % Shift subplots
        % [left, bottom, width, height]
        position = get(hsubs(row,col),'pos');
        if row > 1
            position = position + [0,0.01*(row-2)-0.04,0,0];
        end
        position = position + [0,0,0.05,0.01];
        set(hsubs(row,col),'pos',position)
        
        if (row == 4) && (col == 1)
            position = get(hYLabelShear,'pos');
            position = position + [0,0.1,0];
            set(hYLabelShear,'pos',position);
        end
        
    end
    end

    if save_plots
        % Save figures to file (dpdf = PDF file) (loose = uncropped)
        filename = ['../images/prob1_10.pdf'];
        fprintf(['Saving <',filename,'>...']);
        print(h,'-dpdf','-loose',filename);
        fprintf(' done. \n');
    end

end

