from PIL import Image
import numpy as np
import matplotlib.pyplot as pt
import sys

#out_img_name = "../data/" + sys.argv[1] + "_deskewed.png"
out_img_name = sys.argv[1].replace('.bmp','_deskewed.png')
width = int(sys.argv[2])
hight = width
img_len = width * hight


file_handle = open("out_image.dat", "r")
number = np.zeros([1, img_len])

myline = file_handle.readline()

myline_split = myline.split(' ')

#print(myline_split)
for i in range(img_len):
    #print(i)
    number[0, i] = float(myline_split[i])

number = np.reshape(number, (width, hight))
pt.imshow(number, cmap='Greys_r')
pt.savefig(out_img_name, dpi=100)
