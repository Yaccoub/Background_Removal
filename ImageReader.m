classdef ImageReader
    %  read two of the three available scenerey images from a specific folder as an endless loop.
    %  the method next has two outputs: tensors left and right for each selected camera
    %  next functionality load subsequent frames
    properties (Access = public)
        src       = NaN; % sourcepath of the dataset
        L         = NaN; % left camera. value must be {1,2}
        R         = NaN; % right camera. value must be {2,3}
        start     = 0;   % starting frame. must be within length of the dataset.
        N         = 1;   % number of frames to load.
        left_path  = NaN;% path to the frames of the left camera
        right_path = NaN;% path to the frames of the right camera
        loop = 0;        % initiliaze loop value.
    end
    methods (Access = public)
        %% Constructor
        function ir = ImageReader(src, L, R, start, N)
            ir.src      = src;
            ir.L        = L;
            ir.R        = R;
            ir.start    = start;
            ir.N        = N;
            dirlist = dir(ir.src);
            cams = string(dirlist(length(dirlist)).name(1:end-1)); % extracts sourcepath
            ir.left_path  = fullfile(ir.src,  cams + ir.L); % compose the left _path using L value
            ir.right_path = fullfile(ir.src , cams + ir.R); % compose the right _path using R value
        end
        
        function [left, right, loop] = next(ir)
            all_file = fullfile(ir.left_path , 'all_file.txt'); % reads all_file.txt file
            image_names  = strsplit(fileread(all_file), '\n');  % extracts frame names from file
            i = 1 ;
            % path images and names
            if (ir.loop == 0)
                % ir.loop to read images
                % computes left and right tensor
                if (ir.start < size(image_names,2)) % starting point must be within length of dataset
                    if (ir.start+ir.N) <= size(image_names,2)-1 % N frames within length of dataset
                        for k = ir.start+1:ir.start+ir.N+1
                            image_left_path = fullfile(ir.left_path,image_names(k));
                            image_right_path = fullfile(ir.right_path,image_names(k));
                            if exist(image_left_path, 'file') == 2
                                left{i} = imread(image_left_path);   % read i_th left frame
                                right{i} = imread(image_right_path); % read i_th right frame
                            end
                            i = i + 1;
                        end
                    else
                        
                        ir.loop = 1; % N frames exceed dataset length
                        for k = ir.start+1:size(image_names,2)-1 % loop until end of the frames
                            image_left_path = fullfile(ir.left_path,image_names(k));
                            image_right_path = fullfile(ir.right_path,image_names(k));
                            if exist(image_left_path, 'file') == 2
                                left{i} = imread(image_left_path);   % read i_th left frame
                                right{i} = imread(image_right_path); % read i_th right frame
                            end
                            i = i +1 ;
                        end
                    end
                else
                    % returns empty tensors
                    left = {};
                    right= {};
                    loop = 1;
                end
            else
                for k = 1:ir.N % start from first frame in case of loop value equal to 1
                    image_left_path = fullfile(ir.left_path,image_names(k));
                    image_right_path = fullfile(ir.right_path,image_names(k));
                    if exist(image_left_path, 'file') == 2
                                left{i} = imread(image_left_path);   % read i_th left frame
                                right{i} = imread(image_right_path); % read i_th right frame
                            end
                    i = i +1 ;
                end
                ir.loop = 0;
                ir.start = ir.start + ir.N;
            end
            loop = ir.loop  ;
        end
    end
end

