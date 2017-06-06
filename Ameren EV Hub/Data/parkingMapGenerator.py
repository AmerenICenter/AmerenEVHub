import json, sys
from PIL import Image, ImageDraw

light_gray = (200,) * 3
dark_gray = (85,) * 3

spot_width = 50
spot_height = 80
inter_spot_space = 40
margin = 40
number_margin = 5
line_width = 2

f = open(sys.argv[1])
spots = json.load(f)
f.close()
spots = spots["spots"]
height = len(spots)
width = len(spots[0])
map_dimensions = (margin * 2 + (spot_width + line_width) * width + line_width, margin * 2 + height * spot_height + (height - 1) // 2 * inter_spot_space + (height + 1) // 2 * line_width)
map = Image.new("RGB", map_dimensions, color=light_gray)
map_draw = ImageDraw.Draw(map)

map_y = margin
for spot_y in range(height):
	map_x = margin
	even = spot_y % 2 == 0
	for spot_x in range(width):
		spots[spot_y][spot_x]["centerX"] = map_x + line_width + (spot_width // 2)
		spots[spot_y][spot_x]["centerY"] = map_y + (spot_height // 2)
		map_draw.rectangle([(map_x, map_y), (map_x + line_width, map_y + spot_height)], fill=dark_gray, outline=dark_gray)
		map_x += line_width + spot_width
		if spot_x == width - 1:
			map_draw.rectangle([(map_x, map_y), (map_x + line_width, map_y + spot_height)], fill=dark_gray, outline=dark_gray)
		text_size = map_draw.textsize(str(spots[spot_y][spot_x]["spotId"]))
		if even:
			map_draw.text((map_x - (spot_width // 2) - (text_size[0] // 2), map_y + number_margin), str(spots[spot_y][spot_x]["spotId"]), fill=dark_gray)
		else:
			map_draw.text((map_x - (spot_width // 2) - (text_size[0] // 2), map_y + spot_height - text_size[1] - number_margin), str(spots[spot_y][spot_x]["spotId"]), fill=dark_gray)
	map_y += spot_height
	if even:
		map_draw.rectangle([(margin, map_y), (map_dimensions[0] - margin, map_y + line_width)], fill=dark_gray, outline=dark_gray)
		map_y += line_width
	else:
		map_y += inter_spot_space

del map_draw

outf = sys.argv[1][:-5] + ".png"
map.save(outf, "PNG")

spots_dict = {}
spots_dict["spots"] = spots
spots_dict["width"] = width
spots_dict["height"] = height
outjson = open(sys.argv[1], "w")
json.dump(spots_dict, outjson)
outjson.close()
