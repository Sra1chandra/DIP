function []=highboost_filter(image_name,c)
    % usage highboost_filter('blur2.jpg',1);
    img=double((imread(image_name)));
    req_img=img;
    filt=[-c -c -c;-c 8*c+1 -c ; -c -c -c];
    n=3;
    pad=floor(n/2);
    img=padarray(img,[pad pad]);
    [X,Y,Z]=size(img);
    for k=1:Z
        for i=pad+1:X-pad
            for j=pad+1:Y-pad
                req_img(i-pad,j-pad,k)=round(sum(sum(filt.*img(i-pad:i+pad,j-pad:j+pad,k))));
            end
        end
    end
    figure;
    subplot(1,2,1);
    imshow(uint8(img));title('Orginal Image');
    subplot(1,2,2);
    imshow(uint8(req_img),[]);title('Sharpened Image');
end