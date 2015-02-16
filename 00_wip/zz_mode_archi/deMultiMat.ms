-- make one object by multi material


-- collect scene multimaterial

-- for one multimaterial
	-- collect object

-- for one object
	-- count multimaterial number
	multiTmp = $.material.count
	
	-- count objet id
	idMax = 0
	faceMax = $.GetNumFaces ()
	for i = 1 to faceMax do
	(
		polyop.setFaceSelection $ i
		if ($.getMaterialIndex true) > idMax do idMax = $.getMaterialIndex true
	)
	polyop.setFaceSelection $ #none
	print idMax
	
	-- pour chaque id de l'objet a partir de 2:
		for i = 2 to idMax do
		(
			-- detach faces with one material
			$.selectByMaterial  i
			newName = uniquename ($.name + "_mat_" + (i as string))
			polyop.detachFaces $ #selection delete: false asNode: true name: newName

			-- option: split edge by smoothing group
			-- appliquer un shell sur le nouvel objet
			-- faire un outline sur l'objet
			-- rename object by material
			-- apply unique matching material
		)

				
	-- apply first material to complete object
for mat in sceneMaterials do print (classof mat)