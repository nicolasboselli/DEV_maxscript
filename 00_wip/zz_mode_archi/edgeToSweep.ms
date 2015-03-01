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
	checkbox addSweepCB "add Sweep"
	checkbox removeEdgeCB "remove edge"
	button extractBT "extract"
	
	on extractBT pressed do
	(
		sel = $selection as array

		for s in sel do
		(
			-- convert selection if necessary
			if subObjectLevel == 4 do s.ConvertSelectionToBorder #Face #Edge
			
			-- create shape
			newName = uniqueName (s.name + "_shape")
			s.createShape  newName  false s
			subobjectLevel = 0			
			newShape = getnodebyname newName
			updateshape newShape
			
			-- option: remove edge
			if removeEdgeCB.state == True do removeEdgeAndVerticesFN s
			
			if addSweepCB.state == true do
			(
				-- option: add sweep
				mySweep = Sweep CurrentBuiltInShape: 2 PivotAlignment:8
				mySmooth = Smooth name: "my_Smooth" autosmooth: on
				
				addmodifier newShape mySweep
				addmodifier newShape mySmooth
				
				newSweep = getnodebyname newShape.name

				newSweep.modifiers[#Sweep][#Bar_Section].length = 20
				newSweep.modifiers[#Sweep][#Bar_Section].width = 20
			)
			
			select newShape
		)
	)
	
	on edgeToShapeRLT open do
	(
		-- load ini file
		try
		(
			addSweepCB.state =  		(getINISetting (modeArchiScriptRoot + "scriptMode.ini") "edgeToSweep" "sweepState") as booleanClass
			removeEdgeCB.state = 	(getINISetting (modeArchiScriptRoot + "scriptMode.ini") "edgeToSweep" "removeState") as booleanClass
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
		setINISetting (modeArchiScriptRoot + "scriptMode.ini") "edgeToSweep" "removeState" (removeEdgeCB.state as string)
		print "maj ini done"
	)
	
)
createDialog edgeToShapeRLT

"false" as booleanClass 