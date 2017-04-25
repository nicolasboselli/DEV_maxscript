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
	delete s
	detached
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

fn boxerize2 selAr amount: 28 =
(
	wireAr = #(green, red, blue, orange, yellow, brown)
	undo on 
	(
		for s in selAr do
		(
			-- reset x form on selection!!!!!!!!!!!!!!!!!!!!!!!!!!!!
			resetxform s
			converttopoly s
			
			select s
			$.outlineAmount = 2
			$.EditablePoly.Outline ()
			
			-- detacher chaque element
-- 			polyop.setFaceSelection  s #all
			selArr = explodeObject s

			for o in selArr do
			(
				if (polyop.getNumFaces o)>0 do
				(
					-- reset in place
					pivotOnFAce o
-- 					converttopoly o
					
					-- add shell on object
					myShell = Shell innerAmount:0 outerAmount:amount
					addmodifier o myShell
					o.pivot = o.center
					
					converttopoly o
				
					o.material = undefined	
					
					id = random 1 wireAr.count
					o.wirecolor = wireAr[id]
				)
			)
		)
	)
)

-- myShell = undefined


try(destroydialog boxerizeRLT)catch()
rollout boxerizeRLT "Boxerize"
(
	spinner boxSizeSP "Size:" type: #worldunits range:[0,1000,25]
	button boxBT "Boxerize"
	
	on boxBT pressed do
	(
		sel = selection as array
		if sel.count == 1 do boxerize2 sel amount: boxSizeSP.value
	)
)
createdialog boxerizeRLT
