%% Computer Vision Challenge 2020 challenge.m

% Supress warnings
warning('off','images:activecontour:vanishingContour') ;% Active Contour Warning
%% Start timer here
tic
%% Generate Movie

loop= 0;
ren_im = {};
left_input = {};
right_input = {};
masks = {}; 
while loop ~= 1
    % Get next image tensors
    [left,right,loop]= ir.next();
    left_input = [left_input, left{1}];
    right_input = [right_input, right{1}];
    ir.start = ir.start + ir.N;
    % Generate binary mask
    mask = segmentation(left,right);
    masks = [masks, mask]; 
    % Render new frame
    ren_im{end+1} = render(left{1},mask,bg,ren_mode);
       
end

%% Write Movie to Disk
if store
    v = VideoWriter(dest,'Motion JPEG AVI');
    v.FrameRate = 5; % set Frame Rate
    % open the video writer
    open(v);
    for u=1:length(ren_im)
        % convert the image to a frame
        frame = im2frame(ren_im{u});
        writeVideo(v, frame);
    end
    close(v); % close the writer object
end
%% Stop timer here
elapsed_time = toc;
run_time = ['Total time of execution: ',num2str(elapsed_time), ' Seconds'];
disp(run_time);