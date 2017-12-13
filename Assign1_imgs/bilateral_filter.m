function []=bilateral_filter(image_name,n,s1,s2)
    % input arguments image_name,filter_size(odd),sigma1,sigma2
    % sigma1,sigma2 are gaussian filter variances
    % usage bilateral_filter('portraits.jpg',3,3,0.2);
    img=im2double(imread(image_name));
    pad=floor(n/2);
    [x ,y]=meshgrid(-pad:pad,-pad:pad);
    filt=exp(-(x.^2+y.^2)/(2*s1.^2));
    [X,Y,Z]=size(img);
    output=zeros(X-2*pad,Y-2*pad,Z);
    for k=1:Z
        for i=pad+1:X-pad
            for j=pad+1:Y-pad
                filt2=(exp(-(double(img(i-pad:i+pad,j-pad:j+pad,k)-img(i,j,k)).^2)./(2*s2^2)));
                filt1=(filt2.*filt);
                output(i-pad,j-pad,k)=(sum(sum(filt1.*double(img(i-pad:i+pad,j-pad:j+pad,k)))))/sum(sum(filt1));
            end
        end
    end
    figure;
    subplot(1,2,1);
    imshow(img);title('Orginal Image');
    subplot(1,2,2);
    imshow(output);title('Bilateral filtered Image');
end