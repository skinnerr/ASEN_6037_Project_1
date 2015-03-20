function [] = problem_3_1( HIT, save_plots )

    %%%
    % Calculate fluctuating velocity field.
    %%%
    
    % Get the mean velocity components thoroughout the whole domain.
    s = size(HIT);
    xyzAvg = zeros(3,1);
    uPrime = zeros(size(HIT));
    for dim = 1:3
        xyzAvg(dim) = mean(mean(mean(HIT(dim,:,:,:))));
        uPrime(dim,:,:,:) = HIT(dim,:,:,:) - xyzAvg(dim);
    end
    
    %%%
    % Calculate the u-velocity autocorrelation as a function of r.
    %%%
    
    fprintf('Calculating u-velocity autocorrelation for x-slices of...');
    rho_avg = zeros(s(2),1);
    for i = 1:length(rho_avg)
        if ~mod(i-1,10)
            fprintf('\ni = ');
        end
        if i ~= length(rho_avg)
            fprintf('%3i, ',i);
        else
            fprintf('%3i.\n',i);
        end
        for r = 0:(length(rho_avg)-1)
            % Radius uses periodic boundaries.
            iPrime = 1+mod(i+r-1,length(rho_avg));
            slice_rho_avg = uPrime(1,i,:,:) .* uPrime(1,iPrime,:,:);
            rho_avg(r+1) = rho_avg(r+1) + ...
                mean(mean(slice_rho_avg)) / length(rho_avg);
        end
    end
    rho_avg = rho_avg / mean(mean(mean(uPrime(1,:,:,:).*uPrime(1,:,:,:))));
    
    %%%
    % Calculate the integral scale and the Taylor scale.
    %%%
    
    bound_index = 129;
    int_scale = sum(rho_avg(1:bound_index));
    fprintf('Integral scale = %10e.\n',int_scale*(2*pi)/256);
    
    % Evaluate 4th-order accurate one-sided numerical 2nd deriv. at r=0.
    second_deriv = ((15/4)  * rho_avg(1) + ...
                    (-77/6) * rho_avg(2) + ...
                    (107/6) * rho_avg(3) + ...
                    (-13)   * rho_avg(4) + ...
                    (61/12) * rho_avg(5) + ...
                    (-5/6)  * rho_avg(6)) / ...
                   ((2*pi)/256)^2;
    taylor_scale = sqrt(-2*(1/second_deriv));
    fprintf('Second deriv = %10e.\n',second_deriv);
    fprintf('Taylor scale = %10e.\n',taylor_scale);
    
    %%%
    % Plot the autocorrelation with its eponential and gaussian forms!
    %%%

    % Set size (inches) of PDF to output, and make figure.
    pdf_size = [6.5,3];
    h = figure('Position',aligned_position(...
                          100*pdf_size(1),100*pdf_size(2)), ...
               'PaperUnits','inches', ...
               'PaperSize',pdf_size, ...
               'PaperPosition',[0,0,pdf_size]);
    hold on;
    
    % Calculate fits.
	r = 0:length(rho_avg)-1;
    exp_fit = exp(-r/int_scale);
    gauss_fit = exp((-pi/4)*(r/int_scale).^2);
    
    % Plots.
    plot(r,zeros(length(r),1),'-.k','LineWidth',1);
    plot(r,rho_avg,'-','LineWidth',2);
    plot(r,exp_fit,'--','LineWidth',1.5);
    plot(r,gauss_fit,':','LineWidth',1.5);
    plot(0.458*(256/(2*pi))*[1,1],[-0.3,1.1],'-','LineWidth',1);
    plot(0.606*(256/(2*pi))*[1,1],[-0.3,1.1],'-','LineWidth',1);
    legend('Zero', ...
           'Autocorrelation','Exponential Fit','Gaussian Fit', ...
           'Integral Scale','Taylor Scale');
    
    % Annotate plot.
    hold off;
    box on;
    xlim([0,128]);
    ylim([-0.3,1.1]);
    ylabel('\rho(r)');
    set(gca,'XTick',[0,32,64,96,128]);
    set(gca,'XTickLabel',{'0','\pi/4','\pi/2','3\pi/4','\pi'});
    xlabel('r');
    
    % Reposition and resize plot..
    % [left, bottom, width, height]
    position = get(gca,'pos');
    position = position + [0,0.05,0,-0.05];
    set(gca,'pos',position)

    if save_plots
        % Save figures to file (dpdf = PDF file) (loose = uncropped)
        filename = ['../images/prob3_1.pdf'];
        fprintf(['Saving <',filename,'>...']);
        print(h,'-dpdf','-loose',filename);
        fprintf(' done. \n');
    end

end