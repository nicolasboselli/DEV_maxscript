aa = 10
bb = 10

cc = $mouchard.pos
dd =$driver1.pos
ee = $driver2.pos
ff = in coordsys $driver1 $mouchard.pos
gg = in coordsys $driver2 $mouchard.pos

-- � am�liorer: lorsque la condition est rempli, 
-- 1- le mouchard s'aligne sur le test et rel�ve ses coordonn�es. 
-- 2-les coordonn�es deviennent une nouvelle constante qui s'ajoute � la position des driver
-- attention : si je rajoute un controller au test pour le rendre libre il faudra penser � soustraire la position libre � la position contrainte.