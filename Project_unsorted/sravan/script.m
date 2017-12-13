Img1 =imread('3.jpeg'); %read the 2D image
Img=flip(Img1,2);
%Convert the image to Grayscale
I=rgb2gray(Img);

%Edge Detection
Ie=edge(I,'sobel');

%Hough Transform
[H,theta,rho] = hough(Ie);
    
% Finding the Hough peaks (number of peaks is set to 5)
P = houghpeaks(H,20,'threshold',ceil(0.2*max(H(:))));
x = theta(P(:,2));
y = rho(P(:,1));

%Vanishing lines
lines = houghlines(I,theta,rho,P);
[rows, columns] = size(Ie);
figure, imshow(~Ie);
% figure;
hold on;
n=length(lines);
req=zeros((n*(n-1))/2,2);
k=1;
for i=1:n
    xy_1 = [lines(i).point1; lines(i).point2];
    for j=i+1:n
       xy_2 = [lines(j).point1; lines(j).point2];
       %intersection of two lines (the current line and the previous one)
       slopee = @(line) (line(2,2) - line(1,2))/(line(2,1) - line(1,1));
       m1 = slopee(xy_1);
       m2 = slopee(xy_2);
       intercept = @(line,m) line(1,2) - m*line(1,1);
       b1 = intercept(xy_1,m1);
       b2 = intercept(xy_2,m2);
       if m1~=m2
           xintersect = (b2-b1)/(m1-m2);
           yintersect = m1*xintersect + b1;
           req(k,1)=xintersect;
           req(k,2)=yintersect;
           k=k+1;
       end
     end    
end
%finding maximum voted point
clusters=clusterdata(req,floor(size(req,1)/2));
c=find(clusters==mode(clusters));
Xvp=mean(req(c,1));
Yvp=mean(req(c,2));
plot(Xvp,Yvp,'m*','markersize',8, 'Color', 'red');
% refined_lines=lines(c);
xy_1 = zeros([2,2]);
len1=1;
len2=1;
s=struct;
for k = 1:length(lines)
   xy = [lines(k).point1; lines(k).point2];
   % Get the equation of the line
   x1 = xy(1,1);
   y1 = xy(1,2);
   x2 = xy(2,1);
   y2 = xy(2,2);

   slope = (y2-y1)/(x2-x1);
   xLeft = 1; % x is on the left edge.
   yLeft = slope * (xLeft - x1) + y1;
   plot([x1, x2], [y1, y2], 'LineWidth',1,'Color','blue');
   if 0<yLeft && yLeft<rows
%     s.line(len)=lines(k);
    s.yleft(len1)=yLeft;
    plot(xLeft,yLeft,'x','markersize',8,'Color','green');
    len1=len1+1;
   end
   xRight = columns; % x is on the right edge.
   yRight = slope * (xRight - x1) + y1;
   plot([x1, x2], [y1, y2], 'LineWidth',1,'Color','blue');

   if 0<yRight && yRight<rows
%     s.line(len)=lines(k);
    s.yRight(len2)=yRight;
    plot(xRight,yRight,'x','markersize',8,'Color','green');
    len2=len2+1;
   end

end
% req_img=zeros(rows,columns);
% H=rows;W=columns;
% if (Xvp>=W-1 && -((H-1)/(W-1)) * Xvp+H-1<Yvp<((H-1)/(W-1)) * Xvp ) || Xvp>=3*columns/4
%     x1=1;
%     y1=max(s.yleft);
%     [cx,cy,~]=improfile(~Ie,[x1 Xvp],[y1 Yvp]);
%     cx=round(cx);
%     cy=round(cy);
%     intensity=1;
%     offset=1/(size(cx,1)+rows-y1);
%     i=rows;
%     while i>y1
%         req_img(i,:)=intensity;
%         intensity=intensity-offset;
%         i=i-1;
%     end
%     for i=1:size(cx,1)
%         req_img(1:cy(i),cx(i))=intensity;
%         req_img(cy(i),cx(i):end)=intensity;
%         intensity=intensity-offset;
%         if cx(i)>=columns
%             break;
%         end
%     end
% end
% if (Xvp<=0 && (H-1/W-1) * Xvp<Yvp<-(H-1/W-1) * Xvp+H-1) || Xvp<=1*columns/4
%     x1=columns;
%     y1=max(s.yRight);
%     [cx,cy,~]=improfile(~Ie,[x1 Xvp],[y1 Yvp]);
%     cx=round(cx);
%     cy=round(cy);
%     intensity=1;
%     offset=1/(size(cx,1)+rows-y1);
%     i=rows;
%     while i>y1
%         req_img(i,:)=intensity;
%         intensity=intensity-offset;
%         i=i-1;
%     end
%     for i=1:size(cx,1)
%         req_img(1:cy(i),cx(i))=intensity;
%         req_img(cy(i),1:cx(i))=intensity;
%         intensity=intensity-offset;
%         if cx(i)<=1
%             break;
%         end
%     end
% end
Xvp=round(columns/2);
Yvp=round(rows/2);
req_img=zeros(rows,columns);

intensity=0;
offset=1/(rows-Yvp);
x1=1;y1=rows-10;
x2=columns;y2=rows;
slope1=(x1-Xvp)/(y1-Yvp);
slope2=(x2-Xvp)/(y2-Yvp);
for y=Yvp:rows
xL1 = round(slope1 * (y - y1) + x1);
if xL1<1
    xL1=1;end
xL2 = round(slope2 * (y - y2) + x2);
if xL2>columns
    xL2=columns;end
req_img(y,xL1:xL2)=intensity;
intensity=intensity+offset;
end
