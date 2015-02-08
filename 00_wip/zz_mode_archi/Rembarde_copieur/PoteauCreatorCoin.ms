/*
splineSel = $selection as array

boxRef = box length: 5 width: 5 height: 100 name: "poteau"

for o in splineSel do
(
	numSpline = numSplines o
	for i = 1 to numSpline do
	(
		numKnotsSpline = numKnots o i
		for j = 1 to numKnotsSpline do
		(
			boxTemp = instance boxRef
			boxTemp.position = (getKnotPoint o i j)
			
		)
	)
)

InstanceMgr.GetInstances boxRef &boxInstances

select boxInstances
delete boxRef
*/
/*
numKnots $
numSplines $
getKnotPoint $ 1 1
*/


-- points
/*
pointOne = point position:(interpBezier3D lineSel 1 splineSeg 0.50 pathParam:true) name: "pointOne" size: 1 axis_tripod: false cross: true

pointX1 = point position:((tangentBezier3D lineSel 1 splineSeg 0.50 pathParam:true) + pointOne.position) name: "pointX1" size: 1 axis_tripod: false cross: true

pointZ2 = point position:(pointOne.position + [0,0,1])  name: "pointZ2" size: 1 axis_tripod: false cross: true

pointY = point position:(pointOne.pos + (cross  (pointZ2.pos - pointOne.pos) (pointX1.pos - pointOne.pos) ))  name: "pointY" size: 1 axis_tripod: false cross: true

pointZ1 = point position: (pointOne.pos + (cross (pointX1.pos - pointOne.pos)  (pointY.pos - pointOne.pos)  ))  name: "pointZ1" size: 1 axis_tripod: false cross: true

pointZ2 =  point position: (pointOne.pos + (cross  (pointY.pos - pointOne.pos) (pointZ2.pos - pointOne.pos) ))  name: "pointZ2" size: 1 axis_tripod: false cross: true
*/

--coordonnées

boxRef = box length: 5 width: 5 height: 100 name: "poteau"

lineSel = $

splineSel = 1
splineSelNum = numSplines lineSel

splineSeg = 2
splineSegNumAr = for i = 1 to splineSelNum collect (numKnots lineSel i ) - 1

percentCur = 0.99

-- posOnSpline = interpBezier3D lineSel splineSel splineSeg percentCur pathParam:true

posOnSplineAr = #()
for splineNum = 1 to splineSegNumAr.count do 
(
	for i = 1 to splineSegNumAr[splineNum] do
	(
		
		(
		posOnKnot = 	getKnotPoint lineSel splineNum i
		
		posOnSpline = interpBezier3D lineSel splineNum  i percentCur pathParam:true
		
		pointX1 = tangentBezier3D lineSel splineNum i percentCur pathParam:true

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
		
		boxTemp = instance boxRef
		boxTemp.transform = tempMatrix
		boxTemp.position = posOnKnot
		
		/*
		-- position suivant l'orientation de la spline
		tempMatrix = matrix3 1
		tempMatrix.row1 = normalize pointX1
		tempMatrix.row2 = normalize pointY
		tempMatrix.row3 = normalize pointZ1
		tempMatrix.row4 = posOnSpline
		orthogonalize tempMatrix

		test2 = point axis_tripod: true cross: false size: 5 transform:tempMatrix name: "test2" wirecolor: (color 0 255 0)
		*/
		
		)
	)
)

delete boxRef


