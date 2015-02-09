-- squareSize = 200

rollout UVSquareRLT "UVWmap Square"
(
-- 	edittext sizeET "Taille du cube :" text: "100"
	spinner sizeSp "taille du cube: " range: [0,10000,100] type: #float
	radiobuttons axisRB labels: #("x","y","z")
	button gogoUVWMapBT "Go Go Uvwmap!"
	
	on gogoUVWMapBT pressed do
	(
		for o in ($selection as array) do
		(
			select o
			axis = case axisRB.state of (
			1: 0	
			2: 1
			3: 2)
			UvwSquare = Uvwmap  maptype: 4 length: sizeSp.value width: sizeSp.value  height: sizeSp.value  axis: axis
			modPanel.addModToSelection (UvwSquare) ui:on
		)
	)
)

createdialog UVSquareRLT


	 
