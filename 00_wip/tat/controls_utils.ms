-- create root
nameAr = filterString  maxFileName "_"
basename = nameAr[1] + "_" + nameAr[2]

ptRoot = point name: (basename + "_ROOT") wirecolor: (color 14 255 2)  size: 50 box: on cross: off axistripod: off centermarker: off
ptParent = point name: (basename + "_Parent_CTRL") wirecolor: (color 225 198 87) size: 50 box: off cross: on axistripod: off centermarker: off

ptParent.parent = ptRoot

