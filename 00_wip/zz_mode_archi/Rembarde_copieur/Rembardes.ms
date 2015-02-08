macroScript Rembardes
	category:"mode_archi"
	toolTip:""
(
	s = $


	ref_s = reference s
	select ref_s
	modPanel.addModToSelection (sweep ()) ui:on
	$.modifiers[#Sweep][#Cylinder_Section].radius = 1.5
	$.modifiers[#Sweep].yOffset = 75
	$.material = meditMaterials[14]

	ref_s2 = reference s
	select ref_s2
	modPanel.addModToSelection (sweep ()) ui:on
	$.modifiers[#Sweep][#Cylinder_Section].radius = 1.5
	$.modifiers[#Sweep].yOffset = 55
	$.material = meditMaterials[14]
)
