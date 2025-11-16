shader_type canvas_item;

uniform sampler2D screenTexture : hint_screen_texture, filter_nearest;

uniform float delay : hint_range(0.0, 0.5, 0.01) = 0.0;
uniform float height : hint_range(0.0, 3.0, 0.01) = 0.5;
uniform float speed : hint_range(0.0, 1.0, 0.001) = 1.0;

void fragment() {
	vec2 uv = SCREEN_UV;
	float y = mod(TIME * speed, 1.0 + delay);
	float h = height * SCREEN_PIXEL_SIZE.y;
	if (uv.y > y && uv.y < y + h) {
		uv.y = mod(uv.y - h, 1.0);
	}
	COLOR = texture(screenTexture, uv);
}