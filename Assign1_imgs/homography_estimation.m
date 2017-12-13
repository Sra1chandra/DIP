function [tform] =homography_estimation(image1)
img=rgb2gray(imread(image1));
[~,Y,~]=size(img);
img1=img(:,1:Y/2,:);
img2=img(:,Y/2+1:Y,:);
% figure;
% subplot(1,2,1);
% imshow(img1);
% subplot(1,2,2);
% imshow(img2);
img1Points = detectSURFFeatures(img1);
img2Points = detectSURFFeatures(img2);
[img1Features, img1Points] = extractFeatures(img1, img1Points);
[img2Features, img2Points] = extractFeatures(img2, img2Points);
Pairs = matchFeatures(img1Features, img2Features);
matchedimg1Points = img1Points(Pairs(:, 1), :);
matchedimg2Points = img2Points(Pairs(:, 2), :);
[tform, ~, ~] = estimateGeometricTransform(matchedimg1Points, matchedimg2Points, 'projective');

end