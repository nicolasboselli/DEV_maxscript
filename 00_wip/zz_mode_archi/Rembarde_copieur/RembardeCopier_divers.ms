CopyRembarde = $

addmodifier CopyRembarde (sweep ())

CopyRembarde.modifiers[#Sweep].CurrentBuiltInShape = 4
CopyRembarde.modifiers[#Sweep].PivotAlignment = 5
CopyRembarde.modifiers[#Sweep].yOffset = 50 + pas
CopyRembarde.modifiers[#Sweep].XOffset = -5
CopyRembarde.modifiers[#Sweep][#Cylinder_Section].radius = 3	

classof $ == shape 

converttosplineshape $

addmodifier $ (Edit_Spline ())
converttosplineshape $
updateshape $

convertto $ splineshape

s = $
showProperties s
	
showProperties 	$.modifiers[#sweep][#Cylinder_Section]
	$.modifiers[#sweep].CurrentBuiltInShape = 4
	

	$
	
	
	
	