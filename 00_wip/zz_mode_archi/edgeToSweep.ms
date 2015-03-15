/*
maj
add param: reset xform, center pivot, add extrusion, add uvwmap, add mat, setup sweep, keep spline or subobject.
*/

fn removeEdgeAndVerticesFN sel =
(
	sel.EditablePoly.ConvertSelectionToBorder #Edge #Vertex
	sel.EditablePoly.Remove selLevel: #Edge
	sel.EditablePoly.Remove selLevel: #Vertex
)

rollout edgeToShapeRLT "edge to shape"
(
-- 	vars
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
				
				mySweep = Sweep CurrentBuiltInShape: 2 PivotAlignment:8
				mySmooth = Smooth name: "my_Smooth" autosmooth: on
				
				addmodifier newShape mySweep
				addmodifier newShape mySmooth
				
				newSweep = getnodebyname newShape.name

				newSweep.modifiers[#Sweep][#Bar_Section].length = 20
				newSweep.modifiers[#Sweep][#Bar_Section].width = 20
			)
			
			-- option keep selection
			if keepSelCB.state == true then
			(
				select s
				modPanel.setCurrentObject s
				subobjectLevel = 4	

			)
			else
			(
				subobjectLevel = 0		
				select newShape
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
			addSweepCB.state =  		(getINISetting (modeArchiScriptRoot + "scriptMode.ini") "edgeToSweep" "sweepState") as booleanClass
			extSizeSP.value = (getINISetting (modeArchiScriptRoot + "scriptMode.ini") "edgeToSweep" "extrusionSize") as float
			extSize = (getINISetting (modeArchiScriptRoot + "scriptMode.ini") "edgeToSweep" "extrusionSize") as float
			addExtrusionCB.state =  		(getINISetting (modeArchiScriptRoot + "scriptMode.ini") "edgeToSweep" "extrusionState") as booleanClass
			removeEdgeCB.state = 	(getINISetting (modeArchiScriptRoot + "scriptMode.ini") "edgeToSweep" "removeState") as booleanClass
			resetXformCB.state = (getINISetting (modeArchiScriptRoot + "scriptMode.ini") "edgeToSweep" "resetXformState") as booleanClass
		)
		catch
		(
			format "*** % ***\n" (getCurrentException())
		)
	)
	
	on edgeToShapeRLT close do
	(
		-- maj ini file
		setINISetting (modeArchiScriptRoot + "scriptMode.ini") "edgeToSweep" "sweepState" (addSweepCB.state as string)
		setINISetting (modeArchiScriptRoot + "scriptMode.ini") "edgeToSweep" "extrusionSize" (extSizeSP.value as string)
		setINISetting (modeArchiScriptRoot + "scriptMode.ini") "edgeToSweep" "extrusionState" (addExtrusionCB.state as string)
		setINISetting (modeArchiScriptRoot + "scriptMode.ini") "edgeToSweep" "removeState" (removeEdgeCB.state as string)
		setINISetting (modeArchiScriptRoot + "scriptMode.ini") "edgeToSweep" "resetXformState" (resetXformCB.state as string)
		print "maj ini done"
	)
	
)
createDialog edgeToShapeRLT 

