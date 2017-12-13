function []=gaussian_filter(image_name,n,sigma)
    % input argumentsbimage_name,filter_size(odd),variance_of_gaussian_filter
    % usage gaussian_filter('SaltPepperNoise.jpg',3,0.3);
    img=im2double(imread(image_name));
    req_img=size(img);
    pad=floor(n/2);
    [X, Y]=meshgrid(-pad:pad,-pad:pad);
    filt=exp(-(X.^2+Y.^2)/(2*sigma.^2))./(2*pi*sigma.^2);
    img=padarray(img,[pad pad]);
    [X,Y,Z]=size(img);
    for k=1:Z
        for i=pad+1:X-pad
            for j=pad+1:Y-pad
                req_img(i-pad,j-pad,k)=sum(sum(filt.*double(img(i-pad:i+pad,j-pad:j+pad,k))));
            end
        end
    end
    figure;
    subplot(1,2,1);
    imshow(img);title('Orginal Image')
    subplot(1,2,2);
    imshow(req_img);title('Gaussian filtered image');
end