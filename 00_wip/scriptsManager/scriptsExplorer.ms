/*
maj:
 x- add access to ini file
 x- enter folder on double click
 x- back folder in list
 x- back folder on back touch

 -- ajouter ds fonction au rc menu pour manager les scripts: copy, paste, rename, delete, bakup...
 -- revoir la fonction pour trouver le dossier parent
 -- enregister les preferences et la position
*/



struct returnClass
(
	name = "[<<]"
)	

struct folderClass 
(
	tmppath,
	path = substituteString tmppath "\\" "/",
	nameAr = filterString  path "/",
	name = "[ " + (toUpper nameAr[nameAr.count]) + " ]"
)

struct fileClass
(
	tmppath ,
	path = substituteString tmppath "\\" "/",
	name = filenameFromPath path,
	typ = getFilenameType tmppath
)

try(destroyDialog scriptExplorerRLT)catch()

rollout scriptExplorerRLT "Scripts Explorer"
(
	
-- 	vars
	local maxIni = getMAXIniFile()
	local armadasScriptsIni = (getFilenamePath maxIni) + "armadasScriptsIni.ini"
	local tmpRroot = getINISetting armadasScriptsIni "armadasScripts" "armadasScriptsRoot"
	local	root = substituteString tmpRroot "\\" "/"

	local favAr = #()

	local menuRC
	
-- 	local root = getFilenamePath  (getThisScriptFilename() )
	local folderContent
-- 	local folderAr = #()
	
-- 	local filesAr = #()
	local allAr = #()
	local toDisplay = #()
	
	local currentFolder
	
-- 	UI
	edittext pathET "current folder:" readonly: true 
	button openFoldBT "open folder" across: 2
	button accessIniBT "access ini"
	checkbox onlyMs "collect maxscript files only" checked: true
	 
	listbox scriptsListLB "Scripts:" tooltip: "script list" height: 30 -- across: 2
-- 	dotNetControl tv "TreeView"  height:450 visible: false
	
	group "actions:"
	(
		button enterFolderBT "enter folder" tooltip: "enter folder" across: 3
		button backFolderBT "parent folder"
		button copyPathBT "copy path"
		
		button editScriptBT "edit script" across: 3
		button launchScriptBT "launch script" 
		button printPathBT "add to favorites"
	)
		
-- 	functions
	
	fn copyPath =
	(
		pathTmp =  try(toDisplay[scriptsListLB.selection].path) catch()
		setclipboardText pathTmp
	)
	
	
	fn scanFolder onePath =
	(
		-- init de l'array
-- 		allAr = #(returnClass ())
		
		-- collecte des dossiers
		folderContent = getDirectories (onePath + "*")
		folderAr = for fo in folderContent collect folderClass fo
		
		-- collecte des fichiers
		filesContent = getFiles (onePath + "*")
		filesAr = for f in filesContent  collect fileClass f
		
		format "scan done: %\n" onePath
		#(returnClass ()) + folderAr +filesAr

	)
	
	fn returnParentFolder folderPath =
	(
		splitFolder = filterString folderPath "/"
		
		sum = ""
		for i = 1 to (splitFolder.count - 1) do
		(
-- 			print splitFolder[i]
			sum = sum + splitFolder[i] + "/"
		)
		sum
	)
	
	-- Vars dependant
	
	fn collectValues maxscriptOnly: false =
	(
		allAr = scanFolder currentFolder
		
		toDisplay =#()
		for o in allAr do
		(
			if classof o == fileclass and maxscriptOnly then
			(
				if o.typ == ".ms" or o.typ == ".mse" then
				(
					append toDisplay o
				)
			)
			else append toDisplay o
		)
	)
	
	
	-- UI dependant
	fn refreshUI =
	(
		format "currentFolder: %\n" currentFolder
		pathET.text = currentFolder
		scriptsListLB.items = for elt in toDisplay collect  elt.name
	)
	
	fn createRCMenu =
	(
		rcmenu menuRC
		(
			menuItem editIT "edit script" enabled: false
			menuItem launchIT "launch script" enabled: false
			separator sep3
			menuItem copyIT "copy" enabled: false
			menuItem pasteIT "paste"  enabled: false
			menuItem delIT "delete"  enabled: false
			separator sep2
			menuItem renameIT "rename script" enabled: false
			menuItem bakIT "backup script" enabled: false
			menuItem debakIT "de-backup script" enabled: false
			separator sep1
			menuItem foldIT "open folder" enabled: false
			menuItem pathIT "copy Path" 
						
			on pathIT picked do copyPath ()
		)
	)
	
-- 	actions
	
	on accessIniBT pressed do
	(
		doscommand ("explorer " + (getFilenamePath maxIni))
	)
		
	on openFoldBT pressed do 
	(
		foldToOpen = substituteString currentFolder "/" "\\"
		doscommand ("explorer " +  foldToOpen)
	)

	on scriptExplorerRLT open do
	(
		-- scan des dossiers
		currentFolder = root
-- 		allAr = scanFolder root
		collectValues maxscriptOnly: onlyMs.state
		
		-- creation du rcMenu
		menuRC = createRCMenu()
		
		refreshUI()
		
		-- chargement des scripts favoris
		if (hasINISetting armadasScriptsIni "armadasScriptsFavorite" "armadasScriptsArray") == true then
		(
			favArStr = getINISetting armadasScriptsIni  "armadasScriptsFavorite" "armadasScriptsArray"
			favArTmp = execute favArStr
			
			-- test if file exist
			for onePath in favArTmp do
			(
				if doesFileExist onePath == true do
				(
					appendifunique favAr onePath
				)
			)
		)
		else
		(
			favAr = #()
		)
		format "favorites array: %\n" favAr
	)
	
	on onlyMs changed val do
	(
		collectValues maxscriptOnly: val
		refreshUI()
	)
	
	on scriptsListLB doubleClicked arg do enterFolderBT.pressed()
	
	on scriptsListLB rightClick do
	(
		popUpMenu menuRC rollout: scriptExplorerRLT
	)
	
	on enterFolderBT pressed do
	(
-- 		format "selection: %, selected: %\n" scriptsListLB.selection scriptsListLB.selected
		num = scriptsListLB.selection
		if num > 0 do
		(
			obj = toDisplay[num]
-- 			format "classof: %\n"  obj
			
			if classof obj == returnClass then
			(
				currentFolder = returnParentFolder currentFolder
-- 				allAr = scanFolder currentFolder
				collectValues maxscriptOnly: onlyMs.state
			)
			else if classof obj == folderClass then
			(
				currentFolder = obj.path
				collectValues maxscriptOnly: onlyMs.state
-- 				allAr = scanFolder currentFolder
			)
			else if classof obj == fileClass then
			(
-- 				edit obj.path
			)
			else(print "damned!")
		)
		refreshUI()
	)
	
	on backFolderBT pressed do
	(
		currentFolder = returnParentFolder currentFolder
		collectValues maxscriptOnly: onlyMs.state
-- 		allAr = scanFolder currentFolder
		refreshUI()
	)
	
	on printPathBT pressed do
	(
		if classof toDisplay[scriptsListLB.selection] != folderClass then
		(
			appendifunique  favAr toDisplay[scriptsListLB.selection].path 
-- 			favAr = makeuniquearray favAr
			print favAr
			setINISetting armadasScriptsIni "armadasScriptsFavorite" "armadasScriptsArray" (with printAllElements on favAr as string)
		)
		else
		(
			format "un dossier ne peut pas être ajouter aux favoris"
		)
	)
	
	on launchScriptBT pressed do
	(
		sel = toDisplay[scriptsListLB.selection]
		if classof sel == fileClass do
		(
			 filein (sel.path)
		)
	)
	
	on editScriptBT pressed do
	(
		sel = toDisplay[scriptsListLB.selection]
		if classof sel == fileClass do
		(
			 edit (sel.path)
		)
	)
			
	on copyPathBT pressed do copyPath ()	
	
)
createdialog scriptExplorerRLT width: 400



