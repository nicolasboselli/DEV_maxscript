3f = @"C:\test01.max"

-- objsIWant = "select $Sphere001"
getMAXFileObjectNames f

mergeMAXFile f #select

assetCtrl = undefined
lastVersionFile = @"J:\_svn\zz_ressources3D\ELEMENTS_IMMOBILIERS\fenetre_porte_double\003\fenetre_porte_double.max"

n =  getFilenameFile  lastVersionFile

assetCtrl = point name: (uniquename( n + "_ctrl")) size: 200

objStrAr = getMAXFileObjectNames lastVersionFile
res = mergeMAXFile lastVersionFile  #useSceneMtlDups	

LM = layermanager
assetsLayer = LM.getLayerFromName "assets_layer"
if assetsLayer == undefined do assetsLayer = LM.newLayerFromName "assets_layer"

for str in objStrAr do
(
	o = getnodebyname str
	deletion = false
	
	if classof o == vraysun or classof o == vrayplane or  classof o == targetcamera then deletion = true
	else if o.layer.name == "cache_layer" then deletion = true
		
	if deletion == true then delete o
	else
	(
		if  o.parent == undefined then 	o.parent = assetCtrl
	)
)

