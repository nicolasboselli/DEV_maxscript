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

fn centerPivotDef sel = 
(
	for s in sel do
	(
		s.pivot = s.center
	)
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

fn randomWireFN useFirstId: true =
(
	for mat in sceneMaterials do 
	(
		randomWire = color (random 0 255) (random 0 255) (random 0 255) 
		for o in $* do 
		(
			if (superclassof o == GeometryClass) do 
			(
				if (classof o.material) == multimaterial and useFirstId == true then
				(
-- 					print mat 
-- 					print o
					if o.material[1] == mat  do o.wirecolor = randomWire
				)
				else if  o.material == mat then
				(
					o.wirecolor = randomWire
				)
			)
		)
	)
)
-- randomWireFN()

--debug: make usabled on multiselection
fn makeFloorFN currentSel =
(
	local sel =  currentSel
	-- add editpoly
	for s in sel do
	(
		if classof s == splineshape do
		(
			undo on
			(
				myEditPoly = Edit_Poly()
				addmodifier s myEditPoly
				convertto s editable_poly

				-- outline 15 cm
				select s
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
)

fn connectRingFN s loopNum: 1 =
(
-- 	maj: init connect decay
	PolyToolsSelect.ring()
	s.connectEdgeSegments   = loopNum
	s.connectEdges()
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
	undo on
	(
		master = grp[1]
		converttopoly master
		InstanceMgr.MakeObjectsUnique master #individual

		for i = grp.count to 2 by -1 do
		(
			master.EditablePoly.attach grp[i] master
		-- 	print sel[i]
		)
	)
	return master
)


fn cleancombine2 grp =
(
	undo on
	(
		master = grp[1]
		converttopoly master
		InstanceMgr.MakeObjectsUnique master #individual
		
		restGrp = deleteItem  grp 1
		
		for o in restGrp do
		(
			master.EditablePoly.attach o master
		)
		
	)
)


-- transfert
fn transfertModifiers sel =
(
	source = sel[1]

	for i = 2 to sel.count do
	(
		for m in source.modifiers  do
		(
			addmodifier sel[i] m
		)
	)
)


fn transferColor sel =
(
	source = sel[1]

	for i = 2 to sel.count do
	(
		sel[i].material = source.material
	)
)



try(destroyDialog miscRLT)catch()

rollout miscRLT "misc"
(
	button getInstBT "get instances"
	
	group "wirecolor: "
	(
		button randColBT "random color"
		checkbox multiMatIDCB "use first id for multimaterial" checked: true
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
		
		button converttopolyBT "convert to poly"
	)
	
	button centerPivotBT "center pivot"
	
	group "transfert"
	(
		button transferModBT "transfer modifiers"
		button transferMatBT "transfer material"
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
	on randomWireBT pressed do
	(
		randomWireFN useFirstId: multiMatIDCB.state
	)
	on makeFloorBT pressed do makeFloorFN (selection as array) 
	on connectRingBT pressed do 
	(
		sel = selection as array
		for s in sel do
		(
			undo on
			(
				connectRingFN s loopNum:1
			)
		)
	)
	on connectRing2BT pressed do 
	(
		sel = selection as array
		for s in sel do
		(
			undo on
			(
				connectRingFN s loopNum:2
			)
		)
	)
	
		
	on cleanCombineBT pressed do cleancombine (selection as array)
		
	on centerPivotBT pressed do centerPivotDef (selection as array)
	on converttopolyBT pressed do 
	(
		sel = selection as array
		for s in sel do
		(
			converttopoly s
		)
	)
	
	on transferModBT pressed do
	(
		sel = selection as array
		transfertModifiers sel
	)
	
	on transferMatBT pressed do
	(
		sel = selection as array
		transferColor sel
	)
)
createDialog miscRLT


