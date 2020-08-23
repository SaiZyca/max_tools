try DestroyDialog rolloutOffsetObject catch()

rollout rolloutOffsetObject "Offset Object" width:340 height:160
(
	local point_a = [0,0,0]
	local point_b = [0,0,0]
	
	fn getRoot node = if isvalidnode node do (while node.parent != undefined do node = node.parent; node)
	
	group "Measure"
	(
		pickbutton 'a_point' "Position A" width:150 across:2
		pickbutton 'b_point' "Position B" width:150
		button 'caculate' "Calculate " width:306
	)
	
	group "Offset" (
	spinner 'x_pos' "X" width:100 height:16 range:[-999999999,999999999,0] type:#float align:#left across:3
	spinner 'y_pos' "Y" width:100 height:16 range:[-999999999,999999999,0] type:#float align:#center 
	spinner 'z_pos' "Z" width:100 height:16 range:[-999999999,999999999,0] type:#float align:#right 
	checkbox 'move_parent' " Move paret instead"  offset:[0,2] across:2
	button 'move_object' "Move" width:190 offset:[-18,0]
	)
	
	on 'a_point' picked obj do 
	(
		'a_point'.text = (obj.pos as string)
		point_a = obj.pos
	)
	
	on 'a_point' rightclick do
	(
		'a_point'.text = "Position A"
		point_a = [0,0,0]
	)		

	on 'b_point' picked obj do 
	(
		'b_point'.text = (obj.pos as string)
		point_b = obj.pos
	)
	
	on 'b_point' rightclick do
	(
		'b_point'.text = "Position B"
		point_b = [0,0,0]
	)		
	
	on 'caculate' pressed do 
	(
		x_pos.value = point_b.x - point_a.x
		y_pos.value = point_b.y - point_a.y
		z_pos.value = point_b.z - point_a.z
	)

	
	on rolloutOffsetObject open do
	(
		ini_file = (getDir #plugcfg) + "\offseter.ini"
		init_offset = execute (getINISetting ini_file "offset record" "offset")
		init_parent = execute (getINISetting ini_file "offset record" "parent")
		if classof init_offset == Point3 then 
		(
			x_pos.value = init_offset.x
			y_pos.value = init_offset.y
			z_pos.value = init_offset.z
		)
		if classof init_parent == BooleanClass then 'move_parent'.checked = init_parent
	)
	
	on rolloutOffsetObject close do
	(
		ini_file = (getDir #plugcfg) + "\offseter.ini"
		setINISetting ini_file "offset record" "offset"([x_pos.value,y_pos.value,z_pos.value] as string)
		setINISetting ini_file "offset record" "parent"('move_parent'.checked as string)
		print "Close"
	)
	
	on 'move_object' pressed do
	(
		if 'move_parent'.checked == True then
		(
			temp_collection = for i in selection collect (getRoot i) 
			node_collection =  (makeUniqueArray temp_collection)
			undo on
			(
				for item in node_collection do move item [x_pos.value,y_pos.value,z_pos.value]
			)
		)
		else
		(
			undo on
			(
				for item in selection do move item [x_pos.value,y_pos.value,z_pos.value]
			)
		)

	)
)

CreateDialog rolloutOffsetObject