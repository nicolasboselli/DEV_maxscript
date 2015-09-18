-- polyop.moveVert $ #all [10,10,10]

fn roundNumber num =
(
	local roundNumStr
	num = num as float
	
	wholeNumberString = num as string
	
	wholenumbers = filterstring wholeNumberString "e"
	if wholenumbers.count ==2 then
	(
		wholeNumberString = "0.0"
-- 		roundNumStr = "0.0"
	)
	
	wholenumbers = filterstring wholeNumberString "."
	if wholenumbers.count ==2 then 
	(
		unit = wholenumbers[1]
		numberstring = wholenumbers[2]
		decimal = substring numberstring  1 3
		roundNumStr = unit + "." + decimal
	)
	
	execute roundNumStr
)


-- test = -1.21095e-007
-- test = 5.35465
-- test = 5
-- str = test as  string
-- roundNumber test




interior = copy $
-- interior = $

-- interior.material = undefined
maxVert = polyop.getNumVerts interior

-- collect info vertex
globalMoving = #()

-- for each vertex
for i = 1 to maxVert do
(
	deco = "##############"
	format "\n% vertex: % %\n" deco i deco
	
	-- get face by vertex
	facBitAr = polyop.getFacesUsingVert interior #{i}	
	facAr = facBitAr as array
	
	moving = #()
	
	-- collect normal
	for f in facAr do
	(
		-- get normals
		tmp = polyop.getFaceNormal  interior f
		
		
		-- clean movement value
		xVal = roundNumber tmp.x 
		yVal = roundNumber tmp.y 
		zVal = roundNumber tmp.z 
		normalRound = [xVal, yVal, zVal]
		
		normal = normalize normalRound
		
		appendifunique moving normal
		
-- 		format "normal: % , rounded: %, normalize: %\n" tmp  normalRound normal
		
		/*
-- 		print normal.x
		normalMod = normal*-25
		
	-- clean movement value
		xVal = roundNumber normalMod.x 
		yVal = roundNumber normalMod.y 
		zVal = roundNumber normalMod.z 
		
		appendifunique moving [xVal, yVal, zVal]
		*/
		
	)
	
	
	-- compare angles
	val = -10
	angMax = 30 -- replace by angle collection with tresohld
	
	angAr = #()
	endMoving = #(moving[1]*val)
	
	for k = 1 to moving.count do
	(
		for j = 1 to moving.count do
		(
			if j > k then
			(
-- 				print "youpi"
				ang = acos (dot moving[k]  moving[j]) 
-- 				format "n%:%, n%:%, angle:%\n" k  moving[k] j moving[j] ang
				if ang> angMax then
				(
					ang = acos (dot moving[1]  moving[j]) 
					if ang> angMax then appendifunique endMoving (moving[j]*val)
				)
-- 				if ang < 15.0 then append angAr ang 
			)
		)
	)
	
	-- collect first
	-- if in follower angle > 15 then test with first
		-- collect angle
		-- if angle > 15  and different from collected angle treshold collect folower 
	

-- 	format "vert: %, endMoving: %\n" i endMoving

	
	append globalMoving endMoving
)
-- globalMoving
-- globalMoving

-- move vertex

for i = 1 to globalMoving.count do
(
	for mov in globalMoving[i] do polyop.moveVert interior #{i} mov
)






