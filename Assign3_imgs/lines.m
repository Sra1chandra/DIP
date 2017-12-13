I=imread('rectangle3.jpg');
G=edge(rgb2gray(I),'canny');
[H,theta,rho]=hough(G);
peaks=houghpeaks(H,100);
figure;
imshow(I);hold on;
line=houghlines(G,theta,rho,peaks);
for k=1:length(line)
    xy=[line(k).point1;line(k).point2];
   x1 = xy(1,1);
   y1 = xy(1,2);
   x2 = xy(2,1);
   y2 = xy(2,2);
   plot([x1, x2], [y1, y2], 'LineWidth',3,'Color','red');
end