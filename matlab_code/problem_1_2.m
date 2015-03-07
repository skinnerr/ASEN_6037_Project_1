function [] = problem_1_2( HIT, HST, save_plots )

    % Note: RED  = max(u)/2
    %       BLUE = min(u)/2

    for simulation_case = {'HIT','HST'}

        if (strcmp(simulation_case,'HIT'))
            u_vel = HIT(1,:,:,:);
        else
            u_vel = HST(1,:,:,:);
        end
        % Remove singleton dimensions.
        u_vel = squeeze(u_vel);
        
        half_u_min = min(min(min(u_vel)))/2;
        half_u_max = max(max(max(u_vel)))/2;

        % Switch x,y-axes for isosurface, since index (Y,X,Z) expected.
        u_vel = permute(u_vel,[2,1,3]);

        % Set size (inches) of PDF to output, and make figure.
        pdf_size = [3,3.5];
        h = figure('Position',aligned_position(...
                              100*pdf_size(1),100*pdf_size(2)), ...
                   'PaperUnits','inches', ...
                   'PaperSize',pdf_size, ...
                   'PaperPosition',[0,0,pdf_size]);

        % Isosurface for u_max/2.
        p = patch(isosurface(u_vel,half_u_max));
        isonormals(u_vel,p);
        set(p,'FaceColor','red','EdgeColor','none');

        % Isosurface for u_min/2.
        p = patch(isosurface(u_vel,half_u_min));
        isonormals(u_vel,p);
        set(p,'FaceColor','blue','EdgeColor','none');

        % Set figure properties.
        daspect([1,1,1]);   % Set aspect ratio for grid.
        view(3);            % Place camera at standard location for 3D.
        axis('tight');      % Set axes to span only data domain.
        camlight();         % Add lighting, default to from the right.
        lighting('gouraud');% Set how lighting interacts with surface.
        title(simulation_case);
        xlabel('x');
        ylabel('y');
        zlabel('z');
        set(gca,'XTick',[1,256]);
        set(gca,'YTick',[1,129]);
        set(gca,'ZTick',[1,256]);
        set(gca,'XTickLabel',{'0','2\pi'});
        set(gca,'YTickLabel',{'0','\pi'});
        set(gca,'ZTickLabel',{'0','2\pi'});
        %legend('max(u)/2','min(u)/2','Location','northwest');

        if save_plots
            % Save figures to file (dpdf = PDF file) (loose = uncropped)
            filename = ['../images/prob1_2_',char(simulation_case),'.pdf'];
            fprintf(['Saving <',filename,'>...']);
            print(h,'-dpdf','-loose',filename);
            fprintf(' done. \n');
        end

    end

end

