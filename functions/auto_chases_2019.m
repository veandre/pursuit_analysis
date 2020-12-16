
%% debut de l'histoire
clear all
% close all

% load('G:\RECORDS\expe\TEST_ARBO_MATLAB\2\9_positions\recal_workspace1.mat')
% load('C:\Users\matlab\Desktop\leandre\TEST_ARBO_MATLAB\2\9_positions\recal_workspace1.mat')
% load('C:\Users\leand\Desktop\chasing_2019\codes\ARBO_MATLAB\recal_workspace1.mat')

% load('C:\Users\leand\Desktop\chasing_2019\calib19\calib4points\recal_workspace.mat')

[file_recal,path_recal] = uigetfile('*.mat',...
               'Select the recal file','recal_workspace.mat');
load([path_recal '/' file_recal])

clear ball fly;


% -------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------


for analysed_chase =1:3

    
    % Import XYZ data from DLTDV5 .CSV FILE
    if analysed_chase ==1
        [fichier,chemin]=uigetfile('DLTdv5_data_xyzFilt.csv','OUVRIR DLTdv5 data xyzFilt');
        %         legendgraph = {['BALL'] ['FLY']};
    end
    if analysed_chase ==2
        [fichier,chemin]=uigetfile('mouche_xyzpts.csv','OUVRIR mouche xyzpts');
        %         legendgraph = {['HEAD'] ['ASS']};
    end
    if analysed_chase ==3
        [fichier,chemin]=uigetfile('mouche_xyzFilt.csv','OUVRIR mouche xyzFilt');
        %         legendgraph = {['HEAD'] ['ASS']};
    end
    
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
    
    
    %%  RECAL STEREO POINTS IN ARENA REFERENCE
    
    % double décalage, D est le point qui servait d'origine pour les ROT, et D
    % a sa position propre dans le repere absolu qui est ORIGIN(1,:)
    % ATTENTION ON CHANGE LES COORDONNES POUR AVOIR UN REPERE CORRECT AVEC Z EN
    % ALTITUDE: ORIGIN AVANT ORIGINE CORRIGé
    
%     D = [137.5 242.5 345];
%     ORIGINE = [0 0 0];
%     ORIGINE(1) = ORIGIN(1,1);
%     ORIGINE(2) = ORIGIN(1,3);
%     ORIGINE(3) = -ORIGIN(1,2);
%     
%     x = [0 500];
%     y = [0 700];
%     z = [0 500];
%     
%     CA = [x(1) y(1) z(2)];
%     CB = [x(2) y(1) z(2)];
%     CC = [x(1) y(2) z(2)];
%     CD = [x(2) y(2) z(2)];
%     CE = [x(1) y(1) z(1)];
%     CF = [x(2) y(1) z(1)];
%     CG = [x(1) y(2) z(1)];
%     CH = [x(2) y(2) z(1)];
%     
%     cadre = [CA;CB;CC;CD;CE;CF;CG;CH];
%     
%     plateau_calib = plateau_calib+[D;D;D;D;D;D;D;D;D];

cadre = cadre_large;

    nb_points = size(rec1xyzpts)/3;
    recal_dat= zeros(size(rec1xyzpts));
    recal_data= zeros(size(rec1xyzpts));
    
    for n = 0: nb_points(2)-1
        for i = 1 : 3
            recal_dat(:,i+3*n) = rec1xyzpts(:,i+n*3);%-ORIGIN(1,i);
        end
    end
    
    %  DECALAGE changement des axes [xyz] = [x z -x]
    
%     for n = 0: nb_points(2)-1
%         recal_data(:,1+3*n) = recal_dat(:,1+3*n);
%         recal_data(:,2+3*n) = recal_dat(:,3+3*n);
%         recal_data(:,3+3*n) = -recal_dat(:,2+3*n);
%     end
    
    for n = 0: nb_points(2)-1
        recal_data(:,1+3*n) = recal_dat(:,1+3*n);
        recal_data(:,2+3*n) = recal_dat(:,2+3*n);
        recal_data(:,3+3*n) = recal_dat(:,3+3*n);
    end
    
    ball = recal_data(:,1:3);
    fly = recal_data(:,4:6);
    
    %  DECALAGE rotation avec le nouveau repere
    
    ball = ball * RX * RY * RZ;
    fly = fly * RX * RY * RZ;
    
    %  DECALAGE avec le point dorigine
    
    for i = 1 : 3
