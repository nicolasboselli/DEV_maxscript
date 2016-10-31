s = $
spCount = numSplines   s

-- getKnotPoint  $ 1 1

for sp = 1 to spCount do
(
	knCount =numknots s sp
	for i  = (knCount - 1 ) to 2 by -1 do
	(	
		pt1 = getKnotPoint  s sp (i - 1)
		pt2 = getKnotPoint  s sp i
		pt3 = getKnotPoint s sp (i + 1)
	-- 	format "pt1:%, pt2:%, pt3:%\n" pt1 pt2 pt3
		
		vec1 = normalize( pt2 - pt1 )
		vec2 = normalize (pt3 - pt1)
	-- 	format "vec1: %, vec2: % \n" vec1 vec2
		
		ang = acos (dot vec1 vec2)
		format "i: %, ang: % \n" i ang
		
		if ang< 0.02 then deleteKnot s sp i
	)
)
updateShape  s

