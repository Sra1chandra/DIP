twigs=double(imread('notch2.jpg'));
fft_twigs=zeros(size(twigs));
fft_twigs(:,:,1)=fftshift(fft2(twigs(:,:,1)));
filt=ones(size(twigs));

filt(49:56,43:45,:)=0;
filt(52:54,39:50,:)=0;

filt(31:51,107:108,:)=0;
filt(40:41,100:116,:)=0;
filt(80:100,22:23,:)=0;
filt(89:90,17:29,:)=0;


filt(73:81,85:87,:)=0;
filt(76:78,79:92,:)=0;

filt(7:12,20:25,:)=0;
filt(119:123,20:25,:)=0;
filt(6:10,106:110,:)=0;
filt(118:122,105:109,:)=0;




filt(63,1:38,:)=0;
filt(67,1:38,:)=0;

filt(63,90:128,:)=0;
filt(67,90:128,:)=0;


filt(1:40,64:66,:)=0;
filt(91:128,64:66,:)=0;

fft_twigs=fft_twigs.*filt;
figure;
img2=zeros(size(twigs));
img2(:,:,1)=ifft2(ifftshift(fft_twigs(:,:,1)));
subplot(1,3,1);
imshow(uint8(twigs));title('Given Image');
subplot(1,3,2);
imshow(filt);title('filter');
subplot(1,3,3);
imshow(uint8(real(img2)));title('Denoised image');