% impsnr evaluates the psnr between images
%
% psnr = impsnr(X, Y, peak, b)
%
% Output parameters:
%  psnr: psnr between images X and Y
%
% Input parameters:
%  X: image whose dimensions should be same to that of Y
%  Y: image whose dimensions should be same to that of X
%  peak (optional): peak value (default: 255)
%  b (optional): border size to be neglected for evaluation
%
% Example:
%  X = imreadind('X.png');
%  Y = imreadind('Y.png');
%  psnr = impsnr(X, Y);
%  fprintf('%g\n', psnr);
%
% Version: 20120601
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Miscellaneous tools for image processing                 %
%                                                          %
% Copyright (C) 2012 Masayuki Tanaka. All rights reserved. %
%                    mtanaka@ctrl.titech.ac.jp             %
%                                                          %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function [stokes_rmse, stokes_psnr, stokes_ssim] = RMSE_PSNR_SSIM(X, Y, peak, b)
    if( nargin < 3 )
        peak = 255;
    end
    if( nargin < 4 )
        b = 0;
    end

    if( b > 0 )
        X = X(b:size(X,1)-b, b:size(X,2)-b,:);
        Y = Y(b:size(Y,1)-b, b:size(Y,2)-b,:);
    end

    stokes_mse = zeros(1, size(X, 3));
    stokes_rmse = zeros(1, size(X, 3));
    stokes_psnr = zeros(1, size(X, 3));
    stokes_ssim = zeros(1, size(X, 3));
    
    dif = X - Y;
    dif = dif .* dif;
    for i = 1 : size(dif, 3)
        d = dif(:, :, i);
        stokes_mse(i) = sum( d(:) ) / numel(d);
        stokes_rmse(i) = sqrt(stokes_mse(i));
        stokes_ssim(i) = ssim(X(:,:,i), Y(:,:,i));
        if(i < size(dif, 3) - 1)
            stokes_psnr(i) = psnr(X(:,:,i), Y(:,:,i), peak(1));
        elseif(i < size(dif, 3))
            stokes_psnr(i) = psnr(X(:,:,i), Y(:,:,i), peak(2));
        else
            stokes_psnr(i) = psnr(X(:,:,i), Y(:,:,i), peak(3));
        end     
    end
end
