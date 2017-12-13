function output = DepthMap(filename)
    %filename = 'samples/image1.jpg');
    im = imread(filename);

    % computing mean shift clustering
    [output,~] = Ms(im,0.1);

     % finding hsv image 
    output3 = rgb2hsv(output);
    output=output.*255;
    output2 = output;
    
    % applying median filter on segmented image
    output2(:,:,1)= medfilt2(output(:,:,1),[5 5]);
    output2(:,:,2)= medfilt2(output(:,:,2),[5 5]);
    output2(:,:,3)= medfilt2(output(:,:,3),[5 5]);
    med = output2;
    img_hsv = (output3);
    [x,y,~] = size(output3);

    % region detection by color based rules
    % 1-- sky ; 2 -- far mountain ; 3 -- near mountain ; 4 -- land ;
    % 5 -- other
    
    temp = zeros(x,y);
    for i = 1:x
        for j = 1:y
            if(img_hsv(i,j,3)>0.65 && (med(i,j,3)>=160 && med(i,j,3)<=255) && (med(i,j,2)>=70 && med(i,j,2)<=255) && (med(i,j,1)>=0) && (med(i,j,3)+15>=med(i,j,2) && med(i,j,3)+15>=med(i,j,1)))
                temp(i,j) = 1;
            elseif(img_hsv(i,j,3)>0.1 && (med(i,j,3)>=20 && med(i,j,3)<=160) && (med(i,j,2)>=15 && med(i,j,2)<=255) && (med(i,j,1)>=0) && (med(i,j,3)>=med(i,j,2) && med(i,j,3)>=med(i,j,1)))
                temp(i,j) = 2;
            elseif(img_hsv(i,j,3)>0.45 && ( med(i,j,3)<=100) && ( med(i,j,2)<=255) && (med(i,j,1)>=100) &&(med(i,j,1)>=med(i,j,3) && med(i,j,1)>=med(i,j,2)))
                temp(i,j) = 3;
            elseif(img_hsv(i,j,3)>0.14 && img_hsv(i,j,3)<0.65 && (med(i,j,3)<=120) && ( med(i,j,2)<=120) && (med(i,j,1)<=120) &&(med(i,j,2)+10>=med(i,j,3) && med(i,j,2)+10>=med(i,j,1)))
                temp(i,j) = 3;
            elseif(img_hsv(i,j,3)>0.4 && ( med(i,j,3)<=100) && ( med(i,j,2)<=255) && (med(i,j,1)<=200) &&(med(i,j,2)>=med(i,j,3) && med(i,j,2)>=med(i,j,1)))
                temp(i,j) = 4;
            elseif(img_hsv(i,j,3)>0.4 && img_hsv(i,j,3)<0.8 && (med(i,j,1)>=80 && med(i,j,1)<=160) && (med(i,j,2)>=80 && med(i,j,2)<=160) && (med(i,j,3)>=80 && med(i,j,3)<=160))
                temp(i,j) = 2;
            elseif(img_hsv(i,j,3)>0.6 && (med(i,j,1)>165 && med(i,j,1)<=200) && (med(i,j,2)>140 && med(i,j,2)<=190) && (med(i,j,3)>135 && med(i,j,3)<=180))
                temp(i,j) = 4;
            else
                temp(i,j) = 5;
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
                fin_out(i,j,1) = 60;
                fin_out(i,j,2) = 60;
                fin_out(i,j,3) = 60;
            elseif(temp(i,j)==3)
                fin_out(i,j,1) = 120;
                fin_out(i,j,2) = 120;
                fin_out(i,j,3) = 120;
            elseif(temp(i,j)==4)
                fin_out(i,j,1) = 200;
                fin_out(i,j,2) = 200;
                fin_out(i,j,3) = 200;
            elseif(temp(i,j)==5)
                fin_out(i,j,1) = 255;
                fin_out(i,j,2) = 255;
                fin_out(i,j,3) = 255;
            end
        end
    end

    % applying median filter to remove outliers.
    temp_fin = fin_out;
    temp_fin(:,:,1) = medfilt2(fin_out(:,:,1),[5 5]);
    temp_fin(:,:,2) = medfilt2(fin_out(:,:,2),[5 5]);
    temp_fin(:,:,3) = medfilt2(fin_out(:,:,3),[5 5]);

    temp_label = zeros(x,y);


    for i = 1:x
        for j =1:y
            if(temp_fin(i,j,1) ==0)
                temp_label(i,j) = 1;
            elseif((temp_fin(i,j,1)==60) || (temp_fin(i,j,1)==120))
                temp_label(i,j)=2;
            elseif(temp_fin(i,j,1)==200)
                temp_label(i,j)=3;
            elseif(temp_fin(i,j,1)==255)
                temp_label(i,j)=4;
            end
        end
    end

    % image classification into outdoor or indoor types.
    
    vals= 1:10:y;
    count = 0;
    count2=0;
    temp_col = 0;
    flag=0;
    temp_cnt = 0;
    for j = 1:size(vals,2)
        for i = 1:x
            if(i==1)
                if(temp_label(i,vals(1,j)) == 1)
                    temp_col = 1;
                    temp_cnt = 1;
                    continue;
                else
                    flag=1;
                    break;
                end
            elseif(i<x)
                if(temp_label(i,vals(1,j))==temp_col)
                    continue;
                elseif(temp_label(i,vals(1,j))>temp_col)
                    temp_cnt = temp_cnt+1;
                    temp_col = temp_label(i,vals(1,j));
                elseif(temp_label(i,vals(1,j))<temp_col)
                    temp_col = temp_label(i,vals(1,j));
                    temp_cnt = temp_cnt+1;
                end
            end
        end
        if(flag==0)
            count2=count2+1;
            if(temp_cnt<=5)
                count=count+1;
            end
        end
    end
    % 0 -- outdoor without geometric elements , 1-- outdoor with geometric elements 2-- indoor

    if(count >= 0.65*size(vals,2))
        type=0;
    elseif(count2>=0.4*size(vals,2))
        type=1;
    else
        type = 2;
    end

    disp(type);
    save('d.mat','type','temp_fin');

    % plotting 
    figure;
    subplot(1,3,1);
    imshow(uint8(fin_out));
    title('Qualitative depth map');
    subplot(1,3,2);
    imshow(med./255);
    title('segmented image');
    subplot(1,3,3);
    imshow(img_hsv);
    title('hsv image');

    figure;
    subplot(1,2,1);
    imshow(im);
    title('Actual image');
    subplot(1,2,2);
    imshow(uint8(temp_fin));
    title('Qualitative depth map');
end