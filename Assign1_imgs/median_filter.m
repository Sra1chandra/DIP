function [req_img]=median_filter(image_name,n)
    % usage median_filter('zelda512-NoiseV400.jpg',3);
    img=double((imread(image_name)));
    req_img=img;
    pad=floor(n/2);
    img=padarray(img,[pad pad]);
    [X,Y,Z]=size(img);
    for k=1:Z
        for i=pad+1:X-pad
            for j=pad+1:Y-pad
                req_img(i-pad,j-pad,k)=median(reshape(img(i-pad:i+pad,j-pad:j+pad,k),1,n*n));
            end
        end
    end
    figure;
    subplot(1,2,1);
    imshow(uint8(img));title('Orginal Image');
    subplot(1,2,2);
    imshow(uint8(req_img));title('Filtered image');
end