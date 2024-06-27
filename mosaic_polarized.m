
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function [raw, mosaic, mask] = mosaic_polarized(img)
    img = double(img);
    [row, col, ch] = size(img);
    raw = zeros(row, col);
    mosaic = zeros(row, col, ch);
    mask = zeros(row, col, ch);
    
    mask(1 : 2 : end, 1 : 2 : end, 1) = 1;
    mask(1 : 2 : end, 2 : 2 : end, 2) = 1;
    mask(2 : 2 : end, 2 : 2 : end, 3) = 1;
    mask(2 : 2 : end, 1 : 2 : end, 4) = 1;
    
    mosaic(:,:,1) = img(:,:,1) .* mask(:,:,1);
    mosaic(:,:,2) = img(:,:,2) .* mask(:,:,2);
    mosaic(:,:,3) = img(:,:,3) .* mask(:,:,3);
    mosaic(:,:,4) = img(:,:,4) .* mask(:,:,4);
    
    raw(1 : 2 : end, 1 : 2 : end) = img(1 : 2 : end, 1 : 2 : end, 1);
    raw(1 : 2 : end, 2 : 2 : end) = img(1 : 2 : end, 2 : 2 : end, 2);
    raw(2 : 2 : end, 2 : 2 : end) = img(2 : 2 : end, 2 : 2 : end, 3);
    raw(2 : 2 : end, 1 : 2 : end) = img(2 : 2 : end, 1 : 2 : end, 4);
end
