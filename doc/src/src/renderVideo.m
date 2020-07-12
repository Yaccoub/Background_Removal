
function [result] = renderVideo(frames,masks,vid_bg)
% This function takes in an series of images and their binary
% masks to return images rendred using the virtual bakcground
% video.
%
% Input:
%   - frames: cell array containing images 
%   - masks: cell array of all binary masks.
%   - vid_bg: video to be used as a virtual background
%
% Output:
%   - result: resulting image after rendering 
%
vidBg = VideoReader(vid_bg);
bgFrames=vidBg.NUmberofframes;
[row, col, ~] = size(frames{1});
result = cell(size(min(length(frames), bgFrames)));
for i= 1:min(length(frames), bgFrames) 
        frame = im2double(frames{i});
        mask = im2double(masks{i});
        maskInv = im2double(~(logical(mask))); % construct an inverted mask (Bg= 1, Fg= 0 )
        vidframe = im2double(readFrame(vidBg));
        vidframe = imresize(vidframe , [row col]); % set the size of the virtual background equal to the mask's size 
        vBg = rescale(maskInv .* vidframe); % crop the virtual background according to the shape of the real backgorund 
        rFg = rescale(mask .* frame);  %compute detected foreground on black background
        result{i} = rescale(vBg + rFg); % compute real detected foreground on virtual background 
        imshow(result{i});
end
end