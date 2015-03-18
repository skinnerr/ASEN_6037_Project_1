function [ enstrophy, enstrophy_mean ] = problem_2_6( HIT )
    
    % A_ij vectors, indexed by [i,j,x,y,z], where x,y,z are actually the
    % coordinate indices.
    [Aij, Aij_mean] = problem_2_1(HIT);
    
    Aij_prime = zeros(size(Aij));
    for i = 1:3
    for j = 1:3
        Aij_prime(i,j,:,:,:) = Aij(i,j,:,:,:) - Aij_mean(i,j);
    end
    end
    
    % Calculate the fluctuating vorticity field w'_i, indexed by [i,x,y,z].
    s = size(Aij_prime);
    s = s(3:5);
    wi_prime = zeros([3,s]);
    wi_prime(1,:,:,:) = reshape(squeeze(...
                    Aij_prime(3,2,:,:,:) - Aij_prime(2,3,:,:,:)),[1,s]);
    wi_prime(2,:,:,:) = reshape(squeeze( ...
                    Aij_prime(1,3,:,:,:) - Aij_prime(3,1,:,:,:)),[1,s]);
    wi_prime(3,:,:,:) = reshape(squeeze( ...
                    Aij_prime(2,1,:,:,:) - Aij_prime(1,2,:,:,:)),[1,s]);
    
    % Calculate enstrophy field, 0.5 * (w'_i w'_i).
	enstrophy = squeeze(0.5*sum(wi_prime.^2));
    
    % Calculate volume average of the above.
    enstrophy_mean = mean(mean(mean(enstrophy)));
    
    % Report volume average of enstrophy.
    fprintf('Volume average of Omega is as follows:\n   %+10e\n', ...
            enstrophy_mean);
    
end

