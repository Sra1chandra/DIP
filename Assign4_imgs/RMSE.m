function [ output ] = RMSE( im1,im2 )
[x1,y1,~]=size(im1);
[x2,y2,~]=size(im2);
if(x1>x2)
    im2=padarray(im2,[x1-x2,0],'post');
elseif(x2>x1)
    im1=padarray(im1,[x2-x1,0],'post');
end
if(y1>y2)
    im2=padarray(im2,[0,y1-y2],'post');
elseif(y2>y1)
    im1=padarray(im1,[0,y2-y1],'post');
end

output=sqrt(sum(sum(sum((double(im1)-double(im2)).^2)))/(size(im1,1)*size(im1,2)));
end

