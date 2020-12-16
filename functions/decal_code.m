%% code pour trouver les bonnes valeurs de TR, RX, RY, RZ après la nouvele calibration du 04/04/2017
% et le quadrillage de l'aire efficace

% clear all

% valeurs moteurs simple round
% load('theo_XY_longP.mat');

x = [0 112.5 225];
y = 0;
z = [0 157.5 315];

A = [x(1) y z(1)];
B = [x(1) y z(2)];
C = [x(1) y z(3)];
D = [x(2) y z(1)];
E = [x(2) y z(2)];
F = [x(2) y z(3)];
G = [x(3) y z(1)];
H = [x(3) y z(2)];
I = [x(3) y z(3)];


plateau_calib = [A;D;G;B;E;H;C;F;I];


%% Import XYZ data from DLTDV5 .CSV FILE 
[fichier,chemin]=uigetfile('*.csv','open xyz (non filt) file of the 9 calib points');
cd(chemin)
%filename = 'F:\RECORDS\27_01_2016\1m_par_secxyzpts.csv';
delimiter = ',';
startRow = 2;
formatSpec = '%s%s%s%s%s%s%[^\n\r]';
fileID = fopen([chemin fichier],'r');

dataArray = textscan(fileID, formatSpec, 'Delimiter', delimiter, 'HeaderLines' ,startRow-1, 'ReturnOnError', false);
fclose(fileID);
raw = repmat({''},length(dataArray{1}),length(dataArray)-1);
for col=1:length(dataArray)-1
    raw(1:length(dataArray{col}),col) = dataArray{col};
end
numericData = NaN(size(dataArray{1},1),size(dataArray,2));
for col=[1,2,3,4,5,6]
    rawData = dataArray{col};
    for row=1:size(rawData, 1);
        regexstr = '(?<prefix>.*?)(?<numbers>([-]*(\d+[\,]*)+[\.]{0,1}\d*[eEdD]{0,1}[-+]*\d*[i]{0,1})|([-]*(\d+[\,]*)*[\.]{1,1}\d+[eEdD]{0,1}[-+]*\d*[i]{0,1}))(?<suffix>.*)';
        try
            result = regexp(rawData{row}, regexstr, 'names');
            numbers = result.numbers;
            invalidThousandsSeparator = false;
            if any(numbers==',');
                thousandsRegExp = '^\d+?(\,\d{3})*\.{0,1}\d*$';
                if isempty(regexp(thousandsRegExp, ',', 'once'));
                    numbers = NaN;
                    invalidThousandsSeparator = true;
                end
            end
            if ~invalidThousandsSeparator;
                numbers = textscan(strrep(numbers, ',', ''), '%f');
                numericData(row, col) = numbers{1};
                raw{row, col} = numbers{1};
            end
        catch me
        end
    end
end
R = cellfun(@(x) ~isnumeric(x) && ~islogical(x),raw); % Find non-numeric cells
raw(R) = {NaN}; % Replace non-numeric cells
rec1xyzpts = cell2mat(raw);
clearvars fichier delimiter formatSpec fileID dataArray ans raw col numericData rawData row regexstr result numbers invalidThousandsSeparator thousandsRegExp me R;


%% TRANSLATION 1 POUR SE RAMENER à A (0:300:0)
ORIGIN = rec1xyzpts;

mir_TR1(:,1) = rec1xyzpts(:,1)-ORIGIN(1,1);
mir_TR1(:,2) = rec1xyzpts(:,2)-ORIGIN(1,2);
mir_TR1(:,3) = rec1xyzpts(:,3)-ORIGIN(1,3);

showPointCloud(ORIGIN(:,1:3),[1 1 0], 'MarkerSize', 20);

clearvars rec1xyzpts

%% RX
thetaX =  atan2  (-mir_TR1(7,2), mir_TR1(7,3)) ; %  [-Y , Z] !!

RX = [  1               0               0;...
        0               cos(thetaX)    -sin(thetaX);...
        0               sin(thetaX)    cos(thetaX)];
    
mir_ROTX = mir_TR1 * RX;

%% RY
thetaY =   atan2 ( mir_ROTX(7,1) , mir_ROTX(7,3)) ; % [X , Z]   avt 1 /  3

RY = [  cos(thetaY)     0               sin(thetaY);...
        0               1               0;...
        -sin(thetaY)    0               cos(thetaY)];
    
mir_ROTY = mir_ROTX * RY;

%% rot Z
thetaZ =  atan2 (mir_ROTY(3,2), mir_ROTY(3,1)) ; % [Y , X]

RZ = [  cos(thetaZ)     -sin(thetaZ)    0;...
        sin(thetaZ)     cos(thetaZ)     0;...
        0               0               1];    
    
mir_ROTZ = mir_ROTY * RZ;

%% FIGURE
figure
showPointCloud(mir_TR1,[0 0 0], 'MarkerSize', 20);
hold on
showPointCloud(mir_ROTX,[1 0 0], 'MarkerSize', 15);
showPointCloud(mir_ROTY,[0 1 0], 'MarkerSize', 15);
showPointCloud(mir_ROTZ,[0 0 1], 'MarkerSize', 15);
showPointCloud(ORIGIN(:,1:3),[1 1 0], 'MarkerSize', 20);

axis equal
xlabel('X')
ylabel('Y')
zlabel('Z')
legend('mir TR1','mir ROTX','mir ROTY','mir ROTZ','ORIGIN')

err = mir_ROTZ - plateau_calib;

err_x = mean(err(:,1))
err_y = mean(err(:,2))
err_z = mean(err(:,3))

S1 = mir_ROTZ + plateau_calib;
S1 = S1./2;
S = err./S1;

save('recal_workspace1.mat')
