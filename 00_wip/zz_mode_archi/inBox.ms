-- $.min
-- nodeLocalBoundingBox $

bb = nodeGetBoundingBox $ $.transform

xtmp= distance [bb[1].x,0,0] [bb[2].x,0,0]
ytmp= distance [bb[1].y,0,0] [bb[2].y,0,0]
ztmp= distance [bb[1].z,0,0] [bb[2].z,0,0]
	
s = box length: ytmp width: xtmp height: ztmp
-- polyop.moveVert $ #all [10,10,10]

s.rotation = $.rotation
s.position = $.center