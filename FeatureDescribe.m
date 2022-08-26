function des = FeatureDescribe(im,eo,kpts,patch_size,no,nbin)

n = size(kpts,2);
[yim,xim,~] = size(im);
CS = zeros(yim, xim, no); %convolution sequence
for j=1:no
    for i=1:4
        CS(:,:,j)=CS(:,:,j)+abs(eo{i,j});
    end
end
[~,MIM] = max(CS,[],3); % MIM maximum index map

des = zeros(no*no*nbin,n); %descriptor (size: 6¡Á6¡Áo)
parfor k = 1: n
    x = kpts(1, k);
    y = kpts(2, k);
    r = patch_size;
    ang = kpts(3,k);
    
    patch = extract_patches(MIM, x, y, round(r/2), ang);
    patch=imresize(patch,[r+1,r+1]);
    h = hist(patch(:),1:6);
    [~,idx]=max(h);
    patch_rot = patch-idx+1;
    patch_rot(patch_rot<0) = patch_rot(patch_rot<0)+no;
    
    [ys,xs] = size(patch_rot);
    histo = zeros(no,no,nbin);  %descriptor vector
    for j = 1:no
        for i = 1:no
            clip = patch_rot(round((j-1)*ys/no+1):round(j*ys/no),round((i-1)*xs/no+1):round(i*xs/no));
            histo(j,i,:) = permute(hist(clip(:), 1:no), [1 3 2]);
        end
    end
    histo=histo(:);
    
    if norm(histo) ~= 0
        histo = histo /norm(histo);
    end
    des(:,k) = histo;
end


