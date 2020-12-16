% load('03_03_16_chases.mat')
%
clear all

load('chases&orientations.mat')
%load('C:\Users\matlab\Desktop\leandre\29_08_2017_orientations\fly_EL_0\vid\vid_1\hidden_fly\workspace.mat')

pursuite = 1;

% prompt = 'ANIMATED ALL ORIENTATIONS        1:YES             2:NO            __  ';
% result1 = input(prompt);
result1=2;
switch result1
    case 1
        animated_figure = 1;
    case 2
        animated_figure = 0;
    otherwise
        animated_figure = 0;
end


if animated_figure == 1
    figure('units','normalized','outerposition',[0 0 1 1])
    axis equal
    plot3(cadre(:,1),cadre(:,2),cadre(:,3), 'ok');
    
    hold on
    
    fly = animatedline;
    fly.Color = 'blue';
    fly.LineWidth=1.5;
    fly.MaximumNumPoints= 20;
    
    ball = animatedline;
    ball.Color = 'red';
    ball.LineWidth=1.5;
    ball.MaximumNumPoints= 20;
    
    tete = animatedline;
    tete.Color = 'green';
    tete.LineWidth=1.5;
    tete.MaximumNumPoints= 20;
    
    cul = animatedline;
    cul.Color = 'yellow';
    cul.LineWidth=1.5;
    cul.MaximumNumPoints= 20;
    
    plot3(all_chases(pursuite).position_ball(:,1),all_chases(pursuite).position_ball(:,2),all_chases(pursuite).position_ball(:,3),'LineWidth',0.1)
    % plot3(cadre(:,1),cadre(:,3),cadre(:,2),'Color','red','LineWidth',0.3)
    % showPointCloud(cadre,[0 0 1],'MarkerSize', 36);
    
    set(gca, 'XLim', [-100 600], 'YLim',[-100 800] , 'ZLim',[-100 600] );
    % set(gca, 'XLim', [-300 600], 'YLim',[-100 600] , 'ZLim',[-300 500],'ZDir', 'reverse' );
    % set(gca, 'XLim', [min(cadre(:,1))-10 max(cadre(:,1))+10], 'YLim',[min(cadre(:,3))-10 max(cadre(:,3))+10] , 'ZLim',[min(cadre(:,2))-10 max(cadre(:,2))+10],'ZDir', 'reverse' );
end

theta_v1 = NaN(size(all_chases(pursuite).position_ball(:,1),1),2);
theta_v5 = NaN(size(all_chases(pursuite).position_ball(:,1),1),2);
thetabis = NaN(size(all_chases(pursuite).position_ball(:,1),1),2);

thetater = NaN(size(chase_orientation_FILT(pursuite).position_ball(:,1),1),2);
thetaqat = NaN(size(chase_orientation_VRAIE(pursuite).position_ball(:,1),1),2);

