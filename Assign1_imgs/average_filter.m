function []=average_filter(image_name,n)
    %input ImageName , size_of_the_filter(only odd sized filter)
    %for example average_filter('bell.jpg',3);
    img=im2double(imread(image_name));
    req_img=img;
    filt=ones(n,n)./(n*n);
    pad=floor(n/2);
    img=padarray(img,[pad pad]);
    [X,Y,Z]=size(img);
    for i=pad+1:X-pad
        for j=pad+1:Y-pad
            for k=1:Z
            req_img(i-pad,j-pad,k)=sum(sum(filt.*img(i-pad:i+pad,j-pad:j+pad,k)));
            end
        end
    end
    figure;
    subplot(1,2,1);
    imshow(img);title('Orginal Image');
    subplot(1,2,2);
    imshow(req_img);title('Filtered Image');
end