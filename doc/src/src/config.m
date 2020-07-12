%% Computer Vision Challenge 2020 config.m

%% Generall Settings
% Group number:
% group_number = 0;

% Group members:
% members = {'Max Mustermann', 'Johannes Daten'};

% Email-Address (from Moodle!):
% mail = {'ga99abc@tum.de', 'daten.hannes@tum.de'};


%% Setup Image Reader
% Specify Scene Folder
src = "C:\Users\yacco\Documents\TUM\Computer Vision\Challenge\Dataset\P1E_S1";
% Select Cameras
L = 1 
R = 3 

% Choose a start point
% start = randi(1000)

% Choose the number of succseeding frames
% N =

ir = ImageReader(src, L, R, start, N);


%% Output Settings
% Output Path
dst = "output.avi";

% Load Virual Background
% bg = imread("Path\to\my\virtual\background")

% Select rendering mode
mode = "substitute";

% Create a movie array
% movie =

% Store Output?
store = true;
