function kpts = kptsOrientation(key,im,is_ori,patch_size)

if is_ori==1
    n=24;
    ORI_PEAK_RATIO = 0.8;
    h=[-1,0,1;-2,0,2;-1,0,1];

    gradient_x=imfilter(im,h,'replicate');
    gradient_y=imfilter(im,h','replicate');
    gradientImg=sqrt(gradient_x.^2+gradient_y.^2);
    temp_angle=atan2(gradient_y,gradient_x);
    temp_angle=temp_angle*180/pi;
    temp_angle(temp_angle<0)=temp_angle(temp_angle<0)+360;
    gradientAng=temp_angle;
end

feat_index=1;
kpts = zeros(3,size(key,2)*6);
for k = 1: size(key,2)
    x = round(key(1, k));
    y = round(key(2, k));
    r = round(patch_size);
    
    x1 = max(1,x-floor(r/2));
    y1 = max(1,y-floor(r/2));
    x2 = min(x+floor(r/2),size(im,2));
    y2 = min(y+floor(r/2),size(im,1));
    
    if y2-y1 ~= r || x2-x1 ~= r
        continue;
    end
    
    if is_ori==1
        angle = orientation(x,y,gradientImg,gradientAng, r, n,ORI_PEAK_RATIO);
        for i=1:size(angle,2)
            kpts(:,feat_index)=[x;y;angle(i)];
            feat_index = feat_index+1;
        end
    else
        kpts(:,feat_index)=[x;y;0];
        feat_index = feat_index+1;
    end
end
kpts(:,kpts(1,:)==0)=[];


