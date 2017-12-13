function [reqImg]=image_blending(Img1,Img2,Mask,N)
    
    % usage image_blending('./example3/im1.png','./example3/im2.png','./example3/mask.png',5);
    I1=gaussian_and_laplacian_pyramid(Img1,N);
    I2=gaussian_and_laplacian_pyramid(Img2,N);
    M=gaussian_and_laplacian_pyramid(Mask,N);
    [X,Y,Z]=size(I1(N).LaplaseImg);
    reqImg=I1(N).LaplaseImg;
    for k=1:Z
        reqImg(:,:,k)=(I1(N).LaplaseImg(:,:,k).*M(N).GaussImg(1:X,1:Y)+I2(N).LaplaseImg(:,:,k).*(1-M(N).GaussImg(1:X,1:Y)))./1;
    end
    for i=1:N-1
        Img_upsample=Image_up_sampling(reqImg,'BiLinear_interpolation',1);
        [X,Y,Z]=size(I1(N-i).LaplaseImg);
        reqImg=zeros(X,Y,Z);
        for k=1:Z
            Lap=(I1(N-i).LaplaseImg(:,:,k).*M(N-i).GaussImg(1:X,1:Y)+I2(N-i).LaplaseImg(:,:,k).*(1-M(N-i).GaussImg(1:X,1:Y)))./1;
            reqImg(:,:,k)=Img_upsample(1:X,1:Y,k)+Lap;
        end
    end
        figure;
        imshow(reqImg);
end