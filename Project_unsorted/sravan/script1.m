gblock=imread('9.jpg');

%Convert the image to Grayscale
I=rgb2gray(gblock);
figure(1);imshow(I);title('Grayscale Image');pause;
x= I;
%Generate Histogram
imhist(x); pause;
%Perform Median Filtering
x = medfilt2(x);
%Convert Grayscale image to Binary
threshold=98;%assign a threshold value
x(x<threshold)=0;
x(x>=threshold)=1; 
x=logical(x);%convert image to binary compared to threshold
%Perform Median Filtering
im2=medfilt2(x);
figure(1),imshow(im2);title('filtered image');pause;
%Edge Detection
a=edge(im2,'sobel');
imshow(a); title('Edge Detection');pause
%Horizontal Edge Detection
BW=edge(im2,'sobel',(graythresh(I)*0.3),'horizontal');
imshow(BW)
pause;
%Hough Transform
[H,theta,rho] = hough(BW);
figure, imshow(imadjust(mat2gray(H)),[],'XData',theta,'YData',rho,...
'InitialMagnification','fit');
xlabel('\theta (degrees)'), ylabel('\rho');
axis on, axis normal, hold on;
colormap(hot)

% Finding the Hough peaks (number of peaks is set to 10)
P = houghpeaks(H,20,'threshold',ceil(0.2*max(H(:))));

x = theta(P(:,2));
y = rho(P(:,1));
plot(x,y,'s','color','black');
pause;
%Fill the gaps of Edges and set the Minimum length of a line
lines = houghlines(BW,theta,rho,P,'FillGap',100);

figure, imshow(gblock), hold on
max_len = 0;
for k = 1:length(lines)
xy = [lines(k).point1; lines(k).point2];

plot(xy(:,1),xy(:,2),'LineWidth',2,'Color','red');
% Plot beginnings and ends of lines
plot(xy(1,1),xy(1,2),'x','LineWidth',2,'Color','yellow');
plot(xy(2,1),xy(2,2),'x','LineWidth',2,'Color','green');
end
pause;
n=size(lines,1);
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
% %finding maximum voted point
% clusters=clusterdata(req,floor(size(req,1)/2));
% c=find(clusters==mode(clusters));
% Xvp=mean(req(c,1));
% Yvp=mean(req(c,2));
% plot(Xvp,Yvp,'m*','markersize',8, 'Color', 'blue');
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
% if(xy(1,1)<Xvp)
%     LeftPoints.pointsx(len)=xy(1,1);
%     LeftPoints.pointsy(len)=xy(1,2);
%     len=len+1;
%     plot(xy(1,1),xy(1,2),'x','LineWidth',2,'Color','yellow'); 
% end
% if(xy(1,2)>Xvp)
%     RightPoints.pointsx(len2)=xy(2,1);
%     RightPoints.pointsy(len2)=xy(2,2);
%     len2=len2+1;
%     plot(xy(2,1),xy(2,2),'x','LineWidth',2,'Color','green'); 
% end
% 
% % plot(xy(:,1),xy(:,2),'LineWidth',2,'Color','red');
% % Plot beginnings and ends of lines
% 
% 
% end
