-- rotate pivot on y axis with 90 degree

-- rotate object 
fn rotatePivot s xVal yVal zVal =
(
	in coordsys local rotate s (eulerangles xVal yVal zVal)
	-- rotate object offset
	bakRot = $.objectoffsetrot 
	s.objectoffsetrot = bakRot + ((eulerangles (xVal*-1) (yVal*-1) (zval*-1)) as quat)
)

-- rotatePivot $ 0 90 0
try (destroydialog reorientatorRLT )catch()
rollout reorientatorRLT "RE-ORIENTATOR"
(
	group "x:"
	(
		button xPlus90BT "+90" across: 2
		button xMinus90BT "-90"
	)
	
	group "y:"
	(
		button yPlus90BT "+90" across: 2
		button yMinus90BT "-90"
	)
	
	group "z:"
	(
		button zPlus90BT "+90" across: 2
		button zMinus90BT "-90"
	)
	
	on xPlus90BT pressed do
	(
		sel = selection as array
		for s in sel do rotatePivot s 90 0 0
	)
	
	on xMinus90BT pressed do
	(
		sel = selection as array
		for s in sel do rotatePivot s -90 0 0
	)
	
	on yPlus90BT pressed do
	(
		sel = selection as array
		for s in sel do rotatePivot s 0 90 0
	)
	
	on yMinus90BT pressed do
	(
		sel = selection as array
		for s in sel do rotatePivot s 0 -90 0
	)
	
	on zPlus90BT pressed do
	(
		sel = selection as array
		for s in sel do rotatePivot s 0 0 90
	)
	
	on zMinus90BT pressed do
	(
		sel = selection as array
		for s in sel do rotatePivot s 0 0 -90
	)
	
	
)
createdialog reorientatorRLT