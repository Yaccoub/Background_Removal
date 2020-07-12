N=5;
L=1;
R=2;
start=230;
loop = 0;
src = "C:\Users\sfaxi\Desktop\CV\P2E_S5\" ;
left_path = fullfile(src, "P2E_S5_C" + int2str(L));
right_path = fullfile(src, "P2E_S5_C" + int2str(R));
all_file = left_path + "\all_file.txt";
image_names  = strsplit(fileread(all_file), '\n');
i = 1 ; 
image_names(1);
if (loop == 0)
            % loop to read images
            % computes left and right tensor
            if (start+N) <= size(image_names,2)-1
              for k = start:start+N
                image_left_path = fullfile(left_path,image_names(k));
                image_right_path = fullfile(right_path,image_names(k));
                left{i} = imread(image_left_path);
                right{i} = imread(image_right_path);
                i = i + 1; 
              end
            else
                loop = 1;
                for k = start:size(image_names,2)-1
                  image_left_path = fullfile(left_path,image_names(k));
                  image_right_path = fullfile(right_path,image_names(k));
                  left{i} = imread(image_left_path);
                  right{i} = imread(image_right_path);
                  i = i +1 ; 
                end
                
            end
            
  else 
              for k = 0:N
                image_left_path = fullfile(left_path,image_names(k));
                image_right_path = fullfile(right_path,image_names(k));
                left{i} = imread(image_left_path);
                right{i} = imread(image_right_path);
                i = i +1 ; 
              end
                loop = 0;
  end