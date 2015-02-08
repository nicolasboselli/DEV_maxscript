macroScript GF_UI
	category:"mode_archi"
	buttonText: "GestionFenetres"
	toolTip:""

(
	rollout fenetres "fenetres"

	(
		button btn_create_faces "Create face"
		button btn_fenetre_fixes "Create fenetres bases"
		button btn_clean_base "Return to Faces"
		button btn_super_fenetre "Create Fenetre Ouvrables"

		on btn_create_faces pressed do macros.run "mode_archi" "GF_Detach_Fenetres"
		on btn_fenetre_fixes pressed do macros.run "mode_archi" "GF_fenetres"
		on btn_clean_base pressed do macros.run  "mode_archi" "GF_Return2Faces"
		on btn_super_fenetre pressed do macros.run "mode_archi" "GF_SuperFenetre"
	)

	CreateDialog fenetres
)