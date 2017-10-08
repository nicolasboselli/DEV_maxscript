-- function pour retourner le root des scripts
-- créer une fonction générique pour sauver et charger les propriétés d'un rollout (position, préferences)
	-- controls
	-- position
	-- variables
-- créer une table pour lister les versions de script à loader dans les macroscript
	-- permet de porposer une table wip/debug/published
	-- s'appuie sur le versionnement dans des dossiers
	-- propose de faire la bascule entre wip/debup/published
	--permet d'accorder des autorisations

fn getRoot =
(
	local armadasScriptsIni =  (GetDir #maxData) + "armadasScriptsIni.ini"
	local root = getINISetting armadasScriptsIni "armadasScripts" "armadasScriptsRoot"
)

-- load function pour parenter comme dans maya
filein ((getRoot ()) + "Rig/lastParent_def.ms")

-- load function pour enregistrer et loader les préferences
filein ((getRoot ()) + "rollout_pref/rollout_pref.ms")
