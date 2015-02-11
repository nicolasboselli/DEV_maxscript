


fn extractFacesFN outVal shellVal objSel delFace=
(
	/*
	param: 
		float outval: outine value, 
		float shellval: shell value, 
		array objSel: object selected , 
	*/
	
	newName = uniqueName( objSel[1].name + "_part")
	-- detach faces
	polyop.detachFaces objSel[1] #selection delete: delFace asNode: true name: newName


	-- outline faces of new object
	newNode = getnodebyname newName
	select newNode

	polyop.setFaceSelection newNode #all
	newNode.outlineAmount = outVal
	newNode.EditablePoly.Outline ()

	-- add shell on object
	myShell = Shell innerAmount:shellVal outerAmount:shellVal
	addmodifier newNode myShell	

	local appuiMat
	-- material
	if sceneMaterials["appui"] == undefined then
	(
		appuiMat = Standard name: "appui"
	)
	else
	(
		appuiMat = sceneMaterials["appui"]
	)
	newNode.material = appuiMat
)




rollout extractFacesRLT "extract faces"
(
	local modeScriptFolder = getFilenamePath  (getThisScriptFilename() )
	
	group "copy options:"
	(
		checkbox delOriCB "delete original face"
		checkbox copyUvCB "copy UVWMap"
	)
	
	
	group "on extraction:"
	(
		spinner outSp "outline size" range: [-1000, 1000, 0]
		spinner shellSp "shell size"  range: [-1000, 1000, 0]
	)
	
	button extractBT "extract"
	
	on extractBT pressed do
	(
		sel = $selection as array
		if sel.count == 1 do
		(
			extractFacesFN outSp.value shellSp.value sel delOriCB.state
		)
	)
	
	on extractFacesRLT open do
	(
		try 
		(
		outSp.value = 	(getINISetting (modeScriptFolder + "scriptMode.ini") "extractFace" "outSp") as float
		shellSp.value = 	(getINISetting (modeScriptFolder + "scriptMode.ini") "extractFace" "shellSp" ) as float
		)
		catch
		(
			format "*** % ***\n" (getCurrentException())
		)
	)
	
	on extractFacesRLT close do
	(
		-- maj ini file
		setINISetting (modeScriptFolder + "scriptMode.ini") "extractFace" "outSp" (outSp.value as string)
		setINISetting (modeScriptFolder + "scriptMode.ini") "extractFace" "shellSp" (shellSp.value as string)
		print "maj ini done"
	)
)

createDialog extractFacesRLT

