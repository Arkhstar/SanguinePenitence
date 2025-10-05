class_name Configuration
extends Resource

static var lock_cursor : bool = false :
	set(value):
		lock_cursor = value
		if lock_cursor:
			Input.mouse_mode = Input.MOUSE_MODE_CONFINED_HIDDEN
		else:
			Input.mouse_mode = Input.MOUSE_MODE_HIDDEN

static var vsync : bool = true :
	set(value):
		vsync = value
		if vsync:
			DisplayServer.window_set_vsync_mode(DisplayServer.VSYNC_ENABLED)
		else:
			DisplayServer.window_set_vsync_mode(DisplayServer.VSYNC_DISABLED)
