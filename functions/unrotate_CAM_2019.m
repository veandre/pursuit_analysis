
clear all


[filename,filepath]=uigetfile('*.avi','SELECT VIDEO CAM to UNROTATE');
cd(filepath)
vid1=VideoReader([filepath filename]);

% vid1 = VideoReader('E:\chasing\RX0\spycam_C0004.MP4');

epsilon = -0.05;
unrot = VideoWriter('unrot240fps');
% fps = vid1.FrameRate; % images par secondes
fps = 240;
unrot.FrameRate = fps;
open(unrot)

unrot1 = VideoWriter('unrot24fps');
fps1 = 24;
unrot1.FrameRate = fps1;
open(unrot1)

unrot2 = VideoWriter('unrot2_4fps');
fps2 = 2.4;
unrot2.FrameRate = fps2;
open(unrot2)

delta_time= 8; % ms
MOT_CAM= 2400; % en Hz ou steps par secondes
red_mot_CAM = 1024; % en step par tour

% vitesse rotation de la boule:
vit_ang = MOT_CAM/red_mot_CAM *2*3.14; % en rad/seconde
vit_ang = vit_ang * 180/3.14; % en deg par seconde
% angle de rotation interimage:
%rot = (MOT_CAM/red_mot_CAM) / 50 *180/3.14; % attention 30fps dans la formule???

rot = vit_ang /fps +  epsilon; % remplacer par fps pour un qqch de clean

% Setup other parameters
vidHeight = vid1.Height;
vidWidth = vid1.Width;

% Preallocate movie structure.
mov = struct('cdata', zeros(vidHeight, 1730-660, 3, 'uint8'),'colormap',[]);

% Disp first frame and center the ROI
F1 = figure('name','POINTER BOULE PUIS REMONTER LA TIGE','NumberTitle','off');
IM = readFrame(vid1);
IMcut = IM(:,[660:1730],:);
imshow(IMcut);

% track the ball and its rod
barre = drawline;
pos = barre.Position;

% find the rotation angle
delta = atan2d(pos(2,2)-pos(1,2),pos(2,1)-pos(1,1)) + 90; % plus 90 pour que la tige soit verticale et non horizontale

% disp the image rotated 
IMG= imrotate(IMcut,rot+delta,'bilinear','crop');
imshow(IMG);

% foldername1 = sprintf('pursuit_%d', answer_num);
mkdir('unrot')
cd('unrot')
% imwrite(IMG,'im1.png')


%% BUILD THE MOVIE
nframe = vid1.Duration * vid1.FrameRate;
wb = waitbar(1/nframe,'unrotate movie');

for n = 1:nframe-1
    
    waitbar(n/nframe,wb)
    IM = readFrame(vid1);
    IMcut = IM(:,[660:1730],:);
    %         t2= size (IMG(:,:,:));
    
    %         IMG1= imrotate(IMG,k*rot+delta,'bilinear','crop');
    %         plusX = (t2(2)-t2(1))/2;
    %         IMG2(1:t2(1),1:t2(1),:) = IMG1(1:t2(1),plusX:t2(2)-plusX-1,:);
    %         IMG= imrotate(IMG,k*rot+delta,'bilinear','crop');
    
    IMG= imrotate(IMcut,n*rot+delta,'bilinear','crop');
    
    
    %         IMG3= [  IMG2 ];
    %         IMG3= flip(IMG3,2);
    mov(n).cdata = IMG;
    %         mov2(k).cdata = IMG3;
    
    writeVideo(unrot,IMG);
    writeVideo(unrot1,IMG);
    writeVideo(unrot2,IMG);

% mkdir('unrot')
% cd('unrot')
if n<=9
        imagename1 = sprintf('im_00%d', n);

elseif n>9 && n <=99

        imagename1 = sprintf('im_0%d', n);
else
        imagename1 = sprintf('im_%d', n);

end
      imwrite(IMG,[imagename1 '.png'])  
    
    %     k = k + 1;
end


close(wb)
close(unrot)
close(unrot1)
close(unrot2)
close(F1)

hf1 = figure;
set(hf1, 'position', [-1150 -150 vidHeight*0.78 vidHeight*0.78])
movie(hf1, mov, 1, 10);

close(hf1)
cd ..



