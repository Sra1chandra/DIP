function [Img2] = Image_up_sampling(Img,type,N)
    for i=1:N
        [X,Y,Z]=size(Img);
        Img=double(Img);
        Img2=zeros(2*X,2*Y,Z);
        if strcmp(type,'Nearest_Neighbour')
            Img2(1:2:end,1:2:end,:)=Img;
            Img2(1:2:end,2:2:end,:)=Img;
            Img2(2:2:end,1:2:end,:)=Img;
            Img2(2:2:end,2:2:end,:)=Img;
        elseif strcmp(type,'Linear_interpolation')
            Img2(1:2:end,1:2:end,:)=Img;
            Img2(2:2:end,1:2:end,:)=(Img(1:end,1:end,:)+[Img(2:end,1:end,:);Img(end,1:end,:)])/2;
            Img2(1:2:end,2:2:end,:)=(Img(1:end,1:end,:)+[Img(1:end,2:end,:) Img(1:end,end,:)])/2;
            Img2(2:2:end,2:2:end,:)=Img;
        elseif strcmp(type,'BiLinear_interpolation')
            Img2(1:2:end,1:2:end,:)=Img;
            Img2(2:2:end,1:2:end,:)=(Img(1:end,1:end,:)+[Img(2:end,1:end,:);Img(end,1:end,:)])/2;
            Img2(1:2:end,2:2:end,:)=(Img(1:end,1:end,:)+[Img(1:end,2:end,:) Img(1:end,end,:)])/2;
            Img2(2:2:end,2:2:end,:)=(Img2(2:2:end,1:2:end,:)+[Img2(4:2:end,1:2:end,:);Img(end,1:end,:)])/2;
        elseif strcmp(type,'Bicubic_interpolation')
            [X,Y,~]=size(Img);
            Img=padarray(Img,[1 1],'pre');
            Img=padarray(Img,[2 2],'post');
            size(Img)
            Img2(1:2:end,1:2:end,:)=Img(2:X+1,2:Y+1,:);
            Img2(2:2:end,1:2:end,:)=(-1*Img(1:X,2:Y+1,:)+9*Img(2:X+1,2:Y+1,:)+9*Img(3:X+2,2:Y+1,:)-1*Img(4:X+3,2:Y+1,:))*(1/16);
            Img2(1:2:end,2:2:end,:)=(-1*Img(2:X+1,1:Y,:)+9*Img(2:X+1,2:Y+1,:)+9*Img(2:X+1,3:Y+2,:)-1*Img(2:X+1,4:Y+3,:))*(1/16);
            temp=Img2(1:2:end,1:2:end,:);
            temp=padarray(temp,[1 1],'pre');
            temp=padarray(temp,[2 2],'post');
            Img2(2:2:end,2:2:end,:)=(-1*temp(1:X,2:Y+1,:)+9*temp(2:X+1,2:Y+1,:)+9*temp(3:X+2,2:Y+1,:)-1*temp(4:X+3,2:Y+1,:))*(1/16);

        end
        Img=Img2;
    end
end