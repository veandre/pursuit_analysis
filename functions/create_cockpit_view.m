

clear all
selpath = uigetdir(path);
cd(selpath)

load('chases&orientations.mat')
target_fly=[];
body_filt=[];
body_true=[];
target_speed_mod = [];
target_speed_horiz = [];
target_speed_vert = [];


% cd ..


Z_pos_fly = NaN(3,3);
Z_pos_target = NaN(3,3);
DTT_to_capt = NaN(3,3);


ANGLES= struct('Type_of_chase',[],'theta_target_fly',[], 'theta_fly_body',[],'theta_velo',[],'theta_velo74',[],'ERROR_LVP',[],'ERROR_74',[],...
    'sp_theta_target_fly',[],'sp_theta_fly_body',[],'sp_theta_velo',[],'sp_theta_velo74',[],'sp_ERROR_LVP',[],'sp_ERROR_74',[]);
ANGLES_D= struct('Type_of_chase',[],'theta_target_fly_d',[], 'theta_fly_body_d',[],'theta_velo_d',[],'theta_velo74_d',[],'ERROR_LVP_d',[],'ERROR_74_d',[],...
    'sp_theta_target_fly_d',[],'sp_theta_fly_body_d',[],'sp_theta_velo_d',[],'sp_theta_velo74_d',[],'sp_ERROR_LVP_d',[],'sp_ERROR_74_d',[]);

dt = 0.00526;

% all_chases = struct('position_ball',[2 0 0; 2 2 0; 0 2 0; -1 2 2; -1 0 2],...
%                                     'position_fly',[0 0 0 ; 2 0 0; 2 2 0; 0 2 0; -1 2 2]);
%
% chase_orientation_FILT = struct('position_ball',[.5 0 0; 2.5 0 0; 1.5 2 0; - 0.5 2 0; -1 1.5 2 ],...
%                                                             'position_fly',[-0.5 0 0; 1.5 0 0; 2.5 2 0; 0.5 2 0; -1 2.5 2 ]);


target_fly= [target_fly;all_chases];
body_filt= [body_filt; chase_orientation_FILT];

pursuite = 1;

theta_target_fly = NaN(size(all_chases(pursuite).position_ball(:,1),1),2);
theta_fly_body = NaN(size(chase_orientation_FILT(pursuite).position_ball(:,1),1),2);
theta_velo = NaN(size(all_chases(pursuite).position_ball(:,1),1),2);

%%  CALCUL DES ANGLES

for i=1:size(chase_orientation_FILT(pursuite).position_ball(:,1))
    
    % MESURE DU VECTEUR TARGET - MOUCHE
    
    X = (all_chases(pursuite).position_ball(i,1)-all_chases(pursuite).position_fly(i,1));
    Y = (all_chases(pursuite).position_ball(i,2)-all_chases(pursuite).position_fly(i,2));
    Z = (all_chases(pursuite).position_ball(i,3)-all_chases(pursuite).position_fly(i,3));
    
    [theta_target_fly(i,1),theta_target_fly(i,2),r_target_fly(i)] = cart2sph(X,Y,Z);
    
    % MESURE DU VECTEUR MOUCHE (TETE CUL)
    
    X_fly_body = chase_orientation_FILT(pursuite).position_ball(i,1)-chase_orientation_FILT(pursuite).position_fly(i,1);
    Y_fly_body = chase_orientation_FILT(pursuite).position_ball(i,2)-chase_orientation_FILT(pursuite).position_fly(i,2);
    Z_fly_body = chase_orientation_FILT(pursuite).position_ball(i,3)-chase_orientation_FILT(pursuite).position_fly(i,3);
    
    [theta_fly_body(i,1),theta_fly_body(i,2),r_fly_body(i)] = cart2sph(X_fly_body,Y_fly_body,Z_fly_body);
    
end

% MESURE DU VECTEUR VITESSE MOUCHE

for i=1:size(chase_orientation_FILT(pursuite).position_ball(:,1))-1
    
    Xvelo = all_chases(pursuite).position_fly(i+1,1)-all_chases(pursuite).position_fly(i,1);
    Yvelo = all_chases(pursuite).position_fly(i+1,2)-all_chases(pursuite).position_fly(i,2);
    Zvelo = all_chases(pursuite).position_fly(i+1,3)-all_chases(pursuite).position_fly(i,3);
    
    [theta_velo(i,1),theta_velo(i,2),rvelo(i)] = cart2sph(Xvelo,Yvelo,Zvelo);
    
end

% MESURE DU VECTEUR VITESSE TANGEANTE (LAND COLLET 1974)

for i=2:size(chase_orientation_FILT(pursuite).position_ball(:,1))-1
    
    X74 = all_chases(pursuite).position_fly(i+1,1)-all_chases(pursuite).position_fly(i-1,1);
    Y74 = all_chases(pursuite).position_fly(i+1,2)-all_chases(pursuite).position_fly(i-1,2);
    Z74 = all_chases(pursuite).position_fly(i+1,3)-all_chases(pursuite).position_fly(i-1,3);
    
    [theta_velo74(i,1),theta_velo74(i,2),r741(i)] = cart2sph(X74,Y74,Z74);
    
