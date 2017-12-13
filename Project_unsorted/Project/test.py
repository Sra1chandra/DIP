import cv2
import numpy as np
import sys
from matplotlib import pyplot as plt

filename = "./samples/image1.jpg"
image = cv2.imread(filename)
image_hsv = cv2.cvtColor(image,cv2.COLOR_BGR2LUV)

cv2.imshow('img',image);
dst = image;
    #decl (input,sp,sr,out,max_level)s
    #sp - spatial window radius , sr = color window radius
cv2.pyrMeanShiftFiltering(image,30,20,dst,3)
cv2.imshow('img2',dst);
cv2.imwrite('im1.jpg',dst);

med = cv2.medianBlur(dst,5);
img_hsv = cv2.cvtColor(dst,cv2.COLOR_BGR2HSV)
cv2.imshow('img3',img_hsv)
cv2.imwrite('im2.jpg',img_hsv);

k = cv2.waitKey(0);
if(k==27):
    cv2.destroyAllWindows()

color = ('b','g','r')
for i,col in enumerate(color):
    histr = cv2.calcHist([img_hsv],[i],None,[256],[0,256])
    plt.plot(histr,color = col)
    plt.xlim([0,256])
plt.show()

# identify regions
# b = int(med[:][:][0]);
# g = int(med[:][:][1]);
# r = int(med[:][:][2])
#
# h = int(img_hsv[:][:][0])
# s = int(img_hsv[:][:][1])
# v = int(img_hsv[:][:][2])

height,width,channel = dst.shape;
temp = [['a' for x in range(width)] for y in range(height)]
count = 0;
for i in range(0,height):
    for j in range(0,width):
        # if(img_hsv[i][j][2]>150 and (abs(int(med[i][j][0])-int(med[i][j][1]))<=30) and (abs(int(med[i][j][1])-int(med[i][j][2]))<=30)):
        #     temp[i][j]='s';
        if(img_hsv[i][j][2]>160 and (med[i][j][0]>=160 and med[i][j][0]<=255) and (med[i][j][1]>=70 and med[i][j][1]<=255) and (med[i][j][2]>=0) and(med[i][j][0]+15>=med[i][j][1] and med[i][j][0]+15>=med[i][j][2])):
            temp[i][j] = 's'
        elif(img_hsv[i][j][2]>110 and ( med[i][j][0]<=100) and ( med[i][j][1]<=255) and (med[i][j][2]>=100) and(med[i][j][2]>=med[i][j][0] and med[i][j][2]>=med[i][j][1])):
            temp[i][j]='m'
        elif(img_hsv[i][j][2]>30 and img_hsv[i][j][2]<170 and ( med[i][j][0]<=120) and ( med[i][j][1]<=120) and (med[i][j][2]<=120) and(med[i][j][1]>=med[i][j][0] and med[i][j][1]>=med[i][j][2])):
            temp[i][j]='m'
        elif(img_hsv[i][j][2]>100 and ( med[i][j][0]<=100) and ( med[i][j][1]<=255) and (med[i][j][2]<=200) and(med[i][j][1]>=med[i][j][0] and med[i][j][1]>=med[i][j][2])):
            temp[i][j]='l'
        else:
            temp[i][j] = 'o'



        # if((int(med[i][j][0])>int(med[i][j][2])) and (int(med[i][j][0])>int(med[i][j][1]))):
        #     temp[i][j]='s';
        # elif(() and ()):
        #     temp[i][j]='m';

temp2 = med;
for i in range(0,height):
    for j in range(0,width):
        flag = int(med[i][j][0])>int(med[i][j][1])
        #print(temp[i][j],temp2[i][j][0],temp2[i][j][1],temp2[i][j][2],flag);
        if(temp[i][j]=='s' and channel ==3):
            temp2[i][j][0]=0;
            temp2[i][j][1]=0;
            temp2[i][j][2]=0;
        elif(temp[i][j]=='m' and channel == 3):
            temp2[i][j][0]=80
            temp2[i][j][1]=80
            temp2[i][j][2]=80
        elif(temp[i][j]=='l' and channel == 3):
            temp2[i][j][0]=200
            temp2[i][j][1]=200
            temp2[i][j][2]=200
        else:
            temp2[i][j][0]=255
            temp2[i][j][1]=255
            temp2[i][j][2]=255


cv2.imshow('img4',temp2);
cv2.imwrite('im3.jpg',temp2);
k = cv2.waitKey(0);
if(k==27):
    cv2.destroyAllWindows();
