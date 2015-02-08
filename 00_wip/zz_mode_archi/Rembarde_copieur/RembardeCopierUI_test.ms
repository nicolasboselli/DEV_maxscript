	fn cleanPathName v3 =
	(
		CleanNameString = filterString v3 "\\"

		for i = 1 to CleanNameString.count do
		(
			if (findString CleanNameString[i] "jpg") != undefined do filename = CleanNameString[i]
			print filename
		)

		substituteString v3 filename ""
	)

 v3 = "I:\Production\MaxScriptArcCenter\lkcfhdomihf.jpg"
	
cleanPathName v3