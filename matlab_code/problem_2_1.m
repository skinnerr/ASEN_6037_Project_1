function [ Aij, Aij_mean ] = problem_2_1( HIT )
% Calculates the velocity gradient tensor (A_ij = d u_i / d x_j) for HIT.
    
    % A_ij vectors, indexed by [i,j,x,y,z], where x,y,z are actually the
    % coordinate indices.
    dims = size(HIT);
    dims = dims(2:end);
    Aij = zeros([3,3,dims]);
    
    % Scaling to account for location indices being separated by pi/128.
    gradient_scaling = 3.14159 / 128;
    
    %%%
    % Calculate velocity gradient tensors!
    %%%
    
    for i = 1:3
        fprintf('Calculating A_%1ij...',i);
        % Note the transpose here, since gradient function flips x and y.
        [grad_i1,grad_i2,grad_i3] = ...
            gradient(permute(squeeze(HIT(i,:,:,:)),[2,1,3]));
        Aij(i,1,:,:,:) = reshape(grad_i1,[1,1,dims]);
        Aij(i,2,:,:,:) = reshape(grad_i2,[1,1,dims]);
        Aij(i,3,:,:,:) = reshape(grad_i3,[1,1,dims]);
        fprintf(' done.\n');
    end
    Aij = Aij / gradient_scaling;
    
    % Calculate volume average of A_ij.
    Aij_mean = zeros(3,3);
    for i = 1:3
    for j = 1:3
        Aij_mean(i,j) = mean(mean(mean(Aij(i,j,:,:,:))));
    end
    end
    
    % Report volume average of A_ij.
    fprintf('Volume average of A_{ij} is as follows:\n');
    for i = 1:3
        fprintf('i = %1i, j = {1,2,3}:',i)
        for j = 1:3
            fprintf('   %+10.4e',Aij_mean(i,j));
        end
        fprintf('\n');
    end
    
end

