function [] = problem_1_1( HIT, HST )

    max_HIT = zeros(1,3);
    max_HST = zeros(1,3);
    min_HIT = zeros(1,3);
    min_HST = zeros(1,3);
    for i = [1,2,3]
        max_HIT(i) = max(max(max(HIT(i,:,:,:))));
        max_HST(i) = max(max(max(HST(i,:,:,:))));
        min_HIT(i) = min(min(min(HIT(i,:,:,:))));
        min_HST(i) = min(min(min(HST(i,:,:,:))));
    end
    disp('HIT: Maximum velocities (u,v,w):');
    disp(max_HIT)
    disp('HIT: Minimum velocities (u,v,w):');
    disp(min_HIT)
    disp('HST: Maximum velocities (u,v,w):');
    disp(max_HST)
    disp('HST: Minimum velocities (u,v,w):');
    disp(min_HST)

end

