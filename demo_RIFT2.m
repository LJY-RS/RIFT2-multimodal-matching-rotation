clc;clear;close all; warning('off')
addpath optical-optical  % type of multi-modal data

str1='pair1.jpg';   % image pair
str2='pair2.jpg';
im1 = im2uint8(imread(str1));
im2 = im2uint8(imread(str2));

if size(im1,3)==1
    temp=im1; im1(:,:,1)=temp; im1(:,:,2)=temp; im1(:,:,3)=temp;
end

if size(im2,3)==1
    temp=im2; im2(:,:,1)=temp; im2(:,:,2)=temp; im2(:,:,3)=temp;
end

tic
disp('RIFT2 feature detection')
[key1,m1,eo1] = FeatureDetection(im1,4,6,5000);
[key2,m2,eo2] = FeatureDetection(im2,4,6,5000);

disp('RIFT2 main orientation calculation')
kpts1 = kptsOrientation(key1,m1,1,96);
kpts2 = kptsOrientation(key2,m2,1,96);

disp('RIFT2 feature description')
des1 = FeatureDescribe(im1,eo1,kpts1,96,6,6);
des2 = FeatureDescribe(im2,eo2,kpts2,96,6,6);

disp('RIFT2 feature matching')
[indexPairs,matchmetric] = matchFeatures(des1',des2','MaxRatio',1,'MatchThreshold', 100);
kpts1 = kpts1'; kpts2 = kpts2';
matchedPoints1 = kpts1(indexPairs(:, 1), 1:2);
matchedPoints2 = kpts2(indexPairs(:, 2), 1:2);
[matchedPoints2,IA]=unique(matchedPoints2,'rows');
matchedPoints1=matchedPoints1(IA,:);
toc

disp('outlier removal')
H=FSC(matchedPoints1,matchedPoints2,'similarity',3);
Y_=H*[matchedPoints1';ones(1,size(matchedPoints1,1))];
Y_(1,:)=Y_(1,:)./Y_(3,:);
Y_(2,:)=Y_(2,:)./Y_(3,:);
E=sqrt(sum((Y_(1:2,:)-matchedPoints2').^2));
inliersIndex=E<3;
cleanedPoints1 = matchedPoints1(inliersIndex, :);
cleanedPoints2 = matchedPoints2(inliersIndex, :);

disp('Show matches')
figure; showMatchedFeatures(im1, im2, cleanedPoints1, cleanedPoints2, 'montage');

disp('registration result')
image_fusion(im2,im1,double(H));

