faceSel = polyop.getfaceselection $ 
posObj = $.pos
posCenter = polyop.getFaceCenter $ (faceSel as array)[1]
theZ = polyop.getFaceNormal $ (faceSel as array)[1]
theY = normalize (cross [0,0,1] theZ )
theX = normalize (cross theY theZ)
theTM = matrix3   theX theY theZ posCenter

rep = box transform: theTM

