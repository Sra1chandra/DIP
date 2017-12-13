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
s=struct;
len1=1;
len2=1;
len3=1;
len4=1;

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
   P=(slope*(Xvp-x1)-Yvp+y1)/sqrt((slope^2+1));
   if(abs(P)>4)
    continue;
   end
   plot([x1, x2], [y1, y2], 'LineWidth',1,'Color','blue');
   if 0<yLeft && yLeft<rows
    s.yLeft(len1)=yLeft;
%     plot(xLeft,yLeft,'x','markersize',8,'Color','green');
    len1=len1+1;
   end
   xRight = columns; % x is on the right edge.
   yRight = slope * (xRight - x1) + y1;

   if 0<yRight && yRight<rows
    s.yRight(len2)=yRight;
%     plot(xRight,yRight,'x','markersize',8,'Color','green');
    len2=len2+1;
   end


   slope = (x2-x1)/(y2-y1);
   yLeft = 1; % x is on the left edge.
   xLeft = slope * (yLeft - y1) + x1;
   if 0<xLeft && xLeft<columns
    s.xLeft(len3)=xLeft;
%     plot(xLeft,yLeft,'x','markersize',8,'Color','green');
    len3=len3+1;
   end
   yRight = rows; % x is on the right edge.
   xRight = slope * (yRight - y1) + x1;

   if 0<xRight && xRight<columns
    s.xRight(len4)=xRight;
%     plot(xRight,yRight,'o','markersize',8,'Color','green');
    len4=len4+1;
   end

end
% distance=zeros(n,1);
% for i=1:n
%    xy_1 = [lines(i).point1; lines(i).point2];
%    slopee = @(line) (line(2,2) - line(1,2))/(line(2,1) - line(1,1));
%    m1 = slopee(xy_1);
%    intercept = @(line,m) line(1,2) - m*line(1,1);
%    b1 = intercept(xy_1,m1);
%    P = @(m1,b1) abs((m1*Xvp-Yvp+b1)/sqrt(m1*m1+1));
%    distance(i)=P(m1,b1);
% end
% req=lines(distance<=5);
% LeftPoints=struct;
% RightPoints=struct;
% len=1;
% len2=1;
% for k = 1:length(req)
% xy = [req(k).point1; req(k).point2];
% % if(xy(1,1)<Xvp)
%     LeftPoints.pointsx(len)=xy(1,1);
%     LeftPoints.pointsy(len)=xy(1,2);
%     len=len+1;
% %     plot(xy(1,1),xy(1,2),'x','LineWidth',2,'Color','yellow');
% % end
% % if(xy(1,2)>Xvp)
%     RightPoints.pointsx(len2)=xy(2,1);
%     RightPoints.pointsy(len2)=xy(2,2);
%     len2=len2+1;
% %     plot(xy(2,1),xy(2,2),'x','LineWidth',2,'Color','green');
% % end
% 
% % plot(xy(:,1),xy(:,2),'LineWidth',2,'Color','red');
% % Plot beginnings and ends of lines
% 
% 
% end

Xvp=round(Xvp);
Yvp=round(Yvp);
req_img=zeros(rows,columns);

req_img=zeros(rows,columns);
H=rows;W=columns;
if (Xvp>=W-1 && -((H-1)/(W-1)) * Xvp+H-1<Yvp<((H-1)/(W-1)) * Xvp )
    x1=1;
    y1=max(s.yLeft);
    [cx,cy,~]=improfile(~Ie,[x1 Xvp],[y1 Yvp]);
    cx=round(cx);
    cy=round(cy);
    intensity=1;
    offset=1/(size(cx,1)+rows-y1);
    i=rows;
    while i>y1
        req_img(i,:)=intensity;
        intensity=intensity-offset;
        i=i-1;
    end
    for i=1:size(cx,1)
        req_img(1:cy(i),cx(i))=intensity;
        req_img(cy(i),cx(i):end)=intensity;
        intensity=intensity-offset;
        if cx(i)>=columns
            break;
        end
    end
end
if (Xvp<=0 && (H-1/W-1) * Xvp<Yvp<-(H-1/W-1) * Xvp+H-1)
    x1=columns;
    y1=max(s.yRight);
    [cx,cy,~]=improfile(~Ie,[x1 Xvp],[y1 Yvp]);
    cx=round(cx);
    cy=round(cy);
    intensity=1;
    offset=1/(size(cx,1)+rows-y1);
    i=rows;
    while i>y1
        req_img(i,:)=intensity;
        intensity=intensity-offset;
        i=i-1;
    end
    for i=1:size(cx,1)
        req_img(1:cy(i),cx(i))=intensity;
        req_img(cy(i),1:cx(i))=intensity;
        intensity=intensity-offset;
        if cx(i)<=1
            break;
        end
    end
end


if 0<Xvp && Xvp<W-1 && 0<Yvp && Yvp<H-1 
    
    intensity=0;
    offset=1/(rows-Yvp);
    x1=min(s.xRight);y1=rows;
    x2=columns;y2=max(s.yRight);
    slope1=(x1-Xvp)/(y1-Yvp);
    slope2=(x2-Xvp)/(y2-Yvp);    
    for y=Yvp:rows
    xL1 = round(slope1 * (y - y1) + x1);
    if xL1<1
        xL1=1;end
    xL2 = round(slope2 * (y - y2) + x2);
    if xL2>=columns
        xL2=columns;end
    req_img(y,xL1:xL2)=intensity;
    intensity=intensity+offset;
    end


    x1=columns;y1=max(s.yRight);
    x2=max(s.xLeft);y2=1;
    slope1=(y1-Yvp)/(x1-Xvp);
    slope2=(y2-Yvp)/(x2-Xvp);
    intensity=0;
    offset=1/(columns-Xvp);
    for x=Xvp:columns
    yL1 = round(slope1 * (x - x1) + y1);
    if yL1>rows
        yL1=rows;end
    yL2 = round(slope2 * (x - x2) + y2);
    if yL2<1
        yL2=1;end
    req_img(yL2:yL1,x)=intensity;
    intensity=intensity+offset;
    end

    x1=max(s.xLeft);y1=1;
    x2=1;y2=min(s.yLeft);
    slope1=(x1-Xvp)/(y1-Yvp);
    slope2=(x2-Xvp)/(y2-Yvp);
    intensity=0;
    offset=1/(columns-Xvp);
    y=Yvp;
    while y>=1
    xL1 = round(slope1 * (y - y1) + x1);
    if xL1>columns
        xL1=columns;end
    xL2 = round(slope2 * (y - y2) + x2);
    if xL2<1
        xL2=1;end
    req_img(y,xL2:xL1)=intensity;
    intensity=intensity+offset;
    y=y-1;
    end

    x1=1;y1=min(s.yLeft);
    x2=min(s.xRight);y2=rows;
    slope1=(y1-Yvp)/(x1-Xvp);
    slope2=(y2-Yvp)/(x2-Xvp);
    intensity=0;
    offset=1/(columns-Xvp);
    x=Xvp;
    while x>=1
    yL1 = round(slope1 * (x - x1) + y1);
    if yL1<1
        yL1=1;end
    yL2 = round(slope2 * (x - x2) + y2);
    if yL2>rows
        yL2=rows;end
    req_img(yL1:yL2,x)=intensity;
    intensity=intensity+offset;
    x=x-1;
    end
end
