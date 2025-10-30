shader_type canvas_item;

uniform vec3[8] colors : source_color;

void fragment() {
	if (COLOR.rgb == vec3(0.0, 0.0, 0.0)) {
		COLOR.rgb = colors[0];
	}
	else if (COLOR.rgb == vec3(1.0, 0.0, 0.0)) {
		COLOR.rgb = colors[1];
	}
	else if (COLOR.rgb == vec3(0.0, 1.0, 0.0)) {
		COLOR.rgb = colors[2];
	}
	else if (COLOR.rgb == vec3(1.0, 1.0, 0.0)) {
		COLOR.rgb = colors[3];
	}
	else if (COLOR.rgb == vec3(0.0, 0.0, 1.0)) {
		COLOR.rgb = colors[4];
	}
	else if (COLOR.rgb == vec3(1.0, 0.0, 1.0)) {
		COLOR.rgb = colors[5];
	}
	else if (COLOR.rgb == vec3(0.0, 1.0, 1.0)) {
		COLOR.rgb = colors[6];
	}
	else if (COLOR.rgb == vec3(1.0, 1.0, 1.0)) {
		COLOR.rgb = colors[7];
	}
}