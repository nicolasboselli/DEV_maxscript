

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


try(destroydialog xformRLT)catch()

rollout xformRLT "xform in place V2"
(
-- 	vars
	local ref
	
-- 	UI
	button addRefBT "add>>"
	edittext refET "ref:" readonly: true
	button resetRefBT "Clear ref"
	button xformBT "reset xform"
	
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
	
)

createdialog xformRLT
