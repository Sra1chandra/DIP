function [Img2]= Gauss_filter(ImgName,radius,type)
    % usage Gauss_filter('../notch_pass_reject_filter/notch3.jpg',25,'LowPass');
    Img=im2double(imread(ImgName));
    [M,N,Z]=size(Img);
    filt=zeros(M,N);
    Img2=zeros(M,N,Z);
    D0=radius;
    for i=1:M
        for j=1:N
            D=sqrt(((i-M/2)^2)+((j-N/2)^2));
            filt(i,j)=exp(-D*D/(2*D0*D0));
        end
    end
    if strcmp(type,'HighPass')
        filt=1-filt;
    end
    for k=1:Z
        F=fftshift(fft2(double(Img(:,:,k))));
        F=F.*filt;
        Img2(:,:,k)=ifft2(ifftshift(F));
    end
    figure;
    subplot(1,3,1);
    imshow(Img);title('Orginal Image');
    subplot(1,3,2);
    imshow(filt);title('Filter')
    subplot(1,3,3);
    imshow(Img2);title('Filtered Image');
end