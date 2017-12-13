Img =imread('3.jpeg'); %read the 2D image
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
xy_1 = zeros([2,2]);
for k = 1:length(lines)
   xy = [lines(k).point1; lines(k).point2];
   % Get the equation of the line
   x1 = xy(1,1);
   y1 = xy(1,2);
   x2 = xy(2,1);
   y2 = xy(2,2);
   slope = (y2-y1)/(x2-x1);
   xLeft = 1; % x is on the left edge
   yLeft = slope * (xLeft - x1) + y1;
   xRight = columns; % x is on the reight edge.
   yRight = slope * (xRight - x1) + y1;

   
   
   %  len = norm(lines(k).point1 - lines(k).point2);
   plot([x1, x2], [y1, y2], 'LineWidth',1,'Color','blue');
%  plot([xLeft, xRight], [yLeft, yRight], 'LineWidth',1,'Color','blue');
%  Plot original points on the lines .
 plot(xLeft,yLeft,'x','markersize',8,'Color','yellow'); 
%  plot(xy(2,1),xy(2,2),'x','markersize',8,'Color','green');    
end
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
%            plot(xintersect,yintersect,'m*','markersize',8, 'Color', 'red')
           req(k,1)=xintersect;
           req(k,2)=yintersect;
           k=k+1;
       end
     end    
end
%finding maximum voted point
clusters=clusterdata(req,floor(size(req,1)/2));
c=find(clusters==mode(clusters));
vanishing_pointx=mean(req(c,1));
vanishing_pointy=mean(req(c,2));
plot(vanishing_pointx,vanishing_pointy,'m*','markersize',8, 'Color', 'red');

