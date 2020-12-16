


clear all

%% LOAD COEF CALIB 11 per cam
% filename = 'G:\RECORDS\cal03_04_2017DLTcoefs.csv';
[filename,filepath]=uigetfile('*coefs.csv','OPEN DLT COEF');
cd(filepath)
delimiter = ',';
formatSpec = '%f%f%[^\n\r]';
fileID = fopen(filename,'r');
dataArray = textscan(fileID, formatSpec, 'Delimiter', delimiter,  'ReturnOnError', false);
fclose(fileID);
c = [dataArray{1:end-1}];

clearvars filename delimiter formatSpec fileID dataArray ans;
%% IMPORT XYPOINTS
% filename = 'G:\RECORDS\expe\11-10-16\7\mouche_xypts.csv';
[filename,filepath]=uigetfile('mouche_xypts.csv','open fly orientation XY points');
cd(filepath)
delimiter = ',';
startRow = 2;
formatSpec = '%f%f%f%f%f%f%f%f%[^\n\r]';
fileID = fopen(filename,'r');
dataArray = textscan(fileID, formatSpec, 'Delimiter', delimiter, 'HeaderLines' ,startRow-1, 'ReturnOnError', false);
fclose(fileID);
camPts = [dataArray{1:4}];
camPts1 = [dataArray{5:8}];
clearvars filename delimiter startRow formatSpec fileID dataArray ans;

%%

%function [xyz,rmse] = dlt_reconstruct(c,camPts)

% function [xyz,rmse] = dlt_reconstruct(c,camPts)
%
% This function reconstructs the 3D position of a coordinate based on a set
% of DLT coefficients and [u,v] pixel coordinates from 2 or more cameras
%
% Inputs:
%  c - 11 DLT coefficients for all n cameras, [11,n] array
%  camPts - [u,v] pixel coordinates from all n cameras over f frames,
%   [f,2*n] array
%
% Outputs:
%  xyz - the xyz location in each frame, an [f,3] array
%  rmse - the root mean square error for each xyz point, and [f,1] array,
%   units are [u,v] i.e. camera coordinates or pixels
%
% Ty Hedrick

% number of frames
nFrames=size(camPts,1);

% number of cameras
nCams=size(camPts,2)/2;

% setup output variables
xyz(1:nFrames,1:3)=NaN;
rmse(1:nFrames,1)=NaN;
xyz1(1:nFrames,1:3)=NaN;
rmse1(1:nFrames,1)=NaN;
 
% process each frame FOR FIRST POINT (TETE)
for i=1:nFrames

  % get a list of cameras with non-NaN [u,v]
  cdx=find(isnan(camPts(i,1:2:nCams*2))==false);

  % if we have 2+ cameras, begin reconstructing
  if numel(cdx)>=2

    % initialize least-square solution matrices
    m1=[];
    m2=[];

    m1(1:2:numel(cdx)*2,1)=camPts(i,cdx*2-1).*c(9,cdx)-c(1,cdx);
    m1(1:2:numel(cdx)*2,2)=camPts(i,cdx*2-1).*c(10,cdx)-c(2,cdx);
    m1(1:2:numel(cdx)*2,3)=camPts(i,cdx*2-1).*c(11,cdx)-c(3,cdx);
    m1(2:2:numel(cdx)*2,1)=camPts(i,cdx*2).*c(9,cdx)-c(5,cdx);
    m1(2:2:numel(cdx)*2,2)=camPts(i,cdx*2).*c(10,cdx)-c(6,cdx);
    m1(2:2:numel(cdx)*2,3)=camPts(i,cdx*2).*c(11,cdx)-c(7,cdx);

    m2(1:2:numel(cdx)*2,1)=c(4,cdx)-camPts(i,cdx*2-1);
    m2(2:2:numel(cdx)*2,1)=c(8,cdx)-camPts(i,cdx*2);

    % get the least squares solution to the reconstruction
    xyz(i,1:3)=linsolve(m1,m2);

    % compute ideal [u,v] for each camera
    uv=m1*xyz(i,1:3)';

    % compute the number of degrees of freedom in the reconstruction
    dof=numel(m2)-3;

    % estimate the root mean square reconstruction error
    rmse(i,1)=(sum((m2-uv).^2)/dof)^0.5;
  end
end

% process each frame FOR SECOND POINT (CUL)
for i=1:nFrames
  % get a list of cameras with non-NaN [u,v]
  cdx=find(isnan(camPts1(i,1:2:nCams*2))==false);
  % if we have 2+ cameras, begin reconstructing
  if numel(cdx)>=2
    % initialize least-square solution matrices
    m1=[];
    m2=[];
    m1(1:2:numel(cdx)*2,1)=camPts1(i,cdx*2-1).*c(9,cdx)-c(1,cdx);
    m1(1:2:numel(cdx)*2,2)=camPts1(i,cdx*2-1).*c(10,cdx)-c(2,cdx);
    m1(1:2:numel(cdx)*2,3)=camPts1(i,cdx*2-1).*c(11,cdx)-c(3,cdx);
    m1(2:2:numel(cdx)*2,1)=camPts1(i,cdx*2).*c(9,cdx)-c(5,cdx);
    m1(2:2:numel(cdx)*2,2)=camPts1(i,cdx*2).*c(10,cdx)-c(6,cdx);
    m1(2:2:numel(cdx)*2,3)=camPts1(i,cdx*2).*c(11,cdx)-c(7,cdx);
    m2(1:2:numel(cdx)*2,1)=c(4,cdx)-camPts1(i,cdx*2-1);
    m2(2:2:numel(cdx)*2,1)=c(8,cdx)-camPts1(i,cdx*2);
    % get the least squares solution to the reconstruction
    xyz1(i,1:3)=linsolve(m1,m2);
    % compute ideal [u,v] for each camera
    uv=m1*xyz1(i,1:3)';
    % compute the number of degrees of freedom in the reconstruction
    dof=numel(m2)-3;
    % estimate the root mean square reconstruction error
    rmse1(i,1)=(sum((m2-uv).^2)/dof)^0.5;
  end
end


figure
showPointCloud(xyz,[0 0 1]);
hold on
showPointCloud(xyz1,[1 0 0]);

%% 
body = table([xyz(:,:)],[xyz1(:,:)],...
    'VariableNames',{'tete' 'cul'});

offsets = table([zeros(size(camPts,1),1)],[zeros(size(camPts,1),1)],...
    'VariableNames',{'cam1_offset' 'cam2_offset'});


dltres = table([rmse(:,1)],[rmse1(:,1)],...
    'VariableNames',{'pt1_dltres' 'pt2_dltres'});

writetable(offsets,'mouche_offsets.csv','Delimiter',',','QuoteStrings',true);
writetable(body,'mouche_xyzpts.csv','Delimiter',',','QuoteStrings',true);
writetable(dltres,'mouche_xyzres.csv','Delimiter',',','QuoteStrings',true);

% type 'mouche_offsets.csv';
% type 'mouche_xyzpts.csv';
% type 'mouche_xyzres.csv';