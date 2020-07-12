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

foregroundEst = vision.ForegroundDetector('NumGaussians',2, 'NumTrainingFrames',1, ...
    'MinimumBackgroundRatio', 0.6, 'LearningRate', 0.01);

mask = cell(size(left));
threshold = 0.2;
for ii = 1:length(left)
    img = imadjust(rgb2gray(left{ii}));
    mask{ii} = foregroundEst.step(img);
    
    mask{ii} = medfilt2(mask{ii}, [5 5]);
    mask{ii} = bwmorph(mask{ii}, 'bridge', 10');
    mask{ii} = bwmorph(mask{ii}, 'close', 10');
    mask{ii} = bwmorph(mask{ii}, 'fill', 10');
    mask{ii} = bwmorph(mask{ii}, 'thicken', 10');
    mask{ii} = bwconvhull(mask{ii}, 'objects');
    mask{ii} = imfill(mask{ii}, 'holes');
    
    if ii > 2
        prevImg = imadjust(rgb2gray(histeq(left{ii-1})));
        prevImg2 = imadjust(rgb2gray(histeq(left{ii-2})));
        
        maskBg = ones(size(img));
        maskBg2 = ones(size(img));
        maskBg(abs(img - prevImg) < (threshold * prevImg)) = 0;
        maskBg2(abs(prevImg - prevImg2) < (threshold * prevImg2)) = 0;
        
        maskUpdate = maskBg - maskBg2;
        maskUpdate = medfilt2(maskUpdate, [5 5]);
        maskUpdate = bwmorph(maskUpdate, 'bridge', 10');
        maskUpdate = bwmorph(maskUpdate, 'close', 10');
        maskUpdate = bwmorph(maskUpdate, 'fill', 10');
        maskUpdate = bwmorph(maskUpdate, 'thicken', 10');
        
        boundaries = bwconvhull(maskUpdate);
        boundaries = imclose(boundaries, strel('rectangle', [15, 15]));
        boundaries = imfill(boundaries, 'holes');
        
        mask{ii} = mask{ii} .*  boundaries;
    end
    
    mask{ii} = medfilt2(double(mask{ii}), [5 5]);
    
    mask{ii} = imclose(mask{ii}, strel('rectangle', [15, 15]));
    
    se = strel('line',70,90);
    mask{ii} = imclose(mask{ii},se);
    
    se = strel('disk',5);
    mask{ii} = imopen(mask{ii}, se);
    
    se = strel('disk',15);
    mask{ii} = imclose(mask{ii}, se);
    
    mask{ii} = imfill(mask{ii}, 'holes');
    mask{ii} = imgaussfilt(double(mask{ii}), 2);
    
    %     imshow(left{ii} .* uint8(mask{ii}));
end
end
