-- maj: add add to bookmark

-- filesContent = getFiles (root+"\*")
struct folderClass 
(
	path,
	test = print path,
	nameAr = filterString  path "\\",
	name = "[ " + (toUpper nameAr[nameAr.count]) + " ]"
)

struct fileClass
(
	path,
	name = filenameFromPath path
)

rollout scriptExplorerRLT "Scripts Explorer"
(
	local maxIni = getMAXIniFile()
	local armadasScriptsIni = (getFilenamePath maxIni) + "armadasScriptsIni.ini"
	local root = getINISetting armadasScriptsIni "armadasScripts" "armadasScriptsRoot"
	
	
	local favAr = #()
	
-- 	local root = getFilenamePath  (getThisScriptFilename() )
	local folderContent
	local folderAr = #()
	
	local filesAr = #()
	local allAr = #()
	
	local currentFolder
	
	edittext pathET "current path:" readonly: true
	listbox scriptsListLB "Scripts:" height: 30
	button enterFolderBT "open folder"
	button backFolderBT "parent folder"
	button printPathBT "add to favorites"
	button editScriptBT "edit script"
	button copyPathBT "copy path"
	
	fn scanFolder onePath =
	(
		folderContent = getDirectories (onePath + "\*")
		filesContent = getFiles (onePath + "\*")
		folderAr = for f in folderContent collect folderClass f
		filesAr = for f in filesContent  collect fileClass f
		allAr = join folderAr filesAr 
		
-- 		scriptsListLB.items = for fold in folderAr collect (toUpper fold.name)
		scriptsListLB.items = for elt in allAr collect  elt.name

	)
	
	on scriptExplorerRLT open do
	(
		currentFolder = root
		scanFolder root
		if (hasINISetting armadasScriptsIni "armadasScriptsFavorite" "armadasScriptsArray") == true then
		(
			favArTmp = getINISetting armadasScriptsIni "armadasScriptsFavorite" "armadasScriptsArray"
			favAr = execute favArTmp
			print "load favorites done"
		)
		else
		(
			favAr = #()
			print "favorites array init"
		)
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
				scanFolder currentFolder
			)
			else
			(
				edit obj.path
-- 				print "this is not a folder"
			)
		)
	)
	
	on backFolderBT pressed do
	(
		splitFolder = filterString currentFolder "\\"
		
		sum = ""
		for i = 1 to (splitFolder.count - 1) do
		(
-- 			print splitFolder[i]
			sum = sum + splitFolder[i] + "\\"
		)
		currentFolder = sum
		scanFolder currentFolder
	)
	
	on printPathBT pressed do
	(
		if classof allAr[scriptsListLB.selection] != folderClass then
		(
			append  favAr allAr[scriptsListLB.selection].path 
			favAr = makeuniquearray favAr
			print favAr
			setINISetting armadasScriptsIni "armadasScriptsFavorite" "armadasScriptsArray" (favAr as string)
		)
		else
		(
			print "this is a folder"
		)
		
	)
	
	on editScriptBT pressed do
	(
		 edit (allAr[scriptsListLB.selection].path)
	)
	
	on copyPathBT pressed do
	(
		pathTmp =  (allAr[scriptsListLB.selection].path)
		setclipboardText pathTmp
	)
)

createdialog scriptExplorerRLT width: 400

