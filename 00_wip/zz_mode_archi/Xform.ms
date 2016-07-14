
$.objectoffsetrot 
$.objectoffsetpos 
$.objectoffsetscale 

addmodifier $ (xform ())
	
$.modifiers[#xform].gizmo.rotation = inverse $.objectoffsetrot
$.objectoffsetrot = (quat 0 0 0 1)

$.modifiers[#xform].gizmo.position = $.objectoffsetpos
$.objectoffsetpos = [0,0,0]

resetscale $
$.modifiers[#xform].gizmo.scale = $.objectoffsetscale
$.objectoffsetscale = [1,1,1]

$.objectoffsetrot 
$.objectoffsetpos 
$.objectoffsetscale 

-- $.scale
-- $.rotation