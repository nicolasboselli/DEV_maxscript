

-- filesContent = getFiles (root+"\*")
struct folderClass 
(
	path,
	test = print path,
	nameAr = filterString  path "\\",
	name = nameAr[nameAr.count]
)

rollout scriptExplorerRLT "Scripts Explorer"
(
	local root = "J:\GitHub_repo\DEV_maxscript\00_wip\zz_mode_archi"
	local folderContent
	local folderAr = #()
	
	listbox scriptsListLB "Scripts:" 
	
	on scriptExplorerRLT open do
	(
		folderContent = getDirectories (root + "\*")
		folderAr = for f in folderContent collect folderClass f
		scriptsListLB.items = for fold in folderAr collect (toUpper fold.name)
	)
)

createdialog scriptExplorerRLT

-- root = "J:\GitHub_repo\DEV_maxscript\00_wip\zz_mode_archi\\"
-- test = filterString  root "\\"

-- test[test.count]