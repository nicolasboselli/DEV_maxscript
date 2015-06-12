/*
bug:
-- find parent of the selection before 
*/

sel = selection as array
-- create group with first selected object orientation

		-- find head of hierarchy of selection
headsOfHierarchy = #()
for s in sel do
(
	-- if arent is undefined
	if s.parent == undefined then
	(
		appendifunique headsOfHierarchy s
	)
	-- if parent is not in selection 
	else
	(
		isNotHead = False
		
		for p in sel do
		(
			if s.parent == p do
			(
				isNotHead = True
				exit
			)
		)

		if isNotHead == False do appendifunique headsOfHierarchy s
	)
)
print headsOfHierarchy

		-- find parent of head of hierarchy
rootParent = #()
for head in headsOfHierarchy do
(
	appendifunique rootParent head.parent
)

if rootParent.count == 1 then
(
	-- create helper with first selection orientation
selMatrix = sel[1].transform
orientHlpTmp = point name: "orientHlpTmp" transform: selMatrix
	-- parent heads of hierarchy on helper
	-- insert helper  in selection hierarchy (parent to rootparent)
	-- create group on selection
	
	-- reroot group root parent
	-- delete helper
	-- return group
)
else
(
	print "selection uncorrect"
)




/* create controller function */
fn createCtrl num posList tmpGrp = 
(
	tmpPt = point pos: posList[num ] name: ("repere_" + (num  as string)) size: 400 wirecolor: green
	-- point matrix
	ptMatrix = tmpPt.transform.controller.value
	-- group matrix
	grpMatrix = tmpGrp.transform
		
	resMatrix = ptMatrix*grpMatrix
	tmpPt.transform.controller.value = resMatrix
-- 	in coordsys tmpGrp tmpPt.position = posList[num ]
	tmpPt
)

/*
-- parent ref
grpMatrix = $.transform.controller.value
-- world ref
grpMatrix = $.transform

in coordsys parent $.transform.controller.value
	

in coordsys world $.position
	
in coordsys parent $.transform



$.transform.controller.value = grpMatrix 
*/

fn collectCtrlPosition tmpGrp =
(
	setGroupOpen  tmpGrp true
	-- get the group bounding box
	absbbCoord = nodeGetBoundingBox tmpGrp tmpGrp.transform
	append absbbCoord [0,0,0]

	posList = #()

	for i = 1 to 3 do
	(
		for j = 1 to 3 do
		(
			for k = 1 to 3 do
			(
				tmpPos = [absbbCoord[i][1], absbbCoord[j][2], absbbCoord[k][3]]
				append posList tmpPos
			)
		)
	)
	posList
)

rollout addCtrlRLT "Add Controller Utility"
(

-- 	vars
-- 	rollout relative functions
	fn createOneCtrl num sel =
	(
		tmpGrp= group sel name: "tmpGrp"
		posList = collectCtrlPosition tmpGrp

		-- create up controller
		ctrlTmp = createCtrl num posList tmpGrp

		-- delete group
		setGroupOpen  tmpGrp false
		explodeGroup tmpGrp

		-- parent selection to point
		for s in sel do s.parent = ctrlTmp
		ctrlTmp
	)
		
	
-- 	UI
	group "add controller"
	(
		button addZplusCtrl "+z" across: 2
		button addZminusCtrl "-z"
		button addYplusCtrl "+y" across: 2
		button addYminusCtrl "-y"
		button addXplusCtrl "+x" across: 2
		button addXminusCtrl "-x"
	)
	button publishCtrlsBT "publish"
	
-- 	actions
	on addZplusCtrl pressed do
	(
		-- create group on selection
		sel = selection as array
-- 		print sel
		ctrl = createOneCtrl 26 sel
	)
	
	on addZminusCtrl pressed do
	(
		-- create group on selection
		sel = selection as array
		ctrl = createOneCtrl 25 sel
		
	)
	
	on addYplusCtrl pressed do
	(
		sel = selection as array
		ctrl = createOneCtrl 24 sel
	)
	
	on addYminusCtrl pressed do
	(
		sel = selection as array
		ctrl = createOneCtrl 21 sel
	)
	
	on addXplusCtrl pressed do
	(
		sel = selection as array
		ctrl = createOneCtrl 18 sel
	)
	
	on addXminusCtrl pressed do
	(
		sel = selection as array
		ctrl = createOneCtrl 9 sel
	)
	
	on publishCtrlsBT pressed do
	(
		sel = selection as array
		undo on 
		(
			for i = 1 to 27 do
			(
				createOneCtrl i sel
				for s in sel do s.parent = undefined
			)
		)
	)
	
)

createdialog addCtrlRLT