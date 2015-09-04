

fn resetInPlace2 s =
(
	bakparent = s.parent
	
	tmpParent = point transform: s.transform
-- 	format "point scale: %\n" tmpParent.scale
	tmpParent.scale = [1,1,1]
-- 	format "point scale: %\n" tmpParent.scale
	s.parent = tmpParent

	resetxform s
	
	s.parent = bakparent
	delete tmpParent
)

sel = selection as array
for s in sel do resetInPlace2 s