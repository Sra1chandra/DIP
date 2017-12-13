c=1;
Img=imread('Uncompressed_01.bmp');
ca=Img;
for i=1:c
    [ca,ch,cv,cd]=dwt2(ca,'haar');
end
for i=1:c
    cd=zeros(size(ca));
    ch=zeros(size(ca));
    cv=zeros(size(ca));
    ca=idwt2(ca,ch,cv,cd,'haar');
end
Req=ca;
figure;
imshow(uint8(Req));
