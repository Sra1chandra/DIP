function [Img2] = Laplase_filter(Image_Name)
    % usage Laplase_filter('car1.jpg');
    Img=double(rgb2gray(imread(Image_Name)));
    filt=[0 1 0;1 -4 1;0 1 0];
    [X,Y,Z]=size(Img);
    Img2=zeros(X,Y,Z);
    for k=1:Z
        F=fftshift(fft2(Img(:,:,k),X,Y));
        L=fftshift(fft2(filt,X,Y));
        F=F.*L;
        Img2(:,:,k)=real(ifft2(ifftshift(F)));
    end
    figure;
    imshow(uint8(Img2));title('Laplacian of the image')
end