end

theta_velo(end,:)=[];
theta_velo74(1,:)=[];

ERROR_LVP = angdiff(theta_fly_body,theta_target_fly);
ERROR_74 = angdiff(theta_velo74,theta_target_fly(2:end-1,:));

%% SPEED

sp_theta_target_fly = angdiff(theta_target_fly)/dt;
sp_theta_fly_body = angdiff(theta_fly_body)/dt;
sp_theta_velo = angdiff(theta_velo)/dt;
sp_theta_velo74 = angdiff(theta_velo74)/dt;

sp_ERROR_LVP = angdiff(ERROR_LVP)/dt;
sp_ERROR_74 = angdiff(ERROR_74)/dt;

ANGLES.theta_target_fly = theta_target_fly;
ANGLES.theta_fly_body = theta_fly_body;
ANGLES.theta_velo = theta_velo;
ANGLES.theta_velo74 = theta_velo74;
ANGLES.ERROR_LVP = ERROR_LVP;
ANGLES.ERROR_74 = ERROR_74;

ANGLES.sp_theta_target_fly = sp_theta_target_fly;
ANGLES.sp_theta_fly_body = sp_theta_fly_body;
ANGLES.sp_theta_velo = sp_theta_velo;
ANGLES.sp_theta_velo74 = sp_theta_velo74;
ANGLES.sp_ERROR_LVP = sp_ERROR_LVP;
ANGLES.sp_ERROR_74 = sp_ERROR_74;



%% RAD TO DEG

theta_target_fly_d = radtodeg(theta_target_fly);
theta_fly_body_d = radtodeg(theta_fly_body);
theta_velo_d = radtodeg(theta_velo);
theta_velo74_d = radtodeg(theta_velo74);

ERROR_LVP_d = radtodeg(ERROR_LVP);
ERROR_74_d = radtodeg(ERROR_74);

sp_theta_target_fly_d = radtodeg(sp_theta_target_fly);
sp_theta_fly_body_d = radtodeg(sp_theta_fly_body);
sp_theta_velo_d = radtodeg(sp_theta_velo);
sp_theta_velo74_d = radtodeg(sp_theta_velo74);

sp_ERROR_LVP_d = radtodeg(sp_ERROR_LVP);
sp_ERROR_74_d = radtodeg(sp_ERROR_74);

ANGLES_D.theta_target_fly_d = theta_target_fly_d;
ANGLES_D.theta_fly_body_d = theta_fly_body_d;
ANGLES_D.theta_velo_d = theta_velo_d;
ANGLES_D.theta_velo74_d = theta_velo74_d;
ANGLES_D.ERROR_LVP_d = ERROR_LVP_d;
ANGLES_D.ERROR_74_d = ERROR_74_d;

ANGLES_D.sp_theta_target_fly_d = sp_theta_target_fly_d;
ANGLES_D.sp_theta_fly_body_d = sp_theta_fly_body_d;
ANGLES_D.sp_theta_velo_d = sp_theta_velo_d;
ANGLES_D.sp_theta_velo74_d = sp_theta_velo74_d;
ANGLES_D.sp_ERROR_LVP_d = sp_ERROR_LVP_d;
ANGLES_D.sp_ERROR_74_d = sp_ERROR_74_d;



%     clearvars ERROR_74 ERROR_74_d ERROR_LVP ERROR_LVP_d sp_ERROR_74  sp_ERROR_LVP  sp_theta_fly_body_d  sp_theta_target_fly_d  sp_theta_velo74 sp_theta_velo74_d sp_theta_velo_d
%     clearvars theta_fly_body  theta_fly_body_d  theta_target_fly  theta_target_fly_d  theta_velo  theta_velo74  theta_velo74_d  theta_velo_d
%     clearvars sp_ERROR_74_d  sp_ERROR_LVP_d  sp_theta_fly_body  sp_theta_target_fly  sp_theta_velo
%


% figure
% plot(ERROR_LVP_d)

% figure
% plot(ERROR_LVP_d)


%%



cd(selpath)
mkdir('cockpit')
cd('cockpit')

%% Set Coordinates
t = linspace(0,2*pi);

v_sphere = VideoWriter('cockpit_sphere.avi');
v_sphere.FrameRate = 5;
open(v_sphere);
v_flat = VideoWriter('cockpit_flat.avi');
v_flat.FrameRate = 5;
open(v_flat);

capture = 1;
az = ANGLES_D(capture).ERROR_LVP_d(:,1);
el = ANGLES_D(capture).ERROR_LVP_d(:,2);

wb = waitbar(1/numel(az),'creating movie');



