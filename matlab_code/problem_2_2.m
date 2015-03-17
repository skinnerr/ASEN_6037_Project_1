function [] = problem_2_2( HIT, save_plots )
    
    % A_ij vectors, indexed by [i,j,x,y,z], where x,y,z are actually the
    % coordinate indices.
    [Aij, Aij_mean] = problem_2_1(HIT);
    
    Aij_prime = zeros(size(Aij));
    for i = 1:3
    for j = 1:3
        Aij_prime(i,j,:,:,:) = Aij(i,j,:,:,:) - Aij_mean(i,j);
    end
    end
    
    max(max(max(Aij_prime(1,1,:,:,:))))
    max(max(max(Aij_prime(1,2,:,:,:))))
    min(min(min(Aij_prime(1,1,:,:,:))))
    min(min(min(Aij_prime(1,2,:,:,:))))
    
    %%%
    % Calculate PDFs for A'_11 and A'_12.
    %%%
    
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    %%%%%%%%%%%%%%%%%%%%% TODO TODO TODO TODO %%%%%%%%%%%%%%%%%%%%%%%%
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    
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
    
end

