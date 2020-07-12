%% Forground Detector

% foregroundEst = vision.ForegroundDetector('NumGaussians', 2, 'NumTrainingFrames',10, 'MinimumBackgroundRatio', 0.6);
% mask = [];
% for ii = 1:length(left)
%   img = left{ii};  
%   mask{ii}  = foregroundEst.step(img);
%   se = strel('line',15,90); 
%   mask{ii} = imdilate(mask{ii},se);
%   se = strel('square',3); 
%   mask{ii} = imopen(mask{ii}, se); 
%   mask{ii} = imopen(mask{ii}, strel('rectangle', [5, 5]));
%   mask{ii} = imclose(mask{ii}, strel('octagon', 3));
%   mask{ii} = imfill(mask{ii}, 'holes');
%   imshowpair(left{ii}, mask{ii}, 'montage');
% end


%% Deviation from mean Background

% mask = [];
% bg = mean( cat(4, left{1:length(left)}), 4);
% for ii = 1:length(left)
%   img = left{ii};  
%   mask{ii} = sum(abs(double(left{ii}) - bg), 4) > 60;
%   mask{ii} = double(imbinarize(double(mask{ii}), .7));
%   se = strel('square',3); 
%   mask{ii} = imopen(mask{ii}, se); 
%   mask{ii} = imopen(mask{ii}, strel('rectangle', [5, 5]));
%   mask{ii} = imclose(mask{ii}, strel('octagon', 3));
%   mask{ii} = imfill(mask{ii}, 'holes');
%   imshowpair(left{ii},double(mask{ii}), 'montage');
% end

%% Thresholding

% for ii = 1:length(left)
%     mask{ii} = imbinarize(rgb2gray(left{ii}), 0.3);
%     imshowpair(left{ii}, mask{ii}, 'montage');
% end

%% Adaptive Thresholding

% for ii = 1:length(left)
%     grayImage = rgb2gray(left{ii});
%     Thres = adaptthresh(grayImage, 0.45);
%     mask{ii} = imbinarize(grayImage,Thres);
%     mask{ii} = imopen(mask{ii}, strel('rectangle', [3,3]));
%     mask{ii} = imclose(mask{ii}, strel('rectangle', [15,15]));
%     mask{ii} = imfill(mask{ii}, 'holes');
%     imshowpair(left{ii}, mask{ii}, 'montage');
% end

%% Otsu Threshold

% I=rgb2gray(left{1,50}); % Read the Image
% [counts,x] = imhist(I,256);
% stem(x,counts)
% T = otsuthresh(counts);
% BW = imbinarize(I,T);
% figure
% imshow(double(BW))

%% Image Analyst Method

% [lowThreshold, highThreshold] = threshold(4, 20, left{1,50});
% binaryImage = (left{1,50} > lowThreshold) & (left{1,50} < highThreshold);
% imshow(binaryImage, []);