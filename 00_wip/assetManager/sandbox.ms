filein "assetManagerDef.ms"

test = @"J:\_svn\zz_ressources3D\voitures\HD Model Car vol.1\01_clio\assetInfo.ini"

newasset = assetClass()
newasset.initFromIni test "zz_ressources3D"

newasset = assetInScene()
newasset.initFromCtrl $
newasset.updateAsset()

