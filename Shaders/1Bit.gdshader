shader_type canvas_item;

uniform vec4 off : source_color = vec4(0.0, 0.0, 0.0, 0.0);
uniform vec4 on : source_color = vec4(1.0, 1.0, 1.0, 0.0);

void fragment() {
	COLOR = ((COLOR.r + COLOR.g + COLOR.b) / 3.0 > 0.0 ? on : off) * COLOR.a;
}