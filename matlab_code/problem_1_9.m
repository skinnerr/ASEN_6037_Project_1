function [] = problem_1_9( HIT, HST, save_plots )

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

    % u-velocity fluctuations for each case.
    uPrimeShear = zeros(256,129,256);
    for j = 1:129
        uPrimeShear(:,j,:) = HST(1,:,j,:) - xzAvgShear(1,j);
    end
    uPrimeIso = HIT(1,:,:,:) - xyzAvgIso(1);
    
    %%%
    % Calculate PDFs for HIT and HST fluctuation velocities
    %%%
    
    % Number of bins to use.
    num_bins = 1200;
    histogram_radius = 6;
    bin_edges = linspace(-histogram_radius,histogram_radius,num_bins+1);
    
    % Bin HIT data.
    HIT_dist = histcounts(uPrimeIso(:,:,:),bin_edges, ...
        'Normalization','probability');
    
    % Bin HST data.
    HST_dist = zeros(129,num_bins);
    for j = 1:129
        HST_dist(j,:) = ...
            histcounts(uPrimeShear(:,j,:),bin_edges, ...
                'Normalization','probability');
    end
    
    % Grab bin centers.
    bin_centers = zeros(1,num_bins);
    for i = 1:num_bins
        bin_centers(i) = (bin_edges(i)+bin_edges(i+1))/2;
    end
    
    %%%
    % Calculate moments.
    %%%
    
    HIT_moments = zeros(1,4);
    HST_moments = zeros(129,4);
    
    % Loop over moments.
    for n = 1:4
        % Perform integration.
        for i = 1:num_bins
            HIT_moments(n) = HIT_moments(n) + ...
                bin_centers(i)^n * HIT_dist(i);
        end
        % Loop over slices.
        for j = 1:129
            % Perform integration.
            for i = 1:num_bins
                HST_moments(j,n) = HST_moments(j,n) + ...
                    bin_centers(i)^n * HST_dist(j,i);
            end
        end
    end
    
    %%%
    % Compute standard deviation, skewness, and kurtosis.
    %%%
    
    % Standard deviation.
    HIT_stdev = sqrt(HIT_moments(2));
    HST_stdev = sqrt(HST_moments(:,2));
    
    % Skewness.
    HIT_skew = HIT_moments(3) / HIT_stdev^3;
    HST_skew = HST_moments(:,3) ./ HST_stdev.^3;
    
    % Kurtosis.
    HIT_kurt = HIT_moments(4) / HIT_stdev^4;
    HST_kurt = HST_moments(:,4) ./ HST_stdev.^4;
    
    %%%
    % Plot PDFs and moments!
    %%%
    
    pdf_size = [6.5,4.4];
    h = figure('Position',aligned_position(...
                          100*pdf_size(1),100*pdf_size(2)), ...
               'PaperUnits','inches', ...
               'PaperSize',pdf_size, ...
               'PaperPosition',[0,0,pdf_size]);
    
    rows = 2;
    cols = 2;
    for i = 1:rows;
    for j = 1:cols;
        
        plot_number = j + cols*(i-1);
        hsubs(plot_number) = subplot(rows,cols,plot_number);
        
        switch plot_number
            
            case 1 % Plot PDFs.
                hold on;
                plot(bin_centers, ...
                    HIT_dist*(num_bins/(2*histogram_radius)), ...
                    ':','LineWidth',2);
                plot(bin_centers, ...
                    mean(HST_dist*(num_bins/(2*histogram_radius))), ...
                    ':','LineWidth',2);
                legend('HIT','HST');
                box on;
                xlabel('u''');
                ylabel('Probability Density');
%                 text(-3.25,1.7, ...
%                     {[num2str(num_bins),' bins'], ...
%                      ['over [',num2str(-histogram_radius),',', ...
%                                num2str(histogram_radius),']']});
                xlim([-3.5,3.5]);
                ylim([0,2]);
                set(gca,'XTick',-3:3);
                hold off;

            case 2 % Second moment
                hold on;
                plot(1*ones(1,129),'LineWidth',2); % Gaussian
                plot(HIT_moments(2)*ones(1,129),'LineWidth',2);
                plot(mean(HST_moments(:,2))*ones(1,129),'LineWidth',2);
                plot(HST_moments(:,2),'LineWidth',2);
                box on;
                xlabel('y');
                ylabel('Variance');
                xlim([1,129]);
                ylim([0,2.1]);
                set(gca,'XTick',[1,65,129]);
                set(gca,'XTickLabel',{'0','\pi/2','\pi'});
                hold off;

            case 3 % Skewness
                
                hold on;
                plot(0*ones(1,129),'LineWidth',2); % Gaussian
                plot(HIT_skew*ones(1,129),'LineWidth',2);
                plot(mean(HST_skew)*ones(1,129),'LineWidth',2);
                plot(HST_skew,'LineWidth',2);
                box on;
                xlabel('y');
                ylabel('Skewness');
                xlim([1,129]);
                ylim([-0.5,0.5]);
                set(gca,'XTick',[1,65,129]);
                set(gca,'XTickLabel',{'0','\pi/2','\pi'});
                hold off;

            case 4 % Kurtosis
                
                hold on;
                plot(3*ones(1,129),'LineWidth',2); % Gaussian
                plot(HIT_kurt*ones(1,129),'LineWidth',2);
                plot(mean(HST_kurt)*ones(1,129),'LineWidth',2);
                plot(HST_kurt,'LineWidth',2);
                legend('Gaussian','Isotropic','Shear (Mean)','Shear', ...
                    'Location','southeast');
                box on;
                xlabel('y');
                ylabel('Kurtosis');
                xlim([1,129]);
                ylim([0,3.2]);
                set(gca,'XTick',[1,65,129]);
                set(gca,'XTickLabel',{'0','\pi/2','\pi'});
                hold off;
            
        end
        
    end
    end

    for plot_number = 1:(rows*cols)

        % Shift subplots
        % [left, bottom, width, height]
        position = get(hsubs(plot_number),'pos');
        position = position + [0,0.03,0,0];
        set(hsubs(plot_number),'pos',position)
        
    end

    if save_plots
        % Save figures to file (dpdf = PDF file) (loose = uncropped)
        filename = ['../images/prob1_9.pdf'];
        fprintf(['Saving <',filename,'>...']);
        print(h,'-dpdf','-loose',filename);
        fprintf(' done. \n');
    end

end

