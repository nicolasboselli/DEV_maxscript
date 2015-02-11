rollout mxsLaunchRLT "maxscript launcher"
(
	local root = getFilenamePath  (getThisScriptFilename() )
-- 	local scriptArray = #()
	local scriptArray = #( "planificator\create_Plane_UI.ms", \
		"extractFaces2.ms", \
		"extractFaces.ms", \
		"plan_opacity.ms", \
		"rotater.ms", \
		"Plan_resizer.ms")

	listbox scriptArrayLB "scripts list:" items: scriptArray
	
	button launchBT "launch" across: 2
	button editBT "edit"
	
	on launchBT pressed do filein (root + scriptArrayLB.selected)
	on editBT pressed do edit (root + scriptArrayLB.selected)

)
createdialog mxsLaunchRLT width:300 style: #(#style_resizing,#style_titlebar, #style_border, #style_sysmenu,#style_minimizebox, #style_maximizebox )

