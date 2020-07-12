classdef ImageReader
     properties (Access = public)
        src       = NaN;
        L         = NaN;
        R         = NaN;
        start     = 0;
        N         = 1;
        left_path  = NaN;
        right_path = NaN;
        loop = 0;
         
     end
     methods (Access = public)
%% Constructor
        function ir = ImageReader(src, L, R, start, N)
            %src   string
            %L     {mustBeInteger,mustBeMember(L,[1,2,3])}
            %R     {mustBeInteger,mustBeDiffFrom(R,L),mustBeMember(R,[1,2,3])}
            %start {mustBePositive,mustBeInteger}
            %N     {mustBePositive,mustBeInteger}
            ir.src      = src;
            ir.L        = L;
            ir.R        = R;
            ir.start    = start;
            ir.N        = N;
            ir.left_path  = fullfile(ir.src, "P1E_S1_C" + int2str(ir.L));
            ir.right_path = fullfile(ir.src , "P1E_S1_C" + int2str(ir.R));
        end
       
        function [left, right, loop] = next(ir)
            
            all_file = fullfile(ir.left_path , 'all_file.txt');
            image_names  = strsplit(fileread(all_file), '\n');
            i = 1 ;
            % path images and names
        if (ir.loop == 0)
            % ir.loop to read images
            % computes left and right tensor
            if (ir.start+ir.N) <= size(image_names,2)-1
              for k = ir.start+1:ir.start+ir.N+1
                image_left_path = fullfile(ir.left_path,image_names(k))
                image_right_path = fullfile(ir.right_path,image_names(k));
                left{i} = imread(image_left_path);
                right{i} = imread(image_right_path);
                i = i + 1; 
              end
            else
                ir.loop = 1;
                for k = ir.start:size(image_names,2)-1
                  image_left_path = fullfile(ir.left_path,image_names(k));
                  image_right_path = fullfile(ir.right_path,image_names(k));
                  left{i} = imread(image_left_path);
                  right{i} = imread(image_right_path);
                  i = i +1 ; 
                end
                
            end
  else 
              for k = 1:ir.N
                image_left_path = fullfile(ir.left_path,image_names(k));
                image_right_path = fullfile(ir.right_path,image_names(k));
                left{i} = imread(image_left_path);
                right{i} = imread(image_right_path);
                i = i +1 ; 
              end
                ir.loop = 0;
        end
          loop = ir.loop  ; 
        end
     end
end

function mustBeDiffFrom(a,b)
   if a == b 
     error(['Value assigned to R Value must be different to L '])
   end
end
