function [result] = render(frame,mask,bg,render_mode)
% This function takes in an image(graycaled or colored) and its binary
% mask to return an image rendred according to the specified mode.
%
% Possible Modes:
%   - foreground: Background is set to black. Foreground is visible.
%   - background: Foreground is set to black. Background is visible.
%   - overlay: Foreground and Background are colored with distinguishable colors.
%   - substitute: Background is replaced with a virtual background (bg variable).
%
% Input:
%   - frame: image 
%   - mask: binary image, result segmenting the frame  
%   - bg: image to be used as a virtual background
%   - mode: string, have to be one of the mentioned 4 modes.
%
% Output:
%   - result: resulting image after rendering 
%

frame = im2double(frame);
mask = im2double(mask);
maskInv = im2double(~(logical(mask))); % construct an inverted mask (Bg= 1, Fg= 0 )
[row, col] = size(mask);  
bg = double(imresize(bg , [row col])); % set the size of the virtual background equal to the mask's size 

% switch operation based on chosen mode 
switch render_mode
    case 'foreground'
        result = mask .* frame; % compute detected foreground on black background 
        result = rescale(result);
    case 'background'
        result = maskInv .* frame; % compute background of the frame with the foreground set to black 
        result = rescale(result);
    case 'overlay'
        RGB = [.7 ; .8 ; .15]; % define color for foreground
        RGB2 = [.1 ; .9 ; .9]; % define color for background
        
        fgOv = cat(3, mask * RGB(1), mask * RGB(2), mask * RGB(3)); % apply color on the foreground
        bgOv= cat(3, maskInv * (1- RGB2(1)), maskInv * (1- RGB2(2)), maskInv * (1- RGB2(3))); % apply color on the background
        result = fgOv + bgOv; % compute background and foreground of the frame with different colors
        result = rescale(result);
    case 'substitute'
        vBg = rescale(maskInv .* bg); % crop the virtual background according to the shape of the real backgorund 
        rFg = rescale(mask .* frame);  %compute detected foreground on black background
        result = (vBg + rFg); % compute real detected foreground on virtual background 
        result = rescale(result); 
%         imshow(result)
end

