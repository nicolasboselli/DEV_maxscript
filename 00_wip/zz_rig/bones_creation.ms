

/* deprecated
gap = 0
b0 = bone pos:[0,gap,0]


for i = 1 to 50 do
(
	gap -= 5
	in b0 b = bone pos:[0,gap,0]
	b0 = b
)
*/
boneCount = 63
gap = 2.497
prev = 0

b = BoneSys.createBone [0,prev,0] [0,(prev-gap),0] [1,0,0]

for i = 1 to boneCount do
(
	prev -= gap
	b0 = BoneSys.createBone [0,prev,0] [0,(prev-gap),0] [1,0,0]
	b0.boneScaleType=#squash
	b0.parent = b
	b = b0
)

