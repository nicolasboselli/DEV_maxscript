-- InstanceMgr.GetInstances $ &instances

-- select instances

fn getInstancesFN sel = 
(
	InstanceMgr.GetInstances sel &instances
	if instances.count<=1 do print "no instances"
	select instances
)

fn randomColorFN sel =
(
	randomColor = color (random 0 255) (random 0 255) (random 0 255)
	sel.wirecolor =  randomColor
)


fn goutteDeauFN sel =
(
	polyop.bevelFaces sel #selection 3 0
	polyop.bevelFaces sel #selection 0 -5
	polyop.bevelFaces sel #selection  -1 0
	polyop.bevelFaces sel #selection 0 -1
	polyop.bevelFaces sel #selection 1 0
	polyop.bevelFaces sel #selection 0 -5
	polyop.bevelFaces sel #selection -3 0
)

fn debordFN sel = 
(
	polyop.bevelFaces sel #selection 3 0
	polyop.bevelFaces sel #selection 0 -10
	polyop.bevelFaces sel #selection  -3 0
)

fn randomWireFN =
(
	for mat in sceneMaterials do 
	(
		randomWire = color (random 0 255) (random 0 255) (random 0 255) 
		for o in $* do 
		(
			if (superclassof o == GeometryClass) do 
			(
				if  o.material == mat do
				(
					o.wirecolor = randomWire
				)
			)
		)
	)
)

--debug: make usabled on multiselection
fn makeFloorFN currentSel =
(
	local sel =  currentSel
	-- add editpoly
	for s in sel do
	(
		if classof s == splineshape do
		(
			myEditPoly = Edit_Poly()
			addmodifier s myEditPoly
			convertto s editable_poly

			-- outline 15 cm
			polyop.setFaceSelection  s #all
			s.outlineAmount = -15
			s.EditablePoly.Outline ()

			-- shell 10cm
			myShell = Shell innerAmount:10 outerAmount:10
			addmodifier s myShell

			-- convert to poly
			convertto s editable_poly

			-- material "interieur"G
			sel.material = sceneMaterials["interieur"]
		)
	)
)

fn connectRingFN loopNum =
(
-- 	maj: init connect decay
	PolyToolsSelect.ring()
	$.connectEdgeSegments   = loopNum
	$.connectEdges()
)

-- refresh scenematerial
fn updateSceneMaterials =
 (
 saveNodes #() "c:/temp.max"
 deleteFile "c:/temp.max"
 )
updateSceneMaterials()


-- attach object select in the same object
fn cleancombine grp =
(
	master = grp[1]
	converttopoly master
	InstanceMgr.MakeObjectsUnique master #individual

	for i = grp.count to 2 by -1 do
	(
		master.EditablePoly.attach grp[i] master
	-- 	print sel[i]
	)
	return master
)

rollout miscRLT "misc"
(
	button getInstBT "get instances"
	
	group "wirecolor: "
	(
		button randColBT "random color"
		button randomWireBT "wirecolor by material"
	)
	
	group "modeling"
	(
		button goutteBT "goutte d'eau"
		button debordBT "debord balcon"
		
		button makeFloorBT "make floor"
		button connectRingBT "connect ring x1"
		button connectRing2BT "connect ring x2"
		button cleanCombineBT "combine"
	)
	
	on getInstBT pressed do
	(
		sel = selection as array
		if sel.count == 1 do
		(
			getInstancesFN sel[1]
		)
			
	)
	
	on randColBT pressed do
	(
		for s in selection do randomColorFN s
	)
	
	on goutteBT pressed do goutteDeauFN $	
	on debordBT pressed do debordFN $
	on randomWireBT pressed do randomWireFN()
	on makeFloorBT pressed do makeFloorFN selection
	on connectRingBT pressed do connectRingFN 1
	on connectRing2BT pressed do connectRingFN 2
		
	on cleanCombineBT pressed do cleancombine selection
		
)
createDialog miscRLT


