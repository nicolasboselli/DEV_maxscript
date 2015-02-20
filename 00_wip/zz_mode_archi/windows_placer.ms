-- filein (modeArchiScriptRoot + "bardageCreator\zinc_creator_bounding_box_fn.ms")

filein "J:\GitHub_repo\DEV_maxscript\00_wip\GF\FN_gestion_fenetres.ms"

/*
-- selectionner chaque element
polyop.setFaceSelection  $ #all
$.getselection #face

test = detach_elements_selected $

print test



-- find orientation
-- ($.rotation as quaternion).axis = faceAxis
-- ($.rotation as angleAxis).axis = faceAxis
-- $.rotation = (angleAxis 10 faceAxis)
test = $.rotation as eulerangles
$.rotation = test

fn GetAngleFromNormal theNormal =
(
	local theX = normalize theNormal --this is the original vector
	if (dot theX [0,0,1]) > 0.99999 then --if the vector is nearly parallel to Z, assume 0
		eulerangles 0 0 0
	else
	(
		local theY = normalize (cross [0,0,1] theX ) --this is the Y axis orthogonal to the Normal and Up
		local theZ = normalize (cross theY theX) --this is the X orthogonal to Normal and Y
		local theTM = matrix3   theX theY theZ [0,0,0] --this is the matrix3 describing the orientation of the Normal
		print theTM
		theTM.rotationpart as quat --return its Euler rotation 
	)
)


ref = $Box077
target = $Box078

sel = polyop.getFaceSelection ref
sel = sel as array
theNormal = polyop.getFaceNormal ref sel[1]


newAngle = GetAngleFromNormal theNormal
newAngle.z = newAngle.z*-1
target.rotation = newAngle
target.position = [0,0,0]

--> (eulerAngles 0 45 0)

-- oriente le pivot en fonction de la bonne orientation


$.pivot

obj1 = $Box077
obj2 = $Box078

pivrot=obj1.rotation

in coordsys local obj2.rotation =pivrot

obj2.objectoffsetrot =pivrot

*/

-- $.pivot

fn GetAngleFromNormal theNormal =
(
	local theX = normalize theNormal --this is the original vector
	if (dot theX [0,0,1]) > 0.99999 then --if the vector is nearly parallel to Z, assume 0
		eulerangles 0 0 0
	else
	(
		local theY = normalize (cross [0,0,1] theX ) --this is the Y axis orthogonal to the Normal and Up
		local theZ = normalize (cross theY theX) --this is the X orthogonal to Normal and Y
		local theTM = matrix3   theX theY theZ [0,0,0] --this is the matrix3 describing the orientation of the Normal
		print theTM
		theTM.rotationpart as eulerangles --return its Euler rotation 
	)
)

-- reset x form on selection!!!!!!!!!!!!!!!!!!!!!!!!!!!!

-- detacher chaque element
polyop.setFaceSelection  $ #all
$.getselection #face

sel = detach_elements_selected $

-- select test

-- sel = $selection as array

for o in sel do
(
	if (polyop.getNumFaces o)>0 do
	(
		-- set selection
		polyop.setfaceselection o 1
		
		-- get normal orientation
		sel = polyop.getFaceSelection o
		sel = sel as array
		theNormal = polyop.getFaceNormal o sel[1]
		
		newAngle = GetAngleFromNormal theNormal
		newAngle.z = newAngle.z*-1
		
		-- apply new orientation
		in coordsys local o.rotation =newAngle
		o.objectoffsetrot =newAngle
		o.pivot = o.center
	)
)

sel = $selection as array
for o in sel do
(
	if (polyop.getNumFaces o)>0 do
	(	
		polyop.setfaceselection o #all
		
		select o
		$.outlineAmount = 2
		$.EditablePoly.Outline ()
		
		-- add shell on object
		myShell = Shell innerAmount:0 outerAmount:28
		addmodifier o myShell	
	)
)


-- convert to poly
-- reset x form
-- collect x,y and z max
-- generate position for cage
-- position the cage


modFFD =  $.modifiers[#FFD_2x2x2]
animateVertex  modFFD #all
modFFD.Control_Point_1 = [10,0,0]