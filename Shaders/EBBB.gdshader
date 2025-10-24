shader_type canvas_item;

uniform vec2 scroll_velocity;

uniform float h_wave_amp;
uniform float h_wave_speed;
uniform float h_wave_width = 1.0;

uniform float v_wave_amp;
uniform float v_wave_speed;
uniform float v_wave_width = 1.0;

void fragment() {
	vec2 uv = mod(UV + TIME * scroll_velocity, 1.0);
	
	uv = mod(vec2(uv.x + sin((TIME * h_wave_speed + TIME * UV.y) / h_wave_width) * h_wave_amp, uv.y + cos((TIME * v_wave_speed + TIME * UV.y) / v_wave_width) * v_wave_amp), 1.0);
	
	COLOR = texture(TEXTURE, uv);
}