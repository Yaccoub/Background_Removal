 baseFileName = 'bg.jpg';
% Get the full filename, with path prepended.
folder = []; % Determine where demo folder is (works with all versions).
fullFileName = fullfile(folder, baseFileName);
%===============================================================================
% Read in a demo image.
vidbg = VideoReader('vidbg2.mov');
bg = im2double(imread(fullFileName));
% frame= double(left{1, 30});
%double(cell2mat(struct2cell(load('frame.mat'))));


% mask = double(mask{1,30}); %double(cell2mat(struct2cell(load('mask.mat'))));
[row, col] = size(mask);
mode = 'substitute';
ImageSeq = {};
% result = render(frame,mask,bg,mode);
% imshow((result));

 for i = 100:305%length(left)
            vidframe = double(readFrame(vidbg));
            vidframe = imresize(vidframe , [row col]);
            vidframe = rescale(vidframe, 0,255);
            renderIm = render(double(left{i}),double(mask{i}),vidframe,mode);
            ImageSeq{end +1} = renderIm;
 end
        outputVideo = VideoWriter('virbg43.avi');
        outputVideo.FrameRate = vidbg.FrameRate;
        open(outputVideo);
        for i = 1:length(ImageSeq)
            img = rescale(ImageSeq{i});
            writeVideo(outputVideo,img);
        end
        close(outputVideo)
