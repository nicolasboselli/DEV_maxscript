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
	local root = getFilenamePath  (getThisScriptFilename() )
	local folderContent
	local folderAr = #()
	
	local filesAr = #()
	local allAr = #()
	
	local currentFolder
	
	edittext pathET "current path:" readonly: true
	listbox scriptsListLB "Scripts:" 
	button enterFolderBT "open folder"
	button backFolderBT "parent folder"
	
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
)

createdialog scriptExplorerRLT width: 400

