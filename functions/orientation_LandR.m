
clear all
%% Import dlt xy points du tracking initial 
%filename = 'G:\RECORDS\expe\11-10-16\7\DLTdv5_data3_xypts.csv';
[filename,filepath]=uigetfile('DLTdv5_data_xypts.csv','OUVRIR DLT XY POINTS');
cd(filepath)

%filename = 'G:\RECORDS\expe\11-10-16\7\DLTdv5_data1_xypts.csv';
delimiter = ',';
startRow = 2;

formatSpec = '%f%f%f%f%f%f%f%f%[^\n\r]';

fileID = fopen([filepath filename]);

dataArray = textscan(fileID, formatSpec, 'Delimiter', delimiter, 'HeaderLines' ,startRow-1, 'ReturnOnError', false);
fclose(fileID);
DLTdv5dataxypts = [dataArray{1:end-1}];
clearvars filename delimiter startRow formatSpec fileID dataArray ans;
%% SELECT VIDEO
[filename,filepath]=uigetfile('LEFT*.avi','SELECT VIDEO LEFT');
% cd(filepath)
vidL=VideoReader([filepath filename]);
clearvars filename filepath
[filename,filepath]=uigetfile('RIGHT*.avi','SELECT VIDEO RIGHT');
% cd(filepath)
vidR=VideoReader([filepath filename]);

% unrot = VideoWriter([filepath 'unrot' filename ]);
FILM_LR_ROI = VideoWriter('LR_ROI_V01_test');
fps = vidL.FrameRate; % images par secondes
FILM_LR_ROI.FrameRate = fps/10;
open(FILM_LR_ROI)

%%// Setup other parameters

vidHeight = vidL.Height;
vidWidth = vidL.Width;

%// Preallocate movie structure.
mov2 = struct('cdata', zeros(vidHeight, vidWidth, 3, 'uint8'),'colormap',[]);

k = 1;
IMG1L = zeros(121,121,3,'uint8');
%IMP1L = zeros(121,121,3,'uint8');
IMG2 = zeros(484,242,3,'uint8');


%% ATTENTION SI PAS D'EVENT ALORS DECOM NEXT ROWs 
% DLTdv5dataxypts1 = DLTdv5dataxypts(321:801,:);
% clear DLTdv5dataxypts;
% DLTdv5dataxypts = DLTdv5dataxypts1;

%%
LINES = zeros(size(DLTdv5dataxypts,1),8);

hL = waitbar(0,'Proceeding LEFT...');
figL = figure
%% LEFT TRACK
% while hasFrame(vidL)
for k=1:size(DLTdv5dataxypts,1)
        IMGL = readFrame(vidL);
t1= size (IMGL(:,:,:));
if isnan(DLTdv5dataxypts(k,1)) || isnan(DLTdv5dataxypts(k,3))
IMGL = IMGL;
else
posL   = [DLTdv5dataxypts(k,1) t1(1)-DLTdv5dataxypts(k,2); DLTdv5dataxypts(k,5) t1(1)-DLTdv5dataxypts(k,6)];
IMP1L = imcrop(IMGL, [posL(2,1)-20 posL(2,2)-20 40 40 ]); % [xmin ymin width height]
IMG1L = imcrop(IMGL, [posL(2,1)-120 posL(2,2)-120 240 240 ]); % [xmin ymin width height]
end
IMP1L = imresize(IMP1L,6);
% GRAND LEFT
IMG2(1:size(IMG1L,1), 1:size(IMG1L,2),:) =  IMG1L(:,:,:);
% PETIT LEFT
IMG2(end-size(IMP1L,1)+1:end, 1:size(IMP1L,2),:) = IMP1L(:,:,:);
IMG3 = [  IMG2(:,:,:)];
imshow(IMG3)
        ligneL=imline;
        coorL=getPosition(ligneL);
        LINES(k,1) = coorL(1);
        LINES(k,2) = coorL(2);
        LINES(k,3) = coorL(3);
        LINES(k,4) = coorL(4);

        waitbar(k/size(DLTdv5dataxypts,1))
