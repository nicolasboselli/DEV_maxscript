fn createGridBaseMatFN =
(
	local gridmap = bricks Tile_Type: 5 Lock_Gap_Symmetry: 0 Fade_Variance: 0 Brick_Color: (color 0 0 0) Mortar_Color: (color 255 255 255) \
	Vertical_Count: 1 Vertical_Gap: 0 Horizontal_Gap: 2

	local gridMat = standard name: "gc_grid_material" twoSided: true Diffuse: (color 0 0 0 ) opacityMap: gridmap
)





