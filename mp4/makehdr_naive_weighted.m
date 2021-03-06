function hdr = makehdr_naive_weighted(ldrs, exposures)
    % ldrs is an m x n x 3 x k matrix which can be created with ldrs = cat(4, ldr1, ldr2, ...);
    % exposures is a vector of exposure times (in seconds) corresponding to ldrs
    [exposures,sortexp] = sort(reshape(exposures,1,1,1,[]));
    ldrs = ldrs(:,:,:,sortexp); %Sort exposures from dark to light
    [height, width, channels, length] = size(ldrs);
    hdr = zeros(height, width, channels);
    
    w = @(z) double(128-abs(z-128));
    total_weight = 0;
    for i = 1 : length
        weight = w(ldrs(:, :, :, i));
        total_weight = total_weight + weight;
        hdr = hdr + weight .* ldrs(:, :, :, i) ./ exposures(i);
    end
    
    hdr = hdr ./ total_weight;
end
