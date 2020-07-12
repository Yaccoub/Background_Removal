classdef ImageReader
     properties (Access = public)
        src       = NaN;
        L         = NaN;
        R         = NaN;
        start     = 0;
        N         = 1;
        leftPath  = NaN;
        rightPath = NaN;
     end
     methods (Access = public)
%% Constructor
        function ir = ImageReader(src, L, R, start, N)
            src   string
            L     {mustBeInteger,mustBeMember(L,[1,2,3])}
            R     {mustBeInteger,mustBeDiffFromL(R,L),mustBeMember(L,[1,2,3])}
            start {mustBePositive,mustBeInteger}
            N     {mustBePositive,mustBeInteger}
            ir.src      = src;
            ir.L        = L;
            ir.R        = R;
            ir.start    = start;
            ir.N        = N;
            ir.leftPath  = fullfile(ir.src, "P1E_S1_C" + int2str(ir.L));
            ir.rightPath = fullfile(ir.src, "P1E_S1_C" + int2str(ir.R));
         
        end
       
        function [left, right, loop] = next()
            % left path images
            allfileLeft = leftPath + "\all_file.txt"
            fileLeft = fileread(allfileLeft);
            filenamesLeft  = strsplit(fileLeft, '\n');
            % right path images
            allfileRight = rightPath + "\all_file.txt"
            fileRight = fileread(allfileRight);
            filenamesRight  = strsplit(fileRight, '\n');
            % loop for left path images
            for k = 1:length(filenamesLeft)
                imageLeftPath = fullfile(leftPath,filenamesLeft(k));
                imread(imageLeftPath)
            end
            % loop for right path images
            for j = 1:length(filenamesRight)
                imageRightPath = fullfile(rightPath,filenamesRight(j));
                imread(imageRightPath)
            end
            
            left  = 0;
            right = 1;
            loop  = 1;
        end
     end

     

end
function mustBeDiffFromL(a,b)
   if a == b 
     error(['Value assigned to R Value must be different to L '])
   end
end
