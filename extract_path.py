import sys

if __name__ == "__main__":
    if len(sys.argv) > 1:
        # The first argument is at index 1
        parameter = sys.argv[1]
        #print(f"The parameter passed is: {parameter}")
    else:
        1==1#print("No parameter passed.")

from PIL import Image

NAME = "path"
IMAGE = parameter
img = Image.open(IMAGE)
pixels = img.load()


# map colors to node indices
color_map = {
    (255,0,0):1,     
    (255,10,0):2,    
    (255,20,0):3,    
    (255,30,0):4,    
    (255,40,0):5,    
    (255,50,0):6,    
    (255,60,0):7,    
    (255,70,0):8,    
    (255,80,0):9,    
    (255,90,0):10,   
    (255,100,0):11,  
    (255,110,0):12,
    (255,120,0):13,
    (255,130,0):14
}

nodes = {}
path_string = ""

for y in range(img.height):
    for x in range(img.width):
        color = pixels[x,y][:3]
        if color in color_map:
            nodes[color_map[color]] = (x,y)

path_string = "{"
list_length = len(nodes)
for i in sorted(nodes):
    x,y = nodes[i]
    if i == list_length:
        path_string += f"{{x={x},y={y}}}"
    else:
        path_string += f"{{x={x},y={y}}},"
path_string += "}"
print(path_string)