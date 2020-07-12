function [mask] = segmentation(left,right)
% This function takes in images from the left and
% right camera as tensors left and right.
% Generation of tensors is done with the
% ImageReader Class
%
% Input:
%    - left: tensor of images loaded from the left camera
%    - right: tensor of images loaded from the right camera
%
% Output:
%    - mask: foreground binary mask of the images in tensor left
%


% create a foreground estimator object if not exist
if ~exist('foregroundEst')
    global foregroundEst
    foregroundEst = vision.ForegroundDetector('NumGaussians',2, 'AdaptLearningRate',false, ...
        'MinimumBackgroundRatio', 0.6);
end

%initialize mask as cell array
mask2 = cell(size(left));
threshold = 0.3;

for ii = 1:length(left)
    %% Forground detector
    % foreground detector
    img = imadjust(rgb2gray(histeq(left{ii})));
    mask2{ii} = foregroundEst.step(img, 0.01);
    % filter and edit mask
    mask2{ii} = medfilt2(mask2{ii}, [5 5]);
    mask2{ii} = bwmorph(mask2{ii}, 'bridge', 10');
    mask2{ii} = bwmorph(mask2{ii}, 'close', 10');
    mask2{ii} = bwmorph(mask2{ii}, 'fill', 10');
    mask2{ii} = bwmorph(mask2{ii}, 'thicken', 10');
    mask2{ii} = bwconvhull(mask2{ii}, 'objects');
    mask2{ii} = imfill(mask2{ii}, 'holes');
end
%% Preprocessing
% estimate the mean of the images tensor
maskBG = uint8(mean( cat(4, mask2{1:length(mask2)}), 4));
% filter and edit the mean image
maskBG = medfilt2(maskBG, [5 5]);
maskBG = bwmorph(maskBG, 'close', 10');
maskBG = bwmorph(maskBG, 'fill', 10');
maskBG = bwmorph(maskBG, 'thicken', 10');
maskBG = imclose(maskBG, strel('rectangle', [15, 15]));
maskBG = imfill(maskBG, 'holes');

%% Motion detection
% if three or more frames are given
if length(left) >= 3
    img = left{3};
    % save the previous images
    prevImg = left{2};
    prevImg2 = left{1};
    % reinitialize maskBg if three or more frames are given
    maskBg = ones(size(img));
    maskBg2 = ones(size(img));
    % detect background using motion detection
    maskBg(abs(img - prevImg) < (threshold * prevImg)) = 0;
    maskBg2(abs(prevImg - prevImg2) < (threshold * prevImg2)) = 0;
    maskUpdate = rgb2gray(maskBg - maskBg2);
    maskUpdate(maskUpdate < 1 ) = 0;

    maskUpdate = medfilt2(maskUpdate, [5 5]);
    maskUpdate = bwconvhull(maskUpdate);
    maskUpdate = activecontour(left{1}, maskUpdate, 30);
%% Foreground Mask Generation
    maskBG = rescale(maskUpdate .* im2double(maskBG));
end
%% Post- processing
maskBG = medfilt2(maskBG, [5 5]);

maskBG = imclose(maskBG, strel('rectangle', [15, 15]));

se = strel('line',70,90);
maskBG = imclose(maskBG,se);


se = strel('disk',15);
maskBG = imclose(maskBG, se);

maskBG = imfill(maskBG, 'holes');
maskBG = imgaussfilt(double(maskBG), 2);
mask = maskBG;
% imshow(left{1} .* uint8(maskBG));
end

