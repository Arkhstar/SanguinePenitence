shader_type canvas_item;

uniform float strength : hint_range(0.0, 1.0, 0.1) = 0.0;

void fragment() {
	COLOR.rgb = mix(COLOR.rgb, vec3(0.299 * COLOR.r + 0.587 * COLOR.g + 0.114 * COLOR.b), strength);
}