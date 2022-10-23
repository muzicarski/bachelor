from PIL import Image
import numpy as np
import matplotlib.pyplot as pt
import sys

################################
#     Initialize variables     #
################################

#img_name = "../data/" +sys.argv[1]+'.bmp'
img_name = sys.argv[1]
#parsed_input_file_name = sys.argv[1]+'_in'
parsed_input_file_name = img_name.replace('.bmp','_in')
input_image_size_file_name = img_name.replace('.bmp','_size')
#input_image_size_file_name = sys.argv[1]+'_size'

#Open output files
img_dim = open(input_image_size_file_name,"w")
parsed_input_file = open(parsed_input_file_name, 'w')

################################
#    Parse img and get size    #
################################

#Get pixel values
im = Image.open(img_name, 'r')
pix_val = list(im.getdata())
img_string = str(pix_val)
img_string = img_string.replace(',', '')

#Get image size
width, hight = im.size


#Print pixel array to file
parsed_input_file.write(img_string[1:-1])

#Print image size to file
img_dim.write(str(width))

parsed_input_file.close()
img_dim.close()



