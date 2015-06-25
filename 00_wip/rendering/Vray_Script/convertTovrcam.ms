selList = selection as array

for c in selList do
(
	if superclassof c == camera do
	(
		transSel = c.transform.controller.value
		VRayPhysicalCamera  transform: transSel
	)
)

for i = 1 to scenematerials.count do
(
	meditmaterials[i] = scenematerials[i]
)
