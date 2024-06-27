function I_LGCC = LGCC(raw, mosaic, mask)

    % Initialize variables
    [row, col, ch] = size(mosaic);
    Filter_bilinear = [1, 2, 1; 2, 4, 2; 1, 2, 1] / 4;

    % Calculate gradients
    gradient_h = abs(imfilter(raw, [-1, 0, 1], 'replicate'));
    gradient_v = abs(imfilter(raw, [-1; 0; 1], 'replicate'));
    gradient_d1 = abs(imfilter(raw, [-1, 0, 0; 0, 0, 0; 0, 0, 1], 'replicate'));
    gradient_d2 = abs(imfilter(raw, [0, 0, -1; 0, 0, 0; 1, 0, 0], 'replicate'));
    
    % Calculate gradient magnitude and weight
    gradient = gradient_h + gradient_v + 0.5 * (gradient_d1 + gradient_d2);
    gradient_weight = 1 - gradient ./ max(gradient(:)) + eps;

    % Initialization
    I_initial = imfilter(gradient_weight .* mosaic, Filter_bilinear, 'replicate') ./ ...
                imfilter(gradient_weight .* mask, Filter_bilinear, 'replicate');

    % Calculate box filter size
    h = 4; v = 4;
    N = boxfilter(ones(row, col), h, v);

    % Calculate means and variances
    means = boxfilter(I_initial, h, v) ./ N;
    vars = abs(boxfilter(I_initial.^2, h, v) ./ N - means.^2) + eps;

    % Calculate PCC and PCC_weight
    channels = [1 2; 1 3; 1 4; 2 3; 2 4; 3 4];
    num_channels = size(channels, 1);
    PCC = zeros(row, col, num_channels);
    PCC_weight = zeros(row, col, num_channels);
    for i = 1 : num_channels
        ch1 = channels(i, 1);
        ch2 = channels(i, 2);
        PCC(:,:,i) = (boxfilter(I_initial(:,:,ch1).*I_initial(:,:,ch2), h, v) ./ N - means(:,:,ch1).*means(:,:,ch2)) ./ sqrt(vars(:,:,ch1).*vars(:,:,ch2));
        PCC_weight(:,:,i) = 1 ./ (sqrt(abs((vars(:,:,ch1) + vars(:,:,ch2)) .* (1 - PCC(:,:,i).^2)) + eps) + eps);
    end
    PCC_weight = clip(PCC_weight, 0, 1);
   
    % Calculate I_LGCC
    I_LGCC = zeros(row, col,ch);
    I_array = [1,2,3,4,1,2,3];
    PCC_array = [1,2,3; 4,5,1; 6,2,4; 3,5,6];
    for k = 1 : ch
        I_diff = mosaic(:,:,k) - I_initial(:,:,I_array(k+1:k+3)) .* mask(:,:,k);
        I_diff = imfilter(gradient_weight .* I_diff, Filter_bilinear, 'replicate') ./ ...
                 imfilter(gradient_weight .* mask(:,:,k), Filter_bilinear, 'replicate');
        I_combined = I_initial(:,:,I_array(k+1:k+3)) + I_diff;
        
        I_LGCC(:,:,k) = sum(PCC_weight(:,:,PCC_array(k,:)) .* I_combined, 3) ./ ...
                        sum(PCC_weight(:,:,PCC_array(k,:)), 3);
    end
    I_LGCC = clip(I_LGCC, 0, 65535);
end