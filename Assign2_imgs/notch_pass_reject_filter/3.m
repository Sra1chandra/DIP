twigs=double(imread('notch3.jpg'));
fft_twigs(:,:,1)=fftshift(fft2(twigs(:,:,1)));
fft_twigs(:,:,2)=fftshift(fft2(twigs(:,:,2)));
fft_twigs(:,:,3)=fftshift(fft2(twigs(:,:,3)));
filt=ones(size(twigs));
filt(127:132,1:90,:)=0;
filt(127:132,170:256,:)=0;
filt(1:85,126:130,:)=0;
filt(170:256,126:130,:)=0;
fft_twigs=fft_twigs.*filt;
figure;
img2=zeros(size(twigs));
img2(:,:,1)=ifft2(ifftshift(fft_twigs(:,:,1)));
img2(:,:,2)=ifft2(ifftshift(fft_twigs(:,:,2)));
img2(:,:,3)=ifft2(ifftshift(fft_twigs(:,:,3)));
subplot(1,3,1);
imshow(uint8(twigs));title('Given Image')
subplot(1,3,2);
imshow(filt);title('Filter')
subplot(1,3,3);
imshow(uint8(real(img2)));title('Denoised Image');