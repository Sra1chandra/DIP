Img=double(imread('Cricket1.jpeg'));
Img=rgb2hsv(Img);
[X,Y,Z]=size(Img);
R=Img(:,:,1);
G=Img(:,:,2);
B=Img(:,:,3);
[idx,C]=kmeans([R(:) G(:) B(:)],2);
req_img=reshape(idx,X,Y);
imshow(ind2rgb(req_img,[0 0 0;1 1 1]));
