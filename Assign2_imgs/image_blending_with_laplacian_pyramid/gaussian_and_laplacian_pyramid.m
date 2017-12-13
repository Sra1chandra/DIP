function [s] = gaussian_and_laplacian_pyramid(ImgName,N)
    Img=imread(ImgName);
    s(1).GaussImg=im2double(Img);
    pad=10;sigma=4;
    [X, Y]=meshgrid(-pad:pad,-pad:pad);
    filt=exp(-(X.^2+Y.^2)/(2*sigma.^2))./(2*pi*sigma.^2);
    for i=1:N-1
        Img2=imfilter(s(i).GaussImg,filt);
        s(i+1).GaussImg=Img2(1:2:end,1:2:end,:);
        temp=Image_up_sampling(s(i+1).GaussImg,'BiLinear_interpolation',1);
        [X,Y,Z]=size(s(i).GaussImg);
        s(i).LaplaseImg=s(i).GaussImg-temp(1:X,1:Y,1:Z);
    end
    s(N).LaplaseImg=s(N).GaussImg;
end