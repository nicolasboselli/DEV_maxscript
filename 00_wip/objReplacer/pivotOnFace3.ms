fn pivotOnFAce3  s normal: 1 flipNormal: true upnode: 3 flipUpnode: false = 
(
-- 	local copyS = copy s
	
	local theX, theY, theZ
	local invNormal, invUpnode
	local theOrder = #(0,0,0)
	
	local theRest = #{1,2,3} - #{normal, upnode}
	local theRestAr = theRest as array
	local Other = theRestAr[1]
	
	if flipNormal then invNormal = -1 else invNormal = 1
	if flipUpnode then invUpnode = -1 else invUpnode = 1
	
	posCenter = s.center
	bakTM = s.transform
	
	theNormal = normalize ( ( polyop.getFaceNormal s 1) * invNormal )
	theOther = normalize ( cross   ( [0,0,1] * invUpnode ) theNormal)
	theUpnode= normalize ( cross theNormal theOther )
	
	theOrder[normal] = theNormal
	theOrder[Other] = theOther
	theOrder[upnode] = theUpnode
	
	localTM = matrix3   theOrder[1] theOrder[2] theOrder[3] posCenter
	
	pt = point transform: localTM size: 90 wirecolor: green
	s.transform = localTM
-- 	copyS.transform = localTM
	
	addmodifier s (xform ())
	format "bakTM:%\n" bakTM
	format "localTM:%\n" localTM
	format "decay:%\n" (localTM.rotationpart - bakTM.rotationpart)
	
	format "s.transform:%\n"  s.transform
	format "pt.transform:%\n" pt.transform
	format "decay2: %\n" (pt.transform.rotationpart -  s.transform.rotationpart)
	format "decay2.5: %\n" (pt.transform.rotation -  s.transform.rotation)
	format "decay3: %\n" (pt.rotation -  s.rotation)
	
-- 	s.modifiers[#xform].gizmo.rotation = in coordsys local localTM.rotation
-- 	s.modifiers[#xform].gizmo.rotation = localTM.rotationpart - bakTM.rotationpart
	s.modifiers[#xform].gizmo.rotation = localTM.rotation - bakTM.rotation
	s.modifiers[#xform].gizmo.position = (in coordsys local s.center)* - 1
)
pivotOnFAce3  $ normal: 1 flipNormal: true upnode: 3 flipUpnode: false 

-- $.scale = [1,1,1]





-- sel[1].rotation - sel[2].rotation 

-- $.objectoffsetrot