%for i=1:size(all_chases(pursuite).position_ball(:,1))-1
for i=1:size(chase_orientation_FILT(pursuite).position_ball(:,1))-1
    X = (all_chases(pursuite).position_ball(i,1)-all_chases(pursuite).position_fly(i,1));
    Y = (all_chases(pursuite).position_ball(i,2)-all_chases(pursuite).position_fly(i,2));
    Z = (all_chases(pursuite).position_ball(i,3)-all_chases(pursuite).position_fly(i,3));
    
    [thetabis(i,1),thetabis(i,2),rbis(i)] = cart2sph(X,Y,Z);
    
    %     thetabis_born(i,2) = atan2 (all_chases(pursuite).position_ball(i,2)-all_chases(pursuite).position_fly(i,2),sheitanball-sheitanfly);
    if animated_figure == 1
        Xcbis = all_chases(pursuite).position_fly(i,1)+100*cos(thetabis(i,1));
        Ycbis = all_chases(pursuite).position_fly(i,2)+100*sin(thetabis(i,2));
        Zcbis = all_chases(pursuite).position_fly(i,3)+100*sin(thetabis(i,1));
        queue_pointsbis = [ all_chases(pursuite).position_fly(i,1), all_chases(pursuite).position_fly(i,2), all_chases(pursuite).position_fly(i,3);
            Xcbis, Ycbis , Zcbis];
        queuebis = plot3(queue_pointsbis(:,1),queue_pointsbis(:,2),queue_pointsbis(:,3),'Color',[1 0 0]);
    end
    
    %     % orientation FILT
    
    Xter = chase_orientation_FILT(pursuite).position_ball(i,1)-chase_orientation_FILT(pursuite).position_fly(i,1);
    Yter = chase_orientation_FILT(pursuite).position_ball(i,2)-chase_orientation_FILT(pursuite).position_fly(i,2);
    Zter = chase_orientation_FILT(pursuite).position_ball(i,3)-chase_orientation_FILT(pursuite).position_fly(i,3);
    
    [thetater(i,1),thetater(i,2),rter(i)] = cart2sph(Xter,Yter,Zter);
    
    % thetater_born(i,2) = atan2 (chase_orientation_FILT(pursuite).position_ball(i,2)-chase_orientation_FILT(pursuite).position_fly(i,2),sheitanball1-sheitanfly1);
    if animated_figure == 1
        Xcter = chase_orientation_FILT(pursuite).position_ball(i,1)+100*cos(thetater(i,1));
        Ycter = chase_orientation_FILT(pursuite).position_ball(i,2)+100*sin(thetater(i,2));
        Zcter = chase_orientation_FILT(pursuite).position_ball(i,3)+100*sin(thetater(i,1));
        addpoints(tete, chase_orientation_FILT(pursuite).position_ball(i,1),chase_orientation_FILT(pursuite).position_ball(i,2),chase_orientation_FILT(pursuite).position_ball(i,3));
        head3 = scatter3(chase_orientation_FILT(pursuite).position_ball(i,1),chase_orientation_FILT(pursuite).position_ball(i,2),chase_orientation_FILT(pursuite).position_ball(i,3),(pursuite*60),'filled','MarkerFaceColor','k','MarkerEdgeColor','k');
        addpoints(cul, chase_orientation_FILT(pursuite).position_fly(i,1),chase_orientation_FILT(pursuite).position_fly(i,2),chase_orientation_FILT(pursuite).position_fly(i,3));
        head4 = scatter3( chase_orientation_FILT(pursuite).position_fly(i,1), chase_orientation_FILT(pursuite).position_fly(i,2),chase_orientation_FILT(pursuite).position_fly(i,3),'MarkerEdgeColor',[0 .5 .5],...
            'MarkerFaceColor',[0 .7 .7],...
            'LineWidth',1.5);
        
        queue_pointster = [chase_orientation_FILT(pursuite).position_ball(i,1), chase_orientation_FILT(pursuite).position_ball(i,2), chase_orientation_FILT(pursuite).position_ball(i,3);
            Xcter, Ycter , Zcter];
        queueter = plot3(queue_pointster(:,1),queue_pointster(:,2),queue_pointster(:,3),'Color',[0 0 0]);
        
        target_bearing_points = [all_chases(pursuite).position_ball(i,1), all_chases(pursuite).position_ball(i,2), all_chases(pursuite).position_ball(i,3);
            all_chases(pursuite).position_fly(i,1), all_chases(pursuite).position_fly(i,2), all_chases(pursuite).position_fly(i,3)];
        targetbearing = plot3(target_bearing_points(:,1),target_bearing_points(:,2),target_bearing_points(:,3),'Color',[0 1 0]);
    end
    
    if animated_figure == 1
        drawnow
        pause(0.10);
        delete(head3);
        delete(head4);
        pause(0.05)
        delete (queuebis);
        delete (queueter);
        delete(targetbearing);
        xlabel('X')
        ylabel('Y')
        zlabel('Z')
    end
    
end
theta_bis_mod = thetabis;
theta_ter_mod = thetater;


%% modulo 180°
for m = 1:2

    theta_bis_mod(:,m) = unwrap(theta_bis_mod(:,m));

    theta_ter_mod(:,m) = unwrap(theta_ter_mod(:,m));
    
end

thetabis = theta_bis_mod;
thetater = theta_ter_mod;


%% ANGULAR SPEED AND ACCELERATION!!!!!!

dt = 0.00526;                                       % 1/fps avec fps=190

% DIFF SPEED
sp_thetabis = diff(thetabis);
sp_thetabis = sp_thetabis/dt;
sp_thetater = diff(thetater);
sp_thetater = sp_thetater/dt;                    % Turn differential into derivative

% DIFF ACCELERATION
acc_thetabis = diff(sp_thetabis);
acc_thetabis = acc_thetabis/dt;
acc_thetater = diff(sp_thetater);
acc_thetater = acc_thetater/dt;


sp_thetabis = [NaN(3,2); sp_thetabis(3:end,:)];
sp_thetater = [NaN(3,2); sp_thetater(3:end,:)];
acc_thetabis = [NaN(5,2); acc_thetabis(4:end,:)];
acc_thetater = [NaN(5,2); acc_thetater(4:end,:)];


