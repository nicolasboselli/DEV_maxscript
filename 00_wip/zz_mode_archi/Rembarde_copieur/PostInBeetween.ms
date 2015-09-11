fn postInbeetweenDef boxref postNum: 5 distTreshold: 15 =
(
	local lineSel = $
	local splineSelNum = numSplines lineSel

-- 	local ecart =20

	local splineSegNumAr = for i = 1 to splineSelNum collect (numKnots lineSel i ) - 1

	local numKnotsAr = for i = 1 to splineSelNum collect (numKnots lineSel i )

	local poteauNum = postNum

	for i = 1 to splineSelNum do
	(
		
		for j = 1 to splineSegNumAr[i] do
		(
			poteauNum = postNum
			startKnotPos = getKnotPoint lineSel i j
			endKnotPos = getKnotPoint lineSel i (j+1)
			
			distTemp =  (distance startKnotPos endKnotPos)
			postTreshold =  (int (floor (distTemp / distTreshold))) 
			print postTreshold
-- 			poteauNum = 5
			if postTreshold < poteauNum do poteauNum = postTreshold
			
			print poteauNum
			
			percentCurInc = 1.0 / poteauNum
			percentCur= 0
			
			for h = 1 to (poteauNum - 1) do
			(
				percentCur = percentCur + percentCurInc
				posOnSpline = interpBezier3D lineSel i  j percentCur pathParam:true

				pointX1 = tangentBezier3D lineSel i j percentCur pathParam:true

				pointZ2 = [0,0,1]

				pointY =cross  pointZ2  pointX1

				pointZ1 = cross pointX1  pointY

				pointX2 = cross  pointY  pointZ2
					
					
				-- 	position parallèle à l'axe z du monde
				tempMatrix = matrix3 1
				tempMatrix.row1 = normalize pointX2
				tempMatrix.row2 = normalize pointY
				tempMatrix.row3 = normalize pointZ2
				tempMatrix.row4 = posOnSpline
				orthogonalize tempMatrix

		-- 		test = point axis_tripod: true cross: false size: 5  transform:tempMatrix  name: "test1" wirecolor: (color 0 0 255)
				pointPoint = instance boxref
				pointPoint.transform = tempMatrix
				pointPoint.position = posOnSpline
			)
			
		)

	)
)



rollout potoCornerRLT "posts inbeetween"
(
	local boxRef = undefined
	local postNum
	
-- 	pickbutton  poteauRefCB "ref"
	button addRefBT "ref>>"
	edittext refNameET "ref:" readonly: true
	spinner postNumSP "post number max:" type: #integer range:[1,1000,5]
	spinner postTresholdSP "dist treshold:" type: #worldunits range:[0.1,1000,15]
	button multiplyBT "Multiply!"
	
	on addRefBT pressed do
	(
		if selection.count == 1 then 
		(
			boxRef = selection[1]
			refNameET.text = boxRef.name
		)
		else
		(
			print "non conform selection"
		)
	)
	
	
	on multiplyBT pressed do
	(
		local boxOrigin = undefined
		
		if boxRef == undefined do 
		(
			boxOrigin =  box  length: 3 width: 3 height: 80 name: "post_inb_base"
			refNameET.text = boxOrigin.name
			boxRef = boxOrigin
		)
		
		local boxCopy = copy boxRef
		undo on
		(
			postInbeetweenDef boxCopy postNum: postNumSP.value distTreshold: postTresholdSP.value
		)
		delete boxCopy
		if boxOrigin != undefined do delete boxOrigin
	)
	
)

createdialog potoCornerRLT