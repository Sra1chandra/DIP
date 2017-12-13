function []=Compression_FFT(imageName,c)
% imageName='Uncompressed_01.bmp';
% c=3;
Img1 = imread(imageName);
[X,Y,Z]=size(Img1);
% Img=rgb2ycbcr(Img1);
Img=Img1;
finalimage=[];
for i=1:8:X
    for j=1:8:Y
        for k=1:Z
            image_block=Img(i:i+7,j:j+7,k);
            fftimg=fftshift(fft2(image_block));
            finalimage(i:i+7,j:j+7,k)=padarray(fftimg(1+c:8-c,1+c:8-c),[c c],0,'both');
        end
    end
end
output=finalimage;
% figure;imshow(uint8(output));
% imshow(ycbcr2rgb(uint8(output)));
[X,Y,~]=size(output);
finalimage=[];
for i=1:8:X
    for j=1:8:Y
        for k=1:Z
            image_block=output(i:i+7,j:j+7,k);
            fftimg=ifft2(ifftshift(image_block));
            finalimage(i:i+7,j:j+7,k)=fftimg;
        end
    end
end
finalimage=real(finalimage);
% output=ycbcr2rgb(uint8(int16(finalimage)));
output=(uint8(int16(finalimage)));

figure;
subplot(1,2,1);
imshow(uint8(Img1));
title('orginal Image');
subplot(1,2,2);
imshow(uint8(output));
title('restored Image');
disp(RMSE(Img1,output))
end 