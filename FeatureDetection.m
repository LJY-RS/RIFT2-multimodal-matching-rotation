function [kpts,m,eo] = FeatureDetection(im,s,o, npt)

if size(im,3)==3
    im=rgb2gray(im);
end

[m,~,~,~,~,eo,~] = phasecong3(im,s,o,3,'mult',1.6,'sigmaOnf',0.75,'g', 3, 'k',1);
a=max(m(:));  b=min(m(:));  m=(m-b)/(a-b);  

kpts = detectFASTFeatures(m,'MinContrast',0.0001,'MinQuality',0.0001);
kpts = kpts.selectStrongest(npt);
kpts = double(kpts.Location');





