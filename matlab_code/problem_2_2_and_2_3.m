function [] = problem_2_2_and_2_3( HIT, save_plots )
    
    % A_ij vectors, indexed by [i,j,x,y,z], where x,y,z are actually the
    % coordinate indices.
    [Aij, Aij_mean] = problem_2_1(HIT);
    
    Aij_prime = zeros(size(Aij));
    for i = 1:3
    for j = 1:3
        Aij_prime(i,j,:,:,:) = Aij(i,j,:,:,:) - Aij_mean(i,j);
    end
    end
    
    max_a = max(max(max(Aij_prime(1,1,:,:,:))));
    min_a = min(min(min(Aij_prime(1,1,:,:,:))));
    max_b = max(max(max(Aij_prime(1,2,:,:,:))));
    min_b = min(min(min(Aij_prime(1,2,:,:,:))));
    fprintf('Range of A''_11 (a) is [%5.4d, %5.4d].\n',max_a,min_a);
    fprintf('Range of A''_12 (b) is [%5.4d, %5.4d].\n',max_b,min_b);
    
    %%%
    % Calculate PDFs for A'_11 and A'_12.
    %%%
    
    % Binning properties.
    num_bins_a = 1200;
    num_bins_b = 500;
    histogram_radius_a = 7;
    histogram_radius_b = 3;
    bin_edges_a = linspace(-histogram_radius_a, ...
                            histogram_radius_a,num_bins_a+1);
    bin_edges_b = linspace(-histogram_radius_b, ...
                            histogram_radius_b,num_bins_b+1);
    
    % Bin data.
    dist_a = histcounts(Aij_prime(1,1,:,:,:),bin_edges_a, ...
                        'Normalization','probability');
    dist_b = histcounts(Aij_prime(1,2,:,:,:),bin_edges_b, ...
                        'Normalization','probability');
    
    % Grab bin centers.
    bin_centers_a = zeros(1,num_bins_a);
    bin_centers_b = zeros(1,num_bins_b);
    for i = 1:num_bins_a
        bin_centers_a(i) = (bin_edges_a(i)+bin_edges_a(i+1))/2;
    end
    for i = 1:num_bins_b
        bin_centers_b(i) = (bin_edges_b(i)+bin_edges_b(i+1))/2;
    end
    
    %%%
    % Plot PDFs and Gaussian fits.
    %%%
    
    
    pdf_size = [6.5,3];
    h = figure('Position',aligned_position(...
                          100*pdf_size(1),100*pdf_size(2)), ...
               'PaperUnits','inches', ...
               'PaperSize',pdf_size, ...
               'PaperPosition',[0,0,pdf_size]);
    hold on;
    
    % Plot actual PDFs.
    plot(bin_centers_a, dist_a*(num_bins_a/(2*histogram_radius_a)), ...
         '-','LineWidth',2);
    plot(bin_centers_b, dist_b*(num_bins_b/(2*histogram_radius_b)), ...
         '-','LineWidth',2);
     
    % Calculate and plot Gaussian fits.
    avg_a = 0;
    avg_b = 0;
    dev_a = 0;
    dev_b = 0;
    for i = 1:num_bins_a
        avg_a = avg_a + dist_a(i) * bin_centers_a(i);
        dev_a = dev_a + dist_a(i) * bin_centers_a(i)^2;
    end
    dev_a = sqrt(dev_a);
    for i = 1:num_bins_b
        avg_b = avg_b + dist_b(i) * bin_centers_b(i);
        dev_b = dev_b + dist_b(i) * bin_centers_b(i)^2;
    end
    dev_b = sqrt(dev_b);
    gaussian_a = ...
        (1/(dev_a*sqrt(2*pi)))*exp(-(bin_centers_a-avg_a).^2/(2*dev_a^2));
    gaussian_b = ...
        (1/(dev_b*sqrt(2*pi)))*exp(-(bin_centers_b-avg_b).^2/(2*dev_b^2));
    plot(bin_centers_a,gaussian_a,'--','LineWidth',1.5);
    plot(bin_centers_b,gaussian_b,':','LineWidth',1.5);
    
    % Legend
    legend('A''_{11}','A''_{12}','A''_{11} Gaussian','A''_{12} Gaussian');
    
    % Display settings.
    hold off;
    xlim([-2,2]);
    box on;
    xlabel('A''_{ij} Value');
    ylabel('Probability Density');

    if save_plots
        % Save figures to file (dpdf = PDF file) (loose = uncropped)
        filename = ['../images/prob2_2.pdf'];
        fprintf(['Saving <',filename,'>...']);
        print(h,'-dpdf','-loose',filename);
        fprintf(' done. \n');
    end
    
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    %%%%%%%% Problem 2.3 %%%%%%%%%
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    
    % Calculate skewness and kurtosis of A'_11.
    skew_a = 0;
    kurt_a = 0;
    for i = 1:num_bins_a
        skew_a = skew_a + dist_a(i) * bin_centers_a(i)^3;
        kurt_a = kurt_a + dist_a(i) * bin_centers_a(i)^4;
    end
    skew_a = skew_a / (dev_a)^3;
    kurt_a = kurt_a / (dev_a)^4;
    
    fprintf('Skew     of A''_11 is %+10.5d.\n',skew_a);
    fprintf('Kurtosis of A''_11 is %+10.5d.\n',kurt_a);
    
end

