function patch = extract_patches(img, x, y, s, t)

img = im2double(img);
h = size(img,1);
w = size(img,2);
m = size(img,3);

x = round(x);
y = round(y);
x(x<1) = 1;
x(x>w) = w;
y(y<1) = 1;
y(y>h) = h;

s = round(s);
t=t*pi/180;

imgch = cell(m,1);
for ch=1:m
    imgch{ch} = img(:,:,ch);
end



patchsize = s*2+1;

[xg,yg] = meshgrid(-s:s,-s:s);
R = [cos(t) -sin(t);...
    sin(t) cos(t)];
xygrot = R*[xg(:)'; yg(:)'];
xygrot(1,:) = xygrot(1,:) + x;
xygrot(2,:) = xygrot(2,:) + y;

xr = xygrot(1,:)';
yr = xygrot(2,:)';
xf = floor(xr);
yf = floor(yr);
xp = xr-xf;
yp = yr-yf;

patch = zeros(patchsize,patchsize,m);

vid = find(xf >= 1 & xf <= w-1 & yf >= 1 & yf <= h-1);
xf = xf(vid);
yf = yf(vid);
xp = xp(vid);
yp = yp(vid);

ind1 = sub2ind([h,w],yf,xf);
ind2 = sub2ind([h,w],yf,xf+1);
ind3 = sub2ind([h,w],yf+1,xf);
ind4 = sub2ind([h,w],yf+1,xf+1);

for ch=1:m
    ivec = (1-yp).*(xp.*imgch{ch}(ind2)+(1-xp).*imgch{ch}(ind1))+...
        (yp).*(xp.*imgch{ch}(ind4)+(1-xp).*imgch{ch}(ind3));
    temp = zeros(patchsize,patchsize);
    temp(vid) = (ivec);
    patch(:,:,ch) = temp;
%     patch(patch<1)=1;
%     patch(patch>6)=6;
end

end