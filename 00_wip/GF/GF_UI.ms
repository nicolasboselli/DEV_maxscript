rollout fenetresRLT "fenetres"

	(
		 
		local maxIni = getMAXIniFile()
		local armadasScriptsIni = (getFilenamePath maxIni) + "armadasScriptsIni.ini"
		local scriptRoot = getINISetting armadasScriptsIni "armadasScripts" "armadasScriptsRoot"

-- 		UI
		button btn_create_faces "Create face"
		button btn_fenetre_fixes "Create fenetres bases"
		button btn_clean_base "Return to Faces"
		button btn_super_fenetre "Create Fenetre Ouvrables"

		on btn_create_faces pressed do 
		(
			filein (scriptRoot + "GF\\GF_detach_fenetres_v3.ms")
		)
		
		on btn_fenetre_fixes pressed do
		(
			filein (scriptRoot + "GF\\GF_fenetres_v4.ms")
		)
		
		on btn_clean_base pressed do 
		(
			filein (scriptRoot + "GF\\GF_return2faces_v2.ms")
		)
		
		on btn_super_fenetre pressed do 
		(
			filein (scriptRoot + "GF\\GF_super_fenetre_v2.ms")
		)
		
		on fenetresRLT open do
		(
			filein (scriptRoot + "GF\\FN_gestion_fenetres.ms")
		)

	)
CreateDialog fenetresRLT
	