%         ball(:,i) = ball(:,i)+D(i)-ORIGINE(i);
%         fly(:,i) = fly(:,i)+D(i)-ORIGINE(i);
        ball(:,i) = ball(:,i) - point2(i) + point2_theo(i);
        fly(:,i) = fly(:,i) - point2(i) + point2_theo(i);
    end
    
    
    %% CREATING CHASING
    
    % N = 3;                 % Order of polynomial fit
    % F = 5;                 % Window length
    % [b,g] = sgolay(N,F);   % Calculate S-G coefficients
    %
    % dt = 0.00526;
    %
    % HalfWin  = ((F+1)/2) -1;
    % for i=1:3
    %     for n = (F+1)/2 : length(ball)-(F+1)/2,
    %         % Zeroth derivative (smoothing only)
    %         SG0_ball(n,i) = dot(g(:,1),ball(n - HalfWin:n + HalfWin , i));
    %         SG0_fly(n,i) = dot(g(:,1),fly(n - HalfWin:n + HalfWin , i));
    %         % 1st differential
    %         SG1_ball(n,i) = dot(g(:,2),ball(n - HalfWin:n + HalfWin , i));
    %         SG1_fly(n,i) = dot(g(:,2),fly(n - HalfWin:n + HalfWin , i));
    %
    %         % 2nd differential
    %         SG2_ball(n,i) = 2*dot(g(:,3)',ball(n - HalfWin:n + HalfWin , i))';
    %         SG2_fly(n,i) = 2*dot(g(:,3)',fly(n - HalfWin:n + HalfWin , i))';
    %     end
    %     SG1_ball(:,i) = SG1_ball(:,i)/dt;         % Turn differential into derivative
    %     SG1_fly(:,i) = SG1_fly(:,i)/dt;
    %     SG2_ball(:,i) = SG2_ball(:,i)/(dt*dt);    % and into 2nd derivative
    %     SG2_fly(:,i) = SG2_fly(:,i)/(dt*dt);
    % end
    
    %% on remplace les SGOLAY par des diff et dt car nos data sont deja smooth (xyzFILT)
    
    dt = 0.00526;
    
    SG0_ball = ball;
    SG0_fly = fly;
    
    SG1_ball = diff(ball)/dt;
    SG1_fly = diff(fly)/dt;
    
    SG2_ball = diff(SG1_ball)/dt/dt;
    SG2_fly = diff(SG1_fly)/dt/dt;
    
    
    %%
    
    n_chase =1;
    
    for ii = 1:size(SG0_fly,1)
        DTT(ii,1) = sqrt((SG0_fly(ii,1)-SG0_ball(ii,1))^2+(SG0_fly(ii,2)-SG0_ball(ii,2))^2+(SG0_fly(ii,3)-SG0_ball(ii,3))^2);
    end
    
    n = size(ball,1);
    
    chase = struct('time',[1 n*5],...
        'DTT_diff',DTT,...
        'position_ball',SG0_ball(:,:),...
        'position_fly',SG0_fly(:,:),...
        'speed_ball',SG1_ball(:,:),...
        'speed_fly',SG1_fly(:,:),...
        'accel_ball',SG2_ball(:,:),...
        'accel_fly',SG2_fly(:,:));
    
    ri=1;
    
    for r = 1:n-1
        speed_ball_mod(ri) = sqrt((SG1_ball(r,1))^2+...
            (SG1_ball(r,2))^2+...
            (SG1_ball(r,3))^2);
        ri = ri+1;
        speed_fly_mod(ri) = sqrt((SG1_fly(r,1))^2+...
            (SG1_fly(r,2))^2+...
            (SG1_fly(r,3))^2);
    end
    
    %% SAVE WORKSPACE
    
    if analysed_chase ==1
        all_chases = chase;
        SG0_ball_chase=SG0_ball;
        SG0_fly_chase=SG0_fly;
        SG1_ball_chase = SG1_ball;
        SG1_fly_chase = SG1_fly;
        SG2_ball_chase=SG2_ball;
        SG2_fly_chase=SG2_fly;
        speed_ball_mod_chase = speed_ball_mod;
        speed_fly_mod_chase = speed_fly_mod;
        save('chases&orientations1.mat','cadre','all_chases','SG0_ball_chase','SG0_fly_chase','SG1_ball_chase','SG1_fly_chase','SG2_ball_chase','SG2_fly_chase','speed_ball_mod_chase','speed_fly_mod_chase')
    end
    
    if analysed_chase ==2
        chase_orientation_VRAIE = chase;
        save('chases&orientations2.mat','chase_orientation_VRAIE')
    end
    
    if analysed_chase ==3
        chase_orientation_FILT = chase;
        save('chases&orientations3.mat','chase_orientation_FILT','SG0_ball','SG0_fly','SG1_ball','SG1_fly','SG2_ball','SG2_fly','speed_ball_mod','speed_fly_mod')
    end
    
    
end


% clear all

load('chases&orientations1.mat')
load('chases&orientations2.mat')
load('chases&orientations3.mat')
save('chases&orientations.mat')
