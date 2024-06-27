
function [Stokes] = StokesCalculation(img)
    img = double(img);
    
    S0 = (img(:,:,1) + img(:,:,2) + img(:,:,3) + img(:,:,4)) * 0.5;
    S1 = img(:,:,1) - img(:,:,3);
    S2 = img(:,:,2) - img(:,:,4);

    DoLP = sqrt(S1.^2 + S2.^2) ./ S0;
    AoP = atan2d(S2, S1);
    AoP(AoP < 0) = AoP(AoP < 0) + 360;
    AoP = 1 ./ 2 .* AoP;
    
    Stokes(:,:,1) = img(:,:,1);
    Stokes(:,:,2) = img(:,:,2);
    Stokes(:,:,3) = img(:,:,3);
    Stokes(:,:,4) = img(:,:,4);
    Stokes(:,:,5) = S0;
    Stokes(:,:,6) = S1;
    Stokes(:,:,7) = S2;
    Stokes(:,:,8) = clip(DoLP, 0, 1);
    Stokes(:,:,9) = clip(AoP, 0, 180);
end



