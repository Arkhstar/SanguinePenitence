shader_type canvas_item;

uniform vec3 flash_color : source_color = vec3(1.0, 1.0, 1.0);
uniform float speed_scale = 30.0;
uniform bool enabled = false;

void fragment() {
	if (enabled) {
		int state = int(floor(TIME * speed_scale)) % 4;
		if (state == 0 && COLOR.rgb == vec3(0.0, 0.0, 0.0)) {
			COLOR = vec4(flash_color.r, flash_color.g, flash_color.b, COLOR.a);
		}
		else if (state == 2 && COLOR.rgb != vec3(0.0, 0.0, 0.0)) {
			COLOR = vec4(flash_color.r, flash_color.g, flash_color.b, COLOR.a);
		}
	}
}
