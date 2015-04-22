/*
maj:
 - add access to ini file
 - enter folder on double click
 - back folder in list
 - back folder on back touch
 - manager many set of favorites
*/

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
	name = filenameFromPath path
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
	
-- 	local root = getFilenamePath  (getThisScriptFilename() )
	local folderContent
	local folderAr = #()
	
	local filesAr = #()
	local allAr = #()
	
	local currentFolder


	
-- 	UI
	edittext pathET "current folder:" readonly: true
	button openFoldBT "open folder" across: 2
	button accessIniBT "access ini"
	listbox scriptsListLB "Scripts:" tooltip: "script list" height: 30 -- across: 2
-- 	dotNetControl tv "TreeView"  height:450 visible: false
	
	group "navigation:"
	(
		button enterFolderBT "enter folder" tooltip: "enter folder" across: 2
		button backFolderBT "parent folder"
	)
	
	group "utilities:"
	(
		
		button editScriptBT "edit script" across: 3
		button launchScriptBT "launch script" 
		button copyPathBT "copy path"
	)
	
	group "favorites:"
	(
		button printPathBT "add to favorites"
	)

		
-- 	functions

	
	/*
	fn fillInTreeView tv =
	(
-- 		tv.AllowDrop = true
		theRoot = tv.Nodes.add "SCRIPT ROOT" --add parent node
		rootNodes =  for elt in allAr collect  elt
		for o in rootNodes do
		(
			newNode = theRoot.Nodes.add o.name
-- 			newNode.tag = dotNetMXSValue o
		)
-- 		addChildren theRoot rootNodes --no need to pass theTreeView
	)
	*/
	
	fn refreshUI =
	(
		print currentFolder
		pathET.text = currentFolder
		scriptsListLB.items = for elt in allAr collect  elt.name
	)
	
	fn scanFolder onePath =
	(
		folderAr = #()
		append folderAr (folderClass "<<")
		folderContent = getDirectories (onePath + "*")
		filesContent = getFiles (onePath + "*")
		for f in folderContent do
		(
			append folderAr (folderClass f)
		)
		filesAr = for f in filesContent  collect fileClass f
		local allAr = join folderAr filesAr 
		return allAr
-- 		scriptsListLB.items = for fold in folderAr collect (toUpper fold.name)
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
		currentFolder = root
		allAr = scanFolder root
		
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
			print "favorites array init"
		)
		
		refreshUI()
-- 		fillInTreeView tv
		
	)
	
	on enterFolderBT pressed do
	(
		num = scriptsListLB.selection
		print num
		if num > 0 do
		(
			obj = folderAr[num]
			if classof obj == folderClass then
			(
				currentFolder = obj.path
				allAr = scanFolder currentFolder
			)
			else
			(
				edit obj.path
-- 				print "this is not a folder"
			)
		)
		refreshUI()
	)
	
	on backFolderBT pressed do
	(
		splitFolder = filterString currentFolder "/"
		
		sum = ""
		for i = 1 to (splitFolder.count - 1) do
		(
-- 			print splitFolder[i]
			sum = sum + splitFolder[i] + "/"
		)
		currentFolder = sum
		allAr = scanFolder currentFolder
		refreshUI()
	)
	
	on printPathBT pressed do
	(
		if classof allAr[scriptsListLB.selection] != folderClass then
		(
			appendifunique  favAr allAr[scriptsListLB.selection].path 
-- 			favAr = makeuniquearray favAr
			print favAr
			setINISetting armadasScriptsIni "armadasScriptsFavorite" "armadasScriptsArray" (with printAllElements on favAr as string)
		)
		else
		(
			print "this is a folder. it can't be add to favorites"
		)
		
	)
	
	on launchScriptBT pressed do
	(
		sel = allAr[scriptsListLB.selection]
		if classof sel == fileClass do
		(
			 filein (sel.path)
		)
	)
	
	on editScriptBT pressed do
	(
		sel = allAr[scriptsListLB.selection]
		if classof sel == fileClass do
		(
			 edit (sel.path)
		)
	)
		
		
	
	on copyPathBT pressed do
	(
		pathTmp =  (allAr[scriptsListLB.selection].path)
		setclipboardText pathTmp
	)
)

createdialog scriptExplorerRLT width: 400