% SGOLAY METHOD
N = 3;                 % Order of polynomial fit
F = 5;                 % Window length
[b,g] = sgolay(N,F);   % Calculate S-G coefficients

HalfWin  = ((F+1)/2) -1;
for i=1:2
    for n = (F+1)/2 : length(thetater)-(F+1)/2,
        % Zeroth derivative (smoothing only)
        SG0_thetabis(n,i) = dot(g(:,1),thetabis(n - HalfWin:n + HalfWin , i));
        SG0_thetater(n,i) = dot(g(:,1),thetater(n - HalfWin:n + HalfWin , i));
        % 1st differential
        SG1_thetabis(n,i) = dot(g(:,2),thetabis(n - HalfWin:n + HalfWin , i));
        SG1_thetater(n,i) = dot(g(:,2),thetater(n - HalfWin:n + HalfWin , i));
        
        % 2nd differential
        SG2_thetabis(n,i) = 2*dot(g(:,3)',thetabis(n - HalfWin:n + HalfWin , i));
        SG2_thetater(n,i) = 2*dot(g(:,3)',thetater(n - HalfWin:n + HalfWin , i))';
    end
    SG1_thetabis(:,i) = SG1_thetabis(:,i)/dt;
    SG1_thetater(:,i) = SG1_thetater(:,i)/dt;         % Turn differential into derivative
    SG2_thetabis(:,i) = SG2_thetabis(:,i)/(dt*dt);
    SG2_thetater(:,i) = SG2_thetater(:,i)/(dt*dt);    % and into 2nd derivative
    
end
SG0_thetabis = [NaN(7,2); SG0_thetabis(5:end,:)];
SG0_thetater = [NaN(7,2); SG0_thetater(5:end,:)];
SG1_thetabis = [NaN(7,2); SG1_thetabis(5:end,:)];
SG1_thetater = [NaN(7,2); SG1_thetater(5:end,:)];
SG2_thetabis = [NaN(7,2); SG2_thetabis(5:end,:)];
SG2_thetater = [NaN(7,2); SG2_thetater(5:end,:)];


%% CREATE THETA STRUCTURE
points = 1:size(theta_v1(:,1));
points = points'*dt;
pointster = 1:size(thetater(:,1));
pointster = pointster'*dt;

THETA = struct('thetabis',thetabis,...
    'thetater',thetater,...
    'sp_thetabis',sp_thetabis,...
    'sp_thetater',sp_thetater,...
    'acc_thetabis',acc_thetabis,...
    'acc_thetater',acc_thetater,...
    'SG0_thetater',SG0_thetater,...
    'SG1_thetater',SG1_thetater,...
    'SG2_thetater',SG2_thetater,...
    'theta_bis_mod',theta_bis_mod,...
    'theta_ter_mod',theta_ter_mod);

%%
figure
subplot(2,2,1)
[tout1, rout1] = rose( thetabis(1:size(pointster,1),1),80);
relativefreq1= rout1/length( thetabis(1:size(pointster,1),1));
polar(tout1,relativefreq1)
title('AZ heading to ball');

subplot(2,2,3)
[tout2, rout2] = rose( theta_ter_mod(:,1)-theta_bis_mod(1:size(pointster,1),1),80);
relativefreq2= rout2/length( theta_ter_mod(:,1)-theta_bis_mod(1:size(pointster,1),1));
polar(tout2,relativefreq2)
title 'AZ heading to ball-FILT';

subplot(2,2,2)
[tout3, rout3] = rose( thetabis(1:size(pointster,1),2),80);
relativefreq3= rout3/length(  thetabis(1:size(pointster,1),2));
polar(tout3,relativefreq3)
title 'EL heading to ball';

subplot(2,2,4)
[tout4, rout4] = rose( theta_ter_mod(:,2)-theta_bis_mod(1:size(pointster,1),2),80);
relativefreq4= rout4/length( theta_ter_mod(:,2)-theta_bis_mod(1:size(pointster,1),2));
polar(tout4,relativefreq4)
title 'EL heading to ball-FILT';

clearvars tout1 rout1 tout2 rout2 tout3 rout3 tout4 rout4

%% ERROR DEG
errAZ1 = (SG0_thetater(:,1)-SG0_thetabis(1:size(pointster,1),1));
errAZ2 = (thetater(:,1)-thetabis(1:size(pointster,1),1));
errEL1 = (SG0_thetater(:,2)-SG0_thetabis(1:size(pointster,1),2));
errEL2 = (thetater(:,2)-thetabis(1:size(pointster,1),2));
figure('Name','ERROR DEG','NumberTitle','off');
subplot(3,2,1)
plot(pointster, errAZ1 ,pointster, errAZ2)
legend('SG0 thetabis-SG0 thetater','filt-to ball')
title 'ERROR AZIMUTH SGO VS ORIGINAL'

subplot(3,2,2)
plot(pointster, errEL1,pointster,errEL2)
legend('SG0 thetabis-SG0 thetater','filt-to ball')
title 'ERROR ELEVATION SGO VS ORIGINAL'

subplot(3,2,3)
plot(pointster, SG1_thetater(:,1)-SG1_thetabis(1:size(pointster,1),1),pointster, sp_thetater(:,1)-sp_thetabis(1:size(pointster,1),1))
legend('SG0 thetabis-SG1 thetater','filt-to ball')
title 'SPEED AZIMUTH SGO VS ORIGINAL'

subplot(3,2,4)
plot(pointster, SG1_thetater(:,2)-SG1_thetabis(1:size(pointster,1),2),pointster, sp_thetater(:,2)-sp_thetabis(1:size(pointster,1),2))
legend('SG1 thetabis-SG1 thetater','filt-to ball')
title 'SPPED ELEVATION SGO VS ORIGINAL'

subplot(3,2,5)
plot(pointster, SG2_thetater(:,1)-SG2_thetabis(1:size(pointster,1),1),pointster, acc_thetater(:,1)-acc_thetabis(1:size(pointster,1),1))
legend('SG2 thetabis-SG2 thetater','filt-to ball')
title 'ACCELERATION AZIMUTH SGO VS ORIGINAL'

subplot(3,2,6)
plot(pointster, SG2_thetater(:,2)-SG2_thetabis(1:size(pointster,1),2),pointster, acc_thetater(:,2)-acc_thetabis(1:size(pointster,1),2))
legend('SG2 thetabis-SG2 thetater','filt-to ball')
title 'ACCELERATION ELEVATION SGO VS ORIGINAL'

%%
AA = SG0_thetabis(isnan(SG0_thetabis(:,1))==0 , 1)';
AA = radtodeg(AA);
AAA = SG0_thetater(isnan(SG0_thetater(:,1))==0 , 1)';
AAA = radtodeg(AAA);
% AAAA = AAA-AA;
AAAA = -AAA+AA;

AB = SG0_thetabis(isnan(SG0_thetabis(:,2))==0 , 2)';
AB = radtodeg(AB);
AAB = SG0_thetater(isnan(SG0_thetater(:,2))==0 , 2)';
AAB = radtodeg(AAB);
AAAB = -AAB+AB;

A = SG1_thetabis(isnan(SG1_thetabis(:,1))==0 , 1)';
A = radtodeg(A);
A1 = SG1_thetater(isnan(SG1_thetater(:,1))==0 , 1)';
A1 = radtodeg(A1);
% AA1 = A1-A;
AA1 = -A1+A;
B = SG1_thetabis(isnan(SG1_thetabis(:,2))==0 , 2)';
B = radtodeg(B);
B1 = SG1_thetater(isnan(SG1_thetater(:,2))==0 , 2)';
B1 = radtodeg(B1);
% BB = B1-B;
BB = -B1+B;
C = SG2_thetabis(isnan(SG2_thetabis(:,1))==0 , 1)';
C = radtodeg(C);
C1 = SG2_thetater(isnan(SG2_thetater(:,1))==0 , 1)';
C1 = radtodeg(C1);
% CC = C1-C;
CC = -C1+C;
D = SG2_thetabis(isnan(SG2_thetabis(:,2))==0 , 2)';
D = radtodeg(D);
D1 = SG2_thetater(isnan(SG2_thetater(:,2))==0 , 2)';
D1 = radtodeg(D1);
% DD = D1-D;
DD = -D1+D;

figure('Name','TO BALL, FLY, ERR = FLY-2BALL','NumberTitle','off');
subplot(3,2,1)
plot(dt:dt:size(AA,2)*dt,AA,dt:dt:size(AAA,2)*dt,AAA,dt:dt:size(AAAA,2)*dt,AAAA)
legend('AZ to ball','AZ FLY', 'FLY- TO BALL')
subplot(3,2,2)
plot(dt:dt:size(AB,2)*dt,AB,dt:dt:size(AAB,2)*dt,AAB,dt:dt:size(AAAB,2)*dt,AAAB)
legend('EL to ball','EL FLY', 'FLY- TO BALL')
subplot(3,2,3)
plot(dt:dt:size(A,2)*dt,A,dt:dt:size(A1,2)*dt,A1,dt:dt:size(AA1,2)*dt,AA1)
legend('AZ to ball','AZ FLY', 'FLY- TO BALL')
subplot(3,2,4)
plot(dt:dt:size(B,2)*dt,B,dt:dt:size(B1,2)*dt,B1,dt:dt:size(BB,2)*dt,BB)
legend('EL to ball','EL FLY', 'FLY- TO BALL')
subplot(3,2,5)
plot(dt:dt:size(C,2)*dt,C,dt:dt:size(C1,2)*dt,C1,dt:dt:size(CC,2)*dt,CC)
legend('AZ to ball','AZ FLY', 'FLY- TO BALL')
subplot(3,2,6)
plot(dt:dt:size(D,2)*dt,D,dt:dt:size(D1,2)*dt,D1,dt:dt:size(DD,2)*dt,DD)
legend('EL to ball','EL FLY', 'FLY- TO BALL')


figure
subplot(3,2,1)
rose( degtorad(AA));
title 'AZ to ball';
subplot(3,2,3)
rose( degtorad(AAA));
title 'AZ fly';
subplot(3,2,5)
rose( degtorad(AAAA));
title 'AZ error';
subplot(3,2,2)
rose( degtorad(AB));
title 'EL to ball';
subplot(3,2,4)
rose( degtorad(AAB));
title 'EL fly';
subplot(3,2,6)
rose( degtorad(AAAB));
title 'EL error';

figure
subplot(3,2,1)
[tout1, rout1] = rose( degtorad(AA),80);
relativefreq1= rout1/length(degtorad(AA));
polar(tout1,relativefreq1)
title('AZ to ball');
subplot(3,2,3)
[tout2, rout2] = rose( degtorad(AAA),80);
relativefreq2= rout2/length(degtorad(AAA));
polar(tout2,relativefreq2)
title 'AZ fly';
subplot(3,2,5)
[tout3, rout3] = rose( degtorad(AAAA),80);
relativefreq3= rout3/length(degtorad(AAAA));
polar(tout3,relativefreq3)
title 'AZ error';
subplot(3,2,2)
[tout4, rout4] = rose( degtorad(AB),80);
relativefreq4= rout4/length(degtorad(AB));
polar(tout4,relativefreq4)
title('EL to ball');
subplot(3,2,4)
[tout5, rout5] = rose( degtorad(AAB),80);
relativefreq5= rout5/length(degtorad(AAB));
polar(tout5,relativefreq5)
title 'EL fly';
subplot(3,2,6)
[tout6, rout6] = rose( degtorad(AAAB),80);
relativefreq6= rout6/length(degtorad(AAAB));
polar(tout6,relativefreq6)
title 'EL error';

Mean_fly_lenght = mean(rter);
Median_fly_lenght = median(rter);
STD_fly_lenght= std(rter);
Mean_DTT = mean(rbis);
Median_DTT = median(rbis);
STD_DTT= std(rbis);
Mean_ERROR_AZ = mean(AAAA);
Median_ERROR_AZ = median(AAAA);
STD_ERROR_AZ= std(AAAA);
Median_ERROR_EL = median(AAAB);
Mean_ERROR_EL = mean(AAAB);
STD_ERROR_EL= std(AAAB);
disp(['FLY LENGHT          mean=' num2str(Mean_fly_lenght) '             median= ' num2str(Median_fly_lenght) '               STD= ' num2str(STD_fly_lenght)])
disp(['DTT                           mean= ' num2str(Mean_DTT) '                 median= ' num2str(Median_DTT) '               STD= ' num2str(STD_DTT)])
disp(['Azimuth error          mean= ' num2str(Mean_ERROR_AZ) '                median= ' num2str(Median_ERROR_AZ) '                STD= ' num2str(STD_ERROR_AZ)])
disp(['Elevation error        mean  = ' num2str(Mean_ERROR_EL) 'median  = ' num2str(Median_ERROR_EL) '  STD= ' num2str(STD_ERROR_EL)])


figure('Name','FLY LENGHT','NumberTitle','off');
plot (dt:dt:size(rter,2)*dt,rter)


figure('Name','DTT','NumberTitle','off');
plot (dt:dt:size(rbis,2)*dt,rbis)


figure
% boxplot([rter',rbis'],'Notch','on','Labels',{'fly lenght','DTT'})
boxplot(rter','Notch','on','Labels',{'fly lenght'})
title (' sizes error repartition ' )

figure
hold on
plot(dt:dt:size(speed_fly_mod_chase,2)*dt,speed_fly_mod_chase)
plot(dt:dt:size(speed_ball_mod_chase,2)*dt,speed_ball_mod_chase)
legend('fly','mirror')
title('Fly and mirror velocities')