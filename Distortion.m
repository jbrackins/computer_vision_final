function Distortion( image, amplitude, type )
%Distortion warp image to appear as if they have been wrapped around sphere
%%% Julian Anthony Brackins   %%%
%%% CSC 514 - Computer Vision %%%
%%% Final Exam                %%%
    

%Code for computing barrel and pincushion inspired by matlab website:
% http://www.mathworks.com/help/images/examples/creating-a-gallery-of-transformed-images.html?searchHighlight=barrel%20transformation#zmw57dd0e4190

    clc
    close all

    fprintf('Running Distortion.m...\n\n');

    if nargin < 3
       %Set a default type so program doesn't break
       type = 'PINCUSHION'; 

       %Inform user of default settings
       fprintf('type of distortion not specified...\n');
       fprintf('\tusing %s as default...\n', type);
    end
    
    %Preserve original colour image, but use grayscale
    imageOriginal = image;
    imageGray = rgb2gray(image);
    [nrows,ncols] = size(imageGray);
    
    %Create meshgrid
    [xi,yi] = meshgrid(1:ncols,1:nrows);
    
    %Get midpoint
    midpoint = round(size(imageGray,2)/2);
    resamp = makeresampler('linear','fill');

    %Determine xt, yt, theta, and r
    xt = xi(:) - midpoint;
    yt = yi(:) - midpoint;
    [theta,r] = cart2pol(xt,yt);
    
    %BARREL DISTORTION
    if strcmp(type, 'BARREL')
        if nargin < 2 | amplitude < 0
            amplitude = .00009; 
            fprintf('invalid amplitude value... \n');
            fprintf('\tusing default of %f...\n', amplitude);
        end   
    end

    %PINCUSHION DISTORTION
    if strcmp(type,'PINCUSHION')
        if nargin < 2 | amplitude > 0
            amplitude = -.000009;
            fprintf('invalid amplitude value... \n');
            fprintf('\tusing default of %f...\n', amplitude);
        end
    end

    %calculate s from radius and amplitude
    s = r + amplitude*r.^3;
    
    %Get u, v
    [ut,vt] = pol2cart(theta,s);
    u = reshape(ut,size(xi)) + midpoint;
    v = reshape(vt,size(yi)) + midpoint;
    
    %Build transformation map
    tmap_B = cat(3,u,v);
    imageTransformed = tformarray(imageOriginal,[],resamp,[2 1],[1 2],[],tmap_B,.3);

    %Display results
    figure, imshow(imageTransformed)
    title(type)  
    
    %Output console info
    fprintf('\n');
    fprintf('+~+~+~+~+~+~+~+~+~+~+~+~+~+~+~+~+~+\n');
    fprintf('Distortion.m:\n');
    fprintf('\tAmplitude Value: %f\n', amplitude);
    fprintf('\tDistortion Type: %s\n', type);
    fprintf('+~+~+~+~+~+~+~+~+~+~+~+~+~+~+~+~+~+\n');

    
end