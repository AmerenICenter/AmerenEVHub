import json, sys
from PIL import Image, ImageDraw

light_gray = 200
dark_gray = 85

spot_width = 40
spot_height = 100
inter_spot_space = 40
margin = 40
line_weight = 2

spots = json.open(sys.argv[1])
w, h
map = Image.new("RGB", (margin * 2 
