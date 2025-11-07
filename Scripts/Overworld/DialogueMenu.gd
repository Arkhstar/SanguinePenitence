class_name DialogueMenu
extends NinePatchRect

@onready var speaker_label : Label = $Speaker
@onready var message_label : Label = $Message

@onready var response_panel : NinePatchRect = $Response
@onready var response_cursor : TextureRect = $Response/Cursor
@onready var response_container : VBoxContainer = $Response/VBoxContainer
@onready var response_option : Label = $Response/VBoxContainer/Option1

@onready var continue_texture : TextureRect = $Continue

@onready var speak_sfx : AudioStreamPlayer = $Speak
@onready var nav_sfx : AudioStreamPlayer = $Nav
@onready var select_sfx : AudioStreamPlayer = $Select

@onready var timer : Timer = $Timer

func speak(speaker : String, message : String, responses : PackedStringArray = []) -> int:
	response_panel.hide()
	continue_texture.hide()
	speaker_label.text = speaker
	message_label.visible_ratio = 0
	message_label.text = message
	
	await RenderingServer.frame_post_draw
	await RenderingServer.frame_post_draw
	
	var has_responses : bool = responses.size() > 0
	if has_responses:
		var required : int = responses.size()
		var existing : int = response_container.get_child_count()
		for i : int in maxi(existing, required):
			if i < required:
				if i < existing:
					response_container.get_child(i).text = responses[i]
				else:
					var label : Label = response_option.duplicate()
					label.text = responses[i]
					response_container.add_child(label)
			else:
				response_container.get_child(i).queue_free()
		response_panel.size.y = required * 10 + 8
		response_panel.position.y = -response_panel.size.y
	
	var speed : float = [0.075, 0.05, 0.025, 0.015, 0.005][Config.text_speed]
	
	var t : Tween = create_tween()
	t.tween_property(message_label, "visible_ratio", 1.0, message.length() * speed + message.count(".") * 2.0 * speed)
	t.play()
	speak_sfx.play()
	while message_label.visible_ratio < 1:
		if Input.is_action_just_pressed("menu_select"):
			t.custom_step(message.length() * 2.0)
		await RenderingServer.frame_post_draw
	speak_sfx.stop()
	
	if has_responses:
		response_panel.show()
		var selection_index : int = 0
		var response_count : int = responses.size()
		response_cursor.position.y = selection_index * 10 + 5
		timer.start()
		while timer.time_left > 0:
			await RenderingServer.frame_post_draw
		while true:
			if Input.is_action_just_pressed("menu_up") or Input.is_action_just_pressed("menu_left"):
				selection_index = (selection_index + response_count - 1) % response_count
				nav_sfx.play()
			if Input.is_action_just_pressed("menu_down") or Input.is_action_just_pressed("menu_right"):
				selection_index = (selection_index + 1) % response_count
				nav_sfx.play()
			response_cursor.position.y = selection_index * 10 + 5
			if Input.is_action_just_pressed("menu_select"):
				select_sfx.play()
				return selection_index
			await RenderingServer.frame_post_draw
	
	continue_texture.show()
	timer.start()
	while timer.time_left > 0:
		await RenderingServer.frame_post_draw
	while true:
			if Input.is_action_just_pressed("menu_select"):
				break
			await RenderingServer.frame_post_draw
	return -1
