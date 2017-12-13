im = imread('4.jpg');

[output,~] = Ms(im,0.1);
output=output.*255;
output2 = output;
output2(:,:,1)= medfilt2(output(:,:,1),[5 5]);
output2(:,:,2)= medfilt2(output(:,:,2),[5 5]);
output2(:,:,3)= medfilt2(output(:,:,3),[5 5]);
output3 = rgb2hsv(output2);
med = output2;
img_hsv = (output3);
[x,y,c] = size(output3);

temp = zeros(x,y);
for i = 1:x
    for j = 1:y
        if((med(i,j,3)>=160 && med(i,j,3)<=255) && (med(i,j,2)>=70 && med(i,j,2)<=255) && (med(i,j,1)>=0) && (med(i,j,3)+15>=med(i,j,2) && med(i,j,3)+15>=med(i,j,1)))
            temp(i,j) = 1;
        elseif( ( med(i,j,3)<=100) && ( med(i,j,2)<=255) && (med(i,j,1)>=100) &&(med(i,j,1)>=med(i,j,3) && med(i,j,1)>=med(i,j,2)))
            temp(i,j) = 2;
        elseif(( med(i,j,3)<=120) && ( med(i,j,2)<=120) && (med(i,j,1)<=120) &&(med(i,j,2)>=med(i,j,3) && med(i,j,2)>=med(i,j,1)))
            temp(i,j) = 2;
        elseif( ( med(i,j,3)<=100) && ( med(i,j,2)<=255) && (med(i,j,1)<=200) &&(med(i,j,2)>=med(i,j,3) && med(i,j,2)>=med(i,j,1)))
            temp(i,j) = 3;
        else
            temp(i,j) = 4;
        end
    end
end

fin_out = med;
for i = 1:x
    for j = 1:y
        if(temp(i,j)==1)
            fin_out(i,j,1) = 0;
            fin_out(i,j,2) = 0;
            fin_out(i,j,3) = 0;
        elseif(temp(i,j)==2)
            fin_out(i,j,1) = 80;
            fin_out(i,j,2) = 80;
            fin_out(i,j,3) = 80;
        elseif(temp(i,j)==3)
            fin_out(i,j,1) = 200;
            fin_out(i,j,2) = 200;
            fin_out(i,j,3) = 200;
        elseif(temp(i,j)==4)
            fin_out(i,j,1) = 255;
            fin_out(i,j,2) = 255;
            fin_out(i,j,3) = 255;
        end
    end
end

        
            
figure;
subplot(1,3,1);
imshow(uint8(fin_out));
subplot(1,3,2);
imshow(med./255);
subplot(1,3,3);
imshow(img_hsv);