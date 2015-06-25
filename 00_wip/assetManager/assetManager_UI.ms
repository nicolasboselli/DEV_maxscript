-- assetManager UI

rollout assetManagerRlt "Asset Manager"
(
	local assetPath = @"\\ELVIS\_svn\zz_ressources3D"
	

	button createNewBT "create new asset"
	button exportBT "export selection as asset" enabled: false
	button saveBT "publish version"
	
	group "parameters: "
	(
		edittext pathET "base path:"
		edittext nameET "name:"
		edittext versionET "version:"
		edittext statusET "status:"
		edittext superclassET "superclass:"
		edittext classET "class:"
		edittext commentET "comment:"
	)
	
	edittext resultET "result:" readonly: true
	button confirmBT "publish"
	
	on createNewBT pressed do
	(
		pathET.text = assetPath
	)
	
)

createdialog assetManagerRlt width: 400