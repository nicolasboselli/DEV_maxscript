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

fn makeFloorFN sel =
(
	-- add editpoly
	myEditPoly = Edit_Poly()
	addmodifier sel myEditPoly
	convertto sel editable_poly

	-- outline 15 cm
	polyop.setFaceSelection  sel #all
	sel.outlineAmount = -15
	sel.EditablePoly.Outline ()

	-- shell 10cm
	myShell = Shell innerAmount:10 outerAmount:10
	addmodifier sel myShell

	-- convert to poly
	convertto sel editable_poly

	-- material "interieur"G
	sel.material = sceneMaterials["interieur"]
)

rollout miscRLT "misc"
(
	button getInstBT "get instances"
	button randColBT "random color"
	button goutteBT "goutte d'eau"
	button debordBT "debord balcon"
	button randomWireBT "random wirecolor"
	button makeFloorBT "make floor"
	
	on getInstBT pressed do
	(
		sel = $selection as array
		if sel.count == 1 do
		(
			getInstancesFN sel[1]
		)
			
	)
	
	on randColBT pressed do
	(
		sel = $selection as array
		for s in sel do
		(
			randomColorFN s
		)
		
	)
	
	on goutteBT pressed do goutteDeauFN $	
	on debordBT pressed do debordFN $
	on randomWireBT pressed do randomWireFN()
	on makeFloorBT pressed do makeFloorFN $
)
createDialog miscRLT