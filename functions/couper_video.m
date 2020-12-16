clear all

%% DECLARE THE 3 MOVIE FILES
[file_left,currentFolder]=uigetfile('*.mp4','SELECT LEFT');
cd(currentFolder)

vid_left = VideoReader([currentFolder file_left]);
[file_right,path_right]=uigetfile('*.mp4','SELECT RIGHT');
vid_right = VideoReader([currentFolder file_right]);
[file_grincam,path_grincam]=uigetfile('*.mp4','SELECT GRIN CAM');
vid_grincam = VideoReader([currentFolder file_grincam]);


answer_txt = inputdlg('Which pursuit is it on the full video?');
answer_num = str2num(answer_txt{:}); 

foldername1 = sprintf('pursuit_%d', answer_num);
mkdir(foldername1)
cd(foldername1)

%% reduce LEFT

prompt = {'Enter Start Frame:','Enter Stop Frame:'};
dlg_title = 'LEFT VIDEO PURSTUIT FRAMES';
num_lines = 1;
Left_bornes = inputdlg(prompt,dlg_title,num_lines);
frame_start = str2num(Left_bornes{1});
frame_stop = str2num(Left_bornes{2});

% left_vid_name = sprintf('LEFT_%d.avi', answer_num);
LEFT = VideoWriter('LEFT.avi');
LEFT.FrameRate = vid_left.FrameRate;
open(LEFT)
current_frame = 1;
h = waitbar(0,'Proceeding LEFT...');
for current_frame = frame_start:frame_stop
% Extract the frame from the movie structure.
    thisFrame = read(vid_left,current_frame);
    writeVideo(LEFT,thisFrame);    
    waitbar((current_frame-frame_start) / (frame_stop-frame_start))

end
close(h) 
close(LEFT)
clearvars current_frame;
    
%% reduce RIGHT
prompt = {'Enter Start Frame:','Enter Stop Frame:'};
dlg_title = 'RIGHT VIDEO PURSTUIT FRAMES';
num_lines = 1;
Right_bornes = inputdlg(prompt,dlg_title,num_lines);
frame_start = str2num(Right_bornes{1});
frame_stop = str2num(Right_bornes{2});


    
RIGHT = VideoWriter('RIGHT.avi');
RIGHT.FrameRate = vid_right.FrameRate;
open(RIGHT)
current_frame = 1;
h = waitbar(0,'Proceeding RIGHT...');
for current_frame = frame_start:frame_stop
% Extract the frame from the movie structure.
    thisFrame = read(vid_right,current_frame);
    writeVideo(RIGHT,thisFrame);    
    waitbar((current_frame-frame_start) / (frame_stop-frame_start))
end
close(h) 
close(RIGHT)
clearvars current_frame;
% 
%reduce GRINCAM
% frame_start = 1150;
% frame_stop = 1242;
prompt = {'Enter Start Frame:','Enter Stop Frame:'};
dlg_title = 'Embedded video pursuit frames';
num_lines = 1;
Embedded_bornes = inputdlg(prompt,dlg_title,num_lines);
frame_start = str2num(Embedded_bornes{1});
frame_stop = str2num(Embedded_bornes{2});


GRINCAM = VideoWriter('GRINCAM.avi');
GRINCAM.FrameRate = vid_grincam.FrameRate;
open(GRINCAM)
current_frame = 1;
h = waitbar(0,'Proceeding GRINCAM...');
for current_frame = frame_start:frame_stop
% Extract the frame from the movie structure.
    thisFrame = read(vid_grincam,current_frame);
    writeVideo(GRINCAM,thisFrame);
    waitbar((current_frame-frame_start) / (frame_stop-frame_start))
end
close(h) 
close(GRINCAM)

