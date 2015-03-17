function [ pseudo_diss, pseudo_diss_mean ] = problem_2_4( HIT )
    
    % A_ij vectors, indexed by [i,j,x,y,z], where x,y,z are actually the
    % coordinate indices.
    [Aij, Aij_mean] = problem_2_1(HIT);
    
    Aij_prime = zeros(size(Aij));
    for i = 1:3
    for j = 1:3
        Aij_prime(i,j,:,:,:) = Aij(i,j,:,:,:) - Aij_mean(i,j);
    end
    end
    
    % Calculate fluctuating strain rate S'_ij = 0.5(A'_ij + A'_ji).
    Sij_prime = 0.5*(Aij_prime + permute(Aij_prime,[2,1,3,4,5]));
    
    % Calculate pseudo energy dissipation rate 2(S'_ij S'_ij).
    % Indexed by [x,y,z] indices.
    % Squeeze removes singleton dimensions that were eliminated by the
    %   tensor contraction.
    pseudo_diss = 2*(sum(sum(Sij_prime .* Sij_prime))));
    pseudo_diss = squeeze(pseudo_diss);
    
    % Calculate volume average of the above.
    pseudo_diss_mean = mean(mean(mean(pseudo_diss)));
    
    % Report volume average of the pseudo energy dissipation rate field.
    fprintf('Volume average of epsilon/nu is as follows:\n   %+10e\n', ...
            pseudo_diss_mean);
    
end

