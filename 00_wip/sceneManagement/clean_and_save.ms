-- save current version as autoback
-- apply maxscript
-- save cleanversion
-- back to  autoback

-- OU
-- save version 
	-- get scenes folder
	sceneFolder = pathConfig.getCurrentProjectFolder() + "\\"  + "scenes"
-- 	num  = pathConfig.getProjectSubDirectoryCount() 
-- 	for i = 1 to num do format "%\n"(pathConfig.getProjectSubDirectory i)
	
-- créer un point bat qui lance une nouvelle instance de max (ouvre le fichier sauvegardé précedemment) et passe un script en parametres
	maxVers = "C:\\Program Files\\Autodesk\\3ds Max 2015\\3dsmax.exe"
	script = "D:\\githubDEV_maxscript\\00_wipsceneManagement\\testLoadScript.ms"
	batFile = sceneFolder + "\\" + "test.bat" 
	
	str = createFile batFile
	close  str
	
	str = openFile batFile mode: "w+"
	format  " \"%\" -U MAXScript \"%\"  pause" maxVers script to:str
	close  str
	
-- lancer un .bat qui ouvre max avec le fichier à traiter et qui passse le script de traitement en parametres
	ShellLaunch "D:/github/DEV_maxscript/00_wip/sceneManagement/testMax.bat" ""

-- sauver la version aprés le traitement

	/*
	doscommand " \"C:\Program Files\Autodesk\3ds Max 2015\3dsmax.exe\" -mxs \"b=box(); render\" "
	doscommand " C:\\Program Files\\Autodesk\\3ds Max 2015\\3dsmax.exe -U MAXScript D:\\githubDEV_maxscript\\00_wipsceneManagement\\testLoadScript.ms  pause"
	HiddenDOSCommand   " \"C:\\Program Files\\Autodesk\\3ds Max 2015\\3dsmax.exe\" -U MAXScript \"D:\\githubDEV_maxscript\\00_wipsceneManagement\\testLoadScript.ms\"  pause"
	wipFile = @"T:\ADN Patrimoine\Routedepibrac_0917\Perspectives\Scene3D\route_de_pibrac_11[Clean].max"
	if doesFileExist wipFile do shellLaunch (GetDir #maxroot + "3dsmax.exe") wipFile
	
	shellLaunch (GetDir #maxroot + "3dsmax.exe") ""  -u MAXScript "D:/github/DEV_maxscript/00_wip/sceneManagement/testLoadScript.ms"
	3dsmax -u MAXScript "D:/github/DEV_maxscript/00_wip/sceneManagement/testLoadScript.ms"
*/



-- collapse railclone
objs = objects as array
-- objs = selection as array

i = 0
for o in objs where classof o.baseobject == railclone_pro do
(
	format "railclone:%\n" o.name
	o.rendermode = off
	o.weld = off
	o.weldth = 0

	o.vmesh = 0
	o.faceType = 1
	i = i +1
)

sel = #()
for o in objs where classof o.baseobject == railclone_pro do
(
	append sel o
)
select sel

for o in objs where classof o.baseobject == railclone_pro do
(
	converttopoly o
	format "convert done:%\n" o.name
)

-- collapse sweep
objs = objects as array
for o in objs where o.modifiers.count >= 1 do
(
	local atLeastOneConvertion = false
	for m in o.modifiers where classof m == sweep do
	(
		atLeastOneConvertion = true
		format "obj: %, mod: %\n" o m
		converttopoly o
	)
	
	if not atLeastOneConvertion then format "Pas de modifiers clone à collapser."

)

-- collapse clone 
sel = #()
objs = objects as array
for o in objs where o.modifiers.count >= 1 do
(
	local atLeastOneConvertion = false
	for m in o.modifiers where classof m == clone do
	(
		atLeastOneConvertion = true
		format "obj: %, mod: %\n" o m
		append sel o
		converttopoly o
	)
	
	if not atLeastOneConvertion then format "Pas de modifiers clone à collapser."
)
-- select sel

