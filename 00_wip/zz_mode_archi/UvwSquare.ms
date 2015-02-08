-- squareSize = 200

rollout UVSquareRLT "UVWmap Square"
(
	edittext sizeET "Taille du cube :" text: "100"
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
			UvwSquare = Uvwmap  maptype: 4 length: (sizeET.text as float) width: (sizeET.text as float)  height: (sizeET.text as float)  axis: axis
			modPanel.addModToSelection (UvwSquare) ui:on
		)
	)
)

createdialog UVSquareRLT


	 
