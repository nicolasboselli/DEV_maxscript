l =$

max modify mode
modPanel.setCurrentObject l.baseobject
subObjectLevel = 1

spCount = numSplines   l
for i = 1 to spCount do
(
	knCount =numknots l i
-- 	format "knots: % \n" knCount
	setKnotSelection l i #(knCount)
)
splineOps.makeFirst l


subObjectLevel = 0