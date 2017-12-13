function []=Compression_wavelet(imageName,c)
% imageName='Uncompressed_01.bmp';
Img1 = imread(imageName);
[X,Y,~]=size(Img1);
Img=rgb2ycbcr(Img1);
% Img=Img1;
finalimage=[];
for i=1:8:X
    for j=1:8:Y
            image_block=Img(i:i+7,j:j+7,:);
            [ca,ch,cv,cd]=dwt2(image_block,'haar');
            if c>=1 cd=zeros(size(cd));end
            if c>=2 cv=zeros(size(cv));end
            if c==3 ch=zeros(size(ch));end
            finalimage(i:i+7,j:j+7,:)=[ca ch;cv cd];
    end
end
output=finalimage;
% figure;imshow(uint8(output));
% imshow(ycbcr2rgb(uint8(output)));
[X,Y,~]=size(output);
finalimage=[];
for i=1:8:X
    for j=1:8:Y
            ca=output(i:i+3,j:j+3,:);
            cv=output(i+4:i+7,j:j+3,:);
            ch=output(i:i+3,j+4:j+7,:);
            cd=output(i+4:i+7,j+4:j+7,:);
            finalimage(i:i+7,j:j+7,:)=idwt2(ca,ch,cv,cd,'haar');
    end
end

output=ycbcr2rgb(uint8(int16(finalimage)));
% output=(uint8(int16(finalimage)));

figure;
subplot(1,2,1);
imshow(uint8(Img1));
title('orginal Image');
subplot(1,2,2);
imshow(uint8(output));
title('restored Image');
disp(RMSE(Img1,output))
end