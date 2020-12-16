clear all
[filename,filepath]=uigetfile('chases&orientations.mat','chases&orientations');
cd(filepath)
load('chases&orientations.mat')
% load('workspace.mat')
currentFolder = pwd;

seqTime = size(SG0_ball,1)*1/190;
% answer_txt = inputdlg(['The sequence is  ' num2str(seqTime) ' seconds, what is the resolution of big markers in milisec? (from 100ms)']);
% answer_num = str2num(answer_txt{:}); 

% num_bigmarkers = round(seqTime*1000/answer_num);

% points_regul=SG0_ball_chase(19*num_bigmarkers,:);
% points_regul1=SG0_ball_chase(19*num_bigmarkers,:);

% for i = 1:num_bigmarkers-1
% points_reg = SG0_ball_chase(19*(i+1),:);
% points_reg1 = SG0_ball(19*(i+1),:);
% points_regul = [points_regul;points_reg];
% points_regul1 = [points_regul1;points_reg1];
% end

relative_velocity = sqrt(all_chases(1).speed_fly(:,1).^2 + all_chases(1).speed_fly(:,2).^2 + all_chases(1).speed_fly(:,3).^2)-...
    sqrt(all_chases(1).speed_ball(:,1).^2 + all_chases(1).speed_ball(:,2).^2 + all_chases(1).speed_ball(:,3).^2);
relative_fw_velocity  = sqrt(all_chases(1).speed_fly(:,1).^2 + all_chases(1).speed_fly(:,3).^2)-...
    sqrt(all_chases(1).speed_ball(:,1).^2 + all_chases(1).speed_ball(:,3).^2);
relative_upw_velocity = -all_chases(1).speed_fly(:,2) + all_chases(1).speed_ball(:,2);


figure
plot3(SG0_ball_chase(:,1),SG0_ball_chase(:,2),SG0_ball_chase(:,3));
hold on
plot3(SG0_ball(:,1),SG0_ball(:,2),SG0_ball(:,3));
plot3(SG0_fly(:,1),SG0_fly(:,2),SG0_fly(:,3));
% showPointCloud(final_cam, [0 0 0],'MarkerSize', 36);
scatter3(cadre(:,1),cadre(:,2),cadre(:,3),15,'filled');
axis equal
view(54,27)
% showPointCloud(points_regul, [0 0 0],'MarkerSize', 20);
% showPointCloud(points_regul1, [1 0 0],'MarkerSize', 20);

title ('orientation')
xlabel('X')
ylabel('Y')
zlabel('Z')
hold off

%% 
for i=1:size(SG0_ball(:,1))-1
%     theta_v1(i,1) = atan2 ((all_chases(pursuite).position_fly(i,3)-all_chases(pursuite).position_fly(i+1,3)),(all_chases(pursuite).position_fly(i,1)-all_chases(pursuite).position_fly(i+1,1)));
%     theta_v1(i,2) = atan2 ((all_chases(pursuite).position_fly(i,2)-all_chases(pursuite).position_fly(i+1,2)),(all_chases(pursuite).position_fly(i,1)-all_chases(pursuite).position_fly(i+1,1)));

    theta_v1(i,1) = atan2 ((SG0_fly(i,3)-SG0_ball(i,3)),(SG0_fly(i,1)-SG0_ball(i,1)));
    theta_v1(i,2) = atan2 ((SG0_fly(i,2)-SG0_ball(i,2)),(SG0_fly(i,1)-SG0_ball(i,1)));

        Xc_v1(i) = SG0_fly_chase(i,1)+100*cos(theta_v1(i,1));
        Yc_v1(i) = SG0_fly_chase(i,3)+100*sin(theta_v1(i,1));
        Zc_v1(i) = SG0_fly_chase(i,2)+100*sin(theta_v1(i,2));

end

%%

figure
plot(relative_velocity);
hold on
plot(relative_fw_velocity);
plot(relative_upw_velocity);
% ylim([-600 2000])
legend ('relative speed','relative fw speed','relative upward speed')

