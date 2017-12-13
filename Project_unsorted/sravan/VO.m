function [req_img]= VO(type,temp_fin,image_name)
    temp_fin=temp_fin(:,:,1);
    [rows,columns,~]=size(temp_fin);
    if type==0
        y=zeros(rows,1);
        for i=1:columns
           temp=find(temp_fin(:,i)==200|temp_fin(:,i)==255);
           if(isempty(temp))
            y(i)=0;
           else
               y(i)=temp(1);
           end
        end
        Yvp=max(y);
        Xvp=round(columns/2);
        Yvp=round(Yvp);
        req_img=zeros(rows,columns);
        intensity=1;
        offset=(1-200/255)/(rows-Yvp);
        i=rows;
        while i>Yvp && i>1
            req_img(i,:)=intensity;
            intensity=intensity-offset;
            i=i-1;
        end
        req_img(1:Yvp,:)=60/255;
        figure;subplot(1,2,1);imshow(imread(image_name));title('Actual Image');subplot(1,2,2);imshow(req_img);title('Geometric Depthmap');
    else
        req_img=geometric_depthMap(type,image_name);
    end
end