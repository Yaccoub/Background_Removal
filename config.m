%% Computer Vision Challenge 2020 config.m

%% Generall Settings
% Group number:
% group_number = 16;

% Group members:
% members = {'Alaeddine Yacoub', 'Kheireddine Achour', 'Mohamed Mezghanni', 'Oumaima Zneidi', 'Salem Sfaxi'};

% Email-Address (from Moodle!):
% mail = {'alaeddine.yacoub@tum.de', 'kheireddine.achour@tum.de', 'mohamed.mezghanni@tum.de', 'oumaima.zneidi@tum.de', 'salem.sfaxi@tum.de'};


%% Setup Image Reader
% Specify Scene Folder
src = "C:\Users\sfaxi\Desktop\CV\P2E_S5";
% Select Cameras
L = 1
R = 2

% Choose a start point
start = 100
% Choose the number of succseeding frames
N = 5
ir = ImageReader(src, L, R, start, N);


%% Output Settings
% Output Path
dest = "output.avi";

% Load Virual Background
bg = imread('C:\Users\sfaxi\Desktop\CV\bg.jpg');

% Select rendering mode
ren_mode = "substitute";

% Store Output?
store = true;
