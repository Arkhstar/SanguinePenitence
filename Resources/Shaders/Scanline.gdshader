shader_type canvas_item;

uniform sampler2D screenTexture : hint_screen_texture, filter_nearest;
uniform float speed = 0.5;
uniform float height = 2;

void fragment() {
	vec2 uv = SCREEN_UV;
	
	float delta1 = sin(TIME * speed - uv.y);
	float delta2 = cos(TIME * speed - uv.y);
	float h = SCREEN_PIXEL_SIZE.y * height;
	if ((delta1 > -h && delta1 < h) || (delta2 > -h && delta2 < h)) {
		uv.y -= h;
	}
	
	vec4 tex = texture(screenTexture, uv);
	COLOR = tex;
}