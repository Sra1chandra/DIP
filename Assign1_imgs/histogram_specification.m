function []=histogram_specification(image1,image2)
    % usage histogram_specification('hist_equal.jpg','bell.jpg');
    n=256;
    img1=imread(image1);
    img2=imread(image2);
    img3=img1;
    for k=1:3
        X1=imhist(img1(:,:,k));
        cumulative_matrix = tril(ones(n,n),0);
        N=sum(X1);
        initial_cumulative_sum = round(((cumulative_matrix*X1)*(n-1))/N);
        X2=imhist(img2(:,:,k));
        cumulative_matrix = tril(ones(n,n),0);
        N=sum(X2);
        final_cumulative_sum = round(((cumulative_matrix*X2)*(n-1))/N);
        img4=img1(:,:,k);
        for i=1:n
            temp=find(final_cumulative_sum>initial_cumulative_sum(i),1);
            if isempty(temp)
                z=n-1;
            else
                z=temp-1;
            end
           temp2=find(img1(:,:,k)==(i-1));
           if ~isempty(temp2)

                img4(temp2)=z;
           end
        end
        img3(:,:,k)=img4;
    end

    figure;
    subplot(2,3,1);
    imshow(img1);
    subplot(2,3,2);
    imshow(img2);
    subplot(2,3,3);
    imshow(uint8(img3));
    subplot(2,3,4);
    imhist(img1(:,:,1));
    subplot(2,3,5);
    imhist(img2(:,:,1));
    subplot(2,3,6);
    imhist(img3(:,:,1));

end