selList = selection as array

for c in selList do
(
	if superclassof c == camera do
	(
		transSel = c.transform.controller.value
		VRayPhysicalCamera  transform: transSel
	)
)

