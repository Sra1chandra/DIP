I=imread('circle3.jpg');
Img=imbinarize(rgb2gray(I));
[Gmag, Gdir] = imgradient(Img,'prewitt');
[Gx,Gy]=imgradientxy(rgb2gray(I),'prewitt');
figure;
imshow(Gmag)
% x=139;y=127;r=125;
% theta=atan(Gy(y,x)/Gx(y,x));
% % theta=deg2rad(-Gdir(y,x));
% rad2deg(theta)
% x1=round(x+r*cos(-(theta)));
% y1=-round(-y+r*sin(-(theta)));
% RGB = insertShape(I,'circle',[x y 2],'LineWidth',5);
% RGB = insertShape(RGB,'circle',[x1 y1 2],'LineWidth',5);
% figure;
% imshow(RGB)
% imshow(Gmag)
figure;
[X,Y]=size(Img);
Rmax=180;
Rmin=140;
P=zeros(X,Y,Rmax-Rmin+1);
for x=1:X
    for y=1:Y
        if Gmag(x,y)>0
%            theta=atan(Gy(x,y)/Gx(x,y));
           for r=Rmin:Rmax
               for theta=0:360-1
                   x1=round(x-r*cos(deg2rad(theta)));
                   y1=round(y-r*sin(deg2rad(theta)));
                   if 0<x1 && x1<=X && 0<y1 && y1<=Y
                       P(x1,y1,r-Rmin+1)=P(x1,y1,r-Rmin+1)+1;
                   end
               end
           end
        end
    end
end
% [M,In] = max (P(:));
In=find(P(:)>100);
[ind1, ind2, ind3] = ind2sub(size(P),In);
RGB = insertShape(I,'circle',[ind2 ind1 ind3+Rmin-1],'LineWidth',5);
% [ind1, ind2, ind3] = ind2sub(size(P),In);
imshow(RGB)