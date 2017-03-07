fn resetInPlaceFN sel=
(
	bakPos = sel.position
	bakRot = sel.rotation
	
	sel.rotation = eulerangles 0 0 0
	sel.position = [0,0,0]
	
	resetxform sel 
	ConvertTo sel Editable_Poly
	
	sel.rotation = bakRot
	sel.position = bakPos
)

fn resetInPlaceAuto s =
(
	bakparent = s.parent
	tmpParent = point rotation: s.rotation
	s.parent = tmpParent	
	
	resetxform s
	s.parent = bakparent	
	delete tmpParent
)


fn resetInPlace2 s tmpParent =
(
	bakparent = s.parent
	
-- 	tmpParent = point transform: s.transform

	tmpParent.scale = [1,1,1]

	s.parent = tmpParent

	resetxform s
	
	s.parent = bakparent
	
-- 	delete tmpParent
)

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



try(destroydialog xformRLT)catch()

rollout xformRLT "xform in place V2"
(
-- 	vars
	local ref
	
-- 	UI
	group "auto xform: "
	(
		button autoBT "auto xform"
	)
	
	group "xform on parent:"
	(
		button addRefBT "add>>"
		edittext refET "ref:" readonly: true
		button resetRefBT "Clear ref"
		button xformBT "reset xform"
	)
	group "clear offset pivot:"
	(
		button clearOffsetBT "clear"
	)
	
-- 	function
	fn refreshUI =
	(
		if ref == undefined then refET.text = "[NONE]"
		else refET.text = ref.name
	)
	
-- 	Actions
	on xformRLT open do
	(
		refreshUI()
	)
	
	on autoBT pressed do
	(
		sel = selection as array
		for s in sel do resetInPlaceAuto s
	)
	
	on addRefBT pressed do
	(
		sel = selection as array
		if sel.count == 1 then
		(
			ref = sel[1]
			refreshUI()
		)
	)
	
	on resetRefBT pressed do
	(
		ref = undefined
		refreshUI()
	)
	
	
	
	on xformBT pressed do
	(
		sel = selection as array
		for s in sel do
		(
			if ref == undefined then
			(
				tmpParent = point transform: s.transform
				resetInPlace2 s tmpParent
				delete tmpParent
			)
			else
			(
-- 				tmpParent = point transform: s.transform
				resetInPlace2 s ref
			)
		)
	)
	
	on clearOffsetBT pressed do
	(
		for s in selection do resetXformInPlace3 s
	)
	
)

createdialog xformRLT
