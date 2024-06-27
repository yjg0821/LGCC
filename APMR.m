
function [apmr] = APMR(img, peak, b)
    if( nargin < 2 )
        peak = 255;
    end
    if( nargin < 3 )
        b = 0;
    end
    
    if( b > 0 )
        img = img(b:size(img,1)-b, b:size(img,2)-b,:);
    end

    [row, col, ~] = size(img);
    img_tmp = img(:,:,1) + img(:,:,3) - img(:,:,2) - img(:,:,4);
    img_tmp = img_tmp .* img_tmp;
    img_sum = sum(sum(img_tmp));
    apmr = 10 * log10( peak * peak * row * col / img_sum );
end
