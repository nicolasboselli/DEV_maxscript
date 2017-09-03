/*
maj:
	-- creer de nouveaux dossier
	-- renommer des dossiers
	-- prendre en compte des script du meme nom au copy/paste pour numeroteer les version
	-- enregister les preferences et la position du script
	-- toggle pour backupper/ debakkuper les fichiers
 
 rebuild:
	 -- revoir la fonction pour trouver le dossier parent
	 -- revoir les fonction copy/paste/duplicate pour que duplicate execute un copy/paste
	 -- faire fonctionner le rename de dossier avec le meme rollout que pour les scripts
	 -- revoir le trie des fchiers: bakuper changer le onlyMxs en ignoreBak
	 -- passer la selection folder ou script mode à l ouverture du rollout rename ET PAS pas des methodes init
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


rollout renameRLT "rename" width: 400
(
	-- vars
	local o 
	
	local oldPath 
	local oldFilename 
	local Typ 
	
	local folderMode = false
	local scriptMode = false
	
	-- ui
	edittext nameET "name:"
-- 	edittext typeET "type:"
	button okBT "ok"
	
	-- functions
	fn initForScript =
	(
		o = scriptExplorerRLT.toDisplay[scriptExplorerRLT.scriptsListLB.selection]
		
		oldPath = getFilenamePath o.path
		oldFilename = getFilenameFile o.path
		Typ = getFilenameType o.path
		
		nameET.text = oldFilename + typ
	)
	
	fn initforFolder =
	(
		format "je sais pas quoi faire"
	)
	
	-- actions
	on renameRLT open do
	(
		o = scriptExplorerRLT.toDisplay[scriptExplorerRLT.scriptsListLB.selection]
		
		if classof o == folderClass then folderMode = true
		else if classof o == fileClass then scriptMode = true
		else()
	)
	
	
	on nameET entered val do okBT.pressed()
	
	on okBT pressed do
	(
		oldname =  oldPath + oldFilename + Typ
		newName = oldPath + nameET.text

		format "rename: % >>> %\n" oldname newName
		renameFile oldname newName
		
		destroyDialog renameRLT
		
		scriptExplorerRLT.collectValues maxscriptOnly: scriptExplorerRLT.onlyMs.state
		scriptExplorerRLT.refreshUI()
	)
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
	
	local fileToCopy
	
	local newName
	
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
	checkbox onlyMs "ignore .bak" checked: true
	 
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
	
		
	fn collectValues2 ignoreBak: false =
	(
		allAr = scanFolder currentFolder
		
		toDisplay =#()
		for o in allAr do
		(
			if classof o == fileclass and matchpattern o.path  then
			(
				if o.typ == ".ms" or o.typ == ".mse" then
				(
					append toDisplay o
				)
			)
			else append toDisplay o
		)
	)
	
	fn duplicateFile =
	(
		o = toDisplay[scriptsListLB.selection]
		PathOne = getFilenamePath o.path
		FilenameOne = getFilenameFile o.path
		Typ = getFilenameType o.path
		
		copyFile o.path (PathOne + FilenameOne + "_copy" + Typ)
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
			menuItem editIT "edit script" enabled: true
			menuItem launchIT "launch script" enabled: true
			separator sep3
			menuItem copyIT "copy" enabled: true
			menuItem pasteIT "paste"  enabled: true
			menuItem dupIT "duplicate"  enabled: true
			menuItem delIT "delete"  enabled: true
			separator sep2
			menuItem renameIT "rename script" enabled: true
			menuItem bakIT "backup script toggle" enabled: false
			menuItem createFolderIT "create folder" enabled: false
-- 			menuItem addToFavIT "add to favorites" enabled: false
			separator sep1
			menuItem foldIT "open folder" enabled: false
			menuItem pathIT "copy Path" 
			
			on editIT picked do editScriptBT.pressed()
			on launchIT picked do launchScriptBT.pressed()
			
			on copyIT picked do
			(
				o = toDisplay[scriptsListLB.selection]
				fileToCopy = o.path
			)
			
			on pasteIT picked do
			(
				PathOne = getFilenamePath fileToCopy
				FilenameOne = getFilenameFile fileToCopy
				Typ = getFilenameType fileToCopy
		
				res = copyFile fileToCopy (currentFolder + FilenameOne + Typ)
				format "copy done: %\n" res
				
				collectValues maxscriptOnly: onlyMs.state
				refreshUI()
			)
			
			on delIT picked do
			(
				o = toDisplay[scriptsListLB.selection]
				PathOne = deleteFile o.path
				
				collectValues maxscriptOnly: onlyMs.state
				refreshUI()
			)
			
			on renameIT picked do
			(
				createdialog renameRLT
				
				o = toDisplay[scriptsListLB.selection]
				
				if classof o == fileClass then
				(
					
					renameRLT.initForScript()
				)
				else if classof o == folderClass then
				(
					renameRLT.initForFolder()
				)
				else
				(
				)
				
-- 				format "newName:%\n" newName
			)
			
			on dupIT picked do
			(
				o = toDisplay[scriptsListLB.selection]
				
				PathOne = getFilenamePath o.path
				FilenameOne = getFilenameFile o.path
				Typ = getFilenameType o.path
		
				res = copyFile o.path (PathOne + FilenameOne + "_copy" + Typ)
-- 				format "copy done: %\n" res
				
				collectValues maxscriptOnly: onlyMs.state
				refreshUI()
			)
			
			
			
-- 			on foldIT picked do 
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



