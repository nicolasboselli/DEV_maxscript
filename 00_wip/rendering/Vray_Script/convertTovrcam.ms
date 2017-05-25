selList = selection as array

for c in selList do
(
	if superclassof c == camera do
	(
		vrayCam = vrayCreateVRayPhysicalCamera ()
		vrayCam.f_number = 11
		vrayCam.whiteBalance_preset = 1
		vrayCam.whiteBalance = color 255 255 255
		vrayCam.shutter_speed = 250
		
		vrayCam.transform = c.transform.controller.value
-- 		VRayPhysicalCamera  transform: transSel
	)
)

-- vrayCam = vrayCreateVRayPhysicalCamera ()
-- vrayCam.transform = $.transform.controller.value



