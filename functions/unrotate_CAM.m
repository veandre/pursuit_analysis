
clear all


[filename,filepath]=uigetfile('*.mp4','SELECT VIDEO CAM to UNROTATE');
cd(filepath)
vid1=VideoReader([filepath filename]);
%vid1 = VideoReader('G:\RECORDS\expe\11-10-16\7\GRINCAM3.avi');
%vid2 = VideoReader('G:\RECORDS\expe\11-10-16\7\LEFT1.avi');
%load('G:\RECORDS\expe\11-10-16\7\xypointsCHASE1.mat')

% unrot = VideoWriter([filepath 'unrot' filename ]);
unrot = VideoWriter('unrot');
fps = vid1.FrameRate; % images par secondes
unrot.FrameRate = fps;
open(unrot)

delta_time= 8; % ms
MOT_CAM= 2400; % en Hz ou steps par secondes
red_mot_CAM = 1024; % en step par tour

% vitesse rotation de la boule:
vit_ang = MOT_CAM/red_mot_CAM *2*3.14; % en rad/seconde
vit_ang = vit_ang * 180/3.14; % en deg par seconde
% angle de rotation interimage:
%rot = (MOT_CAM/red_mot_CAM) / 50 *180/3.14; % attention 30fps dans la formule???

rot = vit_ang /fps; % remplacer par fps pour un qqch de clean
%deg=360/40;

%%// Setup other parameters
%nFrames = 508-180+1;
vidHeight = vid1.Height;
vidWidth = vid1.Width;

%// Preallocate movie structure.
mov2 = struct('cdata', zeros(vidHeight*2, vidWidth, 3, 'uint8'),'colormap',[]);
mov = struct('cdata', zeros(vidHeight, vidWidth, 3, 'uint8'),'colormap',[]);

k = 1;
figure
IM = readFrame(vid1);
imshow(IM);
h = impoint(gca,[]);
%position = wait(h);
pos = getPosition(h)
pos(1) = -pos(1);
pos = pos - [-320 240]
close 
delta = atan2d(pos(1), pos(2));
delta = delta-180


%// Read one frame at a time.
while hasFrame(vid1)
        IMG = readFrame(vid1);
        t2= size (IMG(:,:,:));

        IMG1= imrotate(IMG,k*rot+delta,'bilinear','crop'); 
        plusX = (t2(2)-t2(1))/2;
        IMG2(1:t2(1),1:t2(1),:) = IMG1(1:t2(1),plusX:t2(2)-plusX-1,:);
        IMG= imrotate(IMG,k*rot+delta,'bilinear','crop');


        IMG3= [  IMG2 ];
        IMG3= flip(IMG3,2);
        mov(k).cdata = IMG2;
        mov2(k).cdata = IMG3;
        
    writeVideo(unrot,IMG3);    


    k = k + 1;
end



close(unrot)

hf1 = figure;
set(hf1, 'position', [150 150 vidHeight vidHeight])
movie(hf1, mov2, 1, 10);


% % %% Import the EVENTS
% % [fichier_evt,chemin_evt]=uigetfile('*.xls','OUVRIR EVENTS');
% % %cd(chemin)
% % if fichier_evt
% % [~, ~, raw] = xlsread([chemin_evt fichier_evt]);
% % raw(cellfun(@(x) ~isempty(x) && isnumeric(x) && isnan(x),raw)) = {''};
% % cellVectors = raw(:,1);
% % raw = raw(:,2);
% % data = reshape([raw{:}],size(raw));
% % debut_rot = cellVectors(:,1);
% % frame_events = data(:,1);
% % clearvars data raw cellVectors;
% % end
% 
% % %%
% % n_chase = length(frame_events)/2;
% % 
% % for n= 1:n_chase
% %     for nn=1:(frame_events(n*2)-frame_events(n*2-1))    
% %         IMG = mov(frame_events(n*2-1)+nn).cdata;
% %         figure 
% %         imshow(IMG);
% %         chase(nn) = struct('cdata', IMG,'colormap',[]);
% %     end
% % 
% % chases(n)= struct('chases', chase);
% % clearvars nn;
% % end
% % 
% % hf1 = figure;
% % set(hf1, 'position', [150 150 vidHeight*2 vidWidth])
% % movie(hf1, chase, 1, xyloObj.FrameRate/10);
% 
% 
