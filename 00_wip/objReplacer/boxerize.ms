-- filein (modeArchiScriptRoot + "bardageCreator\zinc_creator_bounding_box_fn.ms")

-- fn returnScriptRoot =
-- (
-- 	local maxIni = getMAXIniFile()
-- 	local armadasScriptsIni = (getFilenamePath maxIni) + "armadasScriptsIni.ini"
-- 	local root = getINISetting armadasScriptsIni "armadasScripts" "armadasScriptsRoot"
-- 	root
-- )

-- returnScriptRoot()

-- filein "J:\GitHub_repo\DEV_maxscript\00_wip\GF\FN_gestion_fenetres.ms"
-- filein "J:\github\DEV_maxscript\00_wip\GF\FN_gestion_fenetres.ms"
-- filein (returnScriptRoot() + "GF/FN_gestion_fenetres.ms")
-- filein (returnScriptRoot() + "zz_mode_archi/XformInPlace.ms")
-- filein (returnScriptRoot() + "GF/explodeObject.ms")


fn explodeObject s =
(
	num = polyop.getNumFaces s
	numToDetach = #(num)
	detached = #()

	for n in numToDetach do
	(
		facesToDetach = polyop.getElementsUsingFace s #{num}
		fenetre_detach_name = uniquename "fenetre_detach_"
		polyop.detachFaces s facesToDetach delete:true asNode:true name:fenetre_detach_name
		append detached (getnodebyname fenetre_detach_name)
		
		num = polyop.getNumFaces s
		if num > 0 then append numToDetach num
	)

	detached
)


-- filein "J:/GitHub_repo/DEV_maxscript/00_wip/zz_mode_archi/XformInPlace.ms"
/*##############################cubizator ########################"*/

fn resetXformInPlace3 s =
(
	addmodifier s (xform ())
		
	s.modifiers[#xform].gizmo.rotation = inverse s.objectoffsetrot
	s.objectoffsetrot = (quat 0 0 0 1)

	s.modifiers[#xform].gizmo.position = s.objectoffsetpos
	s.objectoffsetpos = [0,0,0]

	resetscale s
	s.modifiers[#xform].gizmo.scale = s.objectoffsetscale
	s.objectoffsetscale = [1,1,1]
)

fn pivotOnFAce s = 
(

	posCenter = s.center

	theX = normalize ((polyop.getFaceNormal s 1)*-1)
	theY = normalize (cross [0,0,1] theX )
	theZ= normalize (cross theX theY)
	localTM = matrix3   theX theY theZ posCenter

	s.transform = localTM
	
	addmodifier s (xform ())

	s.modifiers[#xform].gizmo.rotation = in coordsys local localTM.rotation
	s.modifiers[#xform].gizmo.position = (in coordsys local s.center)* -1
)
-- pivotOnFAce $



fn boxerize2 selAr =
(
	undo on 
	(
		for s in selAr do
		(
		-- reset x form on selection!!!!!!!!!!!!!!!!!!!!!!!!!!!!
		resetxform s
		ConvertTo s Editable_Poly

		-- detacher chaque element
		polyop.setFaceSelection  s #all
		selArr = explodeObject s

		-- ## reorient each element

			for o in selArr do
			(
				if (polyop.getNumFaces o)>0 do
				(
					
					pivotOnFAce o
					
					-- config outline
					select o
-- 					format "o name: %\n" o.name
					$.outlineAmount = 2
-- 					format "$ name: %\n" o.name
					$.EditablePoly.Outline ()
					
					-- add shell on object
					myShell = Shell innerAmount:0 outerAmount:28
					addmodifier o myShell
					o.pivot = o.center
					
-- 					resetInPlaceFN o
					resetXformInPlace3 o
					converttopoly o
					
					o.material = undefined
-- 					
				)
			)
		)
	)
)



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
-- 		print theTM
		theTM.rotationpart as eulerangles --return its Euler rotation 
	)
)


fn boxerize selAr =
(
	undo on 
	(
		for s in selAr do
		(
		-- reset x form on selection!!!!!!!!!!!!!!!!!!!!!!!!!!!!
		resetxform s
		ConvertTo s Editable_Poly

		-- detacher chaque element
		polyop.setFaceSelection  s #all
		selArr = explodeObject s

		-- ## reorient each element

			for o in selArr do
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
					
-- 					print "check1"
					-- apply new orientation
					in coordsys local o.rotation =newAngle
					o.objectoffsetrot =newAngle
					o.pivot = o.center
					
					-- select o
					polyop.setfaceselection o #all
					
					-- config outline
					select o
-- 					format "o name: %\n" o.name
					$.outlineAmount = 2
-- 					format "$ name: %\n" o.name
					$.EditablePoly.Outline ()
					
					-- add shell on object
					myShell = Shell innerAmount:0 outerAmount:28
					addmodifier o myShell
					o.pivot = o.center
					
-- 					resetInPlaceFN o
					resetXformInPlace3 o
					converttopoly o
					
					o.material = undefined
-- 					
				)
			)
		)
	)
)



-- myShell = undefined
sel = selection as array
if sel.count == 1 do boxerize2 sel
	

