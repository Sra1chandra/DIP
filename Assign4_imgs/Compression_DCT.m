function []=Compression_DCT(imageName,c)
Img1 = imread(imageName);
[X,Y,Z]=size(Img1);
Img=int16(rgb2ycbcr(Img1))-128;
qv= [ 16   11   10   16   24   40   51   61;
          12   12   14   19   26   58   60   55;
          14   13   16   24   40   57   69   56;
          14   17   22   29   51   87   80   62;
          18   22   37   56   68  109  103   77;
          24   35   55   64   81  104  113   92;
          49   64   78   87  103  121  120  101;
          72   92   95   98  112  100  103   99;];

finalimage=[];
for i=1:8:X
    for j=1:8:Y
        for k=1:Z
            image_block=Img(i:i+7,j:j+7,k);
            image_blockDCT=dct2(image_block);
            image_blockDCT_quantized=myDCT_quantization(image_blockDCT,qv,c);
            finalimage(i:i+7,j:j+7,k)=image_blockDCT_quantized;
        end
    end
end
output=finalimage;
[X,Y,~]=size(output);
finalimage=[];
for i=1:8:X
    for j=1:8:Y
        for k=1:Z
            image_blockDCT=output(i:i+7,j:j+7,k);
            image_blockDCT_dequantized=myDCT_dequantization(image_blockDCT,qv,c);
            img_block=idct2(image_blockDCT_dequantized);
            finalimage(i:i+7,j:j+7,k)=img_block;
        end
    end
end

output=ycbcr2rgb(uint8(int16(finalimage)+128));

figure;
subplot(1,2,1);
imshow(uint8(Img1));
title('orginal Image');
subplot(1,2,2);
imshow(uint8(output));
title('restored Image');
disp(RMSE(Img1,output))
end