end
close (figL)
close (hL)

%% RIGHT TRACK
k = 1;
hR = waitbar(0,'Proceeding RIGHT...');
figR = figure
IMP1R = zeros(121,121,3,'uint8');
% while hasFrame(vidL)
for k=1:size(DLTdv5dataxypts,1)
        IMGR = readFrame(vidR);
t1= size (IMGR(:,:,:));
if isnan(DLTdv5dataxypts(k,1)) || isnan(DLTdv5dataxypts(k,3))
IMGR = IMGR;
else
posR   = [DLTdv5dataxypts(k,3) t1(1)-DLTdv5dataxypts(k,4); DLTdv5dataxypts(k,7) t1(1)-DLTdv5dataxypts(k,8)];
IMP1R = imcrop(IMGR, [posR(2,1)-20 posR(2,2)-20 40 40 ]); % [xmin ymin width height]
IMG1R = imcrop(IMGR, [posR(2,1)-120 posR(2,2)-120 240 240 ]); % [xmin ymin width height]
end
IMP1R = imresize(IMP1R,6);
IMG2(1:size(IMG1R,1), 1:size(IMG1R,2),:) =  IMG1R(:,:,:);

IMG2(end-size(IMP1R,1)+1:end, 1:size(IMP1R,2),:) = IMP1R(:,:,:);
IMG3 = [  IMG2(:,:,:)];

imshow(IMG3)
        ligneR=imline;
        coorR=getPosition(ligneR);
        LINES(k,5) = coorR(1);
        LINES(k,6) = coorR(2);
        LINES(k,7) = coorR(3);
        LINES(k,8) = coorR(4);
            waitbar(k/ size(DLTdv5dataxypts,1))
end
close (figR)
close (hR)

%% CORECTION DES POINTS 
% 
pointcentral = [121 484-121];
tete_xy = LINES(:,[1,3,5,7]);
tete_xy1(:,[1,3]) = -tete_xy(:,[1,3]) +pointcentral(1);
tete_xy1(:,[2,4]) = tete_xy(:,[2,4]) -pointcentral(2);
% resize factor = 6
tete_xy2(:,:) = tete_xy1(:,:) /6;
tete_xy3(:,:) = -tete_xy2(:,:) + DLTdv5dataxypts(:,[5:8]);
tete_xy4(:,:) = round(tete_xy3,9,'significant');

% CUL
cul_xy = LINES(:,[2,4,6,8]);
cul_xy1(:,[1,3]) = -cul_xy(:,[1,3]) + pointcentral(1);
cul_xy1(:,[2,4]) = cul_xy(:,[2,4]) - pointcentral(2);
% resize factor = 6
cul_xy2(:,:) = cul_xy1(:,:) /6;
cul_xy3(:,:) = -cul_xy2(:,:) + DLTdv5dataxypts(:,[5:8]);
cul_xy4(:,:) = round(cul_xy3,9,'significant');

%%

mouche_xy = table([tete_xy4(:,1)],[tete_xy4(:,2)],[tete_xy4(:,3)],[tete_xy4(:,4)],...
    [cul_xy4(:,1)],[cul_xy4(:,2)],[cul_xy4(:,3)],[cul_xy4(:,4)],...
    'VariableNames',{'pt1_cam1_X' 'pt1_cam1_Y' 'pt1_cam2_X' 'pt1_cam2_Y' ...
    'pt2_cam1_X' 'pt2_cam1_Y' 'pt2_cam2_X' 'pt2_cam2_Y'});

writetable(mouche_xy,'mouche_xypts.csv','Delimiter',',','QuoteStrings',true);

% vidL.CurrentTime = 1/vidL.FrameRate*70;
% FRAME50 = readFrame(vidL);
% imshow(FRAME50)
% h = imline(gca,[tete_xy4(70,1) cul_xy4(70,1)], [tete_xy4(70,2) cul_xy4(70,2)]);

