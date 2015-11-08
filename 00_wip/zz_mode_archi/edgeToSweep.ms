/*
maj
add param:  center pivot,  add uvwmap, add mat, setup sweep, 
*/

fn removeEdgeAndVerticesFN sel =
(
	sel.EditablePoly.ConvertSelection #Edge #Vertex
	sel.EditablePoly.Remove selLevel: #Edge
		-- check vertex
	-- get vertex selection 
	local vertBitAr = sel.GetSelection #vertex
	local vertAr = vertBitAr as array
	-- for each vertex
		-- if vertex edge num <= 3 collect vertex
	local vertToDel = #()
	for id in vertAr do
	(
		num = sel.GetVertexEdgeCount  id
		if num <=2 then
		(
			append vertToDel id
		)
	)
	vertToDelBit = vertToDel as bitarray
	-- set vertex selection with good vertex
	sel.setSelection #vertex vertToDelBit
	sel.EditablePoly.Remove selLevel: #Vertex
)


try(destroyDialog edgeToShapeRLT)catch()

rollout edgeToShapeRLT "edge to shape"
(
-- 	vars
	local maxIni = getMAXIniFile()
	local armadasScriptsIni = (getFilenamePath maxIni) + "armadasScriptsIni.ini"
-- 	local root = getINISetting armadasScriptsIni "armadasScripts" "armadasScriptsRoot"
	
	local extSize  = 100
	
-- 	ui
	checkbox addSweepCB "add Sweep"
	group "Extrusion options:"
	(
		checkbox addExtrusionCB "add extrusion" 
		checkbox addMatCB "add grid base material" enabled: false
		spinner extSizeSP "extrusion size:" range: [0, 1000, extSize] type: #worldunits

	)
	checkbox removeEdgeCB "remove edge selection"
	group "reset x form optons:"
	(
		checkbox resetXformCB "reset x form"
		checkbox collapseXformCB "collapse x form"
	)
	
	checkbox keepSelCB "keep selection"
	button extractBT "extract"
	
	on extractBT pressed do
	(
		sel = selection as array
		
		undo on
		(
			for s in sel do
			(
				-- convert selection if necessary
				if subObjectLevel == 4 do s.ConvertSelectionToBorder #Face #Edge
				
				-- create shape
				newName = uniqueName (s.name + "_shape")
				s.createShape  newName  false s
				
				newShape = getnodebyname newName
				updateshape newShape
				
				-- option reset x form
				if resetXformCB.state == true do
				(
					resetxform newShape 
					if collapseXformCB.state == true do
					(
						converttosplineshape  newShape
						updateshape newShape
					)
				)
				
				-- option: remove edge
				if removeEdgeCB.state == True do removeEdgeAndVerticesFN s
				
				if addExtrusionCB.state == true do
				(
					myExtrusion = Extrude amount: extSize capStart: off capEnd: off
					addmodifier newShape myExtrusion
				)
				
				-- option: add sweep
				if addSweepCB.state == true do
				(
					
					mySweep = Sweep CurrentBuiltInShape: 2 PivotAlignment:8 SmoothPath: false
					mySmooth = Smooth name: "my_Smooth" autosmooth: on
					
					addmodifier newShape mySweep

					redrawViews()
					
					newSweep = getnodebyname newShape.name

					newSweep.modifiers[#Sweep][4].length = 20
					newSweep.modifiers[#Sweep][4].width = 20
				)
				
				-- option keep selection
				if keepSelCB.state == true then
				(
					select s
					modPanel.setCurrentObject s
					subobjectLevel = 2

				)
				else
				(
					subobjectLevel = 0		
					select newShape
				)
			)
		)
	)
	
	on addSweepCB changed theState do
	(
		addExtrusionCB.state = false
		addMatCB.enabled = false
		extSizeSP.enabled = false
	)
	
	on extSizeSP changed size do
	(
		extSize = size
	)
	
	on addExtrusionCB changed  theState do
	(
		addSweepCB.state = false

		addMatCB.enabled = false
		extSizeSP.enabled = true
	)
	
	on edgeToShapeRLT open do
	(
		-- load ini file
		try
		(
			addSweepCB.state =  		(getINISetting armadasScriptsIni "edgeToSweep" "sweepState") 		as booleanClass
			extSizeSP.value = 			(getINISetting armadasScriptsIni "edgeToSweep" "extrusionSize") 	as float
			extSize = 						(getINISetting armadasScriptsIni "edgeToSweep" "extrusionSize") 	as float
			addExtrusionCB.state =  	(getINISetting armadasScriptsIni "edgeToSweep" "extrusionState") 	as booleanClass
			removeEdgeCB.state = 	(getINISetting armadasScriptsIni "edgeToSweep" "removeState") 	as booleanClass
			resetXformCB.state = 		(getINISetting armadasScriptsIni "edgeToSweep" "resetXformState")	as booleanClass
			collapseXformCB.state = 	(getINISetting armadasScriptsIni "edgeToSweep" "collapseXformState") as booleanClass
		)
		catch
		(
			format "*** % ***\n" (getCurrentException())
		)
	)
	
	on edgeToShapeRLT close do
	(
		-- maj ini file
		setINISetting armadasScriptsIni "edgeToSweep" "sweepState" 			(addSweepCB.state as string)
		setINISetting armadasScriptsIni "edgeToSweep" "extrusionSize" 		(extSizeSP.value as string)
		setINISetting armadasScriptsIni "edgeToSweep" "extrusionState" 		(addExtrusionCB.state as string)
		setINISetting armadasScriptsIni "edgeToSweep" "removeState" 		(removeEdgeCB.state as string)
		setINISetting armadasScriptsIni "edgeToSweep" "resetXformState" 	(resetXformCB.state as string)
		setINISetting armadasScriptsIni "edgeToSweep" "collapseXformState" (collapseXformCB.state as string)
		print "maj ini done"
	)
	
)
createDialog edgeToShapeRLT 

