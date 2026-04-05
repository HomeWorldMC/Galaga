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
    (255,5,0):2,
    (255,10,0):3,
    (255,15,0):4,
    (255,20,0):5,
    (255,25,0):6,
    (255,30,0):7,
    (255,35,0):8,
    (255,40,0):9,
    (255,45,0):10,
    (255,50,0):11,
    (255,55,0):12,
    (255,60,0):13,
    (255,65,0):14,
    (255,70,0):15,
    (255,75,0):16,
    (255,80,0):17,
    (255,85,0):18,
    (255,90,0):19,
    (255,95,0):20,
    (255,100,0):21,
    (255,105,0):22,
    (255,110,0):23,
    (255,115,0):24,
    (255,120,0):25,
    (255,125,0):26,
    (255,130,0):27,
    (255,135,0):28,
    (255,140,0):29,
    (255,145,0):30,
    (255,150,0):31,
    (255,155,0):32,
    (255,160,0):33,
    (255,165,0):34,
    (255,170,0):35,
    (255,175,0):36,
    (255,180,0):37,
    (255,185,0):38,
    (255,190,0):39,
    (255,195,0):40,
    (255,200,0):41,
    (255,205,0):42,
    (255,210,0):43,
    (255,215,0):44,
    (255,220,0):45,
    (255,225,0):46
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
        path_string += f"{x},{y},"
    else:
        path_string += f"{x},{y},"
path_string += "}"
print(path_string)
