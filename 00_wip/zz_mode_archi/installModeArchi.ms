/*
1 cr�e un fichier ini "modeArchiScript.ini"a cot� de 3dsmax.ini qui m�morise le dossier ou se trouve les scripts (obtenu par la commande dans le get install)
1.1 cr�� un fonction pour charger la variable du chemin des scripts dans une variable globale et utiliser la variable globale ou bien utiliser un fonction qui retourne la variable locale � chaque fois?
1.2 initialiser la variable globale au lancement de max? au lancement du launcher? ou charger une fonction qui retourne une variable locale au lancement de 3dsmax?
2 installe un macroscript qui lance le launcher en r�cup�rant le  nom du dossier dans le fichier ini
3 cr�e la barre d'outil pour le launcher et l'installe.
*/


-- 1 Create "modeArchiScript.ini" in the same folder then 3dsmax.ini
	-- get 3dsmax.ini filename
	maxIni = getMAXIniFile()
	modeArchiScriptRoot = getFilenamePath  (getThisScriptFilename() )
	-- from 3dsmax.ini filename get folder
	-- create "modeArchiScript.ini" in the folder
	
	-- get script folder from install script
	modeArchiScriptRoot = getFilenamePath  (getThisScriptFilename() )
	
	-- write the script folder in "modeArchiScript.ini"
	setINISetting maxIni "modeArchiScript" "modeArchiScriptRoot" modeArchiScriptRoot
	
	
get folder where to create 

modeArchiScriptRoot