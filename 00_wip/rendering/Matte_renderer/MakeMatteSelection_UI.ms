rollout MakeSelectionMatte "make selection matte"
(
	-- UI
	checkbutton MatteToggleCB "Make Matte"

	-- actions
	on MatteToggleCB changed state do

	if state == on then
	(	
		for o in $selection do
		(
			setUserProp o "VRay_Matte_Enable" true
			setUserProp o "VRay_Matte_Shadows" true
			setUserProp o "VRay_Matte_ShadowAlpha" true
			setUserProp o "VRay_Matte_Alpha" -1
		)
	)

	else 
	(
		for o in $selection do
		(
			setUserProp o "VRay_Matte_Enable" false
			setUserProp o "VRay_Matte_Shadows" false
			setUserProp o "VRay_Matte_ShadowAlpha" false
			setUserProp o "VRay_Matte_Alpha" 1
		)
	)
)

createdialog MakeSelectionMatte




