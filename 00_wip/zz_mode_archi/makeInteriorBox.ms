-- polyop.moveVert $ #all [10,10,10]

maxVert = polyop.getNumVerts $
-- collect info vertex

globalMoving = #()
-- for each vertex
for i = 1 to maxVert do
(
	-- get face by vertex
	facBitAr = polyop.getFacesUsingVert $ #{i}	
	facAr = facBitAr as array
	
	moving = #()
	
	for f in facAr do
	(
		-- get normals
		normal = polyop.getFaceNormal  $ f
		print classof normal.x
-- 		print normal
-- 		oneDir = (normal*5)
		append moving (normal*5.0)
-- 		polyop.moveVert $ #{i} (normal*25)
	)
	format "%\n" moving
	cleanMoving = makeuniqueArray moving
	format "%\n" cleanMoving
	format "%" "-----------------------------\n"
-- 	print #(cleanMoving)
-- 	append globalMoving cleanMoving
)
-- globalMoving
-- move vertex

-- for i = 1 to globalMoving.count do
-- (
-- 	for mov in globalMoving[i] do polyop.moveVert $ #{i} mov

-- )
-- makeuniquearray #([0,0,-5], [-5,0,0], [0,0,-5], [-5,0,0])

