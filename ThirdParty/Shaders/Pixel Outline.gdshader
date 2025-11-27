shader_type canvas_item;

uniform vec4 clr : source_color = vec4(0.29, 0.42, 0.50, 0.5);
uniform int type : hint_range(0, 2) = 1;
uniform float thickness = 1.0;
uniform float blink_rate = 0.25;

const vec2[8] DIRECTIONS = {
	vec2(1.0, 0.0),
	vec2(0.0, 1.0),
	vec2(-1.0, 0.0),
	vec2(0.0, 0.0),
	vec2(1.0, 1.0),
	vec2(-1.0, 1.0),
	vec2(-1.0, -1.0),
	vec2(1.0, -1.0)
};

float gtz(float input) { return max(0, sign(input)); }
// returns 1 if input > 0, else 0

float check(sampler2D tex, vec2 from, vec2 size) {
	float result = 0.0;
	for (int i = 0; i < 4 * type; i++) {
		result += texture(tex, from + DIRECTIONS[i] * size * thickness).a;
	}
	return gtz(result);
}

void fragment() {
	float r = check(TEXTURE, UV, TEXTURE_PIXEL_SIZE) * (1.0 - gtz(COLOR.a));
	COLOR = mix(COLOR, clr, r);
	if (r == 1.0) {
		COLOR.a = mix(COLOR.a, 0, 1.0 - cos(TIME * blink_rate));
	}
}