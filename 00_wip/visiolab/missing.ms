showproperties $

-- lister les chemins d'acc�s 
for i = 1 to (mapPaths.count()) do format "%\n" (mapPaths.get i)
-- sauver les chemin d'acc�s
-- effacer les chemins d'acc�s
-- recharger les chemins d'acc�s
mapPaths.getFullFilePath "Arch41_006_ground.jpg"

-- trouver le chemin d'acces prevus
doesfileexist $.fileName
-- trouver le chemin d'acces charg�s
-- compar�s


-- trouver tous les chemins d'acc�s des objets de la scenes
classof $.baseobject
bmpText = getclassinstances Bitmaptexture 
bmpText.count

meditmaterials[activeMeditSlot ].texmap_diffuse.filename