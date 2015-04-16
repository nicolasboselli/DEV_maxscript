
rollout listview_rollout "ListView Selected"
(

	fn initListView lv =
	(
		lv.gridLines = true --same as in ActiveX --The following controls the display of details. We use defaults:
		lv.View = (dotNetClass "System.Windows.Forms.View").Details
		lv.fullRowSelect = true --same as in ActiveX
		layout_def = #("Object Name", "Object Class", "Verts", "Material","pos x")
		for i in layout_def do
		lv.Columns.add i 96 --add column with name and optional width
	)

	fn fillInSpreadSheet lv =
	(
		theRange = #() --array to collect the list items
		for o in selection do
		(
			--First we create a ListViewItem objectwith the object's name:
			li = dotNetObject "System.Windows.Forms.ListViewItem" o.name
			--Then we add all the sub-itemswith the desired string values:
			sub_li = li.SubItems.add ((classof o) as string)
			sub_li = li.SubItems.add (try((o.mesh.numverts) as string)catch("--"))
-- 			sub_li = li.SubItems.add (try((o.mesh.numfaces) as string)catch("--"))
			sub_li = li.SubItems.add ((o.material) as string)
			sub_li = li.SubItems.add ((o.pos.x) as string)
			append theRange li--we add the list item to the array
		)
	lv.Items.AddRange theRange--when done, we populate the ListView
	)

	dotNetControl lv_objects "System.Windows.Forms.ListView" width:490 height:190 align:#center 

	on listview_rollout open do
	(
-- 		lv_objects.Checkboxes = true
		lv_objects.LabelEdit  = true
		lv_objects.MultiSelect = true
		initListView lv_objects
		fillInSpreadSheet lv_objects
	)
)
try(destroyDialog listview_rollout)catch()
createDialog listview_rollout 500 200
