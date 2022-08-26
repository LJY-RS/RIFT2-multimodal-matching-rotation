function ANG = orientation(x,y,gradientImg,gradientAng, patch_size, n,ORI_PEAK_RATIO)

se=strel('disk',patch_size/2,0); %半径为r的圆
Sa=getnhood(se); %圆的邻域值，即表示圆的矩阵
[hist,max_value]=calculate_oritation_hist(x,y,patch_size/2,gradientImg,gradientAng,n,Sa);

mag_thr=max_value*ORI_PEAK_RATIO;
ANG=[];
for k=1:n
    if(k==1)
        k1=n;
    else
        k1=k-1;
    end
    
    if(k==n)
        k2=1;
    else
        k2=k+1;
    end
    if(hist(k)>hist(k1) && hist(k)>hist(k2)&& hist(k)>mag_thr)
        bin=k-1+0.5*(hist(k1)-hist(k2))/(hist(k1)+hist(k2)-2*hist(k));
        if(bin<0)
            bin=n+bin;
        elseif(bin>=n)
            bin=bin-n;
        end
        angle=(360/n)*bin;%0-360
        ANG=[ANG,angle];
    end
end
