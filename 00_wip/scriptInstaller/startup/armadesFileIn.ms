-- function pour retourner le root des scripts
-- cr�er une fonction g�n�rique pour sauver et charger les propri�t�s d'un rollout (position, pr�ferences)
	-- controls
	-- position
	-- variables
-- cr�er une table pour lister les versions de script � loader dans les macroscript
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

-- load function pour enregistrer et loader les pr�ferences
filein ((getRoot ()) + "rollout_pref/rollout_pref.ms")