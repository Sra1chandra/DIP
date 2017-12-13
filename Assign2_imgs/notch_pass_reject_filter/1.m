twigs=double(imread('notch1.png'));
fft_twigs=zeros(size(twigs));
fft_twigs(:,:,1)=fftshift(fft2(twigs(:,:,1)));
filt=ones(size(twigs));

filt(28:100,135:137,:)=0;
filt(79:81,1:146,:)=0;

filt(79:81,164:320,:)=0;
filt(25:93,171:173,:)=0;

filt(169:231,185:187,:)=0;
filt(178:180,174:320,:)=0;

filt(178:180,1:169,:)=0;
filt(160:231,149:151,:)=0;

filt(160:256,160:162,:)=0;
filt(1:98,160:162,:)=0;



fft_twigs=fft_twigs.*filt;
figure;
img2=zeros(size(twigs));
img2(:,:,1)=ifft2(ifftshift(fft_twigs(:,:,1)));
subplot(1,3,1);
imshow(uint8(twigs));title('Given Image')
subplot(1,3,2);
imshow(filt);title('filter');
subplot(1,3,3);
imshow(uint8(real(img2)));title('Denoised Image');