for i = 1:numel(az)
%     F1 = figure('Position',[-1200 -200 1000 1000],'Color',[.5 .5 .5],'Visible','off'); % gris foncé
%     F1 = figure('Position',[-1200 -200 1000 1000],'Color',[255/255, 200/255, 200/255],'Visible','off'); %rose pale
    F1 = figure('Position',[-1200 -200 1000 1000],'Color',[230/255, 255/255, 230/255],'Visible','off'); %gris clair
    waitbar(i/numel(az),wb)
    % axes('Position',[0 0 1 1])
    % xlim([-180 180]);
    % ylim([-180 180]);
    h = patch;
    h.EdgeColor = 'none';
    axis off
    % grid on
    ax.GridAlpha = 0.5;
    xlim([-90 90])
    xticks([ -90 -45 0 45 90 ])
    ylim([-90 90])
    yticks([ -90 -45 0 45 90])
    
    
    %     sp1 = subplot(2,1,1);
    
    rayon(i)=2*atand(4/target_fly(capture).DTT_diff(i) ); % horizontal radius
    x0(i)=az(i); % x0,y0 ellipse centre coordinates
    y0(i)=el(i);
    t=-pi:0.1:pi+0.1;
    x=x0(i)+rayon(i)*cos(t);
    y=y0(i)+rayon(i)*sin(t);
    
    h.XData =  x0(1,i) + rayon(i)*cos(t);
    h.YData =  y0(1,i) + rayon(i)*sin(t);
    h.FaceVertexCData = h.XData;
    h.FaceColor =[0 .2 0];
    
    hold on
    %     plot([-180 180], [0 0], 'k','lineWidth',2);
%     plot([-5 5], [0 0], 'k','lineWidth',2);
%     plot([0 0], [-5 5], 'k','lineWidth',2);
%         plot([-90 90], [45 45], 'k','lineWidth',2);
%         plot([-45 45], [90 90], 'k','lineWidth',2);
%         plot([-90 90], [-45 -45], 'k','lineWidth',2);
%         plot([-45 45], [-90 -90], 'k','lineWidth',2);
%     plot([45 45], [-90 90], 'k','lineWidth',2);
%     plot([-45 -45], [-90 90], 'k','lineWidth',2);
%     plot([90 90], [-45 45], 'k','lineWidth',2);
%     plot([-90 -90], [-45 45], 'k','lineWidth',2);
% X: 
plot([-90 90], [0 0], 'Color', [.5 .5 .5],'lineWidth',3); %[153/255, 204/255, 255/255], 0, 255, 153
plot([-5 5], [60 60], 'Color', [.5 .5 .5],'lineWidth',3);plot([-5 5], [30 30], 'Color', [.5 .5 .5],'lineWidth',3);plot([-5 5], [-30 -30], 'Color', [.5 .5 .5],'lineWidth',3);plot([-5 5], [-60 -60], 'Color', [.5 .5 .5],'lineWidth',3);
plot([-10 10], [45 45], 'r','lineWidth',3);plot([-10 10], [-45 -45], 'r','lineWidth',3);
% Y:
plot([0 0],[-90 90], 'Color', [.5 .5 .5],'lineWidth',3);
plot([60 60],[-5 5],  'Color', [.5 .5 .5],'lineWidth',3);plot([30 30],[-5 5],  'Color', [.5 .5 .5],'lineWidth',3);plot([-30 -30], [-5 5], 'Color', [.5 .5 .5],'lineWidth',3);plot([-60 -60],[-5 5],  'Color', [.5 .5 .5],'lineWidth',3);
plot([45 45],[-10 10],  'r','lineWidth',3);plot( [-45 -45],[-10 10], 'r','lineWidth',3);
    
    
    
    img = getframe(gca);
    
    F2 = figure('Position',[-1200 -200 720 720],'Color',[.5 .5 .5],'Visible','off');
    
    % ______________________  embeded flat view
    
    %     sp1 = subplot(2,1,1);
    %         sp1 = subplot(4,3,[1,2,4,5]);
    
    IMG_flat = img.cdata(:,:,:);
    
%         imshow(IMG_flat)
    %
    %     if i == 1 % floor(numel(az)/2)
    %     imwrite(IMG_flat,'im3_special.jpg')
    %     end
    
    % ______________________  PROJECTED view
    
    %     sp1_round = subplot(2,1,2);
    %         sp1_round = subplot(4,3,[7,8,10,11]);
    
    % figure
    [imgRows,imgCols,imgPlanes] = size(IMG_flat);
    IMG_flat1 = imresize(IMG_flat,[imgRows imgCols]);
    % imgCols1=imgCols;
    % imgCols1= scale(imgCols1(:),2);
    [X,Y,Z] = sphere(imgRows,imgCols);
    % Y1 = Y;
    % Y1 = reshape(Y1,[2 2]);
    warp(X,-Y,-Z,IMG_flat1);
    view(90,0)
    axis equal
    axis off
    
    img2 = getframe(gcf);
    
    if i<=9
        imagename = sprintf('im_00%d', i);
        
    elseif i>9 && i <=99
        
        imagename = sprintf('im_0%d', i);
    else
        imagename = sprintf('im_%d', i);
        
    end
%     imwrite(img2.cdata,[imagename '.png'])
    imwrite(IMG_flat1,[imagename '.png'])
    
    writeVideo(v_sphere,img2);
    writeVideo(v_flat,IMG_flat1);
    close (F1)
    close (F2)
    
end
close(v_sphere)
close(v_flat)

close (wb)
cd ..

