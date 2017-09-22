-- function pour retourner le root des scripts
fn getRoot =
(
	local maxIni = getMAXIniFile()
	local armadasScriptsIni = (getFilenamePath maxIni) + "armadasScriptsIni.ini"
	local root = getINISetting armadasScriptsIni "armadasScripts" "armadasScriptsRoot"
)

-- function pour parenter comme dans maya
filein ((getRoot ()) + "Rig/lastParent_def.